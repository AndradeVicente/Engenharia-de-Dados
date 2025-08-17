FROM python:3.11-slim

WORKDIR /app

# Instalar dependências
RUN pip install pika

# Copiar arquivos necessários
COPY sensor.py .
COPY .env .

# Definir variável de ambiente para saída não bufferizada
ENV PYTHONUNBUFFERED=1

# Executar o script
CMD ["python", "-u", "sensor.py"]