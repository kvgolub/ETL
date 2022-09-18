rollback;

merge into de1m.golb_meta_setdate trg
using (
    select
        'DE1M' schema_name,
        'GOLB_STG_TERMINALS' table_name,
        ( select max( to_date( 'data_file 00:00:00', 'YYYY-MM-DD HH24:MI:SS' ) ) from de1m.golb_stg_terminals ) max_update_dt
    from dual ) src
    on ( trg.schema_name = src.schema_name
        and trg.table_name = src.table_name )
when matched then 
    update set trg.max_update_dt = src.max_update_dt
    where src.max_update_dt is not null
when not matched then 
    insert ( schema_name, table_name, max_update_dt )
    values ( 'DE1M', 'GOLB_STG_TERMINALS', coalesce( src.max_update_dt, to_date( '1900-01-01 00:00:00', 'YYYY-MM-DD HH24:MI:SS' ) ) );

merge into de1m.golb_meta_setdate trg
using (
    select
        'DE1M' schema_name,
        'GOLB_STG_ACCOUNTS' table_name,
        ( select max( update_dt ) from de1m.golb_stg_accounts ) max_update_dt
    from dual ) src
    on ( trg.schema_name = src.schema_name
        and trg.table_name = src.table_name )
when matched then 
    update set trg.max_update_dt = src.max_update_dt
    where src.max_update_dt is not null
when not matched then 
    insert ( schema_name, table_name, max_update_dt )
    values ( 'DE1M', 'GOLB_STG_ACCOUNTS', coalesce( src.max_update_dt, to_date( '1900-01-01 00:00:00', 'YYYY-MM-DD HH24:MI:SS' ) ) );

merge into de1m.golb_meta_setdate trg
using (
    select
        'DE1M' schema_name,
        'GOLB_STG_CARDS' table_name,
        ( select max( update_dt ) from de1m.golb_stg_accounts ) max_update_dt
    from dual ) src
    on ( trg.schema_name = src.schema_name
        and trg.table_name = src.table_name )
when matched then 
    update set trg.max_update_dt = src.max_update_dt
    where src.max_update_dt is not null
when not matched then 
    insert ( schema_name, table_name, max_update_dt )
    values ( 'DE1M', 'GOLB_STG_CARDS', coalesce( src.max_update_dt, to_date( '1900-01-01 00:00:00', 'YYYY-MM-DD HH24:MI:SS' ) ) );

merge into de1m.golb_meta_setdate trg
using (
    select
        'DE1M' schema_name,
        'GOLB_STG_CLIENTS' table_name,
        ( select max( update_dt ) from de1m.golb_stg_accounts ) max_update_dt
    from dual ) src
    on ( trg.schema_name = src.schema_name
        and trg.table_name = src.table_name )
when matched then 
    update set trg.max_update_dt = src.max_update_dt
    where src.max_update_dt is not null
when not matched then 
    insert ( schema_name, table_name, max_update_dt )
    values ( 'DE1M', 'GOLB_STG_CLIENTS', coalesce( src.max_update_dt, to_date( '1900-01-01 00:00:00', 'YYYY-MM-DD HH24:MI:SS' ) ) );

merge into de1m.golb_meta_setdate trg
using (
    select
        'DE1M' schema_name,
        'GOLB_REP_FRAUD' table_name,
        ( select max( event_dt ) from de1m.golb_rep_fraud ) max_update_dt
    from dual ) src
    on ( trg.schema_name = src.schema_name
        and trg.table_name = src.table_name )
when matched then 
    update set trg.max_update_dt = src.max_update_dt
    where src.max_update_dt is not null
when not matched then 
    insert ( schema_name, table_name, max_update_dt )
    values ( 'DE1M', 'GOLB_REP_FRAUD', coalesce( src.max_update_dt, to_date( '1900-01-01 00:00:00', 'YYYY-MM-DD HH24:MI:SS' ) ) );
    
commit;