#!/bin/bash

if [ -z "$1" ]; then
    echo "用法: $0 <目錄>"
    exit 1
fi

dir="$1"

if [ ! -d "$dir" ]; then
    echo "錯誤: $dir 不是一個有效的目錄"
    exit 1
fi

# 遍歷目錄內的所有檔案
for file in "$dir"/*; do
    # 確保是檔案
    [ -e "$file" ] || continue
    
    # 取得檔案名稱
    filename=$(basename -- "$file")
    
    # 先去除 '[DB]'
    new_filename=$(echo "$filename" | sed 's/\[DB\]//g')
    
    # 替換 '('、')'、'['、']' 和空白為 '_'
    new_filename=$(echo "$new_filename" | sed 's/[()\[\] ]/_/g')

    # 若檔名有變更，則重新命名
    if [ "$filename" != "$new_filename" ]; then
        mv "$file" "$dir/$new_filename"
        echo "重命名: $filename -> $new_filename"
    fi
done

echo "完成!"
