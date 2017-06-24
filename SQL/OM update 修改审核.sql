UPDATE tso
SET tso.FStatus = 1, --0-未审核，1-审核 3-关闭
 --审核状态
tso.FMultiCheckLevel1 = 16498,
 --审核日期1
tso.FMultiCheckDate1 = '2017-06-22',
 --审核日期2
tso.FMultiCheckLevel2 = 16510,
 --审核人2
tso.FMultiCheckDate2 = '2017-06-22' --审核日期2
-- 	*
FROM
	SEOrder tso
WHERE
	1 = 1
AND tso.FBillNo IN ('SEORD006917')