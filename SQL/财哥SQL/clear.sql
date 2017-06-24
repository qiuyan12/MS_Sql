truncate table t_voucher
truncate table t_voucherentry

update t1 set fname=t1.fnumber
from t_item t1

update t0 set fname=t9.fnumber,fmodel=t9.fnumber
--update t7 set f_105=''
FROM t_ICItemCore t0
    LEFT JOIN t_ICItemBase t1 ON t0.FItemID=t1.FItemID
    LEFT JOIN t_ICItemMaterial t2 ON t0.FItemID=t2.FItemID
    LEFT JOIN t_ICItemPlan t3 ON t0.FItemID=t3.FItemID
    LEFT JOIN t_ICItemDesign t4 ON t0.FItemID=t4.FItemID 
    LEFT JOIN t_ICItemStandard t5 ON t0.FItemID=t5.FItemID
    LEFT JOIN t_ICItemQuality t6 ON t0.FItemID=t6.FItemID
    LEFT JOIN t_ICItemCustom t7 ON t0.FItemID=t7.FItemID
    LEFT JOIN T_BASE_ICItemEntrance t8 ON t0.FItemID=t8.FItemID
inner join t_icitem t9 on t9.fitemid=t0.fitemid

update t1 set fname=t1.fnumber,fshortname=t1.fnumber,FPhone='',FFax='',FAddress=''
from t_Organization t1

update t1 set fname=t1.fnumber
from t_Emp t1

update t1 set fname=t1.fnumber,fshortname=t1.fnumber,FPhone='',FFax='',FAddress='',fhelpcode=''
from t_Supplier t1

update t1 set fname=t1.fnumber
from cbCostObj t1 where fitemid not in (55,56)

update t1 set fname=t1.fnumber
from t_Item_3007 t1

update t1 set fname=t1.fuserid
from t_user t1
where t1.fuserid >=12 and t1.fuserid <>16394

update t1 set fvalue='test'
from t_SystemProfile t1 where fvalue like '%ÖÐÉ½%'

update t1 set FExplanation='',fheadselfp0241=''
from poorder t1 

update t1 set FExplanation='',fheadselfp0339=''
from poinstock t1 

delete a
from t_Rpt_Content a  
where a.FRptName like '%öÎÍþ%'

update t1 set fmapname=t1.fmapnumber
from ICItemMapping t1

update t1 set fmapname=t1.fmapnumber
from icstockbillentry t1


update t1 set fmapname=t1.fmapnumber
from seorderentry t1

