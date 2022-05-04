CEK ALERT
cat alertexport.log | grep "imported" | wc -l


1. PAR FILE
nohup impdp \"/ as sysdba\" parfile=IMP_TABLE_OPRD016_TCASH_TRX_DAILY.par &

-----------------------------------------------------------------------------------------------------------------------------------

2. FULL DB
nohup impdp \"/ as sysdba\" 
directory=DIR 
dumpfile=FILE_NAME.dmp 
logfile=impdp_file_name.log 
FULL=Y &

Note! create tbs nya dulu
-----------------------------------------------------------------------------------------------------------------------------------

3. TABLES
nohup impdp \"/ as sysdba\" 
directory=DIR 
dumpfile=FILE_NAME.dmp 
logfile=impdp_file_name.log 
tables=SCHEMA.TABLE &
	
-----------------------------------------------------------------------------------------------------------------------------------

4. SCHEMA
nohup impdp import_nbp/Telkomsel@OPNBP1 
directory=DIR
schemas=SCHEMA1,SCHEMA2,DST 
dumpfile=FILE_NAME.dmp 
logfile=impdp_file_name.log 
exclude=STATISTICS 
cluster=N 
PARALLEL=4 
network_link=NBPDB &


NOTE URUTAN (FULL --> TABLESPACE --> SCHEMA --> TABLE)

===================================================================================================================================

1. NETWORK_LINK
#tables with network/db link
nohup impdp user/pass directory=xxx logfile=xxx.log tables=xxx.xxx 
NETWORK_LINK=NBP_EXPDP &


------------------------------------------------------------------------------------------------------

2. REMAP (note kalau remap table/schema, perlu di perhatikan juga tbs nya, jika beda di remap)
#TABLESPACE
nohup impdp user/pass directory=xxx tables=xxx.xxx logfile=xxx network_link=xxx exclude=STATISTICS/MARKER 
remap_tablespace=SOURCE_TBS:TARGET_TBS &

REMAP_TABLESPACE=src1:dst1,src2:dst1,src3:dst1,src4:dst1

REMAP_TABLESPACE=src1:dst1 REMAP_TABLESPACE=src2:dst2

#SCHEMA
nohup impdp \"/ as sysdba\" directory=xxx dumpfile=xxx logfile=xxx 
remap_schema=SCHEMA(old):SCHEMA(new) cluster=N table_exists_action=REPLACE &

#TABLE
nohup impdp \"/ as sysdba\" directory=xxx dumpfile=xxx logfile=xxx parallel=xxx 
tables=SCV_LOAD_USR.KPI_RECHARGE 
remap_table=SCHEMA.KPI_RECHARGE(source):KPI_RECHARGE_20191201(dest) 
QUERY=SCV_LOAD_USR.KPI_RECHARGE:"WHERE etc etc" &
------------------------------------------------------------------------------------------------------

3. QUERY (restore by range tertentu)

nohup impdp \"/ as sysdba\" directory=xxx dumpfile=xxx logfile=xxx parallel=xxx 
remap_table=SCHEMA.KPI_RECHARGE(source):KPI_RECHARGE_20191201(dest) 
TABLES=SCV_LOAD_USR.KPI_RECHARGE 
QUERY=SCV_LOAD_USR.KPI_RECHARGE:"WHERE DT>=to_date('01-12-2019 00:00:00','DD-MM-YYYY HH24:MI:SS') AND DT<to_date('09-01-2020 00:00:00','DD-MM-YYYY HH24:MI:SS')" &

-----------------------------------------------------------------------------------------------------------------------------------

OTHERS PARAMETER:
TABLE_EXISTS_ACTION=APPEND/REPLACE/SKIP
transportable=ALWAYS
CLUSTER=N 

DATA_OPTIONS=SKIP_CONSTRAINT_ERRORS is a very useful parameter mostly used with table_exists_action=APPEND 

==================================================================================================================================

CEK PROSES IMPORT
impdp system/oracle@ODDGPOS attach=SYSTEM.SYS.SYS_IMPORT_FULL_01.5269

impdp '"sys/OR4cl35y5#2015 as sysdba"' attach=SYS_IMPORT_FULL_01
KILL_JOB

----------------------------------------
trus jalanin :
SQL> connect / as sysdba
SQL> exec dbms_stats.gather_dictionary_stats;
SQL> exec dbms_stats.lock_table_stats (null,'X$KCCLH');
SQL> exec dbms_stats.gather_fixed_objects_stats;
======================================================
Check import sudah betul atau belum
- Cek jumlah object di source and destination
Select owner, object_type,count(*) from dba_objects group by owner,object_type order by 1,2;

-Make sure tablespace as is source before import

How to make sure Import 
1. Check partition sudah sama antara destination dan tujuan
2. Check count partition dan samakan dengan row di log expdp
select count(*) from C2PODD_DEV11.PAYLOAD;

Aman jika
1. Jumlah partisi sudah sama
2. error role does not exist ga masalah
======================================================
How to check state Job 
set lines 999
set pages 999
col owner_name for a32
col job_name for a32
col operation for a32
col job_mode for a32
col state for a32
select
   owner_name,
   job_name,
   operation,
   job_mode,
   state,
   attached_sessions
from
   dba_datapump_jobs
where
   job_name not like 'BIN$%'
order by 1,2;

--------------------------
- cek all tablespace
- cek fra
- cek proses longops
- sama cek name
=====================================================================================================
Cek status import 

SELECT owner_name, job_name, operation, job_mode, state FROM dba_datapump_jobs;

================================================================================