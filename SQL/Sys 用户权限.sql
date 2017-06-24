SELECT
	ac.FObjectType,
	ac.FObjectID,
	ot.FName,
	usr.FName
FROM
	t_AccessControl ac
LEFT JOIN t_ObjectType ot ON ac.FObjectType = ot.FObjectType
AND ac.FObjectID = ot.FObjectID
LEFT JOIN t_User usr ON ac.FUserID = usr.FUserID --LEFT JOIN t_group user_group ON usr.FUserID = user_group.FUserID
WHERE
	1 = 1
--AND ac.FUserID = 16512 --权限控制表 
AND ac.FObjectType=99999
AND ac.FObjectID=2
ORDER BY usr.FName