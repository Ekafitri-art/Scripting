CEK ALERT
cat alertexport.log | grep "exported" | wc -l


NOTE untuk parameter!
1. paralel = pakai cpu 
2. _%U = kalau tidak pakai parelel ini di hapus
3. content=METADATA_ONLY (yg di expdp hanya struktur table saja)
4. content=DATA_ONLY (yg di expdp hanya isinya)
5. QUERY= yg di expdp data dari tanggal tertentu saja (minta query nya ke tim apps)



1. PARFILE
nohup expdp \"/ as sysdba\" parfile=file.par &		

Note!
untuk parfile, buat file par nya dulu
lalu semua parameter dimasukan ke dalam file par tersebut.

------------------------------------------------------------------------------------------------------------------------------------------------

2. FULL DB
nohup expdp \"/ as sysdba\" 
directory=DIR 
dumpfile=FILE_NAME_DATE.dmp 
logfile=FILE_NAME_DATE.log 
FULL=Y 
compression=all &


nohup expdp \"/ as sysdba\" 
directory=DIR 
dumpfile=FILE_NAME_DATE_%U.dmp 
logfile=FILE_NAME_DATE.log 
FULL=Y 
parallel=8 
filesize=100G &

------------------------------------------------------------------------------------------------------------------------------------------------

3. TABLESPACE

nohup expdp \"/ as sysdba\" directory=DIR 
tablespaces=TBS_1,TBS_2 
dumpfile=FILE_NAME_DATE_%U.dmp 
logfile=FILE_NAME_DATE.log 
parallel=4 
filesize=100G 
compression=all &

------------------------------------------------------------------------------------------------------------------------------------------------

4. SCHEMA

nohup expdp \"/ as sysdba\" (nohup expdp system/OR4cl35y5#2015)
directory=DIR 
schemas=SCHEMA_NAME1, SCHEMA_NAME2 
dumpfile=FILE_NAME_DATE_%U.dmp 
logfile=FILE_NAME_DATE.log 
parallel=4 &




------------------------------------------------------------------------------------------------------------------------------------------------

5. TABLES
nohup expdp \'/ as sysdba\' 
DIRECTORY=DIR
dumpfile=FILE_NAME.dmp 
logfile=FILE_NAME_DATE.log 
tables=OWNER.TABLE &



------------------------------------------------------------------------------------------------------------------------------------------------

6. PARTISI
nohup expdp \'/ as sysdba\' 
DIRECTORY=DATADUMP 
dumpfile=FILE_NAME_DATE_%U.dmp 
logfile=FILE_NAME_DATE.log 
tables=OWNER.TABLE:PARTISI1, OWNER.TABLE:PARTISI2 
parallel=4 
compression=all &


=======================================================================================================================================================


--CEK DIRECTORY
set lines 300
col owner for a20
col directory_name for a30
col directory_path for a70
select owner, directory_name, directory_path from dba_directories
where directory_name='DUMP_OPESB';


--CEK CURRENT_SCN
col current_scn for 999999999999999999
select current_scn from v$database;


--CREATE AND GRANT DRECTORY (diluar PDB)
create or replace directory NEW_VERONA as '/acfs01/backup2';
grant read, write on directory NEW_VERONA to SYS;
GRANT READ, WRITE ON DIRECTORY SYS.NEW_VERONA TO EXP_FULL_DATABASE;
GRANT READ, WRITE ON DIRECTORY SYS.NEW_VERONA TO IMP_FULL_DATABASE;
grant read, write on directory NEW_VERONA to SYSTEM;


=======================================================================================================================================================

1. VERSION
nohup expdp \'/ as sysdba\' 
directory=xxx schemas=xxx dumpfile=xxx_%U.dmp 
logfile=xxx.log compression=all PARALLEL=4 
version=12.1.0.2.0 & (or version=12.1)
------------------------------------------------------------------------------------------------------------------------------------------------

2. QUERY 
nohup expdp \"/ as sysdba\" directory=xxx 
dumpfile=xxx logfile=xxx tables=xxx 
query='PROAPP.PRO_PAYLOAD:"where UPDATED_DATE < to_date"' \"\(\'29-NOV-2019\',\'DD-MON-YYYY\'\)\" &

nohup expdp \"/ as sysdba\" parfile=pro_order_tm_juli.par &		
directory=xxx umpfile=xxx logfile=xxx tables=xxx
QUERY="WHERE COMPLETION_DATE>=to_date('01-JUL-2020 00:00:00','DD-MON-YYYY HH24:MI:SS')"

-----------------------------------------------------------------------------------------------------------------------------------------------

3. METADATA_ONLY
nohup expdp \"/ as sysdba\" directory=xxx schemas=xxx dumpfile=xxx.dmp logfile=xxx.log compression=all 
content=METADATA_ONLY &

-----------------------------------------------------------------------------------------------------------------------------------------------

4. INCLUDE & EXCLUDE SCEMA
--in linux
EXCLUDE=SCHEMA:"in\('SYSTEM'\)" 
EXCLUDE=SCHEMA:"in\('SYSTEM','FIN'\)".

--in file par
INCLUDE=TABLE:"IN ('COUNTER','COUNTER_LIFETIME')"
INCLUDE=PROCEDURE:"IN ('ESB_GET_CTR_1_MSISDN_OID_BUNDLE','ESB_UPD_6B_UPS_FAM_CTR')"

-----------------------------------------------------------------------------------------------------------------------------------------------

5. FLASHBACK_SCN
nohup expdp \'/ as sysdba\' 
DIRECTORY=DIR
dumpfile=FILE_NAME.dmp 
logfile=FILE_NAME_DATE.log 
tables=OWNER.TABLE 
flashback_scn=xxxxxxxx &

-----------------------------------------------------------------------------------------------------------------------------------------------

5. EXP
#TABLE
nohup exp \'/ as sysdba\' 
file='/path/path/FILE_NAME.dmp' 
log='/path/path/file_name.log' 
tables=sys.aud\$ 
statistic=none &

#OWNER
nohup exp \'/ as sysdba\' 
file='/path/path/FILE_NAME.dmp' 
log='/path/path/file_name.log' 
owner=OWNER_NAME rows=N 
grants=Y constraints=Y &


-----------------------------------------------------------------------------------------------------------------------------------------------
6. With string $ harus pakai \
nohup expdp \'/ as sysdba\' DIRECTORY=DATADUMP dumpfile=BACKUP_CMP3$412834_%U.dmp logfile=BACKUP_CMP3$412834_14122021.log tables=TELKOMSEL.CMP3\$412834 parallel=4 &
vi RESOURCE_TS_DATA_CMP3$412834.par
DIRECTORY=DATADUMP
LOGFILE=BACKUP_RESOURCE_TS_DATANEW.log
DUMPFILE=BACKUP_RESOURCE_TS_DATA_%U.dmp
TABLES=TELKOMSEL.CMP3$412834
parallel=4


cek alert
cat alertexport.log | grep "exported" | wc -l




