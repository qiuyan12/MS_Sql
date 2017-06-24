SELECT
	v1.FBillNo + '[' + t15.FNumber + ']' AS FBillNoItemNumber,
	v1.FBillNo + '[' + CONVERT (VARCHAR(255), u1.FEntryID) + ']' AS FBillNoEntryID,
	v1.FTranType AS FTranType,
	v1.FCheckerID AS FCheckerID,
	v1.FInterID AS FInterID,
	u1.FEntryID AS FEntryID,
	v1.Fdate AS Fdate,
	t4.FName AS FSupplyIDName,
	v1.FBillNo AS FBillNo,
	CASE
WHEN v1.FCheckerID > 0 THEN
	'Y'
WHEN v1.FCheckerID < 0 THEN
	'Y'
ELSE
	''
END AS FCheck,
 CASE
WHEN v1.FStatus = 3 THEN
	'Y'
ELSE
	''
END AS FClose,
 t8.FName AS FStockIDName,
 t9.FName AS FFManagerIDName,
 t10.FName AS FDeptIDName,
 t11.FName AS FEmpIDName,
 t12.FName AS FuserName,
 t13.FName AS FCurrencyIDName,
 v1.FExchangeRate AS FExchangeRate,
 u1.FMapNumber AS FMapNumber,
 u1.FMapName AS FMapName,
 t15.FShortNumber AS FItemIDName,
 t15.Fname AS FItemName,
 t15.Fmodel AS FItemModel,
 t18.FName AS FUnitIDName,
 u1.Fauxqty AS Fauxqty,
 u1.Fauxprice AS Fauxprice,
 u1.Famount AS Famount,
 u1.FNote AS FNote,
 t14.FName AS FCheckerIDName,
 t19.FName AS FBaseUnitID,
 u1.FQty AS FBaseQty,
 CASE
WHEN v1.FCancellation = 1 THEN
	'Y'
ELSE
	''
END AS FCancellation,
 (
	CASE t20.FName
	WHEN '*' THEN
		''
	ELSE
		t20.FName
	END
) AS FRelateBrIDName,
 u1.FOrderBillNo AS FOrderBillNo,
 u1.FContractBillNo AS FContractBillNo,
 u1.FSourceBillNo AS FSourceBillNo,
 t70.FName AS FSourceTranType,
 t15.FQtyDecimal AS FQtyDecimal,
 t15.FPriceDecimal AS FPriceDecimal,
 t15.FNumber AS FFullNumber,
 t7.FName AS FPOStyleName,
 u1.FBatchNo AS FBatchNo,
 (
	CASE t510.FName
	WHEN '*' THEN
		''
	ELSE
		t510.FName
	END
) AS FSPName,
 u1.FKFPeriod AS FKFPeriod,
 u1.FKFDate AS FKFDate,
 v1.FExplanation AS FExplanation,
 v1.FFetchAdd AS FFetchAdd,
 v1.FCheckDate AS FCheckDate,
 (
	CASE t112.FName
	WHEN '*' THEN
		''
	ELSE
		t112.FName
	END
) AS FAuxPropIDName,
 t112.FNumber AS FAuxPropIDNumber,
 CASE
WHEN t15.FOrderUnitID = 0 THEN
	''
ELSE
	t500.FName
END AS FCUUnitName,
 CASE
WHEN t15.FOrderUnitID = 0 THEN
	''
ELSE
	u1.FQty / t500.FCoefficient
END AS FCUUnitQtyMust,
 CASE
WHEN v1.FCurrencyID IS NULL
OR v1.FCurrencyID = '' THEN
	(
		SELECT
			FScale
		FROM
			t_Currency
		WHERE
			FCurrencyID = 1
	)
ELSE
	t503.FScale
END AS FAmountDecimal,
 u1.FPeriodDate AS FPeriodDate,
 t573.FName AS FAreaPS,
 t505.FName AS FSecUnitName,
 u1.FSecCoefficient AS FSecCoefficient,
 u1.FSecQty AS FSecQty,
 t1234.FName AS FHeadSelfP0335,
 v1.FHeadSelfP0336 AS FHeadSelfP0336,
 v1.FHeadSelfP0338 AS FHeadSelfP0338,
 v1.FHeadSelfP0339 AS FHeadSelfP0339,
 v1.FHeadSelfP0340 AS FHeadSelfP0340,
 v1.FHeadSelfP0341 AS FHeadSelfP0341,
 v1.FHeadSelfP0342 AS FHeadSelfP0342,
 t1241.FSHORTNUMBER AS FHeadSelfP0343,
 t1242.F_105 AS FEntrySelfP0337,
 u1.FEntrySelfP0340 AS FEntrySelfP0340,
 u1.FEntrySelfP0336 AS FEntrySelfP0336,
 u1.FEntrySelfP0338 AS FEntrySelfP0338,
 t1246.FSHORTNUMBER AS FEntrySelfP0339,
 v1.FRelateBrID AS FRelateBrID,
 v1.FSupplyID AS FSupplyID
FROM
	POInstock v1
INNER JOIN POInstockEntry u1 ON v1.FInterID = u1.FInterID
AND u1.FInterID <> 0
LEFT OUTER JOIN t_Supplier t4 ON v1.FSupplyID = t4.FItemID
AND t4.FItemID <> 0
LEFT OUTER JOIN t_SubMessage t7 ON v1.FPOStyle = t7.FInterID
AND t7.FInterID <> 0
LEFT OUTER JOIN t_Stock t8 ON u1.FStockID = t8.FItemID
AND t8.FItemID <> 0
LEFT OUTER JOIN t_Emp t9 ON v1.FFManagerID = t9.FItemID
AND t9.FItemID <> 0
LEFT OUTER JOIN t_Department t10 ON v1.FDeptID = t10.FItemID
AND t10.FItemID <> 0
LEFT OUTER JOIN t_Emp t11 ON v1.FEmpID = t11.FItemID
AND t11.FItemID <> 0
LEFT OUTER JOIN t_User t12 ON v1.FBillerID = t12.FUserID
AND t12.FUserID <> 0
INNER JOIN t_Currency t13 ON v1.FCurrencyID = t13.FCurrencyID
AND t13.FCurrencyID <> 0
LEFT OUTER JOIN t_User t14 ON v1.FCheckerID = t14.FUserID
AND t14.FUserID <> 0
INNER JOIN t_ICItem t15 ON u1.FItemID = t15.FItemID
AND t15.FItemID <> 0
INNER JOIN t_MeasureUnit t18 ON u1.FUnitID = t18.FItemID
AND t18.FItemID <> 0
LEFT OUTER JOIN t_MeasureUnit t19 ON t15.FUnitID = t19.FMeasureUnitID
AND t19.FMeasureUnitID <> 0
LEFT OUTER JOIN t_SonCompany t20 ON v1.FRelateBrID = t20.FItemID
AND t20.FItemID <> 0
LEFT OUTER JOIN v_ICTransType t70 ON u1.FSourceTranType = t70.FID
AND t70.FID <> 0
LEFT OUTER JOIN t_StockPlace t510 ON u1.FDCSPID = t510.FSPID
AND t510.FSPID <> 0
AND u1.FDCSPID <> 0
LEFT OUTER JOIN t_AuxItem t112 ON u1.FAuxPropID = t112.FItemid
AND t112.FItemid <> 0
LEFT OUTER JOIN t_MeasureUnit t500 ON t15.FOrderUnitID = t500.FItemID
AND t500.FItemID <> 0
LEFT OUTER JOIN t_Currency t503 ON v1.FCurrencyID = t503.FCurrencyID
AND t503.FCurrencyID <> 0
LEFT OUTER JOIN t_MeasureUnit t505 ON t15.FSecUnitID = t505.FItemID
AND t505.FItemID <> 0
LEFT OUTER JOIN t_Submessage t573 ON v1.FAreaPS = t573.FInterID
AND t573.FInterID <> 0
LEFT OUTER JOIN t_SubMessage t1234 ON v1.FHeadSelfP0335 = t1234.FInterID
AND t1234.FInterID <> 0
LEFT OUTER JOIN t_Supplier t1241 ON v1.FSupplyID = t1241.FItemID
AND t1241.FItemID <> 0
LEFT OUTER JOIN t_ICItem t1242 ON u1.FItemID = t1242.FItemID
AND t1242.FItemID <> 0
LEFT OUTER JOIN t_ICItem t1246 ON u1.FItemID = t1246.FItemID
AND t1246.FItemID <> 0
WHERE
	1 = 1
AND (
	u1.FSourceBillNo = 'XW-PO170610021'
)
AND (
	v1.FTranType = 72
	AND (v1.FCancellation = 0)
)
AND (
	(
		v1.FInterID = 63821
		AND u1.FEntryID = 1
	)
)
ORDER BY
	v1.FInterID,
	u1.FEntryID