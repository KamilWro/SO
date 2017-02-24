#!/bin/bash

# Autor: Kamil Breczko
#
# Pracownia II 
# Systemy operacyjne 2016/2017  
# Temat: System plików
# Data: 17.01.2017

if [ $# != 1 ]; then 
	echo "Incorrect number of arguments. "
	exit 1
fi

catalog="$1"

echo 'Links, which indicate nothing:'
for i in `find "$catalog" -type l`; do
    if [ ! -f `readlink "$i"` -a ! -d `readlink "$i"` ]; then
	echo -n "$i  ->  `readlink "$i"`"
	rm -f "$i" 2>/dev/null
	if [ -L "$i" ]; then
	   echo -n '  not deleted'
	else
	   echo -n '  deleted'
	fi 
	echo
    fi
done
