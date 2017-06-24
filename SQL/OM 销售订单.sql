SELECT
	FCurCheckLevel 审核层次,
	tso.FMultiCheckLevel1 一审人员,
	tso.FMultiCheckLevel2 二审人员,
  FMultiCheckDate1 审核日期1,
	FMultiCheckDate2 审核日期2, 
	tso.FDate,
	tso.FInterID,
	tso.FBillNo 编号,
	tso.FStatus 核准状态, --0-未审核，1-审核,
	--tso.FHeadSelfS0143 源采购订单号,
	--tso.FHeadSelfS0144 源销售订单号,																																																																																																																										
	Customer.FShortName 客户,
	finalCustomer.FName 最终客户,
	tsoe_cur.FNumber 币别,
	tsoe.fentryid,
	tsoe_item.FNumber 产品代码,
	tsoe_item.FName 产品名称,
	--tsoe_item.Fmodel 规格型号,
	tsoe.FQty 数量,
	tsoe.FEntrySelfS0188 纯PCS数
FROM
	SEOrder tso
LEFT JOIN SEOrderEntry tsoe ON tso.FInterID = tsoe.FInterID
LEFT JOIN t_ICItem tsoe_item ON tsoe.FItemID = tsoe_item.FItemID
LEFT JOIN t_Currency tsoe_cur ON tso.FCurrencyID = tsoe_cur.FCurrencyID
LEFT JOIN t_Organization Customer ON tso.FCustID = Customer.FItemID
LEFT JOIN t_Item_3007 finalCustomer ON tso.FHeadSelfS0145 = finalCustomer.FItemID
WHERE
	1 = 1
 --AND tso.FBillNo in ('SEORD006916','SEORD006917')
--and tso.FHeadSelfS0143 = 'POORD032149/POD06339'
AND tso.FBillNo='SEORD006644'
 --AND tso.FBillNo = 'XW1706002'
--and tso.FHeadSelfS0143 = 'POORD032149/POD06339'

