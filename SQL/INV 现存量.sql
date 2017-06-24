SELECT
	onhand_item.FShortNumber,
	onhand_item.FNumber 料号代码,
	onhand_item.FName 料号名称,
	onhand_item.FModel 料号规格,
	onhand.FQty 存货数量,
	onhand.FSecQty 辅助计量单位数量
FROM
	ICInventory onhand
INNER JOIN t_ICItem onhand_item ON onhand.FItemID = onhand_item.FItemID
WHERE
	onhand_item.FNumber IN (
		SELECT
			litem.FNumber
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
		--AND CONVERT (VARCHAR(7), jobH.FDate, 120) >= '2017-06'
		AND ticmo.FBillNo = 'WORK115858' -- AND hitem.FNumber LIKE 'V.B%'
		--AND hitem.FNumber LIKE '2.02.B3005.01.BXH02974'
	)