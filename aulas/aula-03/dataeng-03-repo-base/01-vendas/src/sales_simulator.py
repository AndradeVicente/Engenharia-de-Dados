import os
import random
import time
import logging
from datetime import date
from decimal import Decimal
from db_utils import get_connection

logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger(__name__)

def get_random_cliente(cur):
    cur.execute('SELECT cliente_id FROM public.cliente')
    clientes = [row[0] for row in cur.fetchall()]
    return random.choice(clientes)

def get_random_produtos(cur, n):
    cur.execute('SELECT produto_id, preco_base FROM public.produto WHERE ativo = true')
    produtos = cur.fetchall()
    escolhidos = random.sample(produtos, k=n)
    return escolhidos

def criar_venda(cur, cliente_id):
    cur.execute('INSERT INTO public.venda (cliente_id, "data", entregue, valor_total) VALUES (%s, %s, %s, %s) RETURNING venda_id',
                (cliente_id, date.today(), 'N', Decimal('0.0')))
    venda_id = cur.fetchone()[0]
    return venda_id

def criar_itens_venda(cur, venda_id, produtos):
    valor_total = Decimal('0.0')
    for produto_id, preco_base in produtos:
        quantidade = random.choices([1,2,3,4,5], weights=[40,30,15,10,5])[0]
        preco_base_decimal = Decimal(preco_base)
        valor_item = preco_base_decimal * quantidade
        valor_total += valor_item
        cur.execute('INSERT INTO public.item_venda (venda_id, produto_id, valor_unitario, quantidade, valor_total) VALUES (%s, %s, %s, %s, %s)',
                    (venda_id, produto_id, preco_base_decimal, quantidade, valor_item))
    return valor_total

def atualizar_valor_venda(cur, venda_id, valor_total):
    cur.execute('UPDATE public.venda SET valor_total = %s WHERE venda_id = %s', (valor_total, venda_id))

def main():
    while True:
        with get_connection() as conn:
            with conn.cursor() as cur:
                cliente_id = get_random_cliente(cur)
                n_items = random.choices([1,2,3,4,5], weights=[40,30,15,10,5])[0]
                produtos = get_random_produtos(cur, n_items)
                venda_id = criar_venda(cur, cliente_id)
                valor_total = criar_itens_venda(cur, venda_id, produtos)
                atualizar_valor_venda(cur, venda_id, valor_total)
                logger.info("-" * 20)
                logger.info(f"Venda {venda_id} criada para cliente {cliente_id} com {n_items} itens. Valor total: R$ {float(valor_total):.2f}")
        sleep_time = random.uniform(0.25, 5)
        logger.info(f"Aguardando {sleep_time:.2f} segundos para próxima venda...")
        time.sleep(sleep_time)

if __name__ == '__main__':
    main()
