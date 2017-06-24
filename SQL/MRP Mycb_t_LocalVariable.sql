SELECT
	t.*,
	emp.FName,
	dep.FName,
	billNo.FBillName
FROM
	Mycb_t_LocalVariable t 
LEFT JOIN t_Emp emp on t.fname='fempid' AND t.fvalue=emp.FItemID
LEFT JOIN t_Department dep ON t.fname='fdeptid' and t.fvalue=dep.FItemID
LEFT JOIN ICBillNo  billNo ON t.fbilltype=billNo.FBillID
WHERE
	t.fuserid = 16511