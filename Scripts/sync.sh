#!/bin/bash

# Autor: Kamil Breczko
#
# Pracownia II 
# Systemy operacyjne 2016/2017 
# Temat: System plików
# Data: 17.01.2017

first=$1
second=$2

chmod -R 777 $first
chmod -R 777 $second
rsync -v -r -u -t $first $second
sync
notify-send "Updated catalog 1"
sleep 3
rsync -v -r -u -t $second $first
sync
notify-send "Updated catalog 2"
sleep 3
