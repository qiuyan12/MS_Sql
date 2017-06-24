SELECT
	request_session_id spid,
	OBJECT_NAME(resource_associated_entity_id) tn,
	lock.*
FROM
	sys.dm_tran_locks lock

-- where resource_type='OBJECT'
ORDER BY
	spid