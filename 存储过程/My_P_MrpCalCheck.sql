set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go


ALTER procedure [dbo].[My_P_MrpCalCheck](@frunid int)  --

as

--declare @fitemtype int select @fitemtype=0

set nocount on 

declare @fitemtype int  --0 成品 1 半成品 2 常规物料 3 包材 

select @fitemtype=ftrantype from my_t_mrp where frunid=@frunid

create table #temp(ftype int,fsourcetrantype varchar(50),fsourcebillno varchar(20),
fsourceinterid int,fsourceentryid int,fitemid int,ferr varchar(1000))

--ftype 1 生产计划有未排数 2 采购申请单未关闭 3 收料计划有未排数 4 未配置半成品 5 未配置芯片 6 未做包装方案 7 未做BOM
declare @fdate datetime
select @fdate=replace(convert(varchar(10),getdate(),111),'/','-')  --制单日期

declare @FProductProspectDays int,@FHalfProductProspectDays int,@FProductPrepareDays int,@FHalfProductPrepareDays int

select @FProductProspectDays=fvalue from t_SystemProfile where FCategory='IC' and fkey='FProductProspectDays' 
select @FHalfProductProspectDays=fvalue from t_SystemProfile where FCategory='IC' and fkey='FHalfProductProspectDays' 
select @FProductPrepareDays=fvalue from t_SystemProfile where FCategory='IC' and fkey='FProductPrepareDays' 
select @FHalfProductPrepareDays=fvalue from t_SystemProfile where FCategory='IC' and fkey='FHalfProductPrepareDays' 
--

if @fitemtype=9999 --@fitemtype<>0  --先屏蔽
begin
	insert into #temp(ftype,fsourcetrantype,fsourcebillno,fsourceinterid,fsourceentryid,fitemid,   ferr)
	select            1,    '汇报单',       t2.fbillno,   t1.finterid,   0   ,          t1.fitemid,'汇报单未审核'
	from ICMORptEntry t1 
	inner join ICMORpt t2 on t1.finterid=t2.finterid
	where t2.fstatus=0 --and t2.fheadselfj1112<@fdate  

	--任务数与滚动计划数的平衡关系:任务数-当天以前的汇报数=当天和当天以后的计划数
	insert into #temp(ftype,fsourcetrantype,fsourcebillno,fsourceinterid,fsourceentryid,fitemid,   ferr)
	select            1,    '任务单',       t1.fbillno,   t1.finterid,   0   ,          t1.fitemid,'生产计划有未排数'
	from icmo t1
	left join 
	(
		select t1.fsourceinterid,sum(t1.FQtyFinish) FQtyFinish 
		from ICMORptEntry t1 
		inner join ICMORpt t2 on t1.finterid=t2.finterid
		where t2.fheadselfj1112<@fdate
		group by t1.fsourceinterid
	) t3 on t1.finterid=t3.fsourceinterid
	left join 
	(
		select ficmointerid,sum(fqty) fplanqty 
		from my_t_scheduledetail 
		where fsourcetrantype=85 and fdate>=@fdate
		group by ficmointerid
	) t2 on t1.finterid=t2.ficmointerid  
	where t1.fqty>isnull(t1.fstockqty,0) and t1.fstatus in (1,2,5) --未工的生产任务单
	and t1.fqty<>(isnull(t2.fplanqty,0)+isnull(t3.FQtyFinish,0))

	insert into #temp(ftype,fsourcetrantype,fsourcebillno,fsourceinterid,fsourceentryid,fitemid,   ferr)
	select            2,    '采购申请单',   t1.fbillno,   t2.finterid,   t2.fentryid,   t2.fitemid,'采购申请单未关闭'
	from porequest t1
	inner join porequestentry t2 on t1.finterid=t2.finterid
	inner join t_icitem t3 on t2.fitemid=t3.fitemid
	inner join t_department t4 on t1.fdeptid=t4.fitemid
	where --t1.fstatus>0 and 
	t1.fstatus<>3 and isnull(t2.fmrpclosed,0)<>1
	--and t4.fnumber not like '08.11.%'
	--and t3.ferpclsid in (1)
	--and (t3.fnumber like 'H.%' or t3.fnumber like 'K.%' or t3.fnumber like 'M.%' or t3.fnumber like 'N.%')
	and (t2.fqty-t2.fcommitqty)>0 

	insert into #temp(ftype,fsourcetrantype,fsourcebillno,fsourceinterid,fsourceentryid,fitemid,   ferr)
	select            3,    '采购订单',     t5.fbillno,   t1.finterid,   t1.fentryid,   t1.fitemid,'收料计划有未排数'
	from poorderentry t1
	inner join poorder t5 on t1.finterid=t5.finterid
	left join 
	(
		select t1.fsourceinterid,t1.fsourceentryid,sum(t1.fqty-t1.fbackqty) FQtyFinish 
		from poinstockentry t1 
		inner join poinstock t2 on t1.finterid=t2.finterid
		where t2.fdate<@fdate and t2.ftrantype=72--不审核的也纳入，因为以后将可以由收料计划下推生成收料通知单
		group by t1.fsourceinterid,t1.fsourceentryid
	) t3 on t1.finterid=t3.fsourceinterid and t1.fentryid=t3.fsourceentryid 
	left join 
	(
		select fsourceinterid,fsourceentryid,sum(fqty) fplanqty 
		from my_t_scheduledetail 
		where fsourcetrantype=71 and fdate>=@fdate
		group by fsourceinterid,fsourceentryid
	) t2 on t1.finterid=t2.fsourceinterid and t1.fentryid=t2.fsourceentryid  
	where t1.fqty>isnull(t1.fcommitqty,0) and t5.fstatus in (1,2,5) --未完成的采购订单
	and t1.fmrpclosed<>1 and t1.fqty<>(isnull(t2.fplanqty,0)+isnull(t3.FQtyFinish,0))

	if @fitemtype in (2,3) --2 常规物料 3 包材
	begin
		if @fitemtype=2
		begin
			--收料计划和采购申请单按类别检查
			delete t1
			from #temp t1
			inner join t_icitem t2 on t1.fitemid=t2.fitemid
			where t1.ftype in (2,3) and t2.fnumber like '2.%'  --
		end
		else
		begin
			--收料计划和采购申请单按类别检查
			delete t1
			from #temp t1
			inner join t_icitem t2 on t1.fitemid=t2.fitemid
			where t1.ftype in (2,3) and t2.fnumber not like '2.%'  --

			--生产计划按类别检查--包材只检查成品的任务单
			delete t1
			from #temp t1
			inner join t_icitem t2 on t1.fitemid=t2.fitemid
			inner join icmo t3 on t1.fsourceinterid=t3.finterid
			where t1.ftype in (1) and isnull(t3.forderinterid,0)=0
		end
	end
end

if @fitemtype=0  --半成品和芯片是通过订单配置出来的
begin
	insert into #temp(fsourcetrantype,fsourcebillno,fsourceinterid,fsourceentryid,fitemid,   ferr)
	select            '销售订单',     t7.fbillno,   t1.finterid,   t1.fentryid   ,t1.fitemid,'BOM未做/未审核/未使用'
	from seorderentry t1 
	inner join seorder t7 on t1.finterid=t7.finterid
	inner join t_icitem t2 on t1.fitemid=t2.fitemid 
	left join icbom t3 on t3.fitemid=t1.fitemid and t3.fusestatus=1072
	--left join (select forderinterid,fsourceentryid,sum(fqty) fqty from icmo t1 group by forderinterid,fsourceentryid) t8 on t1.finterid=t8.forderinterid and t1.fentryid=t8.fsourceentryid
	where --datediff(day,getdate(),t1.fdate)<=@FProductProspectDays  --成品展望期30天 
	t1.finterid in (select forderinterid from my_t_MrpSeOrder where frunid=@frunid and fselect=1) --去掉不参与运算的
	and t1.fmrpclosed<>1 --行业务未关闭
	and (t7.fstatus>0 or isnull(t7.FMultiCheckLevel1,0)>0) --一审或者已经审核
	--and (t1.fqty>isnull(t8.fqty,0)) --未完全生成生产任务单
	and left(t2.fnumber,1) in (select fitemtype from v_myitemtype where ftype=0)
	and t3.finterid is null
	--and isnull(t1.FEntrySelfS0175,0)=0 --40089	自产自包,40090	外调自包,40091	外调外包
	and t2.ferpclsid=2 --and t7.fbillno not in ('xw1304008')
	--and isnull(t7.FHeadSelfS0147,0) not in (40032,40033) --40032	样品订单-收费 40033	样品订单-免费

--	insert into #temp(fsourcetrantype,fsourcebillno,fsourceinterid,fsourceentryid,fitemid,   ferr)
--	select            '销售订单',     t7.fbillno,   t1.finterid,   t1.fentryid   ,t1.fitemid,'未配置交付方式'
--	from seorderentry t1 
--	inner join seorder t7 on t1.finterid=t7.finterid
--	inner join t_icitem t2 on t1.fitemid=t2.fitemid 
--	--left join (select forderinterid,fsourceentryid,sum(fqty) fqty from icmo t1 group by forderinterid,fsourceentryid) t8 on t1.finterid=t8.forderinterid and t1.fentryid=t8.fsourceentryid
--	where --datediff(day,getdate(),t1.fdate)<=@FProductProspectDays  --成品展望期30天 
--	t1.finterid in (select forderinterid from my_t_MrpSeOrder where frunid=@frunid and fselect=1) --去掉不参与运算的
--	and t1.fmrpclosed<>1 --行业务未关闭
--	and (t7.fstatus>0 or isnull(t7.FMultiCheckLevel1,0)>0) --一审或者已经审核
--	--and (t1.fqty>isnull(t8.fqty,0)) --未完全生成生产任务单
--	and (t2.fnumber like 'A.%' or t2.fnumber like 'P.%') 
--	and isnull(t1.FEntrySelfS0175,0)=0 --40089	自产自包,40090	外调自包,40091	外调外包
--	and t2.ferpclsid=2 --and t7.fbillno not in ('xw1304008')
--	and isnull(t7.FHeadSelfS0147,0) not in (40032,40033) --40032	样品订单-收费 40033	样品订单-免费

--	/*  --目前都是外调自包,这里先屏蔽,不然时间进度太慢
--	insert into #temp(fsourcetrantype,fsourcebillno,fsourceinterid,fsourceentryid,fitemid,   ferr)
--	select            '销售订单',     t7.fbillno,   t1.finterid,   t1.fentryid   ,t1.fitemid,'未生成采购订单'
--	from seorderentry t1 
--	inner join seorder t7 on t1.finterid=t7.finterid
--	inner join t_icitem t2 on t1.fitemid=t2.fitemid 
--	--left join (select forderinterid,fsourceentryid,sum(fqty) fqty from icmo t1 group by forderinterid,fsourceentryid) t8 on t1.finterid=t8.forderinterid and t1.fentryid=t8.fsourceentryid
--	left join poorderentry t3 on t3.fsourceinterid=t1.finterid and t3.fsourceentryid=t1.fentryid and t3.fsourcetrantype=81
--	where --datediff(day,getdate(),t1.fdate)<=@FProductProspectDays  --成品展望期30天 
--	t1.finterid in (select forderinterid from my_t_MrpSeOrder where frunid=@frunid and fselect=1) --去掉不参与运算的
--	and t1.fmrpclosed<>1 --行业务未关闭
--	and (t7.fstatus>0 or isnull(t7.FMultiCheckLevel1,0)>0) --一审或者已经审核
--	--and (t1.fqty>isnull(t8.fqty,0)) --未完全生成生产任务单
--	and t3.finterid is null 
--	and (t2.fnumber like 'A.%' or t2.fnumber like 'P.%') 
--	and isnull(t1.FEntrySelfS0175,0) in (40090,40091) --40089	自产自包,40090	外调自包,40091	外调外包
--	and t2.ferpclsid=2 --and t7.fbillno not in ('xw1304008')
--	and isnull(t7.FHeadSelfS0147,0) not in (40032,40033) --40032	样品订单-收费 40033	样品订单-免费
--	*/

--	insert into #temp(fsourcetrantype,fsourcebillno,fsourceinterid,fsourceentryid,fitemid,   ferr)
--	select            '销售订单',     t7.fbillno,   t1.finterid,   t1.fentryid   ,t1.fitemid,'未配置半成品'
--	from seorderentry t1 
--	inner join seorder t7 on t1.finterid=t7.finterid
--	inner join t_icitem t2 on t1.fitemid=t2.fitemid 
--	--left join (select forderinterid,fsourceentryid,sum(fqty) fqty from icmo t1 group by forderinterid,fsourceentryid) t8 on t1.finterid=t8.forderinterid and t1.fentryid=t8.fsourceentryid
--	left join t_icitem t9 on t9.fitemid=t1.fentryselfs0164  --半成品
--	where --datediff(day,getdate(),t1.fdate)<=@FProductProspectDays  --成品展望期30天 
--	t1.finterid in (select forderinterid from my_t_MrpSeOrder where frunid=@frunid and fselect=1) --去掉不参与运算的
--	and t1.fmrpclosed<>1 --行业务未关闭
--	and (t7.fstatus>0 or isnull(t7.FMultiCheckLevel1,0)>0) --一审或者已经审核
--	--and (t1.fqty>isnull(t8.fqty,0)) --未完全生成生产任务单
--	and (t2.fnumber like 'A.%' or t2.fnumber like 'P.%') 
--	and isnull(t1.FEntrySelfS0175,0) not in (40090,40091) --40089	自产自包,40090	外调自包,40091	外调外包
--	and t2.ferpclsid=2 and isnull(t9.fitemid,0)=0 --and t7.fbillno not in ('xw1304008')
--	and isnull(t7.FHeadSelfS0147,0) not in (40032,40033) --40032	样品订单-收费 40033	样品订单-免费

--	insert into #temp(fsourcetrantype,fsourcebillno,fsourceinterid,fsourceentryid,fitemid,   ferr)
--	select            '销售订单',     t7.fbillno,   t1.finterid,   t1.fentryid   ,t1.fitemid,'未配置芯片'
--	from seorderentry t1 
--	inner join seorder t7 on t1.finterid=t7.finterid
--	inner join t_icitem t2 on t1.fitemid=t2.fitemid 
--	--left join (select forderinterid,fsourceentryid,sum(fqty) fqty from icmo t1 group by forderinterid,fsourceentryid) t8 on t1.finterid=t8.forderinterid and t1.fentryid=t8.fsourceentryid
--	left join t_item t13 on t13.fitemid=t1.fentryselfs0160 and t13.fitemclassid=3006 --芯片版本  --16465  无芯片
--	left join t_icitem t10 on t10.fitemid=t1.fentryselfs0161  --芯片
--	where --datediff(day,getdate(),t1.fdate)<=@FProductProspectDays  --成品展望期30天 
--	t1.finterid in (select forderinterid from my_t_MrpSeOrder where frunid=@frunid and fselect=1) --去掉不参与运算的
--	and t1.fmrpclosed<>1 --行业务未关闭
--	and (t7.fstatus>0 or isnull(t7.FMultiCheckLevel1,0)>0) --一审或者已经审核
--	--and (t1.fqty>isnull(t8.fqty,0)) --未完全生成生产任务单
--	and (t2.fnumber like 'A.%' or t2.fnumber like 'P.%')  
--	and isnull(t1.FEntrySelfS0175,0) not in (40090,40091) --40089	自产自包,40090	外调自包,40091	外调外包
--	and isnull(t13.fitemid,0)<>16465 and isnull(t10.fitemid,0)=0 --and t7.fbillno not in ('xw1304008')
--	and isnull(t7.FHeadSelfS0147,0) not in (40032,40033) --40032	样品订单-收费 40033	样品订单-免费
end

--if @fitemtype in (3)
--begin
--	insert into #temp(fsourcetrantype,fsourcebillno,fsourceinterid,fsourceentryid,fitemid,   ferr)
--	select            '销售订单',     t7.fbillno,   t1.finterid,   t1.fentryid   ,t1.fitemid,(case when isnull(t11.fid,0)=0 then '未做包装方案' else '包装方案未审核' end)
--	from seorderentry t1 
--	inner join seorder t7 on t1.finterid=t7.finterid
--	inner join t_icitem t2 on t1.fitemid=t2.fitemid 
--	--inner join icmo t8 on t1.finterid=t8.forderinterid and t1.fentryid=t8.fsourceentryid
--	inner join t_item t9 on t9.fitemclassid=3002 and t9.fitemid=t1.fentryselfs0158
--	left join (select min(fid) fid,fproductid,fbrandid,min(fbillno) fbillno,min(FChecker) FChecker from t_BOSPackSub group by fproductid,fbrandid) t11 on t11.fproductid=t1.fitemid and t11.fbrandid=t1.fentryselfs0158  --包装方式
--	where --datediff(day,getdate(),t1.fdate)<=@FProductProspectDays  --成品展望期30天 
--	t1.finterid in (select forderinterid from my_t_MrpSeOrder where frunid=@frunid and fselect=1) --去掉不参与运算的
--	and t1.fmrpclosed<>1 --行业务未关闭
--	--and (t8.fqty>isnull(t8.fstockqty,0) and t8.fstatus in (1,2,5)) --未工的生产任务单
--	and t9.fname not like '%裸包%' and (isnull(t11.fid,0)=0 or isnull(t11.FChecker,0)=0 )
--	and isnull(t7.FHeadSelfS0147,0) not in (40032,40033) --40032	样品订单-收费 40033	样品订单-免费
--end

if @fitemtype in (1) --计算半成品需求时要导入K3生成任务单，所以要有BOM
begin
	insert into #temp(fsourcetrantype,fsourcebillno,fsourceinterid,fsourceentryid,fitemid,   ferr)
	select            '任务单',       t8.fbillno,   t8.finterid,   0   ,          t8.fitemid,(case when isnull(t11.finterid,0)=0 then '未做BOM' else 'BOM未使用' end)
	from icmo t8 
	left join icbom t11 on t11.fitemid=t8.fitemid 
	inner join t_icitem t1 on t1.fitemid=t8.fitemid
	where (t8.fqty>isnull(t8.fstockqty,0) and t8.fstatus in (1,2,5)) --未工的生产任务单
	and (isnull(t11.finterid,0)=0 or isnull(t11.fusestatus,0)<>1072 )
	and isnull(t8.forderinterid,0)=0  --暂时只控制半成品--因为成品有了BOM后才能进行配置，成品MRP运算的时候已经检查成品是否已经进行配置
end

select t1.fsourcetrantype 单据类型,t1.fsourceinterid 单据内码,t1.fsourcebillno 单据编号,t1.fsourceentryid 分录号,
t2.fnumber 物料编码,t2.fname 名称,t2.fmodel 规格型号,t1.ferr 备注
from #temp t1
inner join t_icitem t2 on t1.fitemid=t2.fitemid
order by t1.fsourcetrantype,t1.fsourcebillno,t1.fsourceentryid,t2.fnumber

drop table #temp

set nocount off


