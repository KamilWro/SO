#!/bin/bash

# Autor: Kamil Breczko
#
# Pracownia II 
# Systemy operacyjne 2016/2017 
# Temat: System plików
# Data: 17.01.2017


main=pwd
maxDepth=-1

function flatten {
    local catalog=$1        
    local depth=$2  

	if [ $depth <> 0 ] && [ $catalog != $main ]; then
		mv -i -v `find $catalog  -maxdepth 1 -type f` $main 
		for i in `find "$catalog" -maxdepth 1 -type l`; do
			name=$i	
			name=`echo "$i" | awk 'BEGIN {FS="/"} {print $NF}'`					
			toLink=`readlink "$i"`	
			ln -s $toLink  $main/$name
			echo Created link to $toLink
			rm $i
		done
	fi 
     
	for i in `find $catalog  -mindepth 1 -maxdepth 1 -type d`; do
        	if [ $maxDepth = -1 ] || [ $depth -lt $maxDepth ]; then
            		flatten $i $(($depth + 1)) 
			rmdir $i 2>/dev/null
        	fi
    	done
}




if [ $# != 1 ]; then
	echo "Incorrect number of arguments. "
	exit 1
fi

if [ ! -d $1 ]; then
	echo "$1 isn't a directory!"
	exit 1
fi

cd $1
main=`pwd`
flatten $main 0
