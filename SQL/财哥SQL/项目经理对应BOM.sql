select max(fshortnumber)  from t_icitem where fnumber like 'v.c.%'

select t1.fbomnumber,t2.fnumber,t2.fname,t2.fmodel,t1.fnote 
--update t1 set fnote='汤传义-panasonic'
from icbom t1
inner join t_icitem t2 on t1.fitemid=t2.fitemid
where t2.fnumber like 'v.%' and fname like '%len%'


select t1.fbomnumber,t2.fnumber,t2.fname,t2.fmodel,t1.fnote 
--update t1 set fnote='汤传义-canon'
from icbom t1
inner join t_icitem t2 on t1.fitemid=t2.fitemid
where t2.fnumber like 'v.%' and fmodel like '%gpr%'



select t1.fbomnumber,t2.fnumber,t2.fname,t2.fmodel,t1.fnote 
--update t1 set fnote='刘均庆-oki'
from icbom t1
inner join t_icitem t2 on t1.fitemid=t2.fitemid
where t2.fnumber like 'v.%' and fname like '%ricoh%'


select t1.fbomnumber,t2.fnumber,t2.fname,t2.fmodel,t1.fnote 
--update t1 set fnote='刘占伟-founder'
from icbom t1
inner join t_icitem t2 on t1.fitemid=t2.fitemid
where t2.fnumber like 'v.%' and fname like '%nec%'

select t1.fbomnumber,t2.fnumber,t2.fname,t2.fmodel,t1.fnote 
--update t1 set fnote='唐勇'
from icbom t1
inner join t_icitem t2 on t1.fitemid=t2.fitemid
where t2.fnumber like 'v.%' and fname like '%再生%'

