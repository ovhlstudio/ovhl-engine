#!/bin/bash

# Script untuk auto-move file *.lua.bak dari src ke ./lokal/backups/[timestamp]

# Buat folder dengan timestamp
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_DIR="./lokal/backups/backup_$TIMESTAMP"

# Cek apakah folder src ada
if [ ! -d "src" ]; then
    echo "Error: folder 'src' tidak ditemukan"
    exit 1
fi

# Buat backup directory kalau belum ada
mkdir -p "$BACKUP_DIR"

if [ $? -ne 0 ]; then
    echo "Error: Gagal membuat folder $BACKUP_DIR"
    exit 1
fi

echo "Backup directory: $BACKUP_DIR"

# Find dan move semua file *.lua.bak secara recursive
FILE_COUNT=0

while IFS= read -r file; do
    # Ambil relative path dari file
    rel_path="${file#src/}"
    dir_path="$BACKUP_DIR/$(dirname "$rel_path")"
    
    # Buat folder struktur di backup directory
    mkdir -p "$dir_path"
    
    # Move file
    mv "$file" "$dir_path/"
    
    if [ $? -eq 0 ]; then
        echo "✓ Moved: $file → $dir_path/"
        ((FILE_COUNT++))
    else
        echo "✗ Error moving: $file"
    fi
    
done < <(find src -name "*.lua.bak" -type f)

echo ""
echo "=========================================="
echo "Selesai! Total file dipindahkan: $FILE_COUNT"
echo "Location: $BACKUP_DIR"
echo "=========================================="