rollback;

insert into de1m.golb_dwh_dim_terminals_hist( terminal_id, terminal_type, terminal_city, terminal_address, effective_from, effective_to, deleted_flg ) 
select
    tgt.terminal_id,
    tgt.terminal_type,
    tgt.terminal_city,
    tgt.terminal_address,
    to_date( 'data_file 00:00:00', 'YYYY-MM-DD HH24:MI:SS' ) effective_from,
    to_date( '2100-12-31 23:59:59', 'YYYY-MM-DD HH24:MI:SS' ) effective_to,
    'Y' deleted_flg
from de1m.golb_dwh_dim_terminals_hist tgt
left join de1m.golb_stg_terminals stg
on ( stg.terminal_id = tgt.terminal_id
    and tgt.effective_to = to_date( '2100-12-31 23:59:59', 'YYYY-MM-DD HH24:MI:SS' )
    and deleted_flg = 'N' )
where stg.terminal_id is null
order by effective_from;

update de1m.golb_dwh_dim_terminals_hist tgt
set effective_to = to_date( 'data_file 00:00:00', 'YYYY-MM-DD HH24:MI:SS' ) - interval '1' second
where tgt.terminal_id not in (select terminal_id from de1m.golb_stg_terminals)
    and tgt.effective_to = to_date( '2100-12-31 23:59:59', 'YYYY-MM-DD HH24:MI:SS' )
    and tgt.deleted_flg = 'N';

commit;