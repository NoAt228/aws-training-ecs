#!/bin/bash
set -e

# --- НАЧАЛО МАГИИ ---
# Находим директорию, в которой лежит сам скрипт
SCRIPT_DIR=$(dirname "$0")
# Строим путь к файлу .env, который лежит на уровень выше
ENV_FILE="$SCRIPT_DIR/../deploy.env"
# --- КОНЕЦ МАГИИ ---

echo "Путь к скрипту: $SCRIPT_DIR"
echo "Ищу файл с переменными здесь: $ENV_FILE"

if [ ! -f "$ENV_FILE" ]; then
    echo "ОШИБКА: Файл с переменными окружения '$ENV_FILE' не найден!" >&2
    exit 1
fi

# Загружаем переменные из файла
source "$ENV_FILE"

echo "Переменные загружены: IMAGE_URI=${IMAGE_URI}, CONTAINER_NAME=${CONTAINER_NAME}"

# Стягиваем свежий образ
echo "Стягиваю образ: ${IMAGE_URI}"
docker pull ${IMAGE_URI}

# Запускаем новый контейнер
echo "Запускаю новый контейнер..."
docker run -d -p 80:8080 --name ${CONTAINER_NAME} ${IMAGE_URI}

echo "Деплой завершён!"

