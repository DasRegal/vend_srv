#!/bin/bash

# Восстановление:
# cat backups/ваш_файл.sql | docker compose exec -T db psql -U postgres postgres

# --- НАСТРОЙКИ ---
PROJECT_DIR="/home/user/prj/vend_srv"  # Путь к проекту
BACKUP_DIR="$PROJECT_DIR/backups"
LOG_FILE="$PROJECT_DIR/log/backup.log"
DB_SERVICE_NAME="db"                   # Имя сервиса базы в docker-compose.yml
DB_USER="postgres"                     # Пользователь базы из ENV
DB_NAME="postgres"                     # Имя базы из ENV
DAYS_TO_KEEP=30                        # Сколько дней хранить бэкапы

# Создаем папки, если их нет
mkdir -p $BACKUP_DIR
mkdir -p "$(dirname "$LOG_FILE")"

echo "[$(date +'%Y-%m-%d %H:%M:%S')] Starting backup..." >> $LOG_FILE

# Переходим в папку проекта
cd $PROJECT_DIR || { echo "Error: Could not cd to $PROJECT_DIR" >> $LOG_FILE; exit 1; }

# Имя файла с датой и временем
FILE_NAME="db_$(date +%Y%m%d_%H%M%S).sql"

# 1. СОЗДАНИЕ ДАМПА
# --clean: добавляет DROP TABLE (для чистой перезаписи при восстановлении)
# --if-exists: не выдает ошибку, если таблицы нет
# -T: запуск без интерактивного терминала (важно для Cron)
if docker compose exec -T $DB_SERVICE_NAME pg_dump -U $DB_USER --clean --if-exists $DB_NAME > "$BACKUP_DIR/$FILE_NAME"; then
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] Success: $FILE_NAME created." >> $LOG_FILE
else
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] ERROR: Backup failed!" >> $LOG_FILE
    rm -f "$BACKUP_DIR/$FILE_NAME" # Удаляем пустой файл при ошибке
    exit 1
fi

# 2. ОЧИСТКА СТАРЫХ ФАЙЛОВ
# Ищем только .sql файлы старше 30 дней и удаляем
find "$BACKUP_DIR" -type f -name "*.sql" -mtime +$DAYS_TO_KEEP -exec rm {} \;
echo "[$(date +'%Y-%m-%d %H:%M:%S')] Cleanup finished." >> $LOG_FILE

echo "-------------------------------------" >> $LOG_FILE
