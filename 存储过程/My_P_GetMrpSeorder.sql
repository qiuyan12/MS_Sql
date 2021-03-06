set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go


ALTER procedure [dbo].[My_P_GetMrpSeorder](@fitemtype int)  --0 成品 1 半成品 2 常规物料 3 包材

as

set nocount on 

create table #data(finterid int,fselect bit default 1)
 
--常规物料和半成品都是直接抓取任务单未发料数作为毛需求,所以不用选订单

if @fitemtype=0  --成品
begin
	insert into #data(finterid)  --没有生成生产任务单的订单
	select distinct t7.finterid
	from seorderentry t1 
	inner join seorder t7 on t1.finterid=t7.finterid
	inner join t_icitem t2 on t1.fitemid=t2.fitemid 
	left join (select forderinterid,fsourceentryid,sum(fqty) fqty from icmo t1 group by forderinterid,fsourceentryid) t8 on t1.finterid=t8.forderinterid and t1.fentryid=t8.fsourceentryid
	where t7.FCancellation=0 and t1.fmrpclosed<>1 --行业务未关闭
	and (t7.fstatus>0 or isnull(t7.FMultiCheckLevel1,0)>0) --一审或者已经审核
	and (t1.fqty>isnull(t8.fqty,0)) --未完全生成生产任务单
	--and (t2.fnumber like 'A.%' or t2.fnumber like 'P.%') 
	and t2.ferpclsid=2 --and t7.fbillno not in ('xw1304008')
	--and isnull(t7.FHeadSelfS0147,0) not in (40032,40033) --40032	样品订单-收费 40033	样品订单-免费

	update t2 set fselect=0  --BOM没有做/未审核/未使用
	from
	(
		select distinct t2.finterid
		from seorder t1  
		inner join seorderentry t2 on t1.finterid=t2.finterid
		inner join t_icitem t4 on t4.fitemid=t2.fitemid
		--inner join t_item t9 on t9.fitemclassid=3002 and t9.fitemid=t2.fentryselfs0158
		left join icbom t11 on t11.fitemid=t2.fitemid and t11.fusestatus=1072
		where t11.finterid is null
	) t1 inner join #data t2 on t1.finterid=t2.finterid
	
	/*
	update t3 set fselect=0  --未配置交付方式
	from seorderentry t1 
	inner join seorder t7 on t1.finterid=t7.finterid
	inner join t_icitem t2 on t1.fitemid=t2.fitemid 
	inner join #data t3 on t3.finterid=t1.finterid
	where /*表体的条件才加*/
	t1.fmrpclosed<>1 --行业务未关闭
	--and (t1.fqty>isnull(t8.fqty,0)) --未完全生成生产任务单
	and (t2.fnumber like 'A.%' or t2.fnumber like 'P.%') 
	and isnull(t1.FEntrySelfS0175,0)=0 --40089	自产自包,40090	外调自包,40091	外调外包
	and t2.ferpclsid=2 

	update t4 set fselect=0  --未生成采购订单
	from seorderentry t1 
	inner join seorder t7 on t1.finterid=t7.finterid
	inner join t_icitem t2 on t1.fitemid=t2.fitemid 
	inner join #data t4 on t4.finterid=t1.finterid
	left join poorderentry t3 on t3.fsourceinterid=t1.finterid and t3.fsourceentryid=t1.fentryid and t3.fsourcetrantype=81
	where t1.fmrpclosed<>1 --行业务未关闭
	--and (t1.fqty>isnull(t8.fqty,0)) --未完全生成生产任务单
	and t3.finterid is null 
	and (t2.fnumber like 'A.%' or t2.fnumber like 'P.%') 
	and isnull(t1.FEntrySelfS0175,0) in (40090,40091) --40089	自产自包,40090	外调自包,40091	外调外包
	and t2.ferpclsid=2

	update t2 set fselect=0  --没有配置半成品或芯片
	from
	(
		select distinct t2.finterid
		from seorder t1  
		inner join seorderentry t2 on t1.finterid=t2.finterid
		inner join t_icitem t4 on t4.fitemid=t2.fitemid
		left join t_icitem t9 on t9.fitemid=t2.fentryselfs0164  --半成品
		left join t_icitem t10 on t10.fitemid=t2.fentryselfs0161  --芯片
		left join t_item t13 on t13.fitemid=t2.fentryselfs0160 and t13.fitemclassid=3006 --芯片版本  --16465  无芯片
		where t2.fmrpclosed<>1 --行业务未关闭
		and (left(t4.fnumber,1) in ('A','P') and t4.ferpclsid=2 and isnull(t9.fitemid,0)=0) 
		or (isnull(t13.fitemid,0)<>16465 and isnull(t10.fitemid,0)=0)
	) t1 inner join #data t2 on t1.finterid=t2.finterid
	*/
end

if @fitemtype=3 --包材
begin
	insert into #data(finterid)  --已经生成生产任务单的订单
	select distinct t7.finterid
	from seorderentry t1 
	inner join seorder t7 on t1.finterid=t7.finterid
	inner join t_icitem t2 on t1.fitemid=t2.fitemid 
	inner join (select forderinterid,fsourceentryid,sum(fqty) fqty from icmo t1 group by forderinterid,fsourceentryid) t8 on t1.finterid=t8.forderinterid and t1.fentryid=t8.fsourceentryid
	where t7.FCancellation=0 and t1.fmrpclosed<>1 --行业务未关闭
	and (t7.fstatus>0 or isnull(t7.FMultiCheckLevel1,0)>0) --一审或者已经审核
	--and (t1.fqty>isnull(t8.fqty,0)) --未完全生成生产任务单
	and (left(t2.fnumber,1) in (select fitemtype from v_MyItemType where ftype=0)) 
	and t2.ferpclsid=2 --and t7.fbillno not in ('xw1304008')
	--and isnull(t7.FHeadSelfS0147,0) not in (40032,40033) --40032	样品订单-收费 40033	样品订单-免费
	and t7.finterid not in (select t2.forderinterid from my_t_mrp t1 inner join my_t_mrpseorder t2 on t1.frunid=t2.frunid where t1.ftrantype=3 and t2.fselect=1)  --已经计算过包材的就不给选择了

	insert into #data(finterid)  --直接买包材
	select distinct t7.finterid
	from seorderentry t1 
	inner join seorder t7 on t1.finterid=t7.finterid
	inner join t_icitem t2 on t1.fitemid=t2.fitemid 
	where t7.FCancellation=0 and t1.fmrpclosed<>1 --行业务未关闭
	and (t7.fstatus>0 or isnull(t7.FMultiCheckLevel1,0)>0) --一审或者已经审核
	--and (t1.fqty>isnull(t8.fqty,0)) --未完全生成生产任务单
	and t2.fnumber like '2.%' 
	and t2.ferpclsid=1 --and t7.fbillno not in ('xw1304008')
	--and isnull(t7.FHeadSelfS0147,0) not in (40032,40033) --40032	样品订单-收费 40033	样品订单-免费
	and t7.finterid not in (select t2.forderinterid from my_t_mrp t1 inner join my_t_mrpseorder t2 on t1.frunid=t2.frunid where t1.ftrantype=3 and t2.fselect=1)  --已经计算过包材的就不给选择了

	/*
	update t2 set fselect=0  --没有做包装方案或包装方案未审核
	from
	(
		select distinct t2.finterid
		from seorder t1  
		inner join seorderentry t2 on t1.finterid=t2.finterid
		inner join t_icitem t4 on t4.fitemid=t2.fitemid
		inner join t_item t9 on t9.fitemclassid=3002 and t9.fitemid=t2.fentryselfs0158
		left join t_BOSPackSub t11 on t11.fproductid=t2.fitemid and t11.fbrandid=t2.fentryselfs0158  --包装方式
		where t9.fname not like '%裸包%' and (isnull(t11.fid,0)=0 or isnull(t11.FChecker,0)=0 )
	) t1 inner join #data t2 on t1.finterid=t2.finterid
	*/
end

select t3.fselect 选择,t2.fbillno 单据编号,t2.FHeadSelfS0144 源销售订单号,t2.FHeadSelfS0143 源采购订单号,
t7.fnumber 客户编码,t7.fname 客户名称,t2.finterid 单据内码,t4.fname 制单人,t2.fdate 制单日期,
(select max(fdate) from seorderentry where finterid=t2.finterid) 订单交期  
from seorder t2  
inner join t_user t4 on t4.fuserid=t2.fbillerid  
left join t_Organization t7 on t7.fitemid=t2.fcustid  
inner join t_department t1 on t1.fitemid=t2.fdeptid   
inner join #data t3 on t2.finterid=t3.finterid
--where t2.FHeadSelfS0148<>'1900-01-01' and t2.FHeadSelfS0148<>'2100-01-01'
order by t2.fdate desc   

drop table #data

set nocount off


