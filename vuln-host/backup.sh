#!/bin/bash
# naive backup script – intentionally unsafe
echo "Running backup as $(whoami)"

# Bad idea: allow user to control what to run
if [ -n "$1" ]; then
  echo "Backing up path: $1"
  tar czf /tmp/backup.tgz "$1"
else
  echo "Usage: backup.sh <path>"
fi
