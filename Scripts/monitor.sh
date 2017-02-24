#!/bin/sh

# Autor: Kamil Breczko
#
# Pracownia II 
# Systemy operacyjne 2016/2017 
# Temat: System plików
# Data: 17.01.2017

if  [ $# != 1 ]; then
	echo "Incorrect number of arguments."
	exit 1
fi

acceptable=$1
path="^/dev"
  df=`df -h | grep "$path" | awk '{print $5, $6}' | sed "s/%//"`
  echo "$df" | while read percent fs 
  do
    if [ $percent -gt $acceptable ]; then
 	notify-send "It is used $percent % of the directory $fs"
    fi
  done
