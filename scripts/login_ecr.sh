#!/bin/bash
aws ecr get-login-password --region eu-central-1 | docker login --username AWS --password-stdin 480241654314.dkr.ecr.eu-central-1.amazonaws.com
