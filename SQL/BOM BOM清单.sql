SELECT
	TOP 100 
	bom.fcheckerid,
	bom.FInterID,
	bomgroup.fname ICBomGroup分类信息,
	bom.FBOMNumber,
	bomheaditem.FNumber,
	bomheaditem.FName,
	bomc.FEntryID,
	childitem.FNumber,
	childitem.FName,
	bomc.FQty,
	Unit.FName Unit,
	bom.FCheckerID 审核人ID
FROM
	ICBom bom
LEFT JOIN t_Item bomheaditem ON bom.FItemID = bomheaditem.FItemID -- left join ICBomGroup bomgroup on bomheaditem.fnumber=bomgroup.fnumber
LEFT JOIN ICBomChild bomc ON bom.FInterID = bomc.FInterID
LEFT JOIN t_icItem childitem ON bomc.FItemID = childitem.FItemID
LEFT JOIN t_item ciitem ON childitem.FParentID = ciitem.fitemid
LEFT JOIN ICBomGroup bomgroup ON ciitem.fnumber = bomgroup.fnumber
LEFT JOIN t_Item Unit ON Unit.FItemClassID = 7
AND childitem.FUnitID = Unit.FItemID
WHERE
	1 = 1
AND bomheaditem.FNumber = '3.03.029.300598'--'V.B.B1100.01.VB00036'
--AND bom.FCheckerID >0