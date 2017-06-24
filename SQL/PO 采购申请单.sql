SELECT
	TOP 1 POR.FBillNo 编号,
	pore_Item.FNumber 料号代码,
	pore_Item.FName 料号名称,
	PORE.Fqty 数量,
	PORE.FSourceTranType,
	tranType.FName AS FName,
	tranType.FHeadTable,
	tranType.FEntryTable
FROM
	PORequest POR
LEFT JOIN POrequestEntry PORE ON POR.FInterID = PORE.FInterID
LEFT JOIN t_ICitem pore_Item ON PORE.FItemID = pore_Item.FItemID
LEFT JOIN ICTransactiontype tranType ON PORE.FSourceTranType = tranType.FID
WHERE
	1 = 1 --AND PORE.FSourceTranType <> 0
AND PORE.FInterID = 8273
AND (
	PORE.FPlanOrderInterID = 0
	OR PORE.FPlanOrderInterID IS NULL
)