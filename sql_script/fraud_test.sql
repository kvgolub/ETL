select 
    fio,
    event_type,
    count(fio)
from de1m.golb_rep_fraud
group by fio, event_type
order by event_type, fio;