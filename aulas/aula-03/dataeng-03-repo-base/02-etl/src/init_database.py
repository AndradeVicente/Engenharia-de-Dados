import psycopg2
from pathlib import Path
from dotenv import load_dotenv
import os


ddl_path = Path(__file__).resolve().parents[1] / "sql" / "0001-ddl-warehouse.sql"

with open(ddl_path, "r", encoding="utf-8") as f:
    ddl_commands = f.read()

load_dotenv(dotenv_path=".env")

conn = psycopg2.connect(
    dbname=os.getenv("POSTGRES_DB_APP"),
    user=os.getenv("POSTGRES_USER_APP"),
    password=os.getenv("POSTGRES_PASSWORD_APP"),
    host="localhost",
    port="5435"
)
conn.autocommit = True

cur = conn.cursor()
try:
    cur.execute(ddl_commands)
    print("✅ Banco de dados inicializado com sucesso.")
except Exception as e:
    print("⚠️ Erro ao inicializar o banco:", e)
finally:
    cur.close()
    conn.close()
