rollback;

insert into de1m.golb_dwh_dim_accounts_hist( account_num, valid_to, "CLIENT", effective_from, effective_to, deleted_flg ) 
select
    tgt.account_num,
    tgt.valid_to,
    tgt."CLIENT",
    current_date effective_from,
    to_date( '2100-12-31 23:59:59', 'YYYY-MM-DD HH24:MI:SS' ) effective_to,
    'Y' deleted_flg
from de1m.golb_dwh_dim_accounts_hist tgt
left join de1m.golb_stg_accounts stg
on ( stg.account_num = tgt.account_num
    and tgt.effective_to = to_date( '2100-12-31 23:59:59', 'YYYY-MM-DD HH24:MI:SS' )
    and deleted_flg = 'N' )
where stg.account_num is null;

update de1m.golb_dwh_dim_accounts_hist tgt
set effective_to = current_date - interval '1' second
where tgt.account_num not in (select account_num from de1m.golb_stg_accounts)
    and tgt.effective_to = to_date( '2100-12-31 23:59:59', 'YYYY-MM-DD HH24:MI:SS' )
    and tgt.deleted_flg = 'N';

commit;