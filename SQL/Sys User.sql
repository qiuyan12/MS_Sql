SELECT
	usr.FUserID,
	usr.FName,
	usr.FDescription,
	user_group.FGroupID
	
FROM
	t_User usr
LEFT JOIN t_group user_group ON usr.FUserID = user_group.FUserID