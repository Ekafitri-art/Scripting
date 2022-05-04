SET LINESIZE 500
    SET PAGESIZE 1000

    COLUMN username FORMAT A15
    COLUMN event FORMAT A33
    COLUMN osuser FORMAT A15
    COLUMN spid FORMAT A6
    COLUMN sid FORMAT 99999
    COLUMN serial# FORMAT 99999
    COLUMN lockwait FORMAT 99999999
    COLUMN service_name FORMAT A15
    COLUMN module FORMAT A60
    COLUMN machine FORMAT A35
    COLUMN logon_time FORMAT A20
    COLUMN current_sql FORMAT A53
    

        SELECT NVL(s.username, '(oracle)') AS username,
            s.inst_id,
             s.osuser,
             to_char(s.logon_time,'dd/mm/yyyy hh24:mi:ss')   logon_time,
             s.sid,
             s.serial#,
             p.spid,
             --s.lockwait,
             s.status,
             --s.module,
             --s.machine,
             --s.program,
             s.event,
             s.sql_id,
             round(s.last_call_et/60,0) last_call,
             SUBSTR(sa.sql_text, 1, 45) current_sql
        FROM   gv$session s,
             gv$process p,
             gv$sqlarea sa
        WHERE  s.paddr = p.addr 
          AND s.sql_address    =  sa.address(+) 
          AND s.sql_hash_value =  sa.hash_value(+)
        AND s.USERNAME NOT LIKE '%oracle%'
        --AND s.USERNAME ='DBSNMP'
        --and s.last_call_et > 21600
        --and s.logon_time < sysdate -3
        and s.status='ACTIVE'
        --and osuser != 'oracle'
        --and osuser = 'airun'
        --and s.program like '%rman%'
        --and s.sid=2386
        --and s.sql_id='3y6pgnk2ubw7g'
        --and s.inst_id=1
        ORDER BY s.username, s.osuser;