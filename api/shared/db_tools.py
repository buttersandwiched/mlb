from os import getcwd

from sqlalchemy import create_engine, text
from typing import Literal
import pandas as pd
from dotenv import load_dotenv, find_dotenv
import os


def get_db_credentials():
    load_dotenv()

    return {
        'user': os.getenv("DB_USER"),
        'password': os.getenv("DB_PASSWORD"),
        'host':  os.getenv("DB_HOST"),
        'port': os.getenv("DB_PORT"),
        'db': os.getenv("DB_NAME")
    }


def connect_db():
    creds = get_db_credentials()
    user = creds['user']
    password = creds['password']
    host = creds['host']
    port = creds['port']
    db = creds['db']

    try:
        engine = create_engine(f'postgresql://{user}:{password}@{host}:{port}/{db}')
        return engine
    except Exception as e:
        print(e)


#This function sets up a fresh db instance with requisite schemas, tables and views
#to accommodate the mlb-fantasy app
def init_mlb_api_db(host='localhost', port=5432, db='sports_analytics'):
    try:
        sql_engine = connect_db()
        sql = open('api/shared/init.sql', 'r').read()
        with sql_engine.connect() as connection:
            connection.execute(sql)

    except Exception as e:
        print(e)

    return None


def truncate_table(table_name: str, db_schema: str):
    try:
        conn = connect_db()

        with conn.connect() as connection:
            statement = connection.execute(text(f"TRUNCATE TABLE {db_schema}.{table_name} RESTART IDENTITY CASCADE;"))
            statement.connection.commit()
        return f"Table {db_schema}.{table_name} truncated successfully."

    except Exception as e:
        return f"Error truncating table: {e}"


def write_to_db(data,
                data_schema:    dict=None,
                db_schema:      str='raw',
                table_name:     str=None,
                write_mode:     Literal['fail', 'append', 'replace', 'reload']='replace',
                verbose:        bool=False):
    df = pd.DataFrame(data)
    row_count = len(df)
    conn = connect_db()
    try:

        if write_mode not in ['append', 'replace', 'fail', 'reload']:
            return "Invalid write mode. Options are 'append', 'reload' or 'replace'."

        #do not want the table dropped, only truncated
        elif write_mode == 'reload':
            truncate_table(table_name, db_schema)
            write_mode = 'append'

        rows_affected = df.to_sql(name=table_name,
                  schema=db_schema,
                  con=conn,
                  if_exists=write_mode,
                  dtype=data_schema,
                  index=False)

        if verbose:
            print(f"Rows affected: {rows_affected}\n Row count: {row_count}")

        return rows_affected

    except Exception as e:
        print(f"Error writing to table: {e}")
        return  0
