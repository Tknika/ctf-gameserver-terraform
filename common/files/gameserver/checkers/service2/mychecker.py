#!/usr/bin/env python3

from ctf_gameserver import checkerlib
import requests
from requests import Session
import logging
import http.client
import socket
import paramiko
import crypt
import hashlib
import crypt

PORT = 8787

def ssh_connect():
    def decorator(func):
        def wrapper(*args, **kwargs):
            # SSH connection setup
            client = paramiko.SSHClient()
            client.set_missing_host_key_policy(paramiko.AutoAddPolicy())
            rsa_key = paramiko.RSAKey.from_private_key_file(f'/keys/team{args[0].team}-sshkey')
            client.connect(args[0].ip, username = 'root', pkey=rsa_key)

            # Call the decorated function with the client parameter
            args[0].client = client
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
    def place_flag(self, tick):
        flag = checkerlib.get_flag(tick)
        creds = self._create_system_user(self.client, username="flag_" + str(tick), password=flag)
        if not creds:
            return checkerlib.CheckResult.FAULTY
        logging.info('created')
        checkerlib.store_state(creds["username"], creds)
        checkerlib.set_flagid(creds["username"])
        return checkerlib.CheckResult.OK

    def check_service(self):
        # check if port is open
        if not self._check_port(self.ip, PORT):
            return checkerlib.CheckResult.DOWN
        
        # # check if server is Apache 2.4.50
        if not self._check_apache_version():
            return checkerlib.CheckResult.FAULTY
        
        return checkerlib.CheckResult.OK

    def check_flag(self, tick):
        if not self.check_service():
            return checkerlib.CheckResult.DOWN
        flag = checkerlib.get_flag(tick)
        creds = checkerlib.load_state("flag_" + str(tick))
        if not creds:
            logging.error(f"Cannot find creds for tick {tick}")
            return checkerlib.CheckResult.FLAG_NOT_FOUND
        user_present = self._check_credentials(creds["username"], creds["password"])
        if not user_present:
            return checkerlib.CheckResult.FLAG_NOT_FOUND
        return checkerlib.CheckResult.OK

    # Private Funcs - Return False if error
    def _create_system_user(self, ssh_session, username, password):
        # Execute the user creation command in the conFLAG_Q1RGLUdDlGFTRVJ8RVYwCJk5eQEKR+H9tainer
        command = f"docker exec service2_web_1 sh -c 'useradd -m {username} && echo {username}:{password} | chpasswd'"
        stdin, stdout, stderr = ssh_session.exec_command(command)

        # Check if the command executed successfully
        if stderr.channel.recv_exit_status() != 0:
            return False

        # Return the result
        return {'username': username, 'password': password}

    @ssh_connect()
    def _check_credentials(self, username, password):
        # Check if the username exists
        ssh_session = self.client
        command = f"docker exec service2_web_1 sh -c 'id -u {username}'"
        stdin, stdout, stderr = ssh_session.exec_command(command)
        if stderr.channel.recv_exit_status() != 0:
            return False

        # Check if the password is correct
        command = f"docker exec service2_web_1 sh -c 'cat /etc/shadow | grep {username}'"
        stdin, stdout, stderr = ssh_session.exec_command(command)
        if stderr.channel.recv_exit_status() != 0:
            return False

        output = stdout.read().decode().strip()
        stored_hash = output.split(":")[1]
        hashed_password = crypt.crypt(password, stored_hash)

        return stored_hash == hashed_password

    def _check_port(self, ip, port):
        try:
            conn = http.client.HTTPConnection(ip, port, timeout=5)
            conn.request("GET", "/")
            response = conn.getresponse()
            return response.status == 200
        except (http.client.HTTPException, socket.error) as e:
            print(f"Exception: {e}")
            return False
        finally:
            if conn:
                conn.close()

    @ssh_connect()
    def _check_apache_version(self):
        ssh_session = self.client
        command = f"docker exec service2_web_1 sh -c 'httpd -v | grep \"Apache/2.4.50\'"
        stdin, stdout, stderr = ssh_session.exec_command(command)

        if stdout:
            return True
        else:
            return False

if __name__ == '__main__':
    checkerlib.run_check(MyChecker)
