SELECT
	FSourceTranType,
	documenttype.FName 单据类型,
	
	tsb.FBillNo 编号,
	tsb.FDate,
	tsb.FStatus 状态, --0-未审核,1-已审核
	--tsb.FCheckerID 核准人ID, --审核时 变更
  --tsb.FCheckDate 审核日期, --审核时 变更
	--tsbe_item.FShortNumber,
	tsbe_item.FNumber,
	tsbe_item.FName,
	tsbe.FAuxQty 辅助实际数量,
	tsbe.FAuxQtyActual 辅助实存数量,
	tsbe.FSourceBillNo 源单号码,
	tsbe.FOrderBillNo 订单编号
	
FROM
	ICStockBill tsb
LEFT JOIN ICStockBillEntry tsbe ON tsb.FInterID = tsbe.FInterID
LEFT JOIN t_ICItem tsbe_item ON tsbe.FItemID = tsbe_item.FItemID
LEFT JOIN t_Item_3009 documenttype ON tsb.FHeadSelfB0442=documenttype.FItemID
WHERE
	1 = 1
--AND tsbe_item.FNumber = 'A.01.01.001.A00004'
AND CONVERT (VARCHAR(7), tsb.FDate, 120) >= '2017-06'
AND tsbe_item.FNumber='2.02.B3005.01.BXH02974'