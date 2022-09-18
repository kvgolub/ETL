select 
    trn.trans_date event_dt,
    --cl.passport_num passport,
    --concat(concat(cl.last_name, ' '), concat(concat(cl.first_name, ' '), cl.patronymic)) fio,
    --cl.phone,
    'Использование просроченного паспорта' event_type,
    current_date report_dt
from de1m.golb_dwh_fact_transactions trn
inner join de1m.golb_dwh_dim_cards_hist crd
on (trn.card_num = crd.card_num)
inner join de1m.golb_dwh_dim_accounts_hist acc
on (crd.account_num = acc.account_num)
inner join de1m.golb_dwh_dim_clients_hist cl
on (acc.client = cl.client_id);


select * from de1m.golb_dwh_fact_transactions trn
inner join de1m.golb_dwh_dim_cards_hist crd
on (trn.card_num = crd.card_num); 


select 
    trn.trans_date evenet_dt,
    cl.client_id passport,
    concat(concat(cl.last_name, ' '), concat(concat(cl.first_name, ' '), cl.patronymic)) fio,
    cl.phone,
    'Использование паспорта из черного списка' event_type,
    current_date report_dt
from de1m.golb_dwh_fact_transactions trn
inner join de1m.golb_dwh_dim_cards_hist crd
on (trn.card_num = crd.card_num)
inner join de1m.golb_dwh_dim_accounts_hist acc
on (crd.account_num = acc.account_num)
inner join de1m.golb_dwh_dim_clients_hist cl
on (acc.client = cl.client_id)
inner join de1m.golb_dwh_fact_pssprt_blcklst pbl
on (cl.passport_num = pbl.passport_num);

select 
    *
from de1m.golb_dwh_fact_transactions trn;


select 
    trn.trans_date evenet_dt,
    cl.client_id passport,
    concat(concat(cl.last_name, ' '), concat(concat(cl.first_name, ' '), cl.patronymic)) fio,
    cl.phone,
    'Использование паспорта из черного списка' event_type,
    current_date report_dt
from de1m.golb_dwh_fact_transactions trn
left join de1m.golb_dwh_dim_cards_hist crd
on (trn.card_num = crd.card_num)
inner join de1m.golb_dwh_dim_accounts_hist acc
on (crd.account_num = acc.account_num)
inner join de1m.golb_dwh_dim_clients_hist cl
on (acc.client = cl.client_id)
inner join de1m.golb_dwh_fact_pssprt_blcklst pbl
on (cl.passport_num = pbl.passport_num);
    