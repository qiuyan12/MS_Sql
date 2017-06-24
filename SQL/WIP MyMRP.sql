SELECT
	mrp.frunid 计算编号,
  CONVERT(VARCHAR(10),mrp.fcheckdate,120) 计算日期,
	CONVERT(VARCHAR(19),mrp.fchecktime,120) 计算时间,
	mrpUser.FName 计算用户,
	seo.FBillNo 销售订单号码,
	mrpso.*
FROM
	my_t_Mrp mrp
LEFT JOIN t_User mrpUser ON mrp.FUserID = mrpUser.FUserID
LEFT JOIN my_t_MrpSeOrder mrpso ON mrp.frunid = mrpso.frunid
LEFT JOIN SEOrder seo ON  mrpso.forderinterid=seo.FInterID
WHERE
	1 = 1
AND mrp.fuserid = 16511
AND mrpso.fselect = 1