rollback;

insert into de1m.golb_dwh_dim_cards_hist ( card_num, account_num, effective_from, effective_to, deleted_flg )
select
    tgt.card_num,
    tgt.account_num,
    current_date effective_from,
    to_date( '2100-12-31 23:59:59', 'YYYY-MM-DD HH24:MI:SS' ) effective_to,
    'Y' deleted_flg
from de1m.golb_dwh_dim_cards_hist tgt
left join de1m.golb_stg_cards stg
on ( stg.card_num = tgt.card_num
    and tgt.effective_to = to_date( '2100-12-31 23:59:59', 'YYYY-MM-DD HH24:MI:SS' )
    and deleted_flg = 'N' )
where stg.card_num is null;

update de1m.golb_dwh_dim_cards_hist tgt
set effective_to = current_date - interval '1' second
where tgt.card_num not in (select card_num from de1m.golb_stg_cards)
    and tgt.effective_to = to_date( '2100-12-31 23:59:59', 'YYYY-MM-DD HH24:MI:SS' )
    and tgt.deleted_flg = 'N';

commit;