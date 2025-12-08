#!/bin/bash
set -e
service ssh start
service haproxy start
exec apache2-foreground
