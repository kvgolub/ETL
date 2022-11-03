-- 1. Создание новой схемы:
create schema de1m;


-- 2. Создание промежуточных таблиц (stg):

-- Создание таблицы "Черный список паспортов"
create table de1m.golb_stg_passport_blacklist (
    passport_num varchar(15),
    entry_dt date
);

-- Создание таблицы "Транзакции"
create table de1m.golb_stg_transactions (
    trans_id varchar(15),
    trans_date date,
    card_num varchar(20),
    oper_type varchar(50),
    amt decimal(10,2),
    oper_result varchar(30),
    terminal varchar(50)
);

-- Создание таблицы "Терминалы"
create table de1m.golb_stg_terminals (
    terminal_id varchar(10),
    terminal_type varchar(20),
    terminal_city varchar(50),
    terminal_address varchar(100)
);

-- Создание таблицы "Банковские карты"
create table de1m.golb_stg_cards (
    card_num varchar(20),
    account_num varchar(30),
    create_dt date,
    update_dt date
);

-- Создание таблицы "Аккаунты"
create table de1m.golb_stg_accounts (
    account_num varchar(30),
    valid_to date,
    client varchar(50),
    create_dt date,
    update_dt date
);

-- Создание таблицы "Клиенты"
create table de1m.golb_stg_clients (
    client_id varchar(10),
    last_name varchar(30),
    first_name varchar(30),
    patronymic varchar(30),
    date_of_birth date,
    passport_num varchar(15),
    passport_valid_to date,
    phone varchar(20),
    create_dt date,
    update_dt date
);


-- 3. Создание целевых таблиц-приемников:
-- Создание фактовой таблицы "Черный список паспортов"
create table de1m.golb_dwh_fact_pssprt_blcklst (
    passport_num varchar(15),
    entry_dt date
);

-- Создание фактовой таблицы "Транзакции"
create table de1m.golb_dwh_fact_transactions (
    trans_id varchar(15),
    trans_date date,
    card_num varchar(20),
    oper_type varchar(50),
    amt decimal(10,2),
    oper_result varchar(30),
    terminal varchar(50)
);

-- Создание SCD2 таблицы "Терминалы"
create table de1m.golb_dwh_dim_terminals_hist (
    terminal_id varchar(10),
    terminal_type varchar(20),
    terminal_city varchar(50),
    terminal_address varchar(100),
    effective_from date,
    effective_to date,
    deleted_flg char
);

-- Создание SCD2 таблицы "Банковские карты"
create table de1m.golb_dwh_dim_cards_hist (
    card_num varchar(20),
    account_num varchar(30),
    effective_from date,
    effective_to date,
    deleted_flg char
);

-- Создание SCD таблицы "Аккаунты"
create table de1m.golb_dwh_dim_accounts_hist (
    account_num varchar(30),
    valid_to date,
    client varchar(50),
    effective_from date,
    effective_to date,
    deleted_flg char
);

-- Создание SD2 таблицы "Клиенты"
create table de1m.golb_dwh_dim_clients_hist (
    client_id varchar(10),
    last_name varchar(30),
    first_name varchar(30),
    patronymic varchar(30),
    date_of_birth date,
    passport_num varchar(15),
    passport_valid_to date,
    phone varchar(20),
    effective_from date,
    effective_to date,
    deleted_flg char
);


-- 3. Создание вспомогательных таблици и витрины данных
-- Создание шестистрочной таблицы метаданных (для каждой из 6 таблиц одна строка)
create table de1m.golb_meta_setdate (
    schema_name varchar(30),
    table_name varchar(30),
    max_update_dt date
);

-- таблицы удалений
create table de1m.golb_stg_pass_black_del ( passport_num varchar(15) );
create table de1m.golb_stg_transact_del (trans_id varchar(15) );
create table de1m.golb_stg_terminals_del ( terminal_id varchar(10) );
create table de1m.golb_stg_cards_del ( card_num varchar(20) );
create table de1m.golb_stg_accounts_del ( account_num varchar(30) );
create table de1m.golb_stg_clients_del ( client_id varchar(10) );


-- Создание витрины данных
create table de1m.golb_rep_fraud (
    event_dt date,
    passport varchar(15),
    fio varchar(100),
    phone varchar(20),
    event_type varchar(200),
    report_dt date
);