
select t1.fnumber 代码,t1.fname 名称,t1.fmodel 规格,t1.f_105 描述,f_106 适用机型,f_107 适用区域
from t_icitem t1 where left(t1.fnumber,1) in ('a','p','j','x','y') and fitemid not in(select fitemid from icbom) order by fnumber


select t1.fnumber 代码,t1.fname 名称,t1.fmodel 规格,t1.f_105 描述,f_106 适用机型,f_107 适用区域
from t_icitem t1 where left(t1.fnumber,1) in ('a','p','j','x','y') and fitemid  in(select fitemid from icbom) order by fnumber


select fitemid,fnumber,fname,fmodel from t_icitem where fshortnumber='300402'
select fitemid,fnumber,fname,fmodel from t_icitem where fshortnumber='300450'
select fitemid,fnumber,fname,fmodel from t_icitem where fshortnumber='300330'
select fitemid,fnumber,fname,fmodel from t_icitem where fshortnumber='301339'


select t1.fbomnumber,t2.fnumber,t2.fname,t4.fitemid,t4.fnumber,t4.fname 
--update t1 set fitemid=66875
from icbom t1 
inner join icbomchild t3 on t1.finterid=t3.finterid
inner join t_icitem t4 on t3.fitemid=t4.fitemid
inner join t_icitem t2 on t1.fitemid=t2.fitemid
where t4.fshortnumber in('300450','500450')

select * 
--update t1 set fitemid=66937
from icbomchild t1 where fitemid=65691

select max(fshortnumber) from t_icitem where fnumber like '3.%'


select fbomnumber,t2.fnumber,t2.fname,t2.fmodel,case t1.fstatus when 0 then '未审核' else '审核' end as 审核状态 from icbom t1
inner join t_icitem t2 on t1.fitemid=t2.fitemid
where left(t2.fnumber,1) in ('a','p','j','x','y') and t1.fstatus=0

--刘占伟
select fnumber,fname,fmodel,substring(fnumber,6,2),t3.f_128
--update t3 set f_128=40113
from t_icitem t2  
inner join t_ICItemCustom t3 on t2.fitemid=t3.fitemid
where left(t2.fnumber,1) in ('a','p','j','x','y') and substring(fnumber,6,2) in ('01','02','03')

--刘均庆
select fnumber,fname,fmodel,substring(fnumber,6,2),t3.f_128
--update t3 set f_128=40114
from t_icitem t2  
inner join t_ICItemCustom t3 on t2.fitemid=t3.fitemid
where left(t2.fnumber,1) in ('a','p','j','x','y') and substring(fnumber,6,2) in ('04','05','06','08','09','14','21','19')
order by t2.fnumber


--汤传义
select fnumber,fname,fmodel,substring(fnumber,6,2),t3.f_128
--update t3 set f_128=40115
from t_icitem t2  
inner join t_ICItemCustom t3 on t2.fitemid=t3.fitemid
where left(t2.fnumber,1) in ('a','p','j','x','y') and substring(fnumber,6,2) in ('07','10','11','12','13','15','16')



--唐勇
select fnumber,fname,fmodel,substring(fnumber,6,2),t3.f_128
--update t3 set f_128=40116
from t_icitem t2  
inner join t_ICItemCustom t3 on t2.fitemid=t3.fitemid
where left(t2.fnumber,1) in ('j','x') 


--复印机
select fnumber,fname,fmodel,substring(fnumber,6,2),t3.f_128
--update t3 set f_128=40115
from t_icitem t2  
inner join t_ICItemCustom t3 on t2.fitemid=t3.fitemid
where left(t2.fnumber,1) in ('y') 



--查询标准产品未审核BOM详情
select t3.fname as 研发经理,fbomnumber,t2.fnumber,t2.fname,t2.fmodel,case t1.fstatus when 0 then '未审核' else '审核' end as BOM审核状态,case t2.f_126 when 40019 then '是' else ' 'end as 是否产品引擎 from icbom t1
inner join t_icitem t2 on t1.fitemid=t2.fitemid
left join t_submessage t3 on t2.f_128=t3.finterid
where left(t2.fnumber,1) in ('a','p','j','x','y') and t1.fstatus=0
order by t2.f_128,t2.fnumber


select t3.fname as 研发经理,count(*) as 未审核BOM数 from icbom t1
inner join t_icitem t2 on t1.fitemid=t2.fitemid
inner join t_submessage t3 on t2.f_128=t3.finterid
where left(t2.fnumber,1) in ('a','p','j','x','y') and t1.fstatus=0
group by t3.fname


--查询个性化产品未审核BOM详情
select t3.fname as 研发经理,fbomnumber,t2.fnumber,t2.fname,t2.fmodel,case t1.fstatus when 0 then '未审核' else '审核' end as BOM审核状态,case t2.f_126 when 40019 then '是' else ' 'end as 是否产品引擎 from icbom t1
inner join t_icitem t2 on t1.fitemid=t2.fitemid
left join t_submessage t3 on t2.f_128=t3.finterid
where left(t2.fnumber,1) in ('v') and t1.fstatus=0
order by t2.f_128,t2.fnumber

select * 
--delete
from icbomgroup where fnumber like '8.%'




--查询标准产品未审核BOM详情
select t3.fname as 研发经理,fbomnumber,t2.fnumber,t2.fname,t2.fmodel,case t1.fstatus when 0 then '未审核' else '审核' end as BOM审核状态,case t2.f_126 when 40019 then '是' else ' 'end as 是否产品引擎 from icbom t1
inner join t_icitem t2 on t1.fitemid=t2.fitemid
left join t_submessage t3 on t2.f_128=t3.finterid
where left(t2.fnumber,1) in ('a','p','j','x','y') and substring(t2.fnumber,3,2) in ('01')
order by t2.f_128,t2.fnumber