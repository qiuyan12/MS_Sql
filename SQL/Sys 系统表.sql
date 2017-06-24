SELECT
	DISTINCT
	td.FTableName,
 	td.FDescription,
	fd.FFieldName,
	fd.FDescription,
	FD.FFieldNote
FROM
	t_TableDescription TD
INNER JOIN t_FieldDescription FD ON td.FTableID = fd.FTableID
WHERE
	1 = 1
 AND TD.FTableName  LIKE 'ICMO' 
 --AND TD.FDescription LIKE '%类型%'
  --AND FD.FFieldName IN ('FCheckDate')
-- ORDER BY
-- 	TD.FTableName,
-- 	FD.FFieldName