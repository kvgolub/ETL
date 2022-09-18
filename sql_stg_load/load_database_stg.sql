rollback;

insert into de1m.golb_stg_accounts( account_num, valid_to, client, create_dt, update_dt )
select * from bank.accounts
where update_dt > coalesce( 
    ( select max_update_dt from de1m.golb_meta_setdate
    where schema_name = 'DE1M' and table_name = 'GOLB_STG_ACCOUNTS' ), to_date( '1900-01-01 00:00:00', 'YYYY-MM-DD HH24:MI:SS' )
) or update_dt is NULL;

insert into de1m.golb_stg_cards( card_num, account_num, create_dt, update_dt )
select
    trim(card_num) card_num,
    account account_num,
    create_dt,
    update_dt
from bank.cards
where update_dt > coalesce( 
    ( select max_update_dt from de1m.golb_meta_setdate
    where schema_name = 'DE1M' and table_name = 'GOLB_STG_CARDS' ), to_date( '1900-01-01 00:00:00', 'YYYY-MM-DD HH24:MI:SS' )
) or update_dt is NULL;

insert into de1m.golb_stg_clients( 
    client_id,
    last_name,
    first_name,
    patronymic,
    date_of_birth,
    passport_num,
    passport_valid_to,
    phone,
    create_dt,
    update_dt)
select * from bank.clients
where update_dt > coalesce( 
    ( select max_update_dt from de1m.golb_meta_setdate
    where schema_name = 'DE1M' and table_name = 'GOLB_STG_CLIENTS' ), to_date( '1900-01-01 00:00:00', 'YYYY-MM-DD HH24:MI:SS' )
) or update_dt is NULL;

insert into de1m.golb_stg_accounts_del( account_num )
select account from bank.accounts;

insert into de1m.golb_stg_cards_del( card_num )
select card_num from bank.cards;

insert into de1m.golb_stg_clients_del( client_id )
select client_id from bank.clients;

commit;