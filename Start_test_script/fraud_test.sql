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
on (psbl.passport_num = cl.passport_num);