SELECT
	--TOP 10 CONVERT (VARCHAR(10), jobH.FDate, 120),
	--tworktype.FName 正常生产任务,
	--department.FName 部门,
	--jobH.FOrderBillNo 销售订单号,
	ticmo.FOrderInterID , --销售订单finterid 
	ticmo.FSourceEntryID, --销售订单 fentryid
	ticmo.FHeadSelfJ0176 源采购订单号,
	ticmo.FBillNo 生产任务单号,
	moitem.FNumber 料号代码,
	moitem.FName 料号名称,
	ticmo.FQty 数量,
	ticmo.FCommitQty 完工数量,
	--litem.FshortNumber,
	litem.FNumber,
	litem.FName,
	jobl.FAuxQty 选单数量,
	jobl.FQty 基本单位选单数量,
	jobL.FQtyMust 基本单位计划投料数量,
	jobL.FStockQty 基本单位已领数量,
	jobL.FAuxStockQty 已领数量,
	jobL.FWIPAuxQTY 在制品数量,
	jobL.FWIPQTY 基本单位在制品数量
FROM
	ICMO ticmo
INNER JOIN t_ICitem moitem ON ticmo.FItemID = moitem.FItemID
LEFT JOIN t_WorkType tworktype ON ticmo.FWorkTypeID = tworktype.FInterID
LEFT JOIN t_Department department ON ticmo.FWorkShop = department.FItemID
LEFT JOIN PPBOM jobH ON ticmo.FInterID = jobH.FICMOInterID
LEFT JOIN PPBOMEntry jobL ON jobH.FInterID = jobL.FInterID
INNER JOIN t_ICitem hitem ON jobH.FItemID = hitem.FItemID
INNER JOIN t_ICitem litem ON jobl.FItemID = litem.FItemID
WHERE
	1 = 1
AND CONVERT (VARCHAR(7), jobH.FDate, 120) >= '2017-06' --AND ticmo.FBillNo='WORK115858'
AND moitem.FNumber in ('V.B.B3005.06.VB09407','3.03.029.300598') -- AND hitem.FNumber LIKE 'V.B%'
--AND hitem.FNumber LIKE 'V.B.B1100.01.VB00036'
