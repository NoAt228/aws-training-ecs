#!/bin/bash
set -e # Падать при ошибках, это важно

# Находимся в папке scripts, наш файл лежит уровнем выше
ENV_FILE="../deploy.env"

if [ ! -f "$ENV_FILE" ]; then
    echo "ОШИБКА: Файл с переменными окружения '$ENV_FILE' не найден!" >&2
    exit 1
fi

# Загружаем переменные из файла (IMAGE_URI, CONTAINER_NAME)
source "$ENV_FILE"

echo "Переменные загружены:"
echo "IMAGE_URI: ${IMAGE_URI}"
echo "CONTAINER_NAME: ${CONTAINER_NAME}"

# Стягиваем свежий образ с нужным тегом
echo "Стягиваю образ: ${IMAGE_URI}"
docker pull ${IMAGE_URI}

# Запускаем новый контейнер
echo "Запускаю новый контейнер..."
docker run -d -p 80:8080 --name ${CONTAINER_NAME} ${IMAGE_URI}

echo "Деплой завершён!"

