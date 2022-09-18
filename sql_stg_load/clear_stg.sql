rollback;

truncate table de1m.golb_stg_passport_blacklist;
truncate table de1m.golb_stg_transactions;
truncate table de1m.golb_stg_terminals;
truncate table de1m.golb_stg_cards;
truncate table de1m.golb_stg_accounts;
truncate table de1m.golb_stg_clients;

truncate table de1m.golb_stg_pass_black_del;
truncate table de1m.golb_stg_transact_del;
truncate table de1m.golb_stg_terminals_del;
truncate table de1m.golb_stg_cards_del;
truncate table de1m.golb_stg_accounts_del;
truncate table de1m.golb_stg_clients_del;

commit;