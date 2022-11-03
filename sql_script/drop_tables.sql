-- Удаление промежуточных таблиц:
drop table de1m.golb_stg_passport_blacklist;
drop table de1m.golb_stg_transactions;
drop table de1m.golb_stg_terminals;
drop table de1m.golb_stg_cards;
drop table de1m.golb_stg_accounts;
drop table de1m.golb_stg_clients;

-- Удаление таблиц приемников:
drop table de1m.golb_dwh_fact_pssprt_blcklst;
drop table de1m.golb_dwh_fact_transactions;
drop table de1m.golb_dwh_dim_terminals_hist;
drop table de1m.golb_dwh_dim_cards_hist;
drop table de1m.golb_dwh_dim_accounts_hist;
drop table de1m.golb_dwh_dim_clients_hist;

-- Удаление таблиц:
drop table de1m.golb_meta_setdate;
drop table de1m.golb_rep_fraud;
drop table de1m.golb_stg_pass_black_del;
drop table de1m.golb_stg_transact_del;
drop table de1m.golb_stg_terminals_del;
drop table de1m.golb_stg_cards_del;
drop table de1m.golb_stg_accounts_del;
drop table de1m.golb_stg_clients_del;

-- Удаление схемы:
drop schema de1m;