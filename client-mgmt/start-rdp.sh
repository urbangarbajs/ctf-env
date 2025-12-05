#!/bin/bash
set -e
service xrdp start
service dbus start || true
echo "XRDP ready on 3389 for user HC-ADMIN / Adm1nHC!2025"
tail -f /var/log/xrdp-sesman.log /var/log/xrdp.log
