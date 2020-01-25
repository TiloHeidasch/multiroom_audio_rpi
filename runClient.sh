#!/bin/sh
if [ "$EUID" -ne 0 ]
  then echo "Please run with sudo"
  exit 1
fi

snapclient -h $1