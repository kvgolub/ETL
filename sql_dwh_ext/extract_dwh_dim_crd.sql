rollback;

merge into de1m.golb_dwh_dim_cards_hist tgt
using de1m.golb_stg_cards stg
on( stg.card_num = tgt.card_num
    and deleted_flg = 'N' )
when matched then 
    update set tgt.effective_to = stg.update_dt - interval '1' second
    where 1=1
        and tgt.effective_to = to_date( '2100-12-31 23:59:59', 'YYYY-MM-DD HH24:MI:SS' )
        and (1=0
            or stg.card_num <> tgt.card_num
            or ( stg.card_num is null and tgt.card_num is not null )
            or ( stg.card_num is not null and tgt.card_num is null )
    )
when not matched then 
    insert ( card_num, account_num, effective_from, effective_to, deleted_flg ) 
    values ( stg.card_num, stg.account_num, stg.create_dt, to_date( '2100-12-31 23:59:59', 'YYYY-MM-DD HH24:MI:SS' ), 'N' );

insert into de1m.golb_dwh_dim_cards_hist ( card_num, account_num, effective_from, effective_to, deleted_flg ) 
select
    stg.card_num, 
    stg.account_num,
    stg.update_dt, 
    to_date( '2100-12-31 23:59:59', 'YYYY-MM-DD HH24:MI:SS' ), 
    'N'
from de1m.golb_dwh_dim_cards_hist tgt
inner join de1m.golb_stg_cards stg
on ( stg.card_num = tgt.card_num
    and tgt.effective_to = to_date( '2100-12-31 23:59:59', 'YYYY-MM-DD HH24:MI:SS' )
    and deleted_flg = 'N' )
where 1=0
    or stg.card_num <> tgt.card_num
    or ( stg.card_num is null and tgt.card_num is not null )
    or ( stg.card_num is not null and tgt.card_num is null );

commit;