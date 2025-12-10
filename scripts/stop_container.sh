#!/bin/bash
set +e

# --- НАЧАЛО МАГИИ ---
SCRIPT_DIR=$(dirname "$0")
ENV_FILE="$SCRIPT_DIR/../deploy.env"
DEFAULT_CONTAINER_NAME="my-app-container"
CONTAINER_NAME=""

if [ -f "$ENV_FILE" ]; then
    echo "Найден файл deploy.env, загружаю переменные..."
    source "$ENV_FILE"
    if [ -z "$CONTAINER_NAME" ]; then
        echo "Переменная CONTAINER_NAME пуста, использую имя по умолчанию."
        CONTAINER_NAME=$DEFAULT_CONTAINER_NAME
    fi
else
    echo "Файл deploy.env не найден, использую имя по умолчанию."
    CONTAINER_NAME=$DEFAULT_CONTAINER_NAME
fi
# --- КОНЕЦ МАГИИ ---

echo "Попытка остановить и удалить контейнер: ${CONTAINER_NAME}..."

EXISTING_CONTAINER_ID=$(docker ps -aq -f name=^/${CONTAINER_NAME}$)

if [ -n "$EXISTING_CONTAINER_ID" ]; then
    echo "Контейнер ${CONTAINER_NAME} найден. Останавливаю и удаляю..."
    docker stop $EXISTING_CONTAINER_ID
    docker rm $EXISTING_CONTAINER_ID
else
    echo "Контейнер ${CONTAINER_NAME} не найден."
fi

exit 0

