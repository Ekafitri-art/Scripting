set lines 300 pages 1000
col machine for a40
col username for a30
col osuser for a35
col SERVICE_NAME for a40
 SELECT INST_ID,
        NVL(active_count, 0) AS active,
        NVL(inactive_count, 0) AS inactive,
        NVL(killed_count, 0) AS killed 
 FROM   ( SELECT INST_ID, status, count(*) AS quantity
          FROM   gv$session where username is not null
          GROUP BY INST_ID, status)
 PIVOT  (SUM(quantity) AS count FOR (status) IN ('ACTIVE' AS active, 'INACTIVE' AS inactive, 'KILLED' AS killed))
 ORDER BY inst_id;