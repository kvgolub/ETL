rollback;

merge into de1m.golb_dwh_dim_clients_hist tgt
using de1m.golb_stg_clients stg
on( stg.client_id = tgt.client_id
    and deleted_flg = 'N' )
when matched then 
    update set tgt.effective_to = stg.update_dt - interval '1' second
    where 1=1
        and tgt.effective_to = to_date( '2100-12-31 23:59:59', 'YYYY-MM-DD HH24:MI:SS' )
        and (1=0
            or stg.client_id <> tgt.client_id
            or ( stg.client_id is null and tgt.client_id is not null )
            or ( stg.client_id is not null and tgt.client_id is null )
    )
when not matched then 
    insert ( client_id, last_name, first_name, patronymic, date_of_birth, passport_num, passport_valid_to, phone, effective_from, effective_to, deleted_flg ) 
    values ( stg.client_id, stg.last_name, stg.first_name, stg.patronymic, stg.date_of_birth, stg.passport_num, stg.passport_valid_to, stg.phone, stg.create_dt, to_date( '2100-12-31 23:59:59', 'YYYY-MM-DD HH24:MI:SS' ), 'N' );

insert into de1m.golb_dwh_dim_clients_hist ( client_id, last_name, first_name, patronymic, date_of_birth, passport_num, passport_valid_to, phone, effective_from, effective_to, deleted_flg ) 
select
    stg.client_id, 
    stg.last_name,
    stg.first_name,
    stg.patronymic,
    stg.date_of_birth,
    stg.passport_num,
    stg.passport_valid_to,
    stg.phone,
    stg.update_dt, 
    to_date( '2100-12-31 23:59:59', 'YYYY-MM-DD HH24:MI:SS' ), 
    'N'
from de1m.golb_dwh_dim_clients_hist tgt
inner join de1m.golb_stg_clients stg
on ( stg.client_id = tgt.client_id
    and tgt.effective_to = to_date( '2100-12-31 23:59:59', 'YYYY-MM-DD HH24:MI:SS' )
    and deleted_flg = 'N' )
where 1=0
    or stg.client_id <> tgt.client_id
    or ( stg.client_id is null and tgt.client_id is not null )
    or ( stg.client_id is not null and tgt.client_id is null );

commit;