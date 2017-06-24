SELECT
	POH.FInterID,
	POH.FBillNo,
	tranType.FName 采购订单类型,
	POH.fsupplyid,
	vendor.FName 供应商,
	dept.FName 部门,
	POL.FEntryID 行号,
	POL.FItemID,
	item.FNumber ITEM,
	item.FName ITEM_DES,
	POL.FTaxPrice,
	POL.FQty,
	munit.FName 单位,
	--POL.FSourceTranType,-- 订单来源 71 采购申请 81 销售订单 0 采购申请(只有几张单,可能也不用了)
	--POL.FSourceInterId,
	CONVERT (
		VARCHAR,
		POH.FHeadSelfP0243,
		120
	) 制单时间,
	CONVERT (VARCHAR, POH.FDate, 120) 日期
FROM
	POOrder POH
LEFT JOIN POOrderEntry POL ON POH.FInterID = POL.FInterID --LEFT JOIN ICItemMapping IM ON POL.FItemID = IM.FItemID
LEFT JOIN t_ICItem item ON POL.FItemID = item.FItemID
LEFT JOIN t_MeasureUnit munit ON item.FUnitID = munit.FItemID
INNER JOIN t_Supplier vendor ON POH.FSupplyID = vendor.FItemID
INNER JOIN t_Department dept ON POH.FDeptID = dept.FItemID
INNER JOIN ICTransactiontype tranType ON POH.FTranType = tranType.FID
WHERE
	1 = 1 
--AND POL.FSourceTranType = 81
--AND CONVERT (VARCHAR(10), POH.FDate, 120) >= '2017-05-24' ---AND item.FNumber='A.01.01.001.A00004'
--and POH.FBillNo='POD06271'
--and item.FNumber='2.08.A9999.99.250004'

and POH.FBillNo='XW-PO170610021'