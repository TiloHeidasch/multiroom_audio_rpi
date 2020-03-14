#!/bin/bash

echo "Please enter the name you want your bluetooth adapter to appear as: "
read name

echo "PRETTY_HOSTNAME=$name" | sudo tee /etc/machine-info