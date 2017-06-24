SELECT
	--billNo.FBillName,
	pois.FBillNo 编号,
	CASE
WHEN pois.FSelTranType = 71 THEN
	FHeadSelfP0338
END 源采购单号,
 poise_item.FNumber 物料编号,
 poise_item.FName 物料名称,
 poise.FQty 数量,
 poise.FSourceBillNo 订单单号,
	pois.*
FROM
	POInstock pois
LEFT JOIN POInstockEntry poise ON pois.FInterID = poise.FInterID
LEFT JOIN t_ICItem poise_item ON poise.FItemID = poise_item.FItemID
LEFT JOIN ICBillNo billNo ON pois.FTranType=billNo.FBillID
WHERE
	pois.FBillNo = 'DD060911'