rollback;

merge into de1m.golb_dwh_dim_accounts_hist tgt
using de1m.golb_stg_accounts stg
on( stg.account_num = tgt.account_num
    and deleted_flg = 'N' )
when matched then 
    update set tgt.effective_to = stg.update_dt - interval '1' second
    where 1=1
        and tgt.effective_to = to_date( '2100-12-31 23:59:59', 'YYYY-MM-DD HH24:MI:SS' )
        and (1=0
            or stg.account_num <> tgt.account_num
            or ( stg.account_num is null and tgt.account_num is not null )
            or ( stg.account_num is not null and tgt.account_num is null )
        )
when not matched then 
    insert ( account_num, valid_to, "CLIENT", effective_from, effective_to, deleted_flg ) 
    values ( stg.account_num, stg.valid_to, stg."CLIENT", stg.create_dt, to_date( '2100-12-31 23:59:59', 'YYYY-MM-DD HH24:MI:SS' ), 'N' );

insert into de1m.golb_dwh_dim_accounts_hist ( account_num, valid_to, "CLIENT", effective_from, effective_to, deleted_flg ) 
select
    stg.account_num, 
    stg.valid_to,
    stg."CLIENT",
    stg.update_dt, 
    to_date( '2100-12-31 23:59:59', 'YYYY-MM-DD HH24:MI:SS' ), 
    'N'
from de1m.golb_dwh_dim_accounts_hist tgt
inner join de1m.golb_stg_accounts stg
on ( stg.account_num = tgt.account_num
    and tgt.effective_to = to_date( '2100-12-31 23:59:59', 'YYYY-MM-DD HH24:MI:SS' )
    and deleted_flg = 'N' )
where 1=0
    or stg.account_num <> tgt.account_num
    or ( stg.account_num is null and tgt.account_num is not null )
    or ( stg.account_num is not null and tgt.account_num is null );

commit;