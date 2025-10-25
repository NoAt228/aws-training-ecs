from flask import Flask, request
import math
import time

app = Flask(__name__)


@app.route("/")
def hello():
    return "Hello from ECS Fargate! cicd completed aswaddd "
@app.route("/heavy")
def heavy():
    """
    Эндпоинт, имитирующий ресурсоемкую задачу для тестирования автоскейлинга.
    Выполняет вычисления в цикле. Количество итераций можно задать
    через query-параметр 'iterations'.
    Пример: /heavy?iterations=5000000
    """
    try:
        iterations = int(request.args.get('iterations', 5000000))
    except ValueError:
        return "Invalid 'iterations' parameter. Must be an integer.", 400

    result = 0
    for i in range(iterations):
        result = math.sqrt(i)

    return f"Heavy task completed with {iterations} iterations. Final result: {result}"

@app.route("/memory")
def memory():
    """
    Эндпоинт для имитации потребления ОЗУ.
    Создает в памяти большой объект. Размер в мегабайтах задается
    через query-параметр 'mb'.
    Пример: /memory?mb=100
    """
    try:
        mb_to_consume = int(request.args.get('mb', 100))
    except ValueError:
        return "Invalid 'mb' parameter. Must be an integer.", 400

    # Создаем большой объект в памяти
    memory_hog = bytearray(mb_to_consume * 1024 * 1024)
    
    # Держим память занятой некоторое время
    time.sleep(10)

    return f"Consumed {mb_to_consume} MB of memory for 10 seconds."

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=8080)
