#!/bin/bash

# Autor: Kamil Breczko
#
# Pracownia II 
# Systemy operacyjne 2016/2017 
# Temat: System plików
# Data: 17.01.2017

function entry {
	if [ -d $1 ]; then
		cd $1
	else
		echo "$1 isn't a directory!"
		exit 1
	fi
}

function createFile {
	if [ "$1" != "" ] && [ "$1" != "*" ]; then
		touch "$1"
	fi
}

function createFolder {
	if [ "$1" != "" ]; then
		mkdir "$1" 2>/dev/null
	else
		echo "You couldn't create directory $1!"
		exit 1
	fi
}


if [ $# != 1 ]; then
	echo "Incorrect number of arguments. "
	exit 1
fi

path=$PWD/$1
old_folder=$PWD

awkText=`cat $path |awk '
{
	if(NR!=1){
		start=0
		i=0
		isFolder=0
		isEntry=0
		isLink=0
		path=""
		file=""
		for (j=1; j<=NF; j++){
			if(($j=="|") || ("|------"==$j)){
				i++	
			}	
		}

		if (last_i<i){
			isEntry=1		
		} else if (last_i>i){
			isEntry=-1		
		}

		if($NF=="]"){
			isFolder=1
			file=$(NF-1)	
		} else{
			isFolder=-1
			file=$NF		
		}

		if( (NF > 2) && ($(NF-1)=="->")){
			isLink=1
			path=$NF
			file=$(NF-2)		
		}

		print start, isFolder, isEntry, file, isLink, path
		last_i=i	
	}
	else{
		entry=0
		start=1
		file=$NF
		isFolder=0
		isEntry=0
		isLink=0
		path=""
		print start, isFolder, isEntry, file, isLink, path		
	}
}
'`

echo "$awkText" | while read start isFolder isEntry name isLink toLink
	do	
		if [ $start = 1 ] ; then
			createFolder "$name"
			old_folder=$name
		elif [ $isLink = 1 ] && [ $isEntry = 1 ] ; then
			entry "$old_folder"			
			ln  -s $toLink ./$name
		elif [ $isLink = 1 ] && [ $isEntry = 0 ] ; then
			ln  -s $toLink ./$name
		elif [ $isLink = 1 ] && [ $isEntry = -1 ] ; then
			cd ..
			ln  -s $toLink ./$name
		elif [ $isFolder = -1 ] && [ $isEntry = 1 ] ; then
			entry "$old_folder"
			createFile "$name"
		elif [ $isFolder = -1 ] && [ $isEntry = 0 ] ; then
			createFile "$name"
		elif [ $isFolder = -1 ] && [ $isEntry = -1 ] ; then
			cd ..			
			createFile "$name"
		elif [ $isFolder = 1 ] && [ $isEntry = 1 ]; then	
			entry "$old_folder"			
			createFolder "$name"
			old_folder=$name
		elif [ $isFolder = 1 ] && [ $isEntry = 0 ]; then	
			createFolder "$name"
			old_folder=$name
		elif [ $isFolder = 1 ] && [ $isEntry = -1 ]; then	
			cd ..
			createFolder "$name"
			old_folder=$name			
		fi	
	done

cat $path
