#!/bin/bash

restore="$HOME/restore"

rm -rf "$restore" 2> /dev/null
mkdir "$restore"

backup_dir=$(find "$HOME"/backups/Backup-* -maxdepth 0 | sort -n | tail -n 1)

for file in "$backup_dir"/* "$backup_dir"/**/*
do
	file_name=${file#"$backup_dir"/}

	if [ -d "$file" ]; then
		mkdir -p "$restore/$file_name"
		continue
	fi

	if [[ ! "$file" =~ .*\.[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]]
	then
		file_name=${file#"$backup_dir"/}
		cp "$file" "$restore/$file_name"
	fi
done