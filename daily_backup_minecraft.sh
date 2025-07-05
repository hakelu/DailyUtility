#!/bin/bash

# 設定備份目錄
BACKUP_DIR="/minecraft_data/backup"
WORLD_DIR="/minecraft_data/world"

# 設定要保留的天數
RETENTION_DAYS=14

# 取得今天的日期 (YYYYMMDD 格式)
DATE=$(date +%Y%m%d)

# 設定今天的備份檔名
TODAY_BACKUP_FILE="${BACKUP_DIR}/world_${DATE}.tar.gz"

# 檢查今天的備份檔案是否存在，如果存在則刪除
if [ -f "${TODAY_BACKUP_FILE}" ]; then
  echo "今天的備份檔案 ${TODAY_BACKUP_FILE} 已存在，正在刪除..."
  rm "${TODAY_BACKUP_FILE}"
  echo "已刪除今天的備份檔案"
fi

# 進行備份
tar -czvf "${TODAY_BACKUP_FILE}" "${WORLD_DIR}"

echo "已於 $(date +%Y-%m-%d %H:%M:%S) 完成世界地圖備份至 ${TODAY_BACKUP_FILE}"

# 刪除 ${RETENTION_DAYS} 天前的備份檔案
find "${BACKUP_DIR}" -type f -name "world_*.tar.gz" -mtime +"${RETENTION_DAYS}" -delete

echo "已刪除 ${RETENTION_DAYS} 天前的備份檔案"
