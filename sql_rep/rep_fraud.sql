rollback;

insert into de1m.golb_rep_fraud (event_dt, passport, fio, phone, event_type, report_dt)
select
    trn.trans_date evenet_dt,
    cl.passport_num passport,
    concat(concat(cl.last_name, ' '), concat(concat(cl.first_name, ' '), cl.patronymic)) fio,
    cl.phone,
    '1' event_type,
    current_date report_dt
from de1m.golb_dwh_fact_transactions trn
inner join de1m.golb_dwh_dim_cards_hist crd
    on (trn.card_num = crd.card_num)
inner join de1m.golb_dwh_dim_accounts_hist acc
    on (crd.account_num = acc.account_num)
inner join de1m.golb_dwh_dim_clients_hist cl
    on (acc.client = cl.client_id)
inner join de1m.golb_dwh_fact_pssprt_blcklst pbl
    on (cl.passport_num = pbl.passport_num)
where trn.trans_date > to_date( 'data_file 00:00:00', 'YYYY-MM-DD HH24:MI:SS' )
group by trn.trans_date, cl.passport_num, concat(concat(cl.last_name, ' '), concat(concat(cl.first_name, ' '), cl.patronymic)), cl.phone;

insert into de1m.golb_rep_fraud (event_dt, passport, fio, phone, event_type, report_dt)
select
    trn.trans_date evenet_dt,
    cl.passport_num passport,
    concat(concat(cl.last_name, ' '), concat(concat(cl.first_name, ' '), cl.patronymic)) fio,
    cl.phone,
    '1' event_type,
    current_date report_dt
from de1m.golb_dwh_fact_transactions trn
inner join de1m.golb_dwh_dim_cards_hist crd
    on (trn.card_num = crd.card_num)
inner join de1m.golb_dwh_dim_accounts_hist acc
    on (crd.account_num = acc.account_num)
inner join de1m.golb_dwh_dim_clients_hist cl
    on (acc.client = cl.client_id)
where trn.trans_date > cl.passport_valid_to
    and trn.trans_date > to_date( 'data_file 00:00:00', 'YYYY-MM-DD HH24:MI:SS' )
group by trn.trans_date, cl.passport_num, concat(concat(cl.last_name, ' '), concat(concat(cl.first_name, ' '), cl.patronymic)), cl.phone;

insert into de1m.golb_rep_fraud (event_dt, passport, fio, phone, event_type, report_dt)
select
    trn.trans_date evenet_dt,
    cl.passport_num passport,
    concat(concat(cl.last_name, ' '), concat(concat(cl.first_name, ' '), cl.patronymic)) fio,
    cl.phone,
    '2' event_type,
    current_date report_dt
from de1m.golb_dwh_fact_transactions trn
inner join de1m.golb_dwh_dim_cards_hist crd
    on (trn.card_num = crd.card_num)
inner join de1m.golb_dwh_dim_accounts_hist acc
    on (crd.account_num = acc.account_num)
inner join de1m.golb_dwh_dim_clients_hist cl
    on (acc.client = cl.client_id)
where trn.trans_date > acc.valid_to
    and trn.trans_date > to_date( 'data_file 00:00:00', 'YYYY-MM-DD HH24:MI:SS' )
group by trn.trans_date, cl.passport_num, concat(concat(cl.last_name, ' '), concat(concat(cl.first_name, ' '), cl.patronymic)), cl.phone;

insert into de1m.golb_rep_fraud (event_dt, passport, fio, phone, event_type, report_dt)
select
    trans_date evenet_dt,
    passport,
    fio,
    phone,
    event_type,
    report_dt
from (
    select 
        cl.passport_num passport,
        concat(concat(cl.last_name, ' '), concat(concat(cl.first_name, ' '), cl.patronymic)) fio,
        cl.phone phone,
        '3' event_type,
        current_date report_dt,
        
        crd.card_num card_num ,
        trn.trans_date trans_date,
        lag(trn.trans_date) over (partition by crd.card_num order by trn.trans_date) trans_date_lag,
        trm.terminal_city city,
        lag(trm.terminal_city) over (partition by crd.card_num order by trn.trans_date) city_lag,
        
        trn.oper_type o_type
    from de1m.golb_dwh_fact_transactions trn
    left join de1m.golb_dwh_dim_cards_hist crd
        on (trn.card_num = crd.card_num)
    left join de1m.golb_dwh_dim_accounts_hist acc
        on (crd.account_num = acc.account_num)
    left join de1m.golb_dwh_dim_clients_hist cl
        on (acc.client = cl.client_id) 
    left join de1m.golb_dwh_dim_terminals_hist trm
        on (trn.terminal = trm.terminal_id)
)
where city <> city_lag
    and trans_date - trans_date_lag < 3600/86400
    and o_type <> 'PAYMENT'
    and trans_date > to_date( 'data_file 00:00:00', 'YYYY-MM-DD HH24:MI:SS' );

insert into de1m.golb_rep_fraud (event_dt, passport, fio, phone, event_type, report_dt)
select
    last_time_oper evenet_dt,
    passport,
    fio,
    phone,
    event_type,
    report_dt
from (
    select 
        cl.passport_num passport,
        concat(concat(cl.last_name, ' '), concat(concat(cl.first_name, ' '), cl.patronymic)) fio,
        cl.phone,
        '4' event_type,
        current_date report_dt,  
        
        lag(trn.trans_date, 3) over (partition by crd.card_num order by trn.trans_date) first_time_oper,
        trn.trans_date last_time_oper,
        
        trn.oper_type,
        lag(trn.oper_result, 3) over (partition by crd.card_num order by trn.trans_date) result_1,
        lag(trn.oper_result, 2) over (partition by crd.card_num order by trn.trans_date) result_2,
        lag(trn.oper_result) over (partition by crd.card_num order by trn.trans_date) result_3,
        trn.oper_result result_4, 
        
        lag(trn.amt, 3) over (partition by crd.card_num order by trn.trans_date) amt_1,
        lag(trn.amt, 2) over (partition by crd.card_num order by trn.trans_date) amt_2,
        lag(trn.amt) over (partition by crd.card_num order by trn.trans_date) amt_3,
        trn.amt amt_4    
    from de1m.golb_dwh_fact_transactions trn
    left join de1m.golb_dwh_dim_cards_hist crd
        on (trn.card_num = crd.card_num)
    left join de1m.golb_dwh_dim_accounts_hist acc
        on (crd.account_num = acc.account_num)
    left join de1m.golb_dwh_dim_clients_hist cl
        on (acc.client = cl.client_id)
)
where oper_type = 'WITHDRAW' 
        and result_1 = 'REJECT' and result_2 = 'REJECT' and result_3 = 'REJECT' and result_4 = 'SUCCESS'
        and last_time_oper - first_time_oper < 1200/86400
        and amt_1 > amt_2 and amt_2 > amt_3 and amt_3 > amt_4
        and last_time_oper > to_date( 'data_file 00:00:00', 'YYYY-MM-DD HH24:MI:SS' );

commit;