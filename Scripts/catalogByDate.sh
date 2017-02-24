#!/bin/bash

# Autor: Kamil Breczko
#
# Pracownia II 
# Systemy operacyjne 2016/2017 
# Temat: System plików
# Data: 17.01.2017

if [ $# != 1 ]; then
	echo "Incorrect number of arguments."
	exit 1
fi

cd $1

files=`ls  -l --time-style=long-iso|grep -e  '^.*\.'|awk '{print $6, $8}'`
echo "$files" | while read dates name
 do
    dates=`echo "$dates" | cut -d - -f -2`
    if [ ! -d "$dates" ]; then
        mkdir "$dates"
    fi
    echo Created $dates
    mv -v $name $dates/$name
 done


