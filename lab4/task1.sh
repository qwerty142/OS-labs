#!/bin/bash
trash=".trash"
mkdir -p "$HOME/$trash"
cnt=0
path=$(realpath -- "$1")

if ! [ -f "$path" ];
    then
    exit 1
fi

f_name_with_ras=$(basename -- "$path")

f_name="${f_name_with_ras%.*}"

while [[ -e "$HOME/$trash/${f_name}_$cnt" ]] ; do
    ((cnt=cnt + 1))
done 
ln "$path" "$HOME/$trash/${f_name}_$cnt" &&
rm "$path" &&
echo "$path ${name}_$cnt" >> $HOME/.trash.log
