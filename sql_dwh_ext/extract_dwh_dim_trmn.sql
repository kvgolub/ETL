rollback;

merge into de1m.golb_dwh_dim_terminals_hist tgt
using de1m.golb_stg_terminals stg
on( stg.terminal_id = tgt.terminal_id
    and deleted_flg = 'N' )
when matched then 
    update set tgt.effective_to = to_date( 'data_file 00:00:00', 'YYYY-MM-DD HH24:MI:SS' ) - interval '1' second
    where 1=1
        and tgt.effective_to = to_date( '2100-12-31 23:59:59', 'YYYY-MM-DD HH24:MI:SS' )
        and (1=0
            or stg.terminal_id <> tgt.terminal_id
            or ( stg.terminal_id is null and tgt.terminal_id is not null )
            or ( stg.terminal_id is not null and tgt.terminal_id is null )
    )
when not matched then 
    insert ( terminal_id, terminal_type, terminal_city, terminal_address, effective_from, effective_to, deleted_flg ) 
    values ( 
        stg.terminal_id,
        stg.terminal_type,
        stg.terminal_city,
        stg.terminal_address,
        to_date( 'data_file 00:00:00', 'YYYY-MM-DD HH24:MI:SS' ),
        to_date( '2100-12-31 23:59:59', 'YYYY-MM-DD HH24:MI:SS' ),
        'N');

insert into de1m.golb_dwh_dim_terminals_hist( terminal_id, terminal_type, terminal_city, terminal_address, effective_from, effective_to, deleted_flg )
select
    stg.terminal_id,
    stg.terminal_type,
    stg.terminal_city,
    stg.terminal_address,
    to_date( 'data_file 00:00:00', 'YYYY-MM-DD HH24:MI:SS' ) effective_from,
    to_date( '2100-12-31 23:59:59', 'YYYY-MM-DD HH24:MI:SS' ) effective_to,
    'N' deleted_flg
from de1m.golb_dwh_dim_terminals_hist tgt
inner join de1m.golb_stg_terminals stg
on ( stg.terminal_id = tgt.terminal_id
    and tgt.effective_to = to_date( '2100-12-31 23:59:59', 'YYYY-MM-DD HH24:MI:SS' )
    and deleted_flg = 'N' )
where 1=0
    or stg.terminal_id <> tgt.terminal_id
    or ( stg.terminal_id is null and tgt.terminal_id is not null )
    or ( stg.terminal_id is not null and tgt.terminal_id is null );

commit;