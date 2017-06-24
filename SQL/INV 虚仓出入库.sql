SELECT
	litem.FNumber,
	litem.FShortNumber,
	litem.FName
FROM
	ZPStockBill zsbh
INNER JOIN ZPStockBillEntry zsbl ON zsbh.finterid = zsbl.finterid
INNER JOIN t_Item litem ON zsbl.FItemID = litem.FItemID