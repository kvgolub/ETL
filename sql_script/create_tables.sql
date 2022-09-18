-- 1. Создание промежуточных таблиц (stg):

-- Создание таблицы "Черный список паспортов"
create table de1m.golb_stg_passport_blacklist (
    passport_num varchar2(15),
    entry_dt date
);

-- Создание таблицы "Транзакции"
create table de1m.golb_stg_transactions (
    trans_id varchar2(15),
    trans_date date,
    card_num varchar2(20),
    oper_type varchar2(50),
    amt decimal(10,2),
    oper_result varchar2(30),
    terminal varchar2(50)
);

-- Создание таблицы "Терминалы"
create table de1m.golb_stg_terminals (
    terminal_id varchar2(10),
    terminal_type varchar2(20),
    terminal_city varchar2(50),
    terminal_address varchar2(100)
);

-- Создание таблицы "Банковские карты"
create table de1m.golb_stg_cards (
    card_num varchar2(20),
    account_num varchar2(30),
    create_dt date,
    update_dt date
);

-- Создание таблицы "Аккаунты"
create table de1m.golb_stg_accounts (
    account_num varchar2(30),
    valid_to date,
    "CLIENT" varchar2(50),
    create_dt date,
    update_dt date
);

-- Создание таблицы "Клиенты"
create table de1m.golb_stg_clients (
    client_id varchar2(10),
    last_name varchar2(30),
    first_name varchar2(30),
    patronymic varchar2(30),
    date_of_birth date,
    passport_num varchar2(15),
    passport_valid_to date,
    phone varchar2(20),
    create_dt date,
    update_dt date
);

-- Очистка промежуточных таблиц:
/*
truncate table de1m.golb_stg_passport_blacklist;
truncate table de1m.golb_stg_transactions;
truncate table de1m.golb_stg_terminals;
truncate table de1m.golb_stg_cards;
truncate table de1m.golb_stg_accounts;
truncate table de1m.golb_stg_clients;
*/

-- Удаление промежуточных таблиц:
/*
drop table de1m.golb_stg_passport_blacklist;
drop table de1m.golb_stg_transactions;
drop table de1m.golb_stg_terminals;
drop table de1m.golb_stg_cards;
drop table de1m.golb_stg_accounts;
drop table de1m.golb_stg_clients;
*/


-- 2. Создание целевых таблиц-приемников:
-- Создание фактовой таблицы "Черный список паспортов"
create table de1m.golb_dwh_fact_pssprt_blcklst (
    passport_num varchar2(15),
    entry_dt date
);

-- Создание фактовой таблицы "Транзакции"
create table de1m.golb_dwh_fact_transactions (
    trans_id varchar2(15),
    trans_date date,
    card_num varchar2(20),
    oper_type varchar2(50),
    amt decimal(10,2),
    oper_result varchar2(30),
    terminal varchar2(50)
);

-- Создание SCD2 таблицы "Терминалы"
create table de1m.golb_dwh_dim_terminals_hist (
    terminal_id varchar2(10),
    terminal_type varchar2(20),
    terminal_city varchar2(50),
    terminal_address varchar2(100),
    effective_from date,
    effective_to date,
    deleted_flg char
);

-- Создание SCD2 таблицы "Банковские карты"
create table de1m.golb_dwh_dim_cards_hist (
    card_num varchar2(20),
    account_num varchar2(30),
    effective_from date,
    effective_to date,
    deleted_flg char
);

-- Создание SCD таблицы "Аккаунты"
create table de1m.golb_dwh_dim_accounts_hist (
    account_num varchar2(30),
    valid_to date,
    "CLIENT" varchar2(50),
    effective_from date,
    effective_to date,
    deleted_flg char
);

-- Создание SD2 таблицы "Клиенты"
create table de1m.golb_dwh_dim_clients_hist (
    client_id varchar2(10),
    last_name varchar2(30),
    first_name varchar2(30),
    patronymic varchar2(30),
    date_of_birth date,
    passport_num varchar2(15),
    passport_valid_to date,
    phone varchar2(20),
    effective_from date,
    effective_to date,
    deleted_flg char
);
    
-- Очистка таблиц приемников:
/*
truncate table de1m.golb_dwh_fact_pssprt_blcklst;
truncate table de1m.golb_dwh_fact_transactions;
truncate table de1m.golb_dwh_dim_terminals_hist;
truncate table de1m.golb_dwh_dim_cards_hist;
truncate table de1m.golb_dwh_dim_accounts_hist;
truncate table de1m.golb_dwh_dim_clients_hist;
*/

-- Удаление таблиц приемников:
/*
drop table de1m.golb_dwh_fact_pssprt_blcklst;
drop table de1m.golb_dwh_fact_transactions;
drop table de1m.golb_dwh_dim_terminals_hist;
drop table de1m.golb_dwh_dim_cards_hist;
drop table de1m.golb_dwh_dim_accounts_hist;
drop table de1m.golb_dwh_dim_clients_hist;
*/

-- 3. Создание вспомогательных таблици и витрины данных
-- Создание шестистрочной таблицы метаданных (для каждой из 6 таблиц одна строка)
create table de1m.golb_meta_setdate (
    schema_name varchar2(30),
    table_name varchar2(30),
    max_update_dt date
);

-- таблицы удалений
create table de1m.golb_stg_pass_black_del ( passport_num varchar2(15) );
create table de1m.golb_stg_transact_del (trans_id varchar2(15) );
create table de1m.golb_stg_terminals_del ( terminal_id varchar2(10) );
create table de1m.golb_stg_cards_del ( card_num varchar2(20) );
create table de1m.golb_stg_accounts_del ( account_num varchar2(30) );
create table de1m.golb_stg_clients_del ( client_id varchar2(10) );


-- Создание витрины данных
create table de1m.golb_rep_fraud (
    event_dt date,
    passport varchar2(15),
    fio varchar2(100),
    phone varchar2(20),
    event_type varchar2(200),
    report_dt date
);

-- Очистка таблиц:
/*
truncate table de1m.golb_meta_setdate;
truncate table de1m.golb_rep_fraud;
truncate table de1m.golb_stg_pass_black_del;
truncate table de1m.golb_stg_transact_del;
truncate table de1m.golb_stg_terminals_del;
truncate table de1m.golb_stg_cards_del;
truncate table de1m.golb_stg_accounts_del;
truncate table de1m.golb_stg_clients_del;
/*

-- Удалени таблиц:
/*
drop table de1m.golb_meta_setdate;
drop table de1m.golb_rep_fraud;
drop table de1m.golb_stg_pass_black_del;
drop table de1m.golb_stg_pass_transact_del;
drop table de1m.golb_stg_pass_terminals_del;
drop table de1m.golb_stg_pass_cards_del;
drop table de1m.golb_stg_pass_accounts_del;
drop table de1m.golb_stg_pass_clients_del;
*/