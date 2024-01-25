#!/usr/bin/env python3

from ctf_gameserver import checkerlib
import requests
from requests import Session
import logging
import base64
import socket
import paramiko

PORT = 8787

def ssh_connect():
    def decorator(func):
        def wrapper(*args, **kwargs):
            # SSH connection setup
            client = paramiko.SSHClient()
            client.set_missing_host_key_policy(paramiko.AutoAddPolicy())
            client.connect(args[0].ip, username = f'team{args[0].team}', key_filename= f'/root/team{args[0].team}-sshkey')

            # Call the decorated function with the client parameter
            result = func(*args, **kwargs)

            # SSH connection cleanup
            client.close()

            return result
        return wrapper
    return decorator

class MyChecker(checkerlib.BaseChecker):

    def __init__(self, ip, team):
        checkerlib.BaseChecker.__init__(self, ip, team)
        self._baseurl = f'http://[{self.ip}]:{PORT}'
        logging.info(f"URL: {self._baseurl}")

    @ssh_connect()
    def place_flag(self, tick,  client):
        flag = checkerlib.get_flag(tick)
        creds = self._create_system_user(client, user="flag_" + str(tick), password=flag)
        if not creds:
            return checkerlib.CheckResult.FAULTY
        logging.info(creds)
        checkerlib.store_state("flag_" + str(tick), creds)
        checkerlib.set_flagid(creds["party_id"])
        return checkerlib.CheckResult.OK

    def _check_service(self):
        # check if port is open
        if not self._check_port(self.ip, PORT):
            return checkerlib.CheckResult.DOWN

        # check if server is Apache 2.4.50
        if not self._check_apache_version(self.ip):
            return checkerlib.CheckResult.FAULTY
        
        return checkerlib.CheckResult.OK

    @ssh_connect()
    def check_flag(self, tick, client):
        if not self._check_service():
            return checkerlib.CheckResult.DOWN
        flag = checkerlib.get_flag(tick)
        creds = checkerlib.load_state("flag_" + str(tick))
        if not creds:
            logging.error(f"Cannot find creds for tick {tick}")
            return checkerlib.CheckResult.FLAG_NOT_FOUND
        user_present = self._check_credentials(client, creds["username"], creds["password"])
        if not user_present:
            return checkerlib.CheckResult.FLAG_NOT_FOUND
        return checkerlib.CheckResult.OK

    # Private Funcs - Return None if error
    def _create_system_user(self, ssh_session, username, password):
        # Execute the user creation command
        command = f"sudo useradd -m {username} && echo {username}:{password} | sudo chpasswd"
        stdin, stdout, stderr = ssh_session.exec_command(command)

        # Check if the command executed successfully
        if stderr.channel.recv_exit_status() != 0:
            raise Exception(f"Failed to create user: {stderr.read().decode()}")

        # Return the result
        return True

    def _check_credentials(self, ssh_session, username, password):
        # Check if the username exists
        command = f"id -u {username}"
        stdin, stdout, stderr = ssh_session.exec_command(command)
        if stderr.channel.recv_exit_status() != 0:
            return False

        # Check if the password is correct
        command = f"echo {password} | sudo -S id -u {username}"
        stdin, stdout, stderr = ssh_session.exec_command(command)
        if stderr.channel.recv_exit_status() != 0:
            return False

        return True  

    def _check_port(self, ip, port):
        sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        result = sock.connect_ex((ip, port))
        if result == 0:
            return True
        else:
            return False

    def _check_apache_version(self, ip):
        url = f"http://{ip}/server-status"
        res = requests.get(url)
        if res.status_code == 200 and "Apache/2.4.50" in res.text:
            return True
        else:
            return False

if __name__ == '__main__':
    checkerlib.run_check(MyChecker)
