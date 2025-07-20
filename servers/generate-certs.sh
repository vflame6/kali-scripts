#!/bin/bash

openssl req -x509 -newkey rsa:2048 -keyout key.pem -out certificate.pem -days 365 -nodes
