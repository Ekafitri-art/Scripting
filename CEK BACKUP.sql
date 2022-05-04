set linesize 300
set pagesize 30
col duration format a8
col status format a20
col input_bytes_display format a10
col output_bytes_display format a10
col per_sec format a10
col COMMAND_ID for a20
col START_TIME for a17
col device format a8

SELECT end_time, status, session_key, session_recid, session_stamp, command_id, start_time, 
time_taken_display duration, input_type, output_device_type device, 
input_bytes_display, output_bytes_display, output_bytes_per_sec_display per_sec
FROM
(SELECT end_time, status, session_key, session_recid, session_stamp, command_id, to_char(start_time,'dd/mm/yyyy hh24:mi') start_time, 
time_taken_display, input_type, output_device_type, 
input_bytes_display, output_bytes_display, output_bytes_per_sec_display
FROM v$rman_backup_job_details ORDER BY end_time ASC);