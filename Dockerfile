FROM python:3.10-slim
RUN pip install flask
COPY app.py /app.py
EXPOSE 80
CMD ["python", "/app.py"]
