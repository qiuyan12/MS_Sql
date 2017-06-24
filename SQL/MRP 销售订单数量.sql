SELECT
	tsoe_item.FNumber 产品名称,
	SUM (
		tsoe.FQty - tsoe.FAuxStockQty
	) 未出货数量,

	MIN(onhandinfo.FQty) 库存数量
	
FROM
	SEOrder tso
LEFT JOIN SEOrderEntry tsoe ON tso.FInterID = tsoe.FInterID
LEFT JOIN t_ICItem tsoe_item ON tsoe.FItemID = tsoe_item.FItemID
LEFT JOIN t_Currency tsoe_cur ON tso.FCurrencyID = tsoe_cur.FCurrencyID
LEFT JOIN t_Organization Customer ON tso.FCustID = Customer.FItemID
LEFT JOIN t_Item_3007 finalCustomer ON tso.FHeadSelfS0145 = finalCustomer.FItemID

LEFT JOIN (
	SELECT
		onhand_item.FNumber,
		sum(onhand.FQty) FQty
	FROM
		icinventory onhand
	INNER JOIN t_ICItem onhand_item ON onhand.FItemID = onhand_item.FItemID
	GROUP BY
		onhand_item.FNumber
) onhandinfo ON onhandinfo.FNumber = tsoe_item.FNumber
WHERE
	1 = 1
AND tsoe_item.FNumber = 'V.B.B3005.06.VB09940'
GROUP BY
	tsoe_item.FNumber