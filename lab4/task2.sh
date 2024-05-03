#!/bin/bash

line=""
while read line; do	
	if  ! grep -q -- "$1" <<< "$line"; then
		continue
	fi

    f_name=$(echo $line | cut -d " " -f 1)
    version=$(echo $line | cut -d " " -f 2)
    echo "deleted file with name: $f_name and version: $version" 

    echo "Do you want to restore file with version $version yes/no"
    read answer < /dev/tty
    if [[ "$answer" == "yes" ]]; then
        f_dir=$(dirname -- "$f_name")
        if [[ ! -d f_dir ]]; then
        	echo "Past dir doesnt exist, restore in root"
        	f_dir="$HOME/$1"
        fi
        f_name_with_ras=$(basename -- "$f_name")
        name_in_trash="${f_name_with_ras%.*}"
    	ln "$HOME/.trash/$name_in_trash$version" $f_dir &&
        rm "$HOME/.trash/$name_in_trash$version" && 
        {
      	sed -i "/$f_name/d" $HOME/.trash.log
        echo "Restored $to_untrash"
        }
    fi
done < /$HOME/.trash.log