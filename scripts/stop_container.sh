#!/bin/bash
set -e # Падать при ошибках, это важно, если не обрабатываем их явно.

# Находимся в папке scripts, deploy.env лежит уровнем выше
ENV_FILE="../deploy.env"

if [ ! -f "$ENV_FILE" ]; then
    echo "ОШИБКА: Файл с переменными окружения '$ENV_FILE' не найден! Не могу определить имя контейнера." >&2
    exit 1
fi

# Загружаем переменную CONTAINER_NAME из файла
source "$ENV_FILE"

if [ -z "$CONTAINER_NAME" ]; then
    echo "ОШИБКА: Переменная CONTAINER_NAME не определена в $ENV_FILE." >&2
    exit 1
fi

echo "Попытка остановить и удалить контейнер: ${CONTAINER_NAME}..."

# Проверяем, существует ли контейнер с таким именем (даже остановленный)
# -q выдает только ID, -f name=^/${CONTAINER_NAME}$ ищет по точному имени
EXISTING_CONTAINER_ID=$(docker ps -aq -f name=^/${CONTAINER_NAME}$)

if [ -n "$EXISTING_CONTAINER_ID" ]; then
    # Контейнер найден, пытаемся остановить, если он запущен
    if docker ps -q -f id=$EXISTING_CONTAINER_ID > /dev/null; then
        echo "Контейнер ${CONTAINER_NAME} запущен. Останавливаю..."
        docker stop $EXISTING_CONTAINER_ID
    else
        echo "Контейнер ${CONTAINER_NAME} остановлен, но существует."
    fi
    
    # Удаляем контейнер
    echo "Удаляю контейнер ${CONTAINER_NAME}..."
    docker rm $EXISTING_CONTAINER_ID
    echo "Контейнер ${CONTAINER_NAME} удален."
else
    echo "Контейнер ${CONTAINER_NAME} не найден. Ничего не делаю."
fi

exit 0

