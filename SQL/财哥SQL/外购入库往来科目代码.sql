

select t1.fcussentacctid,t2.famount,t1.* 
--update t1 set fcussentacctid=1209
from icstockbill t1 
inner join icstockbillentry t2 on t1.finterid=t2.finterid
where t1.ftrantype=1 and t1.fcussentacctid=0
and t1.fcussentacctid<>1209 and month(t1.fdate)=10

select * from t_account where faccountid=1209