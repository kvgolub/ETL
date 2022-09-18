-- ошибка в делетах, мнодатся записи в таргете
insert into de1m.golb_dwh_dim_terminals_hist( terminal_id, terminal_type, terminal_city, terminal_address, effective_from, effective_to, deleted_flg ) 
select
    tgt.terminal_id,
    tgt.terminal_type,
    tgt.terminal_city,
    tgt.terminal_address,
    current_date effective_from,
    to_date( '2100-12-31 23:59:59', 'YYYY-MM-DD HH24:MI:SS' ) effective_to,
    'Y' deleted_flg
from de1m.golb_dwh_dim_terminals_hist tgt
left join de1m.golb_stg_terminals stg
on ( stg.terminal_id = tgt.terminal_id
    and tgt.effective_to = to_date( '2100-12-31 23:59:59', 'YYYY-MM-DD HH24:MI:SS' )
    and deleted_flg = 'N' )
where stg.terminal_id is null;




-- ошибка в витрине, вносятся одни т иеже записи
insert into de1m.golb_rep_fraud (event_dt, passport, fio, phone, event_type, report_dt)
select 
    psbl.entry_dt event_dt,
    psbl.passport_num passport,
    concat(concat(cl.last_name, ' '), concat(concat(cl.first_name, ' '), cl.patronymic)) fio,
    cl.phone,
    'Совпадение по черному списку паспортов' event_type,
    current_date report_dt
from de1m.golb_dwh_fact_pssprt_blcklst psbl
inner join de1m.golb_dwh_dim_clients_hist cl
on (psbl.passport_num = cl.passport_num)
where psbl.entry_dt > ( select max( max_update_dt ) from de1m.golb_meta_setdate );

merge into de1m.golb_meta_setdate trg
using (
    select
        'DE1M' schema_name,
        'GOLB_REP_FRAUD' table_name,
        ( select max( event_dt ) from de1m.golb_rep_fraud ) max_update_dt
    from dual ) src
    on ( trg.schema_name = src.schema_name
        and trg.table_name = src.table_name )
when matched then 
    update set trg.max_update_dt = src.max_update_dt
    where src.max_update_dt is not null
when not matched then 
    insert ( schema_name, table_name, max_update_dt )
    values ( 'DE1M', 'GOLB_REP_FRAUD', coalesce( src.max_update_dt, to_date( '1900-01-01 00:00:00', 'YYYY-MM-DD HH24:MI:SS' ) ) );