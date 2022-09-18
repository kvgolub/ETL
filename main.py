#!/usr/bin/python

import pandas as pd
import jaydebeapi
import os
import list_dir as ld


# функция обработки файлов с данными
var = ld.start()

dict_file = {'term_file': var[0], 'trans_file': var[1], 'pass_file': var[2]}
dict_date = {'term_date': var[3], 'trans_date': var[4], 'pass_date': var[5]}


# функция выполнения SQL-запросов из файлов .sql с подстановкой данных
def execute_query_set(out_local):
    list1 = out_local.read().replace('\n', ' ').split(';')
    size = len(list1) - 1
    if list1[size] == '':
        list1.remove('')

    # выполнение запроса
    with out_local as file:
        for i in list1:
            x = str(i).find('data_file')
            if x != -1 and dict_date['term_date'] != '':
                y = str(i).replace('data_file', dict_date['term_date'])
                curs.execute(y)
            elif x != -1 and dict_date['term_date'] == '':
                continue
            else:
                curs.execute(i)


# 1. Подключение к СУБД Oracle на сервере
conn = jaydebeapi.connect(
    'oracle.jdbc.driver.OracleDriver',
    'jdbc:oracle:thin:de1m/test@test:1521/deoracle',
    ['de1m', 'test'],
    '/home/de1m/ojdbc8.jar'
)
curs = conn.cursor()
conn.jconn.setAutoCommit(False)


# 2. Запуск скрипта очистки таблиц STG
# открытие и чтение запроса из файла скрипта SQL
dir = os.path.dirname(__file__)
out = open(dir + '/sql_stg_load/clear_stg.sql', 'r', encoding='utf-8')
execute_query_set(out)


# 3. Запуск скрипта загрузки данных из файлов
# чтение данных их excel, загузка в DataFrame и перенос в таблицы СУБД:

conn.rollback()

# а) Перенос "Черного списка паспортов"
if dict_file['pass_file'] != '':
    df = pd.read_excel(dir + '/' + dict_file['pass_file'], sheet_name='blacklist', header=0, index_col=None)
    df = df.astype(str)

    curs.executemany("insert into de1m.golb_stg_passport_blacklist( entry_dt, passport_num ) values ( to_date( ?, 'YYYY-MM-DD HH24:MI:SS' ), ? )", df.values.tolist())

    curs.execute('insert into de1m.golb_stg_pass_black_del(passport_num) select passport_num from de1m.golb_stg_passport_blacklist')

# b) Перенос "Терминалы"
if dict_file['term_file'] != '':
    df = pd.read_excel(dir + '/' + dict_file['term_file'], sheet_name='terminals', header=0, index_col=None)
    df = df.astype(str)

    curs.executemany("insert into de1m.golb_stg_terminals( terminal_id, terminal_type, terminal_city, terminal_address ) values( ?, ?, ?, ? )", df.values.tolist())

    curs.execute('insert into de1m.golb_stg_terminals_del(terminal_id) select terminal_id from de1m.golb_stg_terminals')

if dict_file['trans_file'] != '':
    # c) Перенос "Транзакции"
    df3 = pd.read_csv(dir + '/' + dict_file['trans_file'], sep=';', header=0, decimal=',')
    df3 = df3.astype(str)

    curs.executemany(
        "insert into de1m.golb_stg_transactions( trans_id, trans_date, amt, card_num, oper_type, oper_result, terminal ) values( ?, to_date( ?, 'YYYY-MM-DD HH24:MI:SS' ), cast ( ? as number ), ?, ?, ?, ? )", df3.values.tolist())

    curs.execute('insert into de1m.golb_stg_transact_del(trans_id) select trans_id from de1m.golb_stg_transactions')

conn.commit()


# 4. Запуск скрипта по переносу данных из СУБД в таблицы STG (захват, extract)
out = open(dir + '/sql_stg_load/load_database_stg.sql', 'r', encoding='utf-8')
execute_query_set(out)


# 5. Запуск скрипта по выделению вставок и изменений (transform) для фактовых таблиц; вставка в их приемник (load)
out = open(dir + '/sql_dwh_ext/extrct_dwc_fact.sql', 'r', encoding='utf-8')
execute_query_set(out)


# 6. Запуск скрипта по выделению вставок и изменений (transform) для таблиц-измерений; вставка в их приемник (load)
list2 = ['extract_dwh_dim_accnt', 'extract_dwh_dim_clnt', 'extract_dwh_dim_crd', 'extract_dwh_dim_trmn']

for i in list2:
    out = open(dir + '/sql_dwh_ext/' + i + '.sql', 'r', encoding='utf-8')
    execute_query_set(out)


# 7. Обработка удалений (папка sql_del)
list2 = ['del_accnt', 'del_clnt', 'del_crd', 'del_trmn']

for i in list2:
    out = open(dir + '/sql_del/' + i + '.sql', 'r', encoding='utf-8')
    execute_query_set(out)


# 8. Обновление метаданных (папка sql_meta) для таблиц измерений
out = open(dir + '/sql_meta/meta_all.sql', 'r', encoding='utf-8')
execute_query_set(out)


# 9. Построение витрины (отчета о мошеннических операциях)
out = open(dir + '/sql_rep/rep_fraud.sql', 'r', encoding='utf-8')
execute_query_set(out)

conn.commit()


if dict_file['trans_file'] != '':
    print('Отчет за ' + dict_date['trans_date'] + ' построен')


# перенос в архив отработанных файлов
ld.file_del(dict_file)
