#!/bin/bash

# 源目錄和目標目錄
SOURCE_DIR="$1"
DEST_DIR="$2"

# 確保目標目錄存在
mkdir -p "$DEST_DIR"

# 遍歷源目錄中的所有 flac 檔案
find "$SOURCE_DIR" -type f -iname "*.flac" | while read FLAC_FILE; do
  # 計算目標 MP3 檔案路徑
  RELATIVE_PATH="${FLAC_FILE#$SOURCE_DIR/}"
  MP3_FILE="$DEST_DIR/${RELATIVE_PATH%.flac}.mp3"

  # 創建目標目錄（如果不存在）
  mkdir -p "$(dirname "$MP3_FILE")"

  echo "$FLAC_FILE"
  echo "$MP3_FILE"


  # 轉換為 MP3 320kbps
  ffmpeg -i "$FLAC_FILE" -vn -ar 44100 -ac 2 -ab 320k "$MP3_FILE"

  echo "Converted: $FLAC_FILE to $MP3_FILE"
done

