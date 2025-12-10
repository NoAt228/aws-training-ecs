#!/bin/bash
# Получаем регион из метаданных инстанса
AWS_REGION=$(curl -s http://169.254.169.254/latest/dynamic/instance-identity/document | grep region | awk -F\" '{print $4}')

# Получаем ID аккаунта
AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)

# Логинимся в ECR, используя полученные данные
aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com
