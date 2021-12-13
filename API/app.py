# -*- coding: utf-8 -*-

__author__ = "The Midway"
__copyright__ = "COPYRIGHT © 2021 The Midway"
__version__ = "0.1"
__status__ = "local communication"
__license__ = "https://github.com/biaduque/TheMidway/blob/main/LICENSE"


## Bibliotecas necessárias:
from datetime import datetime, timedelta

from flask import Flask, request, Response
from flask.json import jsonify
from flask_mysqldb import MySQL

from os import getenv, environ


## Criando a aplicação:
app = Flask(__name__)

app.secret_key = 'secretKey'


# Configuração do JSON
app.config['JSON_AS_ASCII'] = False

# Conexão com o banco de dados
app.config['MYSQL_HOST'] = 'localhost'
app.config['MYSQL_USER'] = 'root'
app.config['MYSQL_PASSWORD'] = getenv('SENHA_BD')
app.config['MYSQL_DB'] = 'theMidway'


# MySql -> Banco de dados
mysql = MySQL(app)


# Tabela sendo usada
TABELA = "encontros"

COLUNAS: tuple = ("data", "hora", "nome", "tipo", "longitude", "latitude", "pais", "cidade", "bairro", "endereco", "numero")

# Cria a rota principal (encontros) com os métodos GET e POST.
@app.route(f'/{TABELA}', methods=['GET', 'POST'])
def home():
    r"""Função principal que é executada assim que faz uma requisição."""
    
    if request.method == "GET":
        # Se comunica com o banco de dados
        data = database_maneger("GET", ())

        # Ajeita os dados
        new_data = convert_data(data)

        # Cria o JSON
        to_json = jsonify({"itens": new_data})

        return to_json

        
    elif request.method == "POST":
        # Pega os dados passados por parâmetro
        data_parameters = []
        for col in COLUNAS:
            try:
                data = request.args.get(col)
                if data == "":
                    data = None
            except:
                data = None
            finally:
                data_parameters.append(data)

        # Se comunica com a banco de dados
        data = database_maneger("POST", tuple(data_parameters))

        return Response(status=200)

    return Response(status=404)


#### MANIPULAÇÃO DOS DADOS ####

def convert_data(data: tuple) -> str:
    r"""Função responsável por criar os itens da lista do JSON."""
    itens: list = []
    for line in data:
        data_filtred = create_encontro_item(line)
        itens.append(data_filtred)

    return itens


def create_encontro_item(data: tuple) -> dict:
    r"""Cria o dicionário para cada linha recebida do banco de dados."""

    column_names = ["id","", "date", "hour", "name", "type", "latitude", "longitude", "country", "city", "district", "address", "number"]
    
    dict_data = {}
    for x in range(len(data)):
        if x != 1:
            if x == 2:
                data_date: datetime = data[x]
                dict_data[column_names[x]] = data_date.strftime("%d/%m/%Y")
            elif x == 3:
                dict_data[column_names[x]] = str(data[x])[:5]
            else:
                dict_data[column_names[x]] = data[x]
    return dict_data


#### COMUNICAÇÃO COM O BANCO DE DADOS ####

def database_maneger(type: str, data: tuple) -> tuple:
    r"""Toda comunicação com o banco de dados é feita nessa função"""

    # Cria a conecção
    cur = mysql.connection.cursor()
    
    if type == "GET":
        # Executa o comando
        cur.execute(f"SELECT * FROM {TABELA}")

        # Salva em uma variável
        data = cur.fetchall()


    elif type == "POST":
        # Cria uma lista para poder editar
        data_list = list(data)
    
        # Converte a data em str para o tipo data (str -> datetime)
        data_list[0] = datetime.strptime(data_list[0], '%d/%m/%Y')
        
        # Converte a hora em str para o tipo hora (str -> timedelta)
        hour_datetime = datetime.strptime(data_list[1], '%H:%M')
        data_list[1] = timedelta(hours=hour_datetime.hour, minutes=hour_datetime.minute)

        # Latitude: (str -> float)
        data_list[4] = float(data_list[4])

        # Longitude: (str -> float)
        data_list[5] = float(data_list[5])


        # Cria uma tupla
        data_tuple = tuple(data_list)


        # Configurações para o comando:
        column_str = str(COLUNAS).replace("\'", "")
        infos: str = "(%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)"

        # Executa o comando
        cur.execute(f"INSERT INTO {TABELA} {column_str} VALUES {infos}", data_tuple)

    
    cur.close()                     # Fecha a comunicação
    mysql.connection.commit()       # Da um commit no MySQL
    return data
    


def main() -> None:
    r"""Função main, o que precisa pra rodar"""

    port = int(environ.get("PORT", 5000))
    app.run(host='0.0.0.0', port=port, debug=True)


# Execução da função main.
if __name__ == '__main__':    
    main()