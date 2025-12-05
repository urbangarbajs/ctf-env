#!/bin/bash
set -e
rsync --daemon --config=/etc/rsyncd.conf
/usr/sbin/sshd -D
