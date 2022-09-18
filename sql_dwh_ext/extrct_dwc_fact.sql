rollback;

insert into de1m.golb_dwh_fact_pssprt_blcklst( passport_num, entry_dt )
select * from de1m.golb_stg_passport_blacklist
where entry_dt > to_date('2021-02-01 00:00:00', 'YYYY-MM-DD HH24:MI:SS');

insert into de1m.golb_dwh_fact_transactions( trans_id, trans_date, card_num, oper_type, amt, oper_result, terminal )
select * from de1m.golb_stg_transactions
where trans_date > to_date('2021-02-01 23:59:59', 'YYYY-MM-DD HH24:MI:SS');

commit;