SELECT
	*
FROM
	(
		SELECT
			*
		FROM
			t_Log l
		UNION
			SELECT
				*
			FROM
				t_logbak
	) t
WHERE
	t.FDescription LIKE '%SEORD006917%'

-- UNION
-- SELECT *FROM (
-- SELECT *from t_Log l  
-- UNION
-- SELECT *FROM t_logbak
-- ) t WHERE t.FDescription LIKE '%SEORD006917%'

ORDER BY t.FDate

