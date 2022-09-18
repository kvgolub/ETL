rollback;

insert into de1m.golb_dwh_dim_clients_hist ( client_id, last_name, first_name, patronymic, date_of_birth, passport_num, passport_valid_to, phone, effective_from, effective_to, deleted_flg )
select
    tgt.client_id,
    tgt.last_name,
    tgt.first_name,
    tgt.patronymic,
    tgt.date_of_birth,
    tgt.passport_num,
    tgt.passport_valid_to,
    tgt.phone,
    current_date effective_from,
    to_date( '2100-12-31 23:59:59', 'YYYY-MM-DD HH24:MI:SS' ) effective_to,
    'Y' deleted_flg
from de1m.golb_dwh_dim_clients_hist tgt
left join de1m.golb_stg_clients stg
on ( stg.client_id = tgt.client_id
    and tgt.effective_to = to_date( '2100-12-31 23:59:59', 'YYYY-MM-DD HH24:MI:SS' )
    and deleted_flg = 'N' )
where stg.client_id is null;

update de1m.golb_dwh_dim_clients_hist tgt
set effective_to = current_date - interval '1' second
where tgt.client_id not in (select client_id from de1m.golb_stg_clients)
    and tgt.effective_to = to_date( '2100-12-31 23:59:59', 'YYYY-MM-DD HH24:MI:SS' )
    and tgt.deleted_flg = 'N';

commit;