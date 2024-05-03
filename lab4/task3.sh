#!/bin/bash

backup="$HOME/backups"
source="$backup/source"
report="$backup/backup-report"

mkdir -p "$backup"
mkdir -p "$source"

if [[ ! -d $source ]] ;
then
	echo "$source directory does not exist"
	exit 1
fi

current_date=$(date +%F)
found_backup=$(find "$backup" -name "Backup-*" 2> /dev/null | sort -n | tail -n 1)
latest_date=$(basename "$found_backup" | awk -F '-' '{print $2"-"$3"-"$4}')

date_diff=$((($(date -d "$current_date" +%s) - ($(date -d "$latest_date" +%s))) / 86400))
echo $latest_date

if [[ (${#latest_date} -eq 2) || ("$date_diff" -gt 7) ]]
then
    dir_name="Backup-$current_date"
	echo $dir_name
	backup_dir=$backup/$dir_name

	mkdir "$backup_dir"
	echo "Backup has been created in $backup_dir"

	{
        echo "Date of the backup: $current_date"
        echo "Folder name: $dir_name"
    } >> "$report"

    ls "$source" >> "$report"

    cp -r "$source"/* "$backup_dir" | 2>/dev/null
else
    dir_name="Backup-$latest_date"
	backup_dir=$backup/$dir_name

	echo "Backup has been updated in: $backup_dir"
	echo "The backup was updated: $current_date" >> "$report"

	for file_path in "$source"/* "$source"/**/*
	do
		file_name=${file_path#"$source"/}
		backup_file="$backup_dir/$file_name"

		if [ -d "$source/$file_name" ]; then
			mkdir -p "$backup_file"
			continue
		fi

		if [ ! -f "$backup_file" ];
		then
			cp "$source/$file_name" "$backup_file" 2>/dev/null
			echo "New file $file_name was saved to backup" >> "$report"
		else 
			source_size=$(stat "$source/$file_name" -c%s)
			indir_size=$(stat "$backup_file" -c%s)
			if [[ "$source_size" -ne "$indir_size" ]];
			then
				mv "$backup_file" "$backup_file.$current_date"
				cp "$source/$file_name" "$backup_file" 2>/dev/null
				echo "New version of $file_name was found. Previous version was renamed to $file_name.$current_date" >> "$report"
			fi	
		fi
	done

fi