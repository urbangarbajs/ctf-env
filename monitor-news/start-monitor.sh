#!/bin/sh
set -eu

python3 /opt/novapress/probe_server.py &
exec snmpd -f -Lo -C -c /etc/snmp/snmpd.conf
