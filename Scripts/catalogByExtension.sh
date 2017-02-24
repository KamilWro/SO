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

exts=$(ls |grep -e  '^.*\.'| sed 's/^.*\.//'| sort -u)
for ext in $exts
 do
    echo Created $ext
    mkdir $ext
    mv -v *.$ext $ext/
 done
