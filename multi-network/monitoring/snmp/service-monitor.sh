#!/bin/bash

# Source the .bash_profile and get NODETYPE
source ~/.bash_profile

# Determine the service name
if [ "$NODETYPE" = "full" ]
then
  service=celestia-full
elif [ "$NODETYPE" = "light" ]
then
  service=celestia-light
else
  echo "Unknown NODETYPE: $NODETYPE"
  exit 2
fi

# Check the status of the service
if systemctl --quiet is-active $service
then
  echo 0
  exit 0
else
  echo 1
  exit 1
fi
