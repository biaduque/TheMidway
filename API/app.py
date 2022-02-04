# -*- coding: utf-8 -*-

__author__ = "The Midway"
__copyright__ = "COPYRIGHT © 2021 The Midway"
__version__ = "1.1"
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

app.secret_key = str(environ.get("SECRET_KEY", 'nada'))


# Configuração do JSON
app.config['JSON_AS_ASCII'] = False

# Conexão com o banco de dados
app.config['MYSQL_HOST'] = str(environ.get("MYSQL_HOST", 'localhost'))
app.config['MYSQL_USER'] = str(environ.get("MYSQL_USER", 'root'))
app.config['MYSQL_PASSWORD'] = str(environ.get("MYSQL_PASSWORD", getenv("SENHA_BD")))
app.config['MYSQL_DB'] = str(environ.get("MYSQL_DB", 'themidway'))


# MySql -> Banco de dados
mysql = MySQL(app)


# Tabelas
TABLE_SUGGESTIONS = "suggestions"
TABLE_MEETINGS_CREATED = "meetingsCreated"



# Colunas das tabelas
COLUMNS_SUGGESTIONS: tuple = ("placeName", "category", "longitude ", "latitude ", "postalCode", "country", "city", "district", "address", "addressNumber")
COLUMNS_MEETINGS_CREATED: tuple = ("meetingName", "date", "time", "placeName", "category", "longitude ", "latitude ", "postalCode", "country", "city", "district", "address", "addressNumber")


# Rota para a tabela de sugestôes
@app.route(f'/{TABLE_SUGGESTIONS}', methods=['GET', 'POST'])
def homeSuggestions():
    r"""Função principal que é executada assim que faz uma requisição."""
    
    if request.method == "GET":
        try:
            parameter = request.args.get("keyWord")
        except:
            return Response(status=404)


        # Se comunica com o banco de dados
        data = database_maneger(TABLE_SUGGESTIONS, "GET", keyWord = parameter)

        # Ajeita os dados
        new_data = convert_data(TABLE_SUGGESTIONS, data)

        # Cria o JSON
        to_json = jsonify({"items": new_data})

        return to_json

        
    elif request.method == "POST":
        # Pega os dados passados por parâmetro
        data_parameters = []
        for col in COLUMNS_SUGGESTIONS:
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



# Rota para a tabela de sugestôes
@app.route(f'/{TABLE_MEETINGS_CREATED}', methods=['GET', 'POST'])
def homeMeetingsCreated():
    r"""Função principal que é executada assim que faz uma requisição."""
    
    if request.method == "GET":
        try:
            parameter = request.args.get("keyWord")
        except:
            parameter = ""

        # Se comunica com o banco de dados
        data = database_maneger(TABLE_MEETINGS_CREATED, "GET", keyWord = "")

        # Ajeita os dados
        new_data = convert_data(TABLE_MEETINGS_CREATED, data)

        # Cria o JSON
        to_json = jsonify({"items": new_data})

        return to_json

        
    elif request.method == "POST":
        # Pega os dados passados por parâmetro
        data_parameters = []
        for col in COLUMNS_MEETINGS_CREATED:
            try:
                data = request.args.get(col)
                if data == "":
                    data = None
            except:
                data = None
            finally:
                data_parameters.append(data)

        # Se comunica com a banco de dados
        data = database_maneger(TABLE_MEETINGS_CREATED, "POST", keyWord = "", data = tuple(data_parameters))

        return Response(status=200)

    return Response(status=404)





#### MANIPULAÇÃO DOS DADOS ####

def convert_data(table: str, data: tuple) -> str:
    r"""Função responsável por criar os itens da lista do JSON."""

    items: list = []
    for line in data:
        data_filtred = create_encontro_item(table, line)
        items.append(data_filtred)

    return items


def create_encontro_item(table: str, data: tuple) -> dict:
    r"""Cria o dicionário para cada linha recebida do banco de dados."""

    dict_data = {}

    if table == TABLE_SUGGESTIONS:
        column_names = ["id","", "placeName", "category", "longitude ", "latitude ", "postalCode", "country", "city", "district", "address", "addressNumber"]

        for x in range(len(data)):
            if x != 1:
                dict_data[column_names[x]] = data[x]

    else:
        column_names = ["id","", "meetingName", "date", "time", "placeName", "category", "longitude ", "latitude ", "postalCode", "country", "city", "district", "address", "addressNumber"]

        for x in range(len(data)):
            if x != 1:
                if x == 3:
                    data_date: datetime = data[x]
                    dict_data[column_names[x]] = data_date.strftime("%d/%m/%Y")
                elif x == 4:
                    dict_data[column_names[x]] = str(data[x])[:5]
                else:
                    dict_data[column_names[x]] = data[x]

    return dict_data


#### COMUNICAÇÃO COM O BANCO DE DADOS ####

def database_maneger(table: str, type: str, keyWord: str, data: tuple = ()) -> tuple:
    r"""Toda comunicação com o banco de dados é feita nessa função"""

    # Cria a conecção
    cur = mysql.connection.cursor()
    
    if type == "GET":
        # Executa o comando
        if keyWord != "":
            cur.execute(f"SELECT * FROM {table} WHERE category = '{keyWord}'")
        else:
            cur.execute(f"SELECT * FROM {table}")
        
        # Salva em uma variável
        data = cur.fetchall()


    elif type == "POST":
        
        query: str = ""

        # Cria uma lista para poder editar
        data_list = list(data)

        if table == TABLE_MEETINGS_CREATED:
            # Converte a data em str para o tipo data (str -> datetime)
            try_convertion(data_list, 1, datetime.strptime(data_list[1], '%d/%m/%Y'))
            
            # Converte a hora em str para o tipo hora (str -> timedelta)
            hour_datetime = datetime.strptime(data_list[2], '%H:%M')
            try_convertion(data_list, 2, timedelta(hours=hour_datetime.hour, minutes=hour_datetime.minute))
            
            # Latitude: (str -> float)
            try:
                try_convertion(data_list, 5, float(data_list[5]))
            except:
                data_list[5] = None

            # Longitude: (str -> float)
            try:
                try_convertion(data_list, 6, float(data_list[6]))
            except:
                data_list[6] = None

            # Cria uma tupla
           

            # Configurações para o comando:
            column_str = str(COLUMNS_MEETINGS_CREATED).replace("\'", "")
            infos: str = "(%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)"

            query = f"INSERT INTO {TABLE_MEETINGS_CREATED} {column_str} VALUES {infos}"


        # Transforma em tupla de novo
        data_tuple = tuple(data_list)

        # Executa o comando
        cur.execute(query, data_tuple)

    
    cur.close()                     # Fecha a comunicação
    mysql.connection.commit()       # Da um commit no MySQL
    return data
    


def try_convertion(data: list, ind: int, newData) -> None:
    # try:
        data[ind] = newData
    # except:
    #     data[ind] = None



def main() -> None:
    r"""Função main, o que precisa pra rodar"""

    port = int(environ.get("PORT", 5000))
    app.run(host='0.0.0.0', port=port, debug=True)


# Execução da função main.
if __name__ == '__main__':    
    main()