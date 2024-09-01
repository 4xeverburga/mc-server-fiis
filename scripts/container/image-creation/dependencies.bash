#!/bin/bash

apt-get update

apt-get install -y wget
# mc server dependencies
apt-get install -y udev

# NOTE: exact version is not that important
# python from apt
apt-get install python-is-python3
# sqlite3
apt-get install sqlite3
