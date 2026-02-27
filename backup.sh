#!/bin/bash

PROJECT_DIR="/home/user/prj/vend_srv"
BACKUP_DIR="$PROJECT_DIR/backups"

mkdir -p $BACKUP_DIR

# 1. Делаем дамп базы (используем -T для работы в фоне)
cd $PROJECT_DIR
docker compose exec -T db pg_dump -U postgres --clean --if-exists postgres > $BACKUP_DIR/db_$(date +%Y%m%d_%H%M).sql

# 2. Удаляем файлы старше 30 дней в папке бэкапов
find $BACKUP_DIR -type f -name "*.sql" -mtime +30 -delete

echo "Backup done and old files cleaned at $(date)"
