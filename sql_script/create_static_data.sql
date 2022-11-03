-- 1. Создание новой схемы:
create schema bank;


-- Создание таблицы "Банковские карты"
create table bank.cards (
    card_num varchar(20),
    account varchar(30),
    create_dt date,
    update_dt date
);

-- Создание таблицы "Аккаунты"
create table bank.accounts (
    account varchar(30),
    valid_to date,
    client varchar(50),
    create_dt date,
    update_dt date
);

-- Создание таблицы "Клиенты"
create table bank.clients (
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


-- Запонение таблицы "Банковские карты"
insert into bank.cards (card_num, account, create_dt, update_dt)
values
('card_num', 'account', '2022-01-01', '2022-05-01'),
('card_num2', 'account2', '2022-02-02', '2022-07-02');


-- Запонение таблицы "Аккаунты"
insert into bank.accounts (account, valid_to, client, create_dt, update_dt)
values
('account', '2022-01-01', 'client', '2022-01-01', '2022-05-01'),
('account2', '2022-01-01', 'client2', '2022-01-01', '2022-05-01');


-- Запонение таблицы "Клиенты"
insert into bank.clients (client_id, last_name, first_name, patronymic, date_of_birth, passport_num, passport_valid_to, phone, create_dt, update_dt)
values
('client_id', 'last_name', 'first_name', 'patronymic', '2040-01-01', 'passport_num', '2022-01-01', 'phone','2022-01-01', '2022-05-01'),
('client_id2', 'last_name2', 'first_name2', 'patronymic2', '2040-01-01', 'passport_num2', '2022-01-01', 'phone2','2022-01-01', '2022-05-01');