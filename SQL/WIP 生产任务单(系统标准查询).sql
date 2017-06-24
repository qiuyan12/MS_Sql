
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED SELECT
	TOP 40 t10.FName AS FCustIDName,
	v1.FCustID AS FCustID,
	t35.FName AS FCostObjIDName,
	v1.FCostObjID AS FCostObjID,
	t1.Fname AS FTranTypeName,
	t7.FTraceTypeID AS FTraceTypeID,
	t7.FName AS FWorktypeIDName,
	v1.Ftype AS FWorktypeID,
	v1.FWorkShop AS FWorkShop,
	v1.FItemID AS FItemID,
	v1.FStatus AS FStatus,
	v1.FTranType AS FTranType,
	v1.FInterID AS FInterID,
	v1.FBillNo AS FBillNo,
	v1.FCheckDate AS FCheckDate,
	CASE v1.FStatus
WHEN 0 THEN
	'计划'
WHEN 3 THEN
	'结案'
WHEN 5 THEN
	'确认'
ELSE
	'下达'
END AS FstatusName,
 CASE
WHEN v1.FCancellation = 1 THEN
	'Y'
ELSE
	''
END AS FCancellation,
 CASE V1.FSuspend
WHEN 0 THEN
	''
ELSE
	'Y'
END AS FSuspend,
 CASE V1.FMRPClosed
WHEN 0 THEN
	''
ELSE
	'Y'
END AS FMRPClosedName,
 (
	CASE
	WHEN t5.FName IS NULL THEN
		'手工录入'
	WHEN t5.FName = '0' THEN
		'手工录入'
	ELSE
		t5.FName
	END
) AS FMRPName,
 t7.FName AS FWorkTypeName,
 t7.FICMOTypeID AS FICMOTypeID,
 t35.FName AS FCostObjName,
 t36.FBomNumber AS FFBomNumber,
 t40.FRoutingName AS FRoutingName,
 t8.FName AS FWorkShopName,
 t10.FName AS FSupplyName,
 t9.FShortNumber AS FShortNumber,
 t9.FNumber AS FLongNumber,
 t9.Fname AS FItemName,
 t9.Fmodel AS FItemModel,
 t12.FName AS FUnitIDName,
 v1.Fauxqty AS Fauxqty,
 t15.FName AS FBaseUnitID,
 v1.FQty AS FBaseQty,
 CASE
WHEN t9.FProductUnitID = 0 THEN
	''
ELSE
	t50.FName
END AS FCUUnitName,
 CASE
WHEN t9.FProductUnitID = 0 THEN
	0
ELSE
	v1.FQty / t50.FCoEfficient
END AS FCUUnitQty,
 v1.FAuxQtyFinish AS FAuxQtyFinish,
 v1.FAuxStockQty AS FAuxStockQty,
 v1.FAuxQtyPass AS FAuxQtyPass,
 v1.FAuxQtyScrap AS FAuxQtyScrap,
 v1.FAuxQtyForItem AS FAuxQtyForItem,
 v1.FAuxQtyLost AS FAuxQtyLost,
 v1.FFinishTime AS FFinishTime,
 v1.FReadyTime AS FReadyTime,
 v1.FfixTime AS FfixTime,
 v1.FPlanCommitDate AS FPlanBeginDate,
 v1.FPlanFinishDate AS FPlanFinishDate,
 v1.FCommitDate AS FCommitDate,
 v1.FStartDate AS FStartDate,
 v1.FFinishDate AS FFinishDate,
 t30.FName AS FBillerName,
 t32.FName AS FCheckerName,
 t31.FName AS FCloserName,
 v1.FCloseDate AS FCloseDate,
 v1.FNote AS FNote,
 IsNull(T22.FBillNO, '') AS FOrderBillNo,
 t20.FBillNo AS FPICMOBillNo,
 t37.FPlanOrderNo AS FPlanOrderNumber,
 t38.FBillNo AS FPOrderNumber,
 CASE v1.FSourceEntryID
WHEN 0 THEN
	NULL
ELSE
	v1.FSourceEntryID
END AS FSourceEntryID,
 CASE
WHEN t45.FCheckerID > 0 THEN
	'Y'
WHEN t45.FCheckerID < 0 THEN
	'Y'
ELSE
	''
END AS FPPBOMStatus,
 t9.FQtyDecimal AS FQtyDecimal,
 t9.FPriceDecimal AS FPriceDecimal,
 (
	CASE
	WHEN (v1.FMrpLockFlag & 2) > 0 THEN
		'Y'
	ELSE
		''
	END
) AS FMrpLockFlag,
 (
	CASE
	WHEN (v1.FMrpLockFlag & 8) > 0 THEN
		'Y'
	ELSE
		''
	END
) AS FMrpTrackFlag,
 (
	CASE
	WHEN (v1.FMrpLockFlag & 32) > 0 THEN
		'Y'
	ELSE
		''
	END
) AS FMrpInvGenFlag,
 CASE
WHEN v1.FHandworkClose = 1 THEN
	'Y'
ELSE
	''
END AS FHandworkClose,
 t33.FName AS FConfirmerName,
 v1.FConfirmDate AS FConfirmDate,
 v1.FGMPBatchNo AS FGMPBatchNo,
 v1.FInHighLimit AS FInHighLimit,
 v1.FAuxInHighLimitQty AS FAuxInHighLimitQty,
 v1.FInHighLimitQty AS FInHighLimitQty,
 CASE
WHEN t9.FProductUnitID = 0 THEN
	0
ELSE
	v1.FInHighLimitQty / (t50.FCoEfficient)
END AS FInHighLimitCuQty,
 v1.FInLowLimit AS FInLowLimit,
 v1.FAuxInLowLimitQty AS FAuxInLowLimitQty,
 v1.FInLowLimitQty AS FInLowLimitQty,
 CASE
WHEN t9.FProductUnitID = 0 THEN
	0
ELSE
	v1.FInLowLimitQty / (t50.FCoEfficient)
END AS FInLowLimitCuQty,
 v1.FChangeTimes AS FChangeTimes,
 v1.FHeadSelfJ0173 AS FHeadSelfJ0173,
 v1.FHeadSelfJ0174 AS FHeadSelfJ0174,
 v1.FHeadSelfJ0175 AS FHeadSelfJ0175,
 v1.FHeadSelfJ0176 AS FHeadSelfJ0176,
 v1.FHeadSelfJ0177 AS FHeadSelfJ0177,
 v1.FHeadSelfJ0178 AS FHeadSelfJ0178,
 v1.FHeadSelfJ0179 AS FHeadSelfJ0179,
 t1262.FName AS FHeadSelfJ0180,
 v1.FHeadSelfJ0181 AS FHeadSelfJ0181,
 t1264.FName AS FHeadSelfJ0182,
 v1.FHeadSelfJ0183 AS FHeadSelfJ0183,
 v1.FHeadSelfJ0184 AS FHeadSelfJ0184,
 v1.FHeadSelfJ0185 AS FHeadSelfJ0185,
 v1.FHeadSelfJ0186 AS FHeadSelfJ0186,
 t1269.FName AS FHeadSelfJ0187
FROM
	ICMO v1
LEFT OUTER JOIN t_SubMessage t5 ON v1.FMRP = t5.FInterID
AND t5.FInterID <> 0
LEFT OUTER JOIN t_WorkType t7 ON v1.FWorktypeID = t7.FInterID
AND t7.FInterID <> 0
LEFT OUTER JOIN t_Department t8 ON v1.FWorkShop = t8.FItemID
AND t8.FItemID <> 0
INNER JOIN t_ICItem t9 ON v1.FItemID = t9.FItemID
AND t9.FItemID <> 0
INNER JOIN t_MeasureUnit t12 ON v1.FUnitID = t12.FItemID
AND t12.FItemID <> 0
LEFT OUTER JOIN t_User t30 ON v1.FBillerID = t30.FUserID
AND t30.FUserID <> 0
LEFT OUTER JOIN t_User t32 ON v1.FConveyerID = t32.FUserID
AND t32.FUserID <> 0
LEFT OUTER JOIN t_User t31 ON v1.FCheckerID = t31.FUserID
AND t31.FUserID <> 0
LEFT OUTER JOIN SEOrder t22 ON v1.FOrderInterID = t22.FInterID
AND t22.FInterID <> 0
LEFT OUTER JOIN t_Routing t40 ON v1.FRoutingID = t40.FInterID
AND t40.FInterID <> 0
LEFT OUTER JOIN t_MeasureUnit t15 ON t9.FUnitID = t15.FMeasureUnitID
AND t15.FMeasureUnitID <> 0
LEFT OUTER JOIN ICMO t20 ON v1.FParentInterID = t20.FInterID
AND t20.FInterID <> 0
LEFT OUTER JOIN CBCostObj t35 ON v1.FCostObjID = t35.FItemID
AND t35.FItemID <> 0
LEFT OUTER JOIN ICBom t36 ON v1.FBomInterID = t36.FInterID
AND t36.FInterID <> 0
LEFT OUTER JOIN t_MeasureUnit t50 ON t9.FProductUnitID = t50.FItemID
AND t50.FItemID <> 0
LEFT OUTER JOIN ICMrpResult t37 ON v1.FPlanOrderInterID = t37.FPlanOrderInterID
AND t37.FPlanOrderInterID <> 0
LEFT OUTER JOIN PPOrder t38 ON v1.FPPOrderInterID = t38.FInterID
AND t38.FInterID <> 0
LEFT OUTER JOIN t_Organization t10 ON v1.FCustID = t10.FItemID
AND t10.FItemID <> 0
LEFT OUTER JOIN PPBOM t45 ON v1.FInterID = t45.FICMOInterID
AND t45.FICMOInterID <> 0
LEFT OUTER JOIN v_ICTransType t1 ON v1.FTranType = t1.FID
AND t1.FID <> 0
LEFT OUTER JOIN t_User t33 ON v1.FConfirmerID = t33.FUserID
AND t33.FUserID <> 0
LEFT OUTER JOIN t_Item t1262 ON v1.FHeadSelfJ0180 = t1262.FItemID
AND t1262.FItemID <> 0
LEFT OUTER JOIN t_SubMessage t1264 ON v1.FHeadSelfJ0182 = t1264.FInterID
AND t1264.FInterID <> 0
LEFT OUTER JOIN t_Item t1269 ON v1.FHeadSelfJ0187 = t1269.FItemID
AND t1269.FItemID <> 0
WHERE
	(v1.FInterID = 118243)
ORDER BY
	v1.FInterID