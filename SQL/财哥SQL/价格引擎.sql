select *
from t_itempropdesc where fitemclassid=4


-- 是否引擎	F_126
-- 价格引擎	F_127
-- 引擎代码	F_129


set nocount on

--数据源
select -1 ftype,fitemid,max(fbanitemid) fbanitemid,max(fxinitemid) fxinitemid,0 fisyinqing,0 fyinqingitemid,
0 FIsPriceError,0 FIsHaveSellPrice,
cast(0.00 as decimal(24,4)) fsellprice,cast(0.00 as decimal(24,4)) fmaterialcost into #data
from
(
	select t1.fitemid,
	case when left(t4.fnumber,1) in ('3','4','5','7','8') then t4.fitemid else 0 end fbanitemid,
	case when left(t4.fnumber,10) in ('1.01.0010.') then t4.fitemid else 0 end fxinitemid
	from t_icitem t1
	inner join t_item t13 on t13.fitemid=t1.fparentid 
	inner join icbom t2 on t1.fitemid=t2.fitemid
	inner join icbomchild t3 on t2.finterid=t3.finterid
	inner join t_icitem t4 on t3.fitemid=t4.fitemid
	where --left(t1.fnumber,4) in ('a.01','p.01','j.01','x.01','y.01') 
	left(t1.fnumber,1) in (select fitemtype from v_myitemtype where ftype=0)
	--and t1.fshortnumber='a02050'
	and left(t1.fnumber,1) not in ('q','r') and t1.fname not like '%禁用%' and t1.fdeleted=0
) t1 group by t1.fitemid

--无芯片、高配
update t1 set ftype=0
from #data t1
inner join t_icitem t2 on t1.fitemid=t2.fitemid
where --left(t2.fnumber,4) in ('a.01','p.01','j.01','x.01','y.01') and 
t1.fxinitemid=0 and t2.fname like '%高配%'

--无芯片、非高配
update t1 set ftype=1
from #data t1
inner join t_icitem t2 on t1.fitemid=t2.fitemid
where t1.fxinitemid=0 and t2.fname not like '%高配%'

--带芯片、高配
update t1 set ftype=2
from #data t1
inner join t_icitem t2 on t1.fitemid=t2.fitemid
where t1.fxinitemid>0 and t2.fname like '%高配%'

--带芯片、非高配
update t1 set ftype=3
from #data t1
inner join t_icitem t2 on t1.fitemid=t2.fitemid
where t1.fxinitemid>0 and t2.fname not like '%高配%'


--傲威中性作为引擎--标准资料只有傲威中性作为引擎
update t7 set fisyinqing=1,fyinqingitemid=t7.fitemid
from #data t7
inner join
(
	select t1.ftype,t1.fbanitemid,min(t2.fitemid) fitemid
	from #data t1
	inner join t_icitem t2 on t1.fitemid=t2.fitemid
	where left(t2.fnumber,4) in ('a.01','p.01','j.01','x.01','y.01')
	--and (t1.fxinitemid)=0
	group by t1.fbanitemid,t1.ftype
) t2 on t7.fitemid=t2.fitemid and t7.ftype=t2.ftype
inner join t_icitem t4 on t2.fitemid=t4.fitemid


--更新引擎 类别+半成品
update t7 set fyinqingitemid=t2.fitemid
from (select fitemid,fbanitemid,ftype from #data where fisyinqing=0) t1  
inner join (select fitemid,fbanitemid,ftype from #data where fisyinqing=1) t2 on t1.fbanitemid=t2.fbanitemid and t1.ftype=t2.ftype
inner join #data t7 on t7.fitemid=t1.fitemid

-- update t7 set fisyinqing=1,fyinqingitemid=t7.fitemid
-- from #data t7
-- inner join
-- (
-- 	select t1.fbanitemid,min(t2.fitemid) fitemid
-- 	from #data t1
-- 	inner join t_icitem t2 on t1.fitemid=t2.fitemid
-- 	where left(t2.fnumber,4) in ('a.01','p.01','j.01','x.01','y.01')
-- 	and (t1.fxinitemid)>0
-- 	group by t1.fbanitemid
-- ) t2 on t7.fitemid=t2.fitemid
-- inner join t_icitem t4 on t2.fitemid=t4.fitemid
-- 
-- update t7 set fyinqingitemid=t2.fitemid
-- from (select fitemid,fbanitemid from #data where fisyinqing=0 and fxinitemid>0) t1
-- inner join (select fitemid,fbanitemid from #data where fisyinqing=1 and fxinitemid>0) t2 on t1.fbanitemid=t2.fbanitemid
-- inner join t_icitem t3 on t1.fitemid=t3.fitemid
-- inner join t_icitem t4 on t2.fitemid=t4.fitemid
-- inner join #data t7 on t7.fitemid=t1.fitemid


--特殊芯片
update t7 set fisyinqing=1,fyinqingitemid=t7.fitemid
from #data t7
inner join
(
	select t1.fitemid
	from #data t1
	inner join t_icitem t2 on t1.fitemid=t2.fitemid
	inner join t_icitem t8 on t1.fxinitemid=t8.fitemid
	where --left(t2.fnumber,4) in ('a.01','p.01','j.01','x.01','y.01') and
	t1.fxinitemid>0 and (t8.fname like '%/099%' or t8.fname like '%chn%')
) t2 on t7.fitemid=t2.fitemid
inner join t_icitem t4 on t2.fitemid=t4.fitemid

select * from t_submessage where ftypeid=10002 and fname ='是'
--是否引擎	F_126
--价格引擎	F_127
--引擎代码	F_129
select t3.fnumber 产品编码,t3.fname 产品名称,t3.fmodel 产品型号,t4.fnumber 引擎编码,t4.fname 引擎名称,t4.fmodel 引擎型号,
t7.fnumber 半成品编码,t7.fname 半成品名称,t7.fmodel 半成品型号,t8.fnumber 芯片编码,t8.fname 芯片名称,t8.fmodel 芯片型号,
(case when t1.fisyinqing=1 then 'Y' end) 是否引擎,(case when t1.fisyinqing=1 then 40019 else 0 end) 是否引擎,
(case when t1.FIsPriceError=1 then 'Y' end) 价格有误,
(case when t1.FIsHaveSellPrice=1 then 'Y' end) 是否已报价,
t1.fsellprice 标准售价,t1.fmaterialcost 材料成本
--update t5 set F_126=(case when t1.fisyinqing=1 then 40019 else 0 end),F_127=fyinqingitemid,F_129=t4.fnumber
from #data t1
inner join t_icitem t3 on t1.fitemid=t3.fitemid
left join t_icitem t4 on t1.fyinqingitemid=t4.fitemid
left join t_icitem t7 on t1.fbanitemid=t7.fitemid
left join t_icitem t8 on t1.fxinitemid=t8.fitemid
--left join IcPrcPlyEntry t9 on t9.fitemid=t1.fitemid
inner join t_ICItemCustom t5 on t1.fitemid=t5.fitemid
-- inner join t_ICItemCustom t6 on t2.fitemid=t6.fitemid --产品引擎 Y
where (left(t3.fnumber,4) in ('a.01','p.01','j.01','x.01','y.01') or left(t3.fnumber,1) in ('v'))
--and t3.fshortnumber in ('A00057','A00058')
and t1.fyinqingitemid>0
--and t1.fisyinqing='1'
order by t4.fnumber,t1.fisyinqing desc,t3.fnumber

--找不到引擎的单独作为引擎

select t3.fnumber 产品编码,t3.fname 产品名称,t3.fmodel 产品型号,isnull(t1.fbomnumber,'') BOM编号
,isnull(t5.fnumber,'') 半产品编码,isnull(t5.fname,'') 半产品名称,isnull(t5.fmodel,'') 半产品型号
,isnull(t8.fnumber,'') 芯片编码,isnull(t8.fname,'') 芯片名称,isnull(t8.fmodel,'') 芯片型号
from t_icitem t3 
left join icbom t1 on t1.fitemid=t3.fitemid
left join 
(
	select t1.finterid,t5.fitemid
	from icbom t1
	inner join icbomchild t2 on t1.finterid=t2.finterid
	inner join t_icitem t5 on t5.fitemid=t2.fitemid 
	where left(t5.fnumber,1) in ('3','4','5','7','8')
) t4 on t4.finterid=t1.finterid
left join t_icitem t5 on t5.fitemid=t4.fitemid
left join 
(
	select t1.finterid,t5.fitemid
	from icbom t1
	inner join icbomchild t2 on t1.finterid=t2.finterid
	inner join t_icitem t5 on t5.fitemid=t2.fitemid 
	where left(t5.fnumber,9) in ('1.01.0010')
) t7 on t7.finterid=t1.finterid
left join t_icitem t8 on t8.fitemid=t7.fitemid
--and t3.fshortnumber in ('A00057','A00058')
where (left(t3.fnumber,4) in ('a.01','p.01','j.01','x.01','y.01') or left(t3.fnumber,1) in ('v'))
and isnull(t3.F_126,0)<>40019 and isnull(t3.F_127,0)=0
and t3.fname not like '%禁用%' and isnull(t3.ftypeid,0)<>40127
order by t3.fnumber



drop table #data

set nocount off



----------------------------------------------------------------------------------------------------------------------


--引擎有问题
select t1.fnumber 编码,t1.fname 名称,t1.fmodel 规格型号,
isnull(t11.fnumber,'') 引擎编码,t11.fname 引擎名称,t11.fmodel 引擎规格型号
--select distinct t1.fitemid into #data
from t_icitem t1 
inner join t_ICItemCustom t3 on t1.fitemid=t3.fitemid
left join t_submessage t4 on t1.f_128=t4.finterid
inner join t_icitem t11 on t11.fitemid=t1.f_127  --引擎
left join t_submessage t12 on t12.finterid=t1.f_126
inner join icbom t13 on t13.fitemid=t1.fitemid
inner join icbom t14 on t14.fitemid=t11.fitemid
WHERE (left(t1.fnumber,1) in ('a','p','j','x','y') or t1.fnumber like 'v.b.%') 
and isnull(t1.f_126,0)<>40019 and t1.fname not like '%禁用%' and t11.fname like '%禁用%'
order by t1.fnumber,t11.fnumber

--套装
select t1.fitemid into #data2
from
(
	select fitemid from
	(
		select t1.fitemid,t1.fnumber,t1.fname,t4.fitemid fbanitemid
		from t_icitem t1
		inner join icbom t2 on t1.fitemid=t2.fitemid
		inner join icbomchild t3 on t2.finterid=t3.finterid
		inner join t_icitem t4 on t3.fitemid=t4.fitemid
		where t1.fitemid in (select fitemid from #data) and t1.fname not like '%禁用%' and t1.fdeleted=0 
		and left(t1.fnumber,1) in ('v') and left(t4.fnumber,1) in ('3','4','5','7','8')
	) t1 group by t1.fitemid
	having count(1)>1
) t1 inner join t_ICItemCustom t12 on t1.fitemid=t12.fitemid
inner join t_icitem t3 on t3.fitemid=t1.fitemid

select t15.fnumber,t15.fname,t14.fnumber,t14.fname,t11.fnumber,t11.fname
--update t2 set flastmoddate='2016-04-13'
--update t12 set f_127=t1.fbaseitemid
from
(
	select t2.fitemid,min(t2.fbaseitemid) fbaseitemid
	from
	(
		select t1.fitemid,t2.fitemid fbaseitemid
		from
		(
			select fitemid,max(fbanitemid) fbanitemid,isnull(max(fxinitemid),0) fxinitemid from
			(
				select t1.fitemid,
				case when left(t4.fnumber,1) in ('3','4','5','7','8') then t4.fitemid else 0 end fbanitemid,
				case when left(t4.fnumber,10) in ('1.01.0010.') then t4.fitemid else 0 end fxinitemid
				from t_icitem t1
				inner join icbom t2 on t1.fitemid=t2.fitemid
				inner join icbomchild t3 on t2.finterid=t3.finterid
				inner join t_icitem t4 on t3.fitemid=t4.fitemid
				where t1.fitemid in (select fitemid from #data) 
				and t1.fitemid not in (select fitemid from #data2) 
				--and left(t1.fnumber,1) in (select fitemtype from v_myitemtype where ftype=0)
				--and t1.fname not like '%禁用%' and t1.fdeleted=0 
			) t1 group by t1.fitemid
		) t1 inner join
		(
			select fitemid,max(fbanitemid) fbanitemid,isnull(max(fxinitemid),0) fxinitemid from
			(
				select t1.fitemid,
				case when left(t4.fnumber,1) in ('3','4','5','7','8') then t4.fitemid else 0 end fbanitemid,
				case when left(t4.fnumber,10) in ('1.01.0010.') then t4.fitemid else 0 end fxinitemid
				from t_icitem t1
				inner join icbom t2 on t1.fitemid=t2.fitemid
				inner join icbomchild t3 on t2.finterid=t3.finterid
				inner join t_icitem t4 on t3.fitemid=t4.fitemid
				where t1.fname not like '%禁用%' and t1.fdeleted=0 and t1.fname not like '%专用%'
				and left(t1.fnumber,4) in ('A.01','P.01','J.01','X.01','Y.01') 
			) t1 group by t1.fitemid
		) t2 on t1.fbanitemid=t2.fbanitemid and t1.fxinitemid=t2.fxinitemid
	) t2 group by t2.fitemid
) t1 inner join t_icitem t14 on t14.fitemid=t1.fitemid
inner join t_icitem t15 on t15.fitemid=t1.fbaseitemid
inner join t_ICItemCustom t12 on t1.fitemid=t12.fitemid
inner join t_icitem t11 on t11.fitemid=t14.f_127  --引擎
inner join t_baseproperty t2 on t1.fitemid=t2.fitemid