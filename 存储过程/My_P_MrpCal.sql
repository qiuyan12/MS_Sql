set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go


--@fitemtype  100 全部 0 成品 1 半成品  2 常规物料 3 包材  @ftype 0 常规运算 1 按单运算
ALTER procedure [dbo].[My_P_MrpCal] (@fuserid int,@frunid int,@fbillno varchar(20),@fitemtype int)  --,@ftype int
 
as
set nocount on

--declare @fuserid int,@frunid int,@fbillno varchar(20),@fitemtype int select @fitemtype=2,@fbillno='',@fuserid=16394,@frunid=0  

if @frunid=0
	exec My_p_GetBillNo 50000002,'my_t_mrp',@frunid output, @fbillno output

declare @fdeptid int,@fitemid int,@fpqty decimal(24,2),@forderinterid int,@s varchar(8000),@forderbillno varchar(50)
declare @fqty decimal(24,4),@fplanqty decimal(24,4),@fstockqty decimal(24,4),@FWillInStockQty decimal(24,4),@FRoughNeedQty decimal(24,4)
declare @FCanUseStockQty decimal(24,4),@FNeedQty decimal(24,4),@fsourceinterid int,@fplandate datetime,@fentryid int
declare @fbegdate datetime,@fenddate datetime,@fneeddate datetime,@finvdate datetime,@fcaldate datetime,@FOrderBillLike varchar(120),@fsourceentryid int
declare @fsendenddate datetime,@iRunID int, @iYear int,@iPeriod int,@fpackoutstockinterid int,@i int,@fnumbermatch varchar(20)
declare @ficmointerid int,@fplancommitdate datetime,@FPrepareDays int

declare @FProductProspectDays int,@FHalfProductProspectDays int,@FProductPrepareDays int,@FHalfProductPrepareDays int
--产品期待日期 30天
select @FProductProspectDays=fvalue from t_SystemProfile where FCategory='IC' and fkey='FProductProspectDays' 
--半成品期待日期 30天
select @FHalfProductProspectDays=fvalue from t_SystemProfile where FCategory='IC' and fkey='FHalfProductProspectDays' 
--产品准备日期 3天
select @FProductPrepareDays=fvalue from t_SystemProfile where FCategory='IC' and fkey='FProductPrepareDays' 
--半成品准备日期 3天
select @FHalfProductPrepareDays=fvalue from t_SystemProfile where FCategory='IC' and fkey='FHalfProductPrepareDays' 

select @s='',@i=1

--生产任务单下达了才能排产，排产了才参与MRP运算；收料计划如果未排，则取采购订单的日期和数量，否则耦合性太强
--icmo fstatus 5 确认 0 计划 1,2 下达 3 结案  fmrp 11061 mps产生 1052 手工录入 11077 mrp产生 

--if exists(
--select t1.fbillno
--from icmo t1
--left join (select ficmointerid,sum(fqty) fqty from my_t_scheduledetail where fsourcetrantype=85 group by ficmointerid) t2 on t1.finterid=t2.ficmointerid
--where t1.fstatus<>3 and (t1.finterid is null  or t1.fqty>isnull(t2.fqty,0)) )
--begin
--	select @s=@s+','+m1.fbillno from
--	(
--		select t1.fbillno
--		from icmo t1
--		left join (select ficmointerid,sum(fqty) fqty from my_t_scheduledetail where fsourcetrantype=85 group by ficmointerid) t2 on t1.finterid=t2.ficmointerid
--		where t1.fstatus<>3 and (t1.finterid is null  or t1.fqty>isnull(t2.fqty,0))
--	) m1
--
--	set @s='任务单['+@s+']还未生成生产计划!'  --排不完就排到最后一天--
--	RAISERROR(@s,18,18)
--end 

------暂时未查出什么原因
------投料单关联错误--1 单据内码
------select t0.fbillno,t1.ficmointerid,t1.fppbomentryid,t1.fitemid,t1.fqty fqty,t1.fsourceinterid,t1.fsourceentryid,t1.*
--update t1 set FEntrySelfZOU30=t1.fsourceinterid,FEntrySelfZOU31=t1.fsourceentryid
--from ZPStockBill t0 --
--inner join ZPStockBillEntry t1 on t0.finterid=t1.finterid  --
--inner join icmo t3 on t3.finterid=t1.FSourceInterId
--where t0.ftrantype=26 --and t0.fbillno='ZOUT000548' 
--and t1.fsourcetrantype in (85) and isnull(t1.FEntrySelfZOU30,0)=0 
--and isnull(t1.fsourceinterid,0)<>0 
----
------投料单关联错误--2 选单数
----select t3.FCheckDate,t3.fbillno,t4.fnumber,t4.fname,t4.fmodel,t1.fqty,isnull(t2.fqty,0) fselectqty

--删除7天前未加工的需求
Delete from My_t_MrpRoughNeedSource where frunid in (select frunid from my_t_Mrp where fdate<=Dateadd(day,-7,getdate()))
--删除7天前需求库存
Delete from My_t_MrpWillInStock where frunid in (select frunid from my_t_Mrp where fdate<=Dateadd(day,-7,getdate()))
--删除7天前结果明细
Delete from my_t_MrpResultDetail where frunid in (select frunid from my_t_Mrp where fdate<=Dateadd(day,-7,getdate()))
--删除7天前的MRP库存
Delete from My_t_MrpStock where frunid in (select frunid from my_t_Mrp where fdate<=Dateadd(day,-7,getdate()))
--删除7天前的结果总数
Delete from my_t_MrpResultSum where frunid in (select frunid from my_t_Mrp where fdate<=Dateadd(day,-7,getdate()))

--删除90天前的清单明细
delete from my_t_scheduledetail where fdate<=Dateadd(day,-90,getdate())

declare @finterid int,@fnumber varchar(50),@fname varchar(500)
declare @FParentNumber varchar(50),@FParentI D int,@FBootID int

--游标开始 查找ITEM 与 ICBomGroup 的关联关系 为空的记录？
--查找 t_item 的分类信息(在BomGroup中不存在),fdetail=0 说明改料号在BOM中属于分类明细,而非具体的BOM明细
DECLARE icbom_cursor CURSOR FOR	
select t1.fnumber,t1.fname 
from t_item t1
left join ICBomGroup t2 on t1.fnumber=t2.fnumber
where t1.fitemclassid=4 and left(t1.fnumber,1) in ('3','4','5','A','P','R','Q','J','X','Y','V') and t1.fdetail=0 
and t2.fnumber is null --查找关联条件 空
order by t1.fnumber

OPEN icbom_cursor

FETCH NEXT FROM icbom_cursor 
INTO @fnumber,@fname

WHILE @@FETCH_STATUS = 0
BEGIN 
	if not exists(select 1 from ICBomGroup where fnumber=@fnumber)
	begin
		set @finterid=0
		SELECT @finterid=isnull(FMaxNum,0) FROM ICMaxNum WHERE FTableName='ICBOMGroup'
		set @finterid=@finterid+1

		if CHARINDEX('.',@fnumber)=0
		begin
			select @FParentID=0,@FBootID=@finterid
		end
		else
		begin
			select @FParentNumber=REVERSE(right(REVERSE(@fnumber),len(@fnumber)-CHARINDEX('.',REVERSE(@fnumber))))
			select @FParentID=FInterID,@FBootID=finterid from ICBomGroup where fnumber=@FParentNumber
		end

		INSERT INTO ICBomGroup (FInterID, FNumber, FName, FParentID, FBootID) 
		VALUES (				@finterid,@fnumber,@fname,@FParentID,@FBootID)

		UPDATE ICMaxNum SET FMaxNum=@finterid WHERE FTableName='ICBOMGroup'
	end

	FETCH NEXT FROM icbom_cursor 
    INTO @fnumber,@fname
END

CLOSE icbom_cursor
DEALLOCATE icbom_cursor
--游标关闭 查找ITEM 与 ICBomGroup 的关联关系 为空的记录？

--ICBomGroup组别   为t_icitem表fparentid字段设置ICBomGroup的组边
update t2 set fparentid=t14.finterid
from t_icitem t1
inner join ICBom t2 on t1.fitemid=t2.fitemid
inner join t_item t13 on t1.FParentID=t13.fitemid
inner join ICBomGroup t14 on t14.fnumber=t13.fnumber
where t2.fparentid<>t14.finterid

update t1 set fqty=isnull(t2.fqty,0),fauxqty=isnull(t2.fqty,0)
from PPBOMEntry t1 --
left join 
(
	select t1.FEntrySelfZOU30 ficmointerid,t1.FEntrySelfZOU31 fppbomentryid,t1.fitemid,sum(t1.fqty) fqty
	from ZPStockBill t0 --
	inner join ZPStockBillEntry t1 on t0.finterid=t1.finterid  --
	inner join icmo t3 on t3.finterid=t1.FEntrySelfZOU30
	where t0.ftrantype=26 and t1.fsourcetrantype in (85,200000014)
	group by t1.FEntrySelfZOU30,t1.FEntrySelfZOU31,t1.fitemid
	union all
	select t1.ficmointerid,t1.fppbomentryid,t1.fitemid,sum(t1.fqty) fqty
	from ICStockBill t0 --
	inner join ICStockBillEntry t1 on t0.finterid=t1.finterid  --
	inner join icmo t3 on t3.finterid=t1.ficmointerid
	where t0.ftrantype=24 and t1.fsourcetrantype in (85,200000014)
	group by t1.ficmointerid,t1.fppbomentryid,t1.fitemid
) t2 on t1.ficmointerid=t2.ficmointerid and t1.FEntryID=t2.fppbomentryid and t1.fitemid=t2.fitemid
inner join icmo t3 on t1.ficmointerid=t3.finterid
inner join t_icitem t4 on t1.fitemid=t4.fitemid 
where t3.fstatus<>3 and t1.fqty<>isnull(t2.fqty,0) and t3.fbillno like '%'
--
------投料单关联错误--3 领料数
--select t3.FCheckDate,t3.fbillno,t4.fnumber,t4.fname,t4.fmodel,t1.fstockqty,isnull(t2.fqty,0) fselectqty
update t1 set fstockqty=isnull(t2.fqty,0),fauxstockqty=isnull(t2.fqty,0)
from PPBOMEntry t1 --
left join 
(
	select t1.FEntrySelfZOU30 ficmointerid,t1.FEntrySelfZOU31 fppbomentryid,t1.fitemid,sum(t1.fqty) fqty
	from ZPStockBill t0 --
	inner join ZPStockBillEntry t1 on t0.finterid=t1.finterid  --
	inner join icmo t3 on t3.finterid=t1.FEntrySelfZOU30
	where t0.ftrantype=26 and t1.fsourcetrantype in (85,200000014) and t0.fstatus>0
	group by t1.FEntrySelfZOU30,t1.FEntrySelfZOU31,t1.fitemid
	union all
	select t1.ficmointerid,t1.fppbomentryid,t1.fitemid,sum(t1.fqty) fqty
	from ICStockBill t0 --
	inner join ICStockBillEntry t1 on t0.finterid=t1.finterid  --
	inner join icmo t3 on t3.finterid=t1.ficmointerid
	where t0.ftrantype=24 and t1.fsourcetrantype in (85,200000014) and t0.fstatus>0
	group by t1.ficmointerid,t1.fppbomentryid,t1.fitemid
) t2 on t1.ficmointerid=t2.ficmointerid and t1.FEntryID=t2.fppbomentryid and t1.fitemid=t2.fitemid
inner join icmo t3 on t1.ficmointerid=t3.finterid
inner join t_icitem t4 on t1.fitemid=t4.fitemid
where t3.fstatus<>3 and t1.fstockqty<>isnull(t2.fqty,0) and t3.fbillno like '%'

--没有成本对象
update t1 set fcostobjid=t2.fitemid
from icmo t1
inner join cbcostobj t2 on t1.fitemid=t2.fstdproductid
where t1.fstatus<>3 and isnull(t1.fcostobjid,0)=0

--包材已经直接置入BOM
--if @fitemtype=3  --前台检查所选订单的包材需求在包装方案都齐备后计算--条件:已经下了生产任务单（但不是所有任务单都拿来计算,因为有些订单还没有配置包装方案）
--begin
--	select distinct t7.fbillno forderbillno,t8.finterid ficmointerid,t2.fnumber,isnull(t11.fid,0) fpacksubid
--	into #mosource
--	from seorderentry t1 
--	inner join seorder t7 on t1.finterid=t7.finterid
--	inner join t_icitem t2 on t1.fitemid=t2.fitemid 
--	inner join icmo t8 on t1.finterid=t8.forderinterid and t1.fentryid=t8.fsourceentryid
--	inner join t_item t9 on t9.fitemclassid=3002 and t9.fitemid=t1.fentryselfs0158
--	left join (select min(fid) fid,fproductid,fbrandid from t_BOSPackSub group by fproductid,fbrandid) t11 on t11.fproductid=t1.fitemid and t11.fbrandid=t1.fentryselfs0158  --包装方式
--	where t1.fmrpclosed<>1 --行业务未关闭
--	and t1.finterid in (select forderinterid from my_t_MrpSeOrder where frunid=@frunid and fselect=1) --去掉不参与运算的
--	--and (t7.fstatus>0 or isnull(t7.FMultiCheckLevel1,0)>0) --一审或者已经审核
--	and (t8.fqty>isnull(t8.fstockqty,0) and t8.fstatus in (1,2,5)) --未工的生产任务单
--	and t9.fname not like '%裸包%'

----	--非裸包但没有包装方案
----	if exists(select 1 from #mosource t1 where fpacksubid=0)
----	begin
----		select @s=@s+','+m1.fbillno from
----		(
----			select (t1.forderbillno+' | '+t1.fnumber) fbillno from #mosource t1 where fpacksubid=0
----		) m1
----
----		set @s='['+@s+']还没有包装方案!'  --
----		RAISERROR(@s,18,18)
----	end 

--	DECLARE Seorder_Cursor CURSOR FOR
--	select ficmointerid from #mosource group by ficmointerid

--	OPEN Seorder_Cursor

--	FETCH NEXT FROM Seorder_Cursor 
--	INTO @ficmointerid

--	WHILE @@FETCH_STATUS = 0
--	BEGIN
--		if not exists (select 1 from ppbomentry t1 inner join t_icitem t2 on t1.fitemid=t2.fitemid 
--					   where t1.ficmointerid=@ficmointerid and (t1.fqty>0 or isnull(t1.folditemid,0)<>0) and t1.FEntrySelfY0259=3)  --如果投料单已经有包材,则不重新生成，防止用户有修改过标准投料单又被清除
--		begin
--			exec My_P_AddOrEditPPBom @fuserid,@ficmointerid,3
--		end

--		FETCH NEXT FROM Seorder_Cursor
--		INTO @ficmointerid
--	END

--	CLOSE Seorder_Cursor
--	DEALLOCATE Seorder_Cursor

--	drop table #mosource
--end

/*
update m2 set fstatus=3
--select distinct m4.fbillno
from icmo m2 
inner join seorderentry m1 on m2.forderinterid=m1.finterid and m2.fsourceentryid=m1.fentryid
inner join seorder m4 on m4.finterid=m1.finterid
where (m1.fmrpclosed=1 or m2.fstockqty>=m2.fqty) and m2.fstatus<>3
*/

--获取运算码--改为前台获取
--declare @iMaxRunID int
--if exists(select 1 from my_t_Mrp)
--  select @iMaxRunID=max(frunid)+1 from my_t_Mrp 
--else
--  set @iMaxRunID=100*10+1
--
--set @frunid=@iMaxRunID

--select dateadd(day,15,getdate()),datediff(day,getdate(),'2012-12-29')

declare @fdate datetime
select @fdate=replace(convert(varchar(10),getdate(),111),'/','-')  --制单日期

--保存运算信息
if not exists(select 1 from my_t_Mrp where frunid=@frunid)
begin
	insert into my_t_Mrp(ftrantype, fbillno, frunid, fuserid, fbilltime,fdate) 
	values(              @fitemtype,@fbillno,@frunid,@fuserid,getdate(),@fdate)
end

----成品展望期内需求数
--insert into My_t_MrpRoughNeedSource(fneeddate,ficmointerid,ftrantype,frunid, forderinterid,forderentryid,fitemid,   fchilditemid,   forderqty,finqty, fqty,fchildmustqty,    fchildoutqty, fchildqty)
--select						        t6.fdate, t5.finterid, 0,        @frunid,0,            0,            t8.fitemid,t4.fitemid,     0,        0,      0,   t3.fmustqty,      t3.fstockqty, t3.fmustqty-t3.fstockqty
--from my_t_scheduledetail t6 
--inner join icmo t5 on t6.ficmointerid=t5.finterid
--inner join ppbom t2 on t5.finterid=t2.ficmointerid
--inner join ppbomentry t3 on t2.finterid=t3.finterid
--inner join t_icitem t4 on t3.fitemid=t4.fitemid --子项
--inner join t_icitem t8 on t5.fitemid=t8.fitemid --父项
--inner join t_SubMessage t13 on t13.finterid=t4.f_114 and t13.ftypeid=10004  --仓管员
--inner join t_SubMessage t17 on t17.finterid=t4.f_115 and t17.ftypeid=10003  --倒冲
--where t5.fstatus in (1,2) and (t3.fqtymust-t3.fstockqty)>0  --
--and isnull(t5.forderinterid,0)<>0 and datediff(day,getdate(),t6.fdate)=30  --成品展望期30天
----and t5.fqty>t5.fstockqty  --如何保证入库的是已经领了料的????????????????

create table #data(fitemid int,fnumber varchar(50),fplancommitdate datetime,fqty decimal(24,4),fsourceinterid int,
fsourceentryid int,fauxqtyscrap decimal(24,4),fscrap decimal(24,4),FPrepareDays int)

--投料单未发数--生产任务单中 成品是30天 半成品是15天
insert into #data(fnumber,fplancommitdate,fqty,fsourceinterid,fsourceentryid,fitemid,fauxqtyscrap,fscrap,FPrepareDays)
select t4.fnumber,t5.fplancommitdate,(t3.fqtymust-t3.fstockqty) fqty,
t5.finterid fsourceinterid,0 fsourceentryid,t3.fitemid,t3.fauxqtyscrap,t3.fscrap,
@FProductPrepareDays FPrepareDays  --成品直接下级则取成品的准备期，否则则取半成品的准备期
from icmo t5 
inner join ppbom t2 on t5.finterid=t2.ficmointerid
inner join ppbomentry t3 on t2.finterid=t3.finterid
inner join t_icitem t4 on t3.fitemid=t4.fitemid --子项
inner join t_icitem t8 on t5.fitemid=t8.fitemid --父项
inner join seorderentry t1 on t1.finterid=t5.forderinterid and t1.fentryid=t5.fsourceentryid
inner join seorder t6 on t6.finterid=t1.finterid
where t5.fstatus in (1,2,5) and (t3.fqtymust-t3.fstockqty)>0 
--and datediff(day,getdate(),t1.fdate)<=@FProductProspectDays  --成品展望期30天 
and t6.FHeadSelfS0148<>'1900-01-01' and t6.FHeadSelfS0148<>'2100-01-01'  --交期确定了以后才参与运算
union all
select t4.fnumber,t5.fplancommitdate,(t3.fqtymust-t3.fstockqty) fqty,
t5.finterid fsourceinterid,0 fsourceentryid,t3.fitemid,t3.fauxqtyscrap,t3.fscrap,
@FHalfProductPrepareDays FPrepareDays  --成品直接下级则取成品的准备期，否则则取半成品的准备期
from icmo t5 
inner join ppbom t2 on t5.finterid=t2.ficmointerid
inner join ppbomentry t3 on t2.finterid=t3.finterid
inner join t_icitem t4 on t3.fitemid=t4.fitemid --子项
inner join t_icitem t8 on t5.fitemid=t8.fitemid --父项
where t5.fstatus in (1,2,5) and (t3.fqtymust-t3.fstockqty)>0 and isnull(t5.forderinterid,0)=0 --半成品

--@fitemtype  100 全部 0 成品 1 半成品  2 常规物料 3 包材 4 芯片
if @fitemtype=1
	delete from #data where left(fnumber,1) not in ('7','8') -- (select fitemtype from v_MyItemType where ftype=1)  --3.  4. 前缀物料编码为半成品
else if @fitemtype=3
begin
	delete from #data where fnumber not like '2.%'   --2. 前缀物料编码为包材

	delete t1
	from #data t1
	inner join t_icitem t2 on t1.fitemid=t2.fitemid
	inner join t_stock t3 on t2.fdefaultloc=t3.fitemid
	where t3.ftypeid=503 --代管仓
end
else if @fitemtype=2
	delete from #data where left(fnumber,1) in (select fitemtype from v_MyItemType where ftype in(1,3))

--性能比较慢,先汇总不到明细
insert into My_t_MrpRoughNeedSource(fneeddate,      ftrantype,frunid, fsourceinterid,   fsourceentryid,   fitemid,   fqty)
select                              fplancommitdate,85,       @frunid,t2.fsourceinterid,t2.fsourceentryid,t2.fitemid,t2.fqty
from #data t2

------按生产计划分摊到日需求中
--DECLARE Seorder_Cursor CURSOR FOR
--select sum(fqty) fqty,fitemid,fsourceinterid 
--from #data 
--group by fitemid,fsourceinterid
--
--OPEN Seorder_Cursor
--
--FETCH NEXT FROM Seorder_Cursor 
--INTO @fqty,@fitemid,@fsourceinterid
--
--WHILE @@FETCH_STATUS = 0
--BEGIN
--	DECLARE SeorderEntry_Cursor CURSOR FOR
--	select Dateadd(day,-t2.FPrepareDays,t6.fdate) fplandate,t6.fqty*t2.fauxqtyscrap*(1+t2.fscrap/100) fqty
--	from #data t2  
--	inner join my_t_scheduledetail t6 on t6.ficmointerid=t2.fsourceinterid  
--	where t2.fsourceinterid=@fsourceinterid and t2.fitemid=@fitemid and t6.fdate>=@fdate  --今天开始计起
--	order by t6.fdate
--
--	OPEN SeorderEntry_Cursor
--
--	FETCH NEXT FROM SeorderEntry_Cursor 
--	INTO @fplandate,@fplanqty
--
--	WHILE @@FETCH_STATUS = 0 and @fqty>0  --
--	BEGIN
--		if @fplanqty>=@fqty  --当天该物料的需求数大于未发数(余数)
--		begin
--			set @fplanqty=@fqty
--			set @fqty=0
--		end
--		else
--		begin
--			set @fqty=@fqty-@fplanqty
--		end	
--		
--		insert into My_t_MrpRoughNeedSource(fneeddate, ftrantype,frunid, fsourceinterid,  fsourceentryid,  fitemid,  fqty)
--		select                              @fplandate,85,       @frunid,@fsourceinterid, 0,               @fitemid, @fplanqty
--	
--		FETCH NEXT FROM SeorderEntry_Cursor 
--		INTO @fplandate,@fplanqty
--	end
--
--	--可能出现当天或当天以后没有生产计划，有余数的话也放在今天的需求中
--	if @fqty>0 --如果还有剩余数则放在今天的需求中--如果当天以前领多了，则没有剩余数，表示最后一天不用领那么多；如果当天以前领少了，则有剩余数，即欠数，表示今天应领出来，否则影响生产；
--	begin
--		insert into My_t_MrpRoughNeedSource(fneeddate, ftrantype,frunid, fsourceinterid,  fsourceentryid,  fitemid,  fqty)
--		select                              @fdate,    85,       @frunid,@fsourceinterid, 0,               @fitemid, @fqty
--	end
--
--	CLOSE SeorderEntry_Cursor
--	DEALLOCATE SeorderEntry_Cursor
--
--    FETCH NEXT FROM Seorder_Cursor
--    INTO @fqty,@fitemid,@fsourceinterid
--END
--
--CLOSE Seorder_Cursor
--DEALLOCATE Seorder_Cursor  


----还没有下任务单的计划投料单--不参与分摊，直接插入--先屏蔽
--insert into My_t_MrpRoughNeedSource(fneeddate,      ftrantype,frunid, fsourceinterid,  fsourceentryid,  fitemid,   fqty)
--select Dateadd(day,-@FProductPrepareDays,t4.fdate), 81,       @frunid,t4.finterid,     t4.fentryid,     t3.fitemid,t1.fqty-isnull(t1.fcommitqty,0)
----select	t3.fnumber,t4.fdate fplancommitdate,(t1.fqty-isnull(t1.fcommitqty,0)) fqty,
----t4.finterid fsourceinterid,t4.fentryid fsourceentryid,t3.fitemid,t1.fbomqty fauxqtyscrap,0 fscrap,
----@FProductPrepareDays FPrepareDays
--from seorderentry t4 
--inner join seorder t5  on t5.finterid=t4.finterid
--inner join t_icitem t8 on t8.fitemid=t4.fitemid
--inner join t_Organization t6 on t5.FCustID=t6.fitemid
--inner join t_BOSPlanChangeStockEntry t1 on t4.finterid=t1.FID_SRC and t4.fentryid=t1.FEntryID_SRC
--inner join t_BOSPlanChangeStock t2 on t2.fid=t1.fid 
--inner join t_icitem t3 on t3.fitemid=t1.fitemid
--inner join t_department t11 on t11.fitemid=t5.fdeptid
--where t4.fmrpclosed<>1 and isnull(t1.fmrpclosed,0)<>40019 
----and (isnull(t5.fstatus,0)>0 or isnull(t5.FMultiCheckLevel1,0)>0) 
--and not exists (select 1 from icmo where forderinterid=t5.finterid) --and t5.finterid not in (select forderinterid from icmo) --不能写成这样!!!
--and (t1.fqty-isnull(t1.fcommitqty,0))>0 

--毛需求--随单出货外购件
insert into My_t_MrpRoughNeedSource(fneeddate,                                   ftrantype,frunid, fsourceinterid,fsourceentryid,fitemid,   fqty   )
select	                            Dateadd(day,-@FProductPrepareDays,t4.fdate), 81,       @frunid,t4.finterid,   t4.fentryid,   t4.fitemid,t4.fqty-isnull(t4.fstockqty,0)
from seorderentry t4 
inner join seorder t5  on t5.finterid=t4.finterid
inner join t_icitem t8 on t8.fitemid=t4.fitemid
inner join t_Organization t6 on t5.FCustID=t6.fitemid
inner join t_department t11 on t11.fitemid=t5.fdeptid
where t8.ferpclsid=1 and t4.fmrpclosed<>1 and (t5.fstatus>0 or isnull(t5.FMultiCheckLevel1,0)>0) --and t5.fdate>='2011-07-01'
--and 
--(
--	datediff(day,getdate(),t4.fdate)=@FProductProspectDays  --成品30天
--	or exists(select 1 from t_BOSPlanChangeStockEntry where FID_SRC=t4.finterid)  --有计划投料单的表示已经模拟
--) 
--and t5.finterid in (select t2.forderinterid from my_t_mrp t1 inner join my_t_mrpseorder t2 on t1.frunid=t2.frunid where t2.fselect=1)
and t4.fqty>t4.fstockqty

--if exists(select 1 from my_t_MrpSeOrder where frunid=@frunid)  --按单MRP运算  --只要计算过的都要考虑
--begin
--	delete from My_t_MrpRoughNeedSource where fitemid not in 
--	(
--		select t1.fitemid
--  		from My_t_MrpRoughNeedSource t1
--		inner join icmo t2 on t1.fsourceinterid=t2.finterid
--		where t1.frunid=@frunid and t1.ftrantype=85 and t2.forderinterid in (select forderinterid from my_t_MrpSeOrder where frunid=@frunid)
--		union all
--		select t1.fitemid
--		from My_t_MrpRoughNeedSource t1
--		where t1.frunid=@frunid and t1.ftrantype=81 and t1.fsourceinterid in (select forderinterid from my_t_MrpSeOrder where frunid=@frunid)
--	)
--end
	
	
--@fitemtype  100 全部 0 成品 1 半成品  2 常规物料 3 包材
if @fitemtype=1
begin
	delete t1 from My_t_MrpRoughNeedSource t1 inner join t_icitem t2 on t1.fitemid=t2.fitemid 
	where t1.frunid=@frunid and left(t2.fnumber,1) not in ('7','8') -- (select fitemtype from v_MyItemType where ftype=1) --3.  4. 前缀物料编码为半成品
end	
else if @fitemtype=3
begin
	delete t1 from My_t_MrpRoughNeedSource t1 inner join t_icitem t2 on t1.fitemid=t2.fitemid 
	where t1.frunid=@frunid and t2.fnumber not like '2.%'   --2. 前缀物料编码为常规物料
end		
else if @fitemtype=2
begin
	delete t1 from My_t_MrpRoughNeedSource t1 inner join t_icitem t2 on t1.fitemid=t2.fitemid 
	where t1.frunid=@frunid and left(t2.fnumber,1) in (select fitemtype from v_MyItemType where ftype in(1,3))
end

----关联任务单未审核的生产领料单
--insert into My_t_MrpRoughNeedSource(fneeddate,ficmointerid,ftrantype,frunid, forderinterid,forderentryid,fitemid,   fchilditemid,   forderqty,finqty, fqty,fchildmustqty,fchildoutqty, fchildqty)
--select						        t2.fdate, t5.finterid, 0,        @frunid,0,            0,            t8.fitemid,t4.fitemid,     0,        0,      0,   t3.fqty,      0,            t3.fqty
--from icmo t5 
--inner join icstockbillentry t3 on t5.finterid=t3.ficmointerid
--inner join icstockbill t2 on t2.finterid=t3.finterid
--inner join t_icitem t4 on t3.fitemid=t4.fitemid
--inner join t_icitem t8 on t5.fitemid=t8.fitemid
--inner join t_SubMessage t13 on t13.finterid=t4.f_114 and t13.ftypeid=10004  --仓管员
--inner join t_SubMessage t17 on t17.finterid=t4.f_115 and t17.ftypeid=10003  --倒冲
--where t2.ftrantype=24 and t2.fstatus in (0) 



--预计入库--要把未收料的数量循环分摊到收料计划中
/*
select                          @frunid,71,       t2.finterid,t2.fentryid,t2.fitemid,t2.fqty,  t2.fcommitqty,t2.fqty-t2.fcommitqty
from poorder t1
inner join poorderentry t2 on  t1.finterid=t2.finterid
inner join t_icitem t3 on t2.fitemid=t3.fitemid
inner join t_department t4 on t1.fdeptid=t4.fitemid
where --t1.FClosed<>1 
t2.fmrpclosed<>1 
--and t4.fnumber not like '08.11.%' --and t1.fstatus>0 
and t1.fstatus<>3  --采购订单收料完毕就关闭，但不一定已经入库
and t3.ferpclsid in (1) 
--and (t3.fnumber like 'H.%' or t3.fnumber like 'K.%' or t3.fnumber like 'M.%' or t3.fnumber like 'N.%')
and (t2.fqty-t2.fcommitqty)>0
and t2.fitemid in (select fchilditemid from My_t_MrpRoughNeedSource where frunid=@frunid)
*/

--收料计划分摊--生产任务单一定有生产计划，而采购订单可能还没有收料计划
select t2.fdate fplancommitdate,(t2.fqty-t2.fcommitqty) fqty,
t2.finterid fsourceinterid,t2.fentryid fsourceentryid,t2.fitemid
into #temp
from poorderentry t2  
inner join poorder t1 on t1.finterid=t2.finterid
inner join t_icitem t3 on t2.fitemid=t3.fitemid
inner join t_department t4 on t1.fdeptid=t4.fitemid
where --t1.FClosed<>1 
t2.fmrpclosed<>1 
--and t4.fnumber not like '08.11.%' --and t1.fstatus>0 
and t1.fstatus<>3  --采购订单收料完毕就关闭，但不一定已经入库
and t3.ferpclsid in (1) 
--and (t3.fnumber like 'H.%' or t3.fnumber like 'K.%' or t3.fnumber like 'M.%' or t3.fnumber like 'N.%')
and (t2.fqty-t2.fcommitqty)>0
and t2.fitemid in (select fitemid from My_t_MrpRoughNeedSource where frunid=@frunid)

--性能比较慢,先汇总不到明细
insert into My_t_MrpWillInStock(frunid, ftrantype,finterid,         fentryid,         fitemid,   fqty ,  fdate     )
select                          @frunid,71,       t2.fsourceinterid,t2.fsourceentryid,t2.fitemid,t2.fqty,t2.fplancommitdate
from #temp t2

--DECLARE Seorder_Cursor CURSOR FOR
--select fqty,fitemid,fsourceinterid,fsourceentryid,fplancommitdate 
--from #temp 
--
--OPEN Seorder_Cursor
--
--FETCH NEXT FROM Seorder_Cursor 
--INTO @fqty,@fitemid,@fsourceinterid,@fsourceentryid,@fplancommitdate
--
--WHILE @@FETCH_STATUS = 0
--BEGIN
--	set @fplandate=null
--
--	DECLARE SeorderEntry_Cursor CURSOR FOR
--	select t2.fdate,t2.fqty
--	from my_t_scheduledetail t2  
--	where t2.fsourceinterid=@fsourceinterid and t2.fsourceentryid=@fsourceentryid 
--	and t2.fitemid=@fitemid and t2.fdate>=@fdate  --今天开始计起 
--	order by t2.fdate
--
--	OPEN SeorderEntry_Cursor
--
--	FETCH NEXT FROM SeorderEntry_Cursor 
--	INTO @fplandate,@fplanqty
--
--	WHILE @@FETCH_STATUS = 0 and @fqty>0  --
--	BEGIN
--		if @fplanqty>=@fqty
--		begin
--			set @fplanqty=@fqty
--			set @fqty=0
--		end
--		else
--		begin
--			set @fqty=@fqty-@fplanqty
--		end	
--		
--		insert into My_t_MrpWillInStock(fdate,     frunid, ftrantype,finterid,       fentryid,       fitemid,   fqty)
--		select                          @fplandate,@frunid,71,       @fsourceinterid,@fsourceentryid,@fitemid,  @fplanqty
--	
--		FETCH NEXT FROM SeorderEntry_Cursor 
--		INTO @fplandate,@fplanqty
--	end
--
--	if @fqty>0 --如果还有剩余数则放在最后一天的计划--如果当天以前收多了，则没有剩余数，表示最后一天不用收那么多；如果当天以前收少了，则有剩余数；
--	begin
--		insert into My_t_MrpWillInStock(frunid, ftrantype,finterid,       fentryid,       fitemid,   fqty ,fdate     )
--		select                          @frunid,71,       @fsourceinterid,@fsourceentryid,@fitemid,  @fqty,isnull(@fplandate,@fplancommitdate)/*如果没有当天或当天以后没有收料计划，则取订单收料日期*/
--	end
--
--	CLOSE SeorderEntry_Cursor
--	DEALLOCATE SeorderEntry_Cursor
--
--    FETCH NEXT FROM Seorder_Cursor
--    INTO @fqty,@fitemid,@fsourceinterid,@fsourceentryid,@fplancommitdate
--END
--
--CLOSE Seorder_Cursor
--DEALLOCATE Seorder_Cursor

--预计入库--(采购申请单--未关闭--未关联数)--逻辑检查未关闭则中断MRP运算，因为采购申请单的到货日期是未确认的--此处开放为订单模拟时候用
insert into My_t_MrpWillInStock(fdate,        frunid, ftrantype,finterid,   fentryid,   fitemid,   fqty)
select                          t2.FFetchTime,@frunid,70,       t2.finterid,t2.fentryid,t2.fitemid,t2.fqty-t2.fcommitqty
from porequest t1
inner join porequestentry t2 on t1.finterid=t2.finterid
inner join t_icitem t3 on t2.fitemid=t3.fitemid
inner join t_department t4 on t1.fdeptid=t4.fitemid
where --t1.fstatus>0 and 
t1.fstatus<>3 and isnull(t2.fmrpclosed,0)<>1
--and t4.fnumber not like '08.11.%'
and t3.ferpclsid in (1)
--and (t3.fnumber like 'H.%' or t3.fnumber like 'K.%' or t3.fnumber like 'M.%' or t3.fnumber like 'N.%')
and (t2.fqty-t2.fcommitqty)>0 
and t2.fitemid in (select fitemid from My_t_MrpRoughNeedSource where frunid=@frunid)

--预计入库(未审核的外购入库单)
insert into My_t_MrpWillInStock(fdate,   frunid, ftrantype,finterid,   fentryid,   fitemid,   fqty)
select                          t1.fdate,@frunid,1,        t2.finterid,t2.fentryid,t2.fitemid,t2.fqty
from icstockbill t1
inner join icstockbillentry t2 on t1.finterid=t2.finterid
inner join t_icitem t3 on t2.fitemid=t3.fitemid
inner join t_department t4 on t1.fdeptid=t4.fitemid
where t1.fstatus=0 and t2.FSourceTranType=72 
--and t4.fnumber not like '08.11.%'
and t2.fitemid in (select fitemid from My_t_MrpRoughNeedSource where frunid=@frunid) and t1.ftrantype=1

--预计入库(收料通知单--未关闭--未关联数)
insert into My_t_MrpWillInStock(fdate,   frunid,  ftrantype,  finterid,   fentryid,   fitemid,   fqty)
select                          t1.fdate,@frunid, 72,         t2.finterid,t2.fentryid,t2.fitemid,t2.fqty-t2.fcommitqty-t2.fbackqty
from poinstock t1
inner join poinstockentry t2 on t1.finterid=t2.finterid
inner join t_icitem t3 on t2.fitemid=t3.fitemid
inner join t_department t4 on t1.fdeptid=t4.fitemid
where t1.fstatus<>3 --已经审核的才纳入????
and t2.fqty>(t2.fcommitqty+t2.fbackqty)
--and t4.fnumber not like '08.11.%'
and t2.fitemid in (select fitemid from My_t_MrpRoughNeedSource where frunid=@frunid) and t1.ftrantype=72

--预计入库(塑胶子件收料申请单--未关闭--未关联数)
insert into My_t_MrpWillInStock(fdate,   frunid,  ftrantype,  finterid,fentryid,   fitemid,   fqty)
select                          t1.fdate,@frunid, 200000022,  t2.fid,  t2.fentryid,t2.fitemid,t2.fqty-t2.fcommitqty
from t_BOSPlasticPoInStock t1 
inner join t_BOSPlasticPoInStockEntry t2 on t1.fid=t2.fid
inner join t_icitem t3 on t2.fitemid=t3.fitemid
inner join poorderentry t7 on t7.finterid=t2.fid_src and t7.fentryid=t2.fentryid_src 
--inner join t_department t4 on t1.fdeptid=t4.fitemid
where t7.FMrpClosed<>1 
and isnull(t2.fmrpclosed,0)<>40019 --and t1.fstatus>0 
and (t2.fqty-t2.fcommitqty)>0
and t2.fitemid in (select fitemid from My_t_MrpRoughNeedSource where frunid=@frunid) --and t1.FClassTypeID=200000022


/*
--预计入库--预测订单
insert into My_t_MrpWillInStock(frunid, ftrantype,finterid,   fentryid,   fitemid,   forderqty,finqty,                       fqty)
select                          @frunid,87,       t2.finterid,t2.fentryid,t2.fitemid,t2.fqty,  isnull(t2.FEntrySelfY0121,0), t2.fqty-isnull(t2.FEntrySelfY0121,0)
from pporder t1
inner join pporderentry t2 on t1.finterid=t2.finterid
inner join t_icitem t3 on t2.fitemid=t3.fitemid
--inner join t_department t4 on t1.FHeadSelfY0121=t4.fitemid
where t2.forderclosed<>1 and t1.fstatus>0 and t1.fstatus<>3
and (t2.fqty-isnull(t2.FEntrySelfY0121,0))>0
--and t4.fnumber not like '08.11.%'
and t2.fitemid in (select fchilditemid from My_t_MrpRoughNeedSource where frunid=@frunid)
*/

--预计入库--任务单--
--要把未入库的数量循环分摊到生产计划中!!!!!!!!!!!!!!!!!!!!!!!!!!!!
/*
insert into My_t_MrpWillInStock(fneedate,frunid, ftrantype,finterid,   fentryid,   fitemid,   forderqty,finqty,                     fqty)
select                          @frunid,85,       t2.finterid,0,          t2.fitemid,t2.fqty,  isnull(t2.fstockqty,0),     t2.fqty-isnull(t2.fstockqty,0)
from icmo t2 
inner join t_icitem t3 on t2.fitemid=t3.fitemid
inner join t_department t4 on t2.fworkshop=t4.fitemid
where t2.fstatus>0 and t2.fstatus<>3
and (t2.fqty-isnull(t2.fstockqty,0))>0
--and t4.fnumber not like '08.11.%'
and t2.fitemid in (select fchilditemid from My_t_MrpRoughNeedSource where frunid=@frunid)
*/

select t2.fplancommitdate,(t2.fqty-t2.fstockqty) fqty,t2.finterid fsourceinterid,0 fsourceentryid,t2.fitemid
into #source
from icmo t2  
inner join t_icitem t3 on t2.fitemid=t3.fitemid
inner join t_department t4 on t2.fworkshop=t4.fitemid
where t2.fstatus<>3
and (t2.fqty-isnull(t2.fstockqty,0))>0
and t2.fitemid in (select fitemid from My_t_MrpRoughNeedSource where frunid=@frunid)

--性能比较慢,先汇总不到明细
insert into My_t_MrpWillInStock(fdate,             frunid, ftrantype,finterid,         fentryid,         fitemid,   fqty)
select                          t2.fplancommitdate,@frunid,85,       t2.fsourceinterid,t2.fsourceentryid,t2.fitemid,t2.fqty
from #source t2

--DECLARE Seorder_Cursor CURSOR FOR
--select fqty,fitemid,fsourceinterid from #source 
--
--OPEN Seorder_Cursor
--
--FETCH NEXT FROM Seorder_Cursor 
--INTO @fqty,@fitemid,@fsourceinterid
--
--WHILE @@FETCH_STATUS = 0
--BEGIN
--	set @fplandate=null
--
--	DECLARE SeorderEntry_Cursor CURSOR FOR
--	select t2.fdate,t2.fqty
--	from my_t_scheduledetail t2  
--	where t2.ficmointerid=@fsourceinterid and t2.fitemid=@fitemid and t2.fdate>=@fdate  --今天开始计起
--	order by t2.fdate
--
--	OPEN SeorderEntry_Cursor
--
--	FETCH NEXT FROM SeorderEntry_Cursor 
--	INTO @fplandate,@fplanqty
--
--	WHILE @@FETCH_STATUS = 0 and @fqty>0
--	BEGIN
--		if @fplanqty>=@fqty
--		begin
--			set @fplanqty=@fqty
--			set @fqty=0
--		end
--		else
--		begin
--			set @fqty=@fqty-@fplanqty
--		end	
--		
--		insert into My_t_MrpWillInStock(fdate,     frunid, ftrantype,finterid,       fentryid,       fitemid,   fqty)
--		select                          @fplandate,@frunid,85,       @fsourceinterid,@fsourceentryid,@fitemid,  @fplanqty
--	
--		FETCH NEXT FROM SeorderEntry_Cursor 
--		INTO @fplandate,@fplanqty
--	end
--
--	if @fqty>0 --生产任务单一定有生产计划,如果还有剩余数表示当天以前还有计划未执行
--	begin
--		insert into My_t_MrpWillInStock(frunid, ftrantype,finterid,       fentryid,       fitemid,   fqty, fdate)
--		select                          @frunid,85,       @fsourceinterid,@fsourceentryid,@fitemid,  @fqty,isnull(@fplandate,@fdate)--当天或当天以后还有计划，则放在最后一天，没有则放在当天
--	end
--
--	CLOSE SeorderEntry_Cursor
--	DEALLOCATE SeorderEntry_Cursor
--
--    FETCH NEXT FROM Seorder_Cursor
--    INTO @fqty,@fitemid,@fsourceinterid
--END
--
--CLOSE Seorder_Cursor
--DEALLOCATE Seorder_Cursor

--库存 根据实际库存插入 My_t_MrpStock,其实就是MPS 库存
insert into My_t_MrpStock(frunid,fitemid,fstockid,fqty)
select @frunid,t1.fitemid,t1.fstockid,t1.fqty
from icinventory t1
inner join t_ICItem t2 on t1.FItemID=t2.FItemID
inner join t_stock t3 on t3.fitemid=t1.fstockid
where --t2.ferpclsid in (1) and 
t1.fqty>0 --and t3.fname not like '%计划%' 
and t3.fname not like '%不良%' and t3.fname not like '%报废%'
--and t3.fnumber not like '11.%' 
--and (t2.fnumber like 'H.%' or t2.fnumber like 'K.%' or t2.fnumber like 'M.%' or t2.fnumber like 'N.%')
and t2.fitemid in (select fitemid from My_t_MrpRoughNeedSource where frunid=@frunid)

insert into My_t_MrpStock(frunid,fitemid,fstockid,fqty)
select @frunid,t1.fitemid,t1.fstockid,t1.fqty
from poinventory t1
inner join t_ICItem t2 on t1.FItemID=t2.FItemID
inner join t_stock t3 on t3.fitemid=t1.fstockid
where --t2.ferpclsid in (1) and 
t1.fqty>0 --and t3.fname not like '%计划%' 
and t3.fname not like '%不良%' and t3.fname not like '%报废%' and t3.fitemid=16483  --代管仓
--and t3.fnumber not like '11.%' 
--and (t2.fnumber like 'H.%' or t2.fnumber like 'K.%' or t2.fnumber like 'M.%' or t2.fnumber like 'N.%')
and t2.fitemid in (select fitemid from My_t_MrpRoughNeedSource where frunid=@frunid)

--select * from ictranstype  select * from t_stock

--半成品只取展望期内的需求
--if @fitemtype=1
--begin
--	delete t1
--	from My_t_MrpRoughNeedSource t1 
--	inner join t_icitem t2 on t1.fitemid=t2.fitemid
--	where t1.frunid=@frunid and datediff(day,getdate(),t1.fneeddate)>@FHalfProductProspectDays  --半成品展望期30天
--
--	delete t1
--	from My_t_MrpWillInStock t1 
--	inner join t_icitem t2 on t1.fitemid=t2.fitemid
--	where t1.frunid=@frunid and datediff(day,getdate(),t1.fdate)>@FHalfProductProspectDays  --半成品展望期30天
--end
 
--汇总--毛需求-预计入库-库存=净需求
select (select min(fneeddate) from My_t_MrpRoughNeedSource where frunid=@frunid and fitemid=t2.fitemid) fneeddate,
t2.fitemid,t3.fitemid funitid,0 fcyid,0 fsupid,0 fempid,
cast (0 as decimal(24,5)) fprice,t1.FRoughNeedQty,t1.FWillInStockQty,t1.FStockQty,
(t1.FRoughNeedQty-t1.FWillInStockQty-t1.FStockQty) FNeedQty, 
isnull(t2.fbatchappendqty,0) fbatchappendqty,isnull(t2.fqtymin,0) fqtymin,isnull(t2.fsecinv,0) fsecinvqty,
0 FTempdNeedQty,0 FActNeedQty,0 FModQty,cast('' as varchar(50)) fremark
into #MyMrpResultSum
from
(
	select fitemid,isnull(sum(FRoughNeedQty),0) FRoughNeedQty,isnull(sum(FWillInStockQty),0) FWillInStockQty,
	isnull(sum(FStockQty),0) FStockQty --ftype 0 毛需求 1 预计入库 2 库存
	from
	(
		select fitemid,(case when ftype=0 then fqty else 0 end) FRoughNeedQty, 
		(case when ftype=1 then fqty else 0 end) FWillInStockQty,
		(case when ftype=2 then fqty else 0 end) FStockQty
		from 
		(
			select t1.fitemid,isnull(sum(t1.fqty),0) fqty,0 ftype
			from My_t_MrpRoughNeedSource t1 where frunid=@frunid group by t1.fitemid
			union all
			select t1.fitemid,isnull(sum(t1.fqty),0) fqty,1 ftype
			from My_t_MrpWillInStock t1 where frunid=@frunid group by t1.fitemid
			union all
			select t1.fitemid,isnull(sum(t1.fqty),0) fqty,2 ftype
			from My_t_MrpStock t1 where frunid=@frunid group by t1.fitemid
		) t1
	) t1 group by fitemid
) t1 inner join t_icitem t2 on t1.fitemid=t2.fitemid
inner join t_measureunit t3 on t2.funitid=t3.fitemid
--where t2.fitemid=6736--t2.ferpclsid in (2)--t2.fhelpcode='39213'


--顺序: 净需求+安全库存=>净需求=>最小订货量=>批量增量
update t1 set FTempdNeedQty=
(case when (fneedqty+fsecinvqty)<fqtymin then fqtymin else (fneedqty+fsecinvqty) end),--考虑安全库存
FActNeedQty=
(case when (fneedqty+fsecinvqty)<fqtymin then fqtymin else (fneedqty+fsecinvqty) end)
from #MyMrpResultSum t1 
where fneedqty>0  --只有有需求的才考虑安全库存数

--保存结果--汇总
insert into my_t_MrpResultSum(fneeddate,frunid,fsupplyid,fcurrencyid,fempid,fprice, 
fitemid,FRoughNeedQty,FWillInStockQty,FStockQty,FNeedQty,fbatchappendqty,fqtymin,fsecinvqty,FActNeedQty,fqty)
select fneeddate,@frunid,isnull(fsupid,0),isnull(fcyid,0),isnull(fempid,0),isnull(fprice,0),fitemid,
FRoughNeedQty,FWillInStockQty,FStockQty,FNeedQty,fbatchappendqty,fqtymin,fsecinvqty,
--(case when t1.FNeedQty<100 and t1.FNeedQty>0 and t1.fqtymin>=1000 then 100 else t1.FActNeedQty end) FActNeedQty,--非合理订货数
--(case when t1.FNeedQty<100 and t1.FNeedQty>0 and t1.fqtymin>=1000 then 100 else t1.FActNeedQty end) FQty
FActNeedQty,FActNeedQty
from #MyMrpResultSum t1 --where fneedqty>0 

create table #MyMrpResultDetail(fneeddate datetime,fitemid int,funitid int,FRoughNeedQty decimal(24,4),
FWillInStockQty decimal(24,4),FCanUseStockQty decimal(24,4),FNeedQty decimal(24,4))

--净需求具体到天
--select * into #sourcedata
--from 
--(
--	select t1.fneeddate,t1.fitemid,sum(t1.fqty) fqty,0 ftype
--	from My_t_MrpRoughNeedSource t1 where frunid=@frunid group by t1.fneeddate,t1.fitemid
--	union all
--	select t1.fdate fneeddate,t1.fitemid,sum(t1.fqty) fqty,1 ftype
--	from My_t_MrpWillInStock t1 where frunid=@frunid group by t1.fdate,t1.fitemid
--	union all
--	select '2100-01-01' fneeddate,t1.fitemid,sum(t1.fqty) fqty,2 ftype
--	from My_t_MrpStock t1 where frunid=@frunid group by t1.fitemid
--) t1

select fitemid,fneeddate,isnull(sum(FRoughNeedQty),0) FRoughNeedQty,isnull(sum(FWillInStockQty),0) FWillInStockQty 
into #sourcedata --ftype 0 毛需求 1 预计入库 2 库存
from
(
	select fitemid,fneeddate,(case when ftype=0 then fqty else 0 end) FRoughNeedQty, 
	(case when ftype=1 then fqty else 0 end) FWillInStockQty,
	(case when ftype=2 then fqty else 0 end) FStockQty
	from 
	(
		select t1.fneeddate,t1.fitemid,isnull(sum(t1.fqty),0) fqty,0 ftype
		from My_t_MrpRoughNeedSource t1 where frunid=@frunid group by t1.fneeddate,t1.fitemid
		union all
		select t1.fdate fneeddate,t1.fitemid,isnull(sum(t1.fqty),0) fqty,1 ftype
		from My_t_MrpWillInStock t1 where frunid=@frunid group by t1.fdate,t1.fitemid
	) t1
) t1 group by fitemid,fneeddate

set @fentryid=0

declare @fminid int,@fmaxid int,@fentryminid int,@fentrymaxid int
create table #Cursor(FID int identity(1,1),fentryid int,fitemid int,FStockQty decimal(24,2))
create table #CursorEntry(FID int identity(1,1),fneeddate datetime,FRoughNeedQty decimal(24,2),FWillInStockQty decimal(24,2))

truncate table #Cursor
insert into #Cursor(fitemid,fstockqty,fentryid)
select t2.fitemid,isnull(max(t1.fstockqty),0) fstockqty,1 fentryid
from #sourcedata t2
left join 			
(
	select t1.fitemid,isnull(sum(t1.fqty),0) fstockqty
	from My_t_MrpStock t1 where frunid=@frunid group by t1.fitemid
) t1 on t1.fitemid=t2.fitemid
group by t2.fitemid

--OPEN icbom_cursor
--
--FETCH NEXT FROM icbom_cursor 
--INTO @fdeptid

select @fminid=0,@fmaxid=0
select @fminid=isnull(min(fid),0),@fmaxid=isnull(max(fid),0) from #Cursor

--DECLARE Seorder_Cursor CURSOR FOR
--select t2.fitemid,isnull(max(t1.fstockqty),0) fstockqty,1 fentryid
--from #sourcedata t2
--left join 			
--(
--	select t1.fitemid,isnull(sum(t1.fqty),0) fstockqty
--	from My_t_MrpStock t1 where frunid=@frunid group by t1.fitemid
--) t1 on t1.fitemid=t2.fitemid
--group by t2.fitemid
--
--OPEN Seorder_Cursor
--
--FETCH NEXT FROM Seorder_Cursor 
--INTO @fitemid,@FStockQty,@fentryid

WHILE @fmaxid>0 and @fminid<=@fmaxid --@@FETCH_STATUS = 0
BEGIN 
	select @fitemid=fitemid,@FStockQty=FStockQty,@fentryid=fentryid from #Cursor where fid=@fminid

--	DECLARE SeorderEntry_Cursor CURSOR FOR
--	select t2.fneeddate,t2.FRoughNeedQty,t2.FWillInStockQty
--	from #sourcedata t2
--	where t2.fitemid=@fitemid 
--	order by t2.fneeddate
--
--	OPEN SeorderEntry_Cursor
--
--	FETCH NEXT FROM SeorderEntry_Cursor 
--	INTO @fneeddate,@FRoughNeedQty,@FWillInStockQty

	truncate table #CursorEntry
	insert into #CursorEntry(fneeddate,FRoughNeedQty,FWillInStockQty)
	select t2.fneeddate,t2.FRoughNeedQty,t2.FWillInStockQty
	from #sourcedata t2	where t2.fitemid=@fitemid order by t2.fneeddate

	select @fentryminid=0,@fentrymaxid=0
	select @fentryminid=isnull(min(fid),0),@fentrymaxid=isnull(max(fid),0) from #CursorEntry

	WHILE @fentrymaxid>0 and @fentryminid<=@fentrymaxid --@@FETCH_STATUS = 0
	BEGIN 
		select @fneeddate=fneeddate,@FRoughNeedQty=FRoughNeedQty,@FWillInStockQty=FWillInStockQty from #CursorEntry where fid=@fentryminid

		if @fentryid=1
			set @FCanUseStockQty=@fstockqty  --库存在第一次循环的时候才纳入

		set @fentryid=@fentryid+1

		set @FCanUseStockQty=@FWillInStockQty+@FCanUseStockQty-@FRoughNeedQty  --可用库存

		if @FCanUseStockQty>=0
			set @FNeedQty=0--净需求
		else
		begin
			set @FNeedQty=-@FCanUseStockQty
			set @FCanUseStockQty=0
		end

		insert into #MyMrpResultDetail(fitemid, fneeddate, FWillInStockQty, FCanUseStockQty, FRoughNeedQty, FNeedQty)
								values(@fitemid,@fneeddate,@FWillInStockQty,@FCanUseStockQty,@FRoughNeedQty,@FNeedQty)

		--update t1 set fqty=@fqty from #MyMrpResultTemp t1 where fneeddate=@fneeddate and fitemid=@fitemid

		set @fentryminid=@fentryminid+1

--		FETCH NEXT FROM SeorderEntry_Cursor 
--		INTO @fneeddate,@FRoughNeedQty,@FWillInStockQty
	end

	set @fminid=@fminid+1
--	CLOSE SeorderEntry_Cursor
--	DEALLOCATE SeorderEntry_Cursor
--
--    FETCH NEXT FROM Seorder_Cursor
--    INTO @fitemid,@FStockQty,@fentryid
END

--CLOSE Seorder_Cursor
--DEALLOCATE Seorder_Cursor

/*
update t1 set FModQty=FTempdNeedQty%fbatchappendqty from #MyMrpResultTemp t1 where fneedqty>0

update t1 set FActNeedQty=FTempdNeedQty+(fbatchappendqty-FModQty) 
from #MyMrpResultTemp t1 where fneedqty>0 and FModQty>0
*/

--保存结果--明细
--delete from my_t_MrpResultDetail where fhscount=@fhscount  --update my_t_MrpResultDetail set fremark=''

insert into my_t_MrpResultDetail(fneeddate,frunid,fitemid,FRoughNeedQty,FWillInStockQty,FCanUseStockQty,FNeedQty)
select '1900-01-01' fneeddate,@frunid,t1.fitemid,0,0,isnull(sum(t1.fqty),0) fqty,0
from My_t_MrpStock t1 where frunid=@frunid group by t1.fitemid
union all
select t1.fneeddate,@frunid,t1.fitemid,t1.FRoughNeedQty,t1.FWillInStockQty,t1.FCanUseStockQty,t1.FNeedQty 
--,t2.fbatchappendqty,t2.fqtymin,t2.fsecinvqty,
--(case when t1.FNeedQty<100 and t1.FNeedQty>0 and t1.fqtymin>=1000 then 100 else t1.FActNeedQty end) FActNeedQty,--非合理订货数
--(case when t1.FNeedQty<100 and t1.FNeedQty>0 and t1.fqtymin>=1000 then 100 else t1.FActNeedQty end) FQty
--FActNeedQty,FActNeedQty
from #MyMrpResultDetail t1 --where fneedqty>0 
inner join t_icitem t2 on t1.fitemid=t2.fitemid
inner join t_measureunit t3 on t2.funitid=t3.fitemid

--@fitemtype  100 全部 0 成品 1 半成品  2 常规物料 3 包材  --全部的时候要分开
if @fitemtype=100
begin
	declare @fsourcerunid int
	set @fsourcerunid=@frunid

	--半成品
	if exists (select 1 from My_t_MrpRoughNeedSource t1 inner join t_icitem t2 on t1.fitemid=t2.fitemid 
	           where t1.frunid=@fsourcerunid and left(t2.fnumber,1) in (select fitemtype from v_MyItemType where ftype=1))  --3.  4. 前缀物料编码为半成品
	begin
		update t1 set ftrantype=1 from my_t_Mrp t1 where frunid=@fsourcerunid
	end	

	--常规物料
	if exists (select 1 from My_t_MrpRoughNeedSource t1 inner join t_icitem t2 on t1.fitemid=t2.fitemid 
	           where t1.frunid=@fsourcerunid and left(t2.fnumber,1) not in (select fitemtype from v_MyItemType where ftype in(1,3)))
	begin
		exec My_p_GetBillNo 50000002,'my_t_mrp',@frunid output, @fbillno output

		insert into my_t_Mrp(ftrantype, fbillno, frunid, fuserid, fbilltime,fdate) 
		values(              2,         @fbillno,@frunid,@fuserid,getdate(),@fdate)

		insert into my_t_MrpSeOrder(frunid, forderinterid,fselect,ftype) 
		select            distinct  @frunid,forderinterid,fselect,ftype 
		from my_t_MrpSeOrder 
		where frunid=@fsourcerunid

		update t1 set frunid=@frunid
		from My_t_MrpRoughNeedSource t1 
		inner join t_icitem t2 on t1.fitemid=t2.fitemid 
		where t1.frunid=@fsourcerunid and (left(t2.fnumber,1) not in (select fitemtype from v_MyItemType where ftype in(1,3)))  

		update t1 set frunid=@frunid
		from My_t_MrpStock t1 
		inner join t_icitem t2 on t1.fitemid=t2.fitemid 
		where t1.frunid=@fsourcerunid and (left(t2.fnumber,1) not in (select fitemtype from v_MyItemType where ftype in(1,3)))  

		update t1 set frunid=@frunid
		from My_t_MrpWillInStock t1 
		inner join t_icitem t2 on t1.fitemid=t2.fitemid 
		where t1.frunid=@fsourcerunid and (left(t2.fnumber,1) not in (select fitemtype from v_MyItemType where ftype in(1,3)))  

		update t1 set frunid=@frunid
		from my_t_MrpResultSum t1 
		inner join t_icitem t2 on t1.fitemid=t2.fitemid 
		where t1.frunid=@fsourcerunid and (left(t2.fnumber,1) not in (select fitemtype from v_MyItemType where ftype in(1,3)))  

		update t1 set frunid=@frunid
		from my_t_MrpResultDetail t1 
		inner join t_icitem t2 on t1.fitemid=t2.fitemid 
		where t1.frunid=@fsourcerunid and (left(t2.fnumber,1) not in (select fitemtype from v_MyItemType where ftype in(1,3)))  
	end	

	--包材
	if exists (select 1 from My_t_MrpRoughNeedSource t1 inner join t_icitem t2 on t1.fitemid=t2.fitemid where t1.frunid=@fsourcerunid and t2.fnumber like '2.%')  
	begin
		exec My_p_GetBillNo 50000002,'my_t_mrp',@frunid output, @fbillno output

		insert into my_t_Mrp(ftrantype, fbillno, frunid, fuserid, fbilltime,fdate) 
		values(              3,         @fbillno,@frunid,@fuserid,getdate(),@fdate)

		insert into my_t_MrpSeOrder(frunid, forderinterid,fselect,ftype) 
		select         distinct     @frunid,forderinterid,fselect,ftype 
		from my_t_MrpSeOrder 
		where frunid=@fsourcerunid

		update t1 set frunid=@frunid
		from My_t_MrpRoughNeedSource t1 
		inner join t_icitem t2 on t1.fitemid=t2.fitemid 
		where t1.frunid=@fsourcerunid and t2.fnumber like '2.%' 

		update t1 set frunid=@frunid
		from My_t_MrpStock t1 
		inner join t_icitem t2 on t1.fitemid=t2.fitemid 
		where t1.frunid=@fsourcerunid and t2.fnumber like '2.%' 

		update t1 set frunid=@frunid
		from My_t_MrpWillInStock t1 
		inner join t_icitem t2 on t1.fitemid=t2.fitemid 
		where t1.frunid=@fsourcerunid and t2.fnumber like '2.%' 

		update t1 set frunid=@frunid
		from my_t_MrpResultSum t1 
		inner join t_icitem t2 on t1.fitemid=t2.fitemid 
		where t1.frunid=@fsourcerunid and t2.fnumber like '2.%' 

		update t1 set frunid=@frunid
		from my_t_MrpResultDetail t1 
		inner join t_icitem t2 on t1.fitemid=t2.fitemid 
		where t1.frunid=@fsourcerunid and t2.fnumber like '2.%' 
	end	
end

--select * from my_t_MrpResultDetail

drop table #temp
drop table #source
drop table #data
drop table #MyMrpResultSum
drop table #MyMrpResultDetail
drop table #sourcedata

set nocount off


