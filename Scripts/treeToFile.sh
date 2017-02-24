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

depth=1
olddir=`pwd`

function listfiles {
        cd "$1";
        for file in *
        do
                for ((i=0; $i < $depth; i++))
                do

			if [ $i = $(($depth-1)) ] ; then
				echo -n "|------ ">>$olddir/tree.txt
			else
				echo -n "|	 ">>$olddir/tree.txt
			fi                    
			#printf "\t";
                done
                
		if [ "`readlink $file`" != "" ]; then
			echo "$file -> `readlink $file`">>$olddir/tree.txt 
		elif [ -d "$file" ]; then
			echo "[ $file ]">>$olddir/tree.txt 
                        #printf "[$file]\n";
                else 
			echo "$file">>$olddir/tree.txt 
                        #printf "$file\n";
                fi

                if [ -d "$file" ] && [ "`readlink $file`" = "" ]
                then
                        depth=$depth+1;
                        listfiles "$file";
                        cd ..;
                fi
        done
        depth=$depth-1;
}
cd "$1"
echo "`pwd`">../tree.txt;
cd ..
listfiles "$1";

cat ../tree.txt

