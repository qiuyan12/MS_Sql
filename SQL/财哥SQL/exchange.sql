select * 
--delete t1
from cbCostObj t1 where fnumber not in (select fnumber from t_icitem) and fitemid not in (55,56)

select * 
--delete t1
from t_item t1 where fitemclassid=2001 and fdetail=1 and fnumber not in (select fnumber from cbCostObj) and fitemid not in (55,56) and flevel in (5)

