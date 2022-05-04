set linesize 100
set pagesize 200
col "MAXSIZE (MB)" for 999999999.99
col "USED (MB)" for 999999999.99
col "FREE (MB)" for 999999999.99
col "% USED" for 999.99
Select  ddf.TABLESPACE_NAME "TABLESPACE",
		ddf.MAXBYTES "MAXSIZE (MB)",
		(ddf.BYTES - dfs.bytes) "USED (MB)",
		ddf.MAXBYTES-(ddf.BYTES - dfs.bytes) "FREE (MB)",
		round(((ddf.BYTES - dfs.BYTES)/ddf.MAXBYTES)*100,2) "% USED"
		from (select TABLESPACE_NAME,
		round(sum(BYTES)/1024/1024,2) bytes,
		round(sum(decode(autoextensible,'NO',BYTES,MAXBYTES))/1024/1024,2) maxbytes
		from   dba_data_files
		group  by TABLESPACE_NAME) ddf,
		(select TABLESPACE_NAME,
		round(sum(BYTES)/1024/1024,2) bytes
	from dba_free_space
	group by TABLESPACE_NAME) dfs
	where ddf.TABLESPACE_NAME=dfs.TABLESPACE_NAME
	and ddf.TABLESPACE_NAME='&TABLESPACE_NAME'
	order by (((ddf.BYTES - dfs.BYTES))/ddf.MAXBYTES) desc, (ddf.MAXBYTES-(ddf.BYTES - dfs.bytes));