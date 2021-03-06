SELECT part.tsname tablespace_name,
       Max(part.used_size) "Current Size (MB)",  /* Current size of tablespace */
       Round(Avg(inc_used_size), 2) "Growth Per Day(MB)" /* Growth of tablespace per day */
 FROM 
 (SELECT sub.days,
         sub.tsname,
         used_size,
         used_size - Lag (used_size, 1)
          over (PARTITION BY sub.tsname ORDER BY sub.tsname, sub.days) inc_used_size /* getting delta increase using analytic function */
       FROM  
       (SELECT TO_CHAR(hsp.begin_interval_time,'MM-DD-YYYY') days,
        hs.tsname,
        MAX((hu.tablespace_usedsize* dt.block_size )/(1024*1024)) used_size
      from
        dba_hist_tbspc_space_usage hu, /* historical tablespace usage statistics */
        dba_hist_tablespace_stat hs , /* tablespace information from the control file */
        dba_hist_snapshot hsp, /* information about the snapshots in the Workload Repository */
        dba_tablespaces dt
      where
        hu.snap_id = hsp.snap_id
        and hu.TABLESPACE_ID = hs.ts#
        and hs.tsname = dt.tablespace_name
        and dt.tablespace_name in ('IXL01')
        AND hsp.begin_interval_time > SYSDATE - 30 /* gathering info about last 30 days */
      GROUP  BY To_char(hsp.begin_interval_time, 'MM-DD-YYYY'),
        hs.tsname
      order by  hs.tsname,days) sub) part
GROUP  BY part.tsname
ORDER  BY part.tsname;