SELECT
	vendor.FName 供应商名称,
	supeItem.FNumber 物料编号,
	supeItem.FName 物料名称,
	munit.FName 单位,
	supe.FPrice 单价,
	supe.ftaxprice 含税单价,
	cur.FNumber 币别,
	supe.FStartQty 订货量_从,
	supe.FEndQty 订货量_到,
	supe.FDiscount 折扣率,
	supe.FQuoteTime 生效日期,
	supe.FDisableDate 失效日期
FROM
	t_SupplyEntry supe
LEFT JOIN t_ICItem supeItem ON supe.FItemID = supeItem.FItemID
LEFT JOIN t_MeasureUnit munit ON supe.FUnitID = munit.FItemID
LEFT JOIN t_Supplier vendor ON supe.FSupID = vendor.FItemID
LEFT JOIN t_Currency cur ON supe.FCyID = cur.FCurrencyID
WHERE
	supe.FItemID = 196142
--AND supe.FSupID = 17065
AND supe.FUnitID = 211
