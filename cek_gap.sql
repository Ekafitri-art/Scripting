set linesize 200
select dest_id,thread#,max(primary) primary, max(transf) maxtransf,
       max(standby) standby, MAX(primary)-MAX(transf) mintransf_gap, MAX(primary)-MAX(standby) apply_gap,
       max(timegap) hoursgap
from (
SELECT dest_id,thread#,max(sequence#) primary, 0 transf, 0 standby, 0 timegap
     FROM v$archived_log
    WHERE STANDBY_DEST='YES'
      and archived = 'YES'
      AND resetlogs_change# = ( select d.resetlogs_change# from v$database d )
 GROUP BY dest_id,thread#
union all
SELECT dest_id,thread#,0 primary, max(sequence#) transf, 0 standby, 0 timegap
     FROM v$archived_log
    WHERE STANDBY_DEST='YES'
      and archived = 'YES'
      AND resetlogs_change# = ( select d.resetlogs_change# from v$database d )
 GROUP BY dest_id,thread#
union all
SELECT dest_id,thread#,0 primary, 0 transf, max(sequence#) standby, trunc((sysdate-max(FIRST_TIME))*24) timegap
     FROM v$archived_log
    WHERE STANDBY_DEST='YES'
      and applied = 'YES'
      AND resetlogs_change# = ( select d.resetlogs_change# from v$database d )
 GROUP BY dest_id,thread#
) asd
group by dest_id,thread#
order by thread#,dest_id;