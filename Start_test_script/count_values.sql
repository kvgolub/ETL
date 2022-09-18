select count(passport_num) stg_passport_blacklist from de1m.golb_stg_passport_blacklist;
select count(passport_num) stg_pass_black_del from de1m.golb_stg_pass_black_del;
select count(passport_num) dwh_fact_pssprt_blcklst from de1m.golb_dwh_fact_pssprt_blcklst;

select count(trans_id) stg_transactions from de1m.golb_stg_transactions;
select count(trans_id) stg_transact_del from de1m.golb_stg_transact_del;
select count(trans_id) dwh_fact_transactions from de1m.golb_dwh_fact_transactions;

select count(terminal_id) stg_terminals from de1m.golb_stg_terminals;
select count(terminal_id) stg_terminals_del from de1m.golb_stg_terminals_del;
select count(terminal_id) dwh_dim_terminals_hist from de1m.golb_dwh_dim_terminals_hist;

select count(account_num) stg_accounts from de1m.golb_stg_accounts;
select count(account_num) stg_accounts_del from de1m.golb_stg_accounts_del;
select count(account_num) dwh_dim_accounts_hist from de1m.golb_dwh_dim_accounts_hist;

select count(card_num) stg_cards from de1m.golb_stg_cards;
select count(card_num) stg_cards_del from de1m.golb_stg_cards_del;
select count(card_num) dwh_dim_cards_hist from de1m.golb_dwh_dim_cards_hist;

select count(client_id) stg_clients from de1m.golb_stg_clients;
select count(client_id) stg_clients_del from de1m.golb_stg_clients_del;
select count(client_id) dwh_dim_clients_hist from de1m.golb_dwh_dim_clients_hist;

select count(schema_name) meta_setdate from de1m.golb_meta_setdate;
select count(event_dt) stg_rep_fraud from de1m.golb_rep_fraud;