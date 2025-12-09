#!/bin/bash
# Не падать при ошибках, мы сами всё контролируем
set +e

# --- НАЧАЛО МАГИИ ---
# Имя контейнера по умолчанию, если ничего не найдено
DEFAULT_CONTAINER_NAME="my-app-container"
CONTAINER_NAME=""

ENV_FILE="deploy.env"

# Пытаемся загрузить переменные, но НЕ падаем, если файла нет
if [ -f "$ENV_FILE" ]; then
    echo "Найден файл deploy.env, загружаю переменные..."
    source "$ENV_FILE"
    # Убедимся, что переменная CONTAINER_NAME действительно загрузилась
    if [ -z "$CONTAINER_NAME" ]; then
        echo "Переменная CONTAINER_NAME пуста в deploy.env, использую имя по умолчанию."
        CONTAINER_NAME=$DEFAULT_CONTAINER_NAME
    fi
else
    echo "Файл deploy.env не найден (это нормально при первом деплое с новыми скриптами). Использую имя контейнера по умолчанию."
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
    echo "Контейнер ${CONTAINER_NAME} не найден, ничего не делаю."
fi

# Всегда выходим с кодом 0, чтобы CodeDeploy считал, что всё хорошо
exit 0
