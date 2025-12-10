#!/bin/bash
# Получаем регион из метаданных инстанса
AWS_REGION=eu-central-1

# Получаем ID аккаунта
AWS_ACCOUNT_ID=480241654314

# Логинимся в ECR, используя полученные данные
aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com
