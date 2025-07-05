#!/bin/bash

if [ "$#" -lt 3 ]; then
    echo "用法: $0 <輸入目錄> <輸出目錄> <輸入副檔名>"
    exit 1
fi

input_dir="$1"
output_dir="$2"
file_extension="$3"

if [ ! -d "$input_dir" ]; then
    echo "輸入目錄不存在或不是目錄"
    exit 1
fi

mkdir -p "$output_dir"

shopt -s nullglob
for file in "$input_dir"/*.$file_extension; do
    filename=$(basename -- "$file")
    output_file="$output_dir/${filename%.*}.mkv"
    
    echo "轉換中: $file -> $output_file"
    ffmpeg -i $file -c:v libx264 -preset medium  -crf 23 -c:a copy -c:s copy -disposition:a:2 default -disposition:a:1 0 $output_file
    
    if [ $? -eq 0 ]; then
        echo "轉換完成: $output_file"
    else
        echo "轉換失敗: $file"
    fi
done

shopt -u nullglob
echo "所有轉換完成!"
