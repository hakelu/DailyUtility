#!/bin/bash

if [ "$#" -lt 3 ]; then
    echo "用法: $0 <目錄> <原始關鍵字> <新關鍵字>"
    exit 1
fi

dir="$1"
original_keyword="$2"
new_keyword="$3"

if [ ! -d "$dir" ]; then
    echo "錯誤: $dir 不是一個有效的目錄"
    exit 1
fi

# 列出目錄內所有檔案，並處理名稱變更
for file in "$dir"/*; do
    [ -e "$file" ] || continue
    filename=$(basename -- "$file")
    
    if [[ "$filename" == *"$original_keyword"* ]]; then
        new_filename="${filename//$original_keyword/$new_keyword}"
        mv "$file" "$dir/$new_filename"
        echo "重命名: $filename -> $new_filename"
    else
        echo "未變更: $filename"
    fi
done

echo "處理完成!"
