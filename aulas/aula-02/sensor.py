import json
import random
import time
import sys
import os
import pika
from datetime import datetime

# Pega o ID do sensor da variável de ambiente ou usa 1 como padrão
SENSOR_ID = int(os.getenv('SENSOR_ID', '1'))

# Configurações do RabbitMQ via variáveis de ambiente
RABBITMQ_HOST = os.getenv('RABBITMQ_HOST', 'rabbitmq')
RABBITMQ_PORT = int(os.getenv('RABBITMQ_PORT', '5672'))
RABBITMQ_USER = os.getenv('RABBITMQ_USER', 'admin')
RABBITMQ_PASS = os.getenv('RABBITMQ_PASS', '')
QUEUE_NAME = os.getenv('QUEUE_NAME', '')

def conectar_rabbitmq():
    """Estabelece conexão com RabbitMQ"""
    credentials = pika.PlainCredentials(RABBITMQ_USER, RABBITMQ_PASS)
    parameters = pika.ConnectionParameters(
        host=RABBITMQ_HOST,
        port=RABBITMQ_PORT,
        credentials=credentials
    )

    try:
        connection = pika.BlockingConnection(parameters)
        channel = connection.channel()

        # Declara a fila (cria se não existir)
        channel.queue_declare(queue=QUEUE_NAME, durable=True)

        return connection, channel
    except Exception as e:
        print(f"Erro ao conectar com RabbitMQ: {e}", flush=True)
        return None, None


def wait_for_rabbitmq():
    """Aguarda RabbitMQ ficar disponível"""
    max_retries = 30
    retry_count = 0

    while retry_count < max_retries:
        try:
            connection, channel = conectar_rabbitmq()
            if connection is not None and channel is not None:
                connection.close()
                print("RabbitMQ está disponível!", flush=True)
                return True
        except Exception as e:
            pass

        retry_count += 1
        print(f"Aguardando RabbitMQ... tentativa {retry_count}/{max_retries}", flush=True)
        time.sleep(2)

    print("RabbitMQ não ficou disponível após 60 segundos", flush=True)
    return False

def gerar_dados_sensor():
    dados = {
        "id": SENSOR_ID,
        "data": datetime.now().isoformat(),
        "temperatura": random.uniform(20.0, 30.0) # Temperatura aleatória (Dummy)
    }
    return json.dumps(dados)

def send_message(channel, dados):
    """Envia mensagem para RabbitMQ usando canal existente"""
    try:
        # Publica a mensagem na fila
        channel.basic_publish(
            exchange='',
            routing_key=QUEUE_NAME,
            body=dados,
            properties=pika.BasicProperties(
                delivery_mode=2,  # Torna a mensagem persistente
            )
        )
        print(f"Mensagem enviada para RabbitMQ: {dados}", flush=True)

    except Exception as e:
        print(f"Erro ao enviar mensagem: {e}", flush=True)
        raise  # Re-lança a exceção para que o loop principal possa lidar com ela


# Aguarda RabbitMQ ficar disponível antes de começar
if not wait_for_rabbitmq():
    print("Encerrando: RabbitMQ não está disponível", flush=True)
    sys.exit(1)

print(f"Sensor {SENSOR_ID} iniciado!", flush=True)

# Cria conexão uma única vez no início
connection, channel = conectar_rabbitmq()
if connection is None or channel is None:
    print("Falha ao estabelecer conexão inicial com RabbitMQ", flush=True)
    sys.exit(1)

try:
    while True:
        dados = gerar_dados_sensor()

        try:
            send_message(channel, dados)
        except Exception as e:
            # Se houver erro na conexão, tenta reconectar
            print(f"Erro na conexão, tentando reconectar: {e}", flush=True)
            try:
                connection.close()
            except:
                pass

            connection, channel = conectar_rabbitmq()
            if connection is None or channel is None:
                print("Falha na reconexão. Tentando novamente no próximo ciclo.", flush=True)
            else:
                # Tenta enviar a mensagem novamente com a nova conexão
                try:
                    send_message(channel, dados)
                except Exception as retry_error:
                    print(f"Falha ao reenviar mensagem: {retry_error}", flush=True)

        # O tempo de espera é baseado no ID do sensor (1 espera menos, 3 espera mais)
        time.sleep(SENSOR_ID)

except KeyboardInterrupt:
    print(f"Sensor {SENSOR_ID} interrompido pelo usuário", flush=True)
except Exception as e:
    print(f"Sensor {SENSOR_ID} teve erro: {e}", flush=True)
finally:
    # Fecha a conexão ao final
    try:
        if connection and not connection.is_closed:
            connection.close()
            print("Conexão com RabbitMQ fechada", flush=True)
    except:
        pass
