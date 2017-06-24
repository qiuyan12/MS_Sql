
drop table #data

SELECT t1.fdate 出库日期,t6.fshortname 购货单位,t15.fname 产品分类,isnull(t14.fname,'') 打印机品牌,
t3.fnumber 产品编码,t3.fname 产品名称,t3.fmodel 规格型号,isnull(t3.f_105,'') 描述,t2.fqty 出库数量,
cast(t2.fprice as decimal(24,4)) 单位成本,t2.famount 成本,cast(t7.fstdamount/t2.fqty as decimal(24,4)) as 销售单价,t7.fstdamount as 销售金额,
(t7.fstdamount-t2.famount) 销售毛利,cast((t7.fstdamount-t2.famount)/t7.fstdamount*100 as decimal(24,4)) 毛利率
--into #data
from icstockbill t1
inner join icstockbillentry t2 on t1.finterid=t2.finterid
inner join t_icitem t3 on t2.fitemid=t3.fitemid
--left join seorderentry t4 on t2.forderinterid=t4.finterid and t2.forderentryid=t4.fentryid
--left join seorder t5 on t4.finterid=t5.finterid
inner join t_Organization t6 on t1.fsupplyid=t6.fitemid
inner join icsaleentry t7 on t2.finterid=t7.fsourceinterid and t2.fentryid=t7.fsourceentryid and t2.fitemid=t7.fitemid and t7.fsourcetrantype=21
inner join icsale t8 on t7.finterid=t8.finterid
left join t_SubMessage t14 on t14.finterid=t3.F_102  --打印机品牌
left join t_submessage t15 on t15.finterid=t3.ftypeid
where t1.ftrantype=21 AND t1.fdate>='2015-01-01' AND t1.fdate<='2015-05-31'
and t7.fstdamount>0 and t1.frob=1
order by t1.fdate

SELECT t1.fdate 出库日期,t6.fshortname 购货单位,t15.fname 产品分类,
t3.fnumber 产品编码,t3.fname 产品名称,t3.fmodel 规格型号,t2.fqty 出库数量,
cast(t2.fprice as decimal(24,4)) 单位成本,t2.famount 成本,cast(t7.fstdamount/t2.fqty as decimal(24,4)) as 销售单价,t7.fstdamount as 销售金额,
(t7.fstdamount-t2.famount) 销售毛利,cast((t7.fstdamount-t2.famount)/t7.fstdamount*100 as decimal(24,4)) 毛利率
--into #data
from icstockbill t1
inner join icstockbillentry t2 on t1.finterid=t2.finterid
inner join t_icitem t3 on t2.fitemid=t3.fitemid
--left join seorderentry t4 on t2.forderinterid=t4.finterid and t2.forderentryid=t4.fentryid
--left join seorder t5 on t4.finterid=t5.finterid
inner join t_Organization t6 on t1.fsupplyid=t6.fitemid
inner join icsaleentry t7 on t2.finterid=t7.fsourceinterid and t2.fentryid=t7.fsourceentryid and t2.fitemid=t7.fitemid and t7.fsourcetrantype=21
inner join icsale t8 on t7.finterid=t8.finterid
left join t_item t15 on t15.fnumber=left(t3.fnumber,1) and t15.fitemclassid=4 and t15.fdetail=0
where t1.ftrantype=21 AND t1.fdate>='2015-01-01' AND t1.fdate<='2015-05-31'
and t7.fstdamount>0 and t1.frob=1
order by t1.fdate


select 产品分类,sum(出库数量) 出库数量,cast(sum(成本)/sum(出库数量) as decimal(24,4)) as 单位成本,sum(成本) 成本,
cast(sum(销售金额)/sum(出库数量) as decimal(24,4)) as 销售单价,sum(销售金额) 销售金额,sum(销售金额-成本) 销售毛利,
cast((sum(销售金额)-sum(成本))/sum(销售金额)*100 as decimal(24,4)) 毛利率
from #data group by 产品分类


------------------------------------------------------------
select * from t_item where fitemclassid=3003

select * from t_itempropdesc where fitemclassid=4

--海关产品分类
--update t6 set F_108=170442
--select  t3.fnumber,t3.fname,t3.fmodel
from t_icitem t3 
inner join t_ICItemCustom t6 on t6.fitemid=t3.fitemid
where t3.fnumber like '1.01.0001.%'

------------------------------------------------------------------

IF EXISTS (select * from sysobjects where name='My_P_ICItemReplaceQry' and xtype='p')  drop  procedure My_P_ICItemReplaceQry
go

create procedure [dbo].My_P_ICItemReplaceQry (@fuserid int,@fproductid int,@fitemid int,@ftype int)  --@fordertype 0 非专利 1 专利 @ferpclsid 2 自制 1 外购 3 全部

as
set nocount on

create table #data(fproductid int,findex int,fentryid int,fitemid int,fqty decimal(24,5),forder int,fsubsitemid int,flevelstring varchar(50))

if @ftype=1 --BOM
begin
	select t3.fnumber 物料编码,t3.fname 名称,isnull(t3.fmodel,'') 规格型号,isnull(t3.F_105,'') 描述,t4.fqty 用量
	from icbom t1
	inner join t_icitem t2 on t1.fitemid=t2.fitemid
	inner join icbomchild t4 on t1.finterid=t4.finterid 
	inner join t_icitem t3 on t3.fitemid=t4.fitemid
	where t1.fitemid=@fproductid
end

if @ftype=2  --替代关系
begin
	insert into #data(fproductid,fitemid)
	select distinct   t1.fitemid,t4.fitemid
	from icbom t1
	inner join t_icitem t2 on t1.fitemid=t2.fitemid
	inner join icbomchild t4 on t1.finterid=t4.finterid 
	inner join t_icitem t3 on t3.fitemid=t4.fitemid
	where t1.fitemid=@fproductid

	select t2.fnumber 物料编码,t2.fname 名称,isnull(t2.fmodel,'') 规格型号,isnull(t2.F_105,'') 描述,
	       t3.fnumber 替代编码,t3.fname 替代名称,isnull(t3.fmodel,'') 替代规格型号,isnull(t3.F_105,'') 替代描述,t1.forder 优先级
	from
	(
		select t2.fitemid,t2.fsubsitemid,t2.forder
		from #data t1
		inner join t_subsItem t2 on t1.fproductid=t2.FApplicableItem and t1.fitemid=t2.fitemid
		union all
		select t2.fitemid,t2.fsubsitemid,t2.forder
		from #data t1
		inner join t_subsItem t2 on t1.fitemid=t2.fitemid
		where t2.FApplicableItem=0
	) t1 inner join t_icitem t2 on t1.fitemid=t2.fitemid
	inner join t_icitem t3 on t3.fitemid=t1.fsubsitemid

	truncate table #data
end

if @ftype=3  --合并BOM
begin
	insert into #data(fproductid,fentryid,   fitemid   ,fqty,   forder,fsubsitemid)
	select            t1.fitemid,t4.fentryid,t4.fitemid,t4.fqty,0,     t4.fitemid
	from icbom t1
	inner join t_icitem t2 on t1.fitemid=t2.fitemid
	inner join icbomchild t4 on t1.finterid=t4.finterid 
	inner join t_icitem t3 on t3.fitemid=t4.fitemid
	where t1.fitemid=@fproductid

	insert into #data(fproductid,   fentryid,   fitemid   ,fqty,   forder,   fsubsitemid)
	select            t1.fproductid,t1.fentryid,t1.fitemid,t1.fqty,t1.forder,t1.fsubsitemid
	from
	(
		select t1.fproductid,t2.fitemid,t2.fsubsitemid,t2.forder,t1.fqty,t1.fentryid
		from #data t1
		inner join t_subsItem t2 on t1.fproductid=t2.FApplicableItem and t1.fitemid=t2.fitemid
		union all
		select t1.fproductid,t2.fitemid,t2.fsubsitemid,t2.forder,t1.fqty,t1.fentryid
		from #data t1
		inner join t_subsItem t2 on t1.fitemid=t2.fitemid
		where t2.FApplicableItem=0
	) t1 inner join t_icitem t2 on t1.fitemid=t2.fitemid
	inner join t_icitem t3 on t3.fitemid=t1.fsubsitemid

	select t1.fentryid 分录号,t2.fnumber 物料编码,t2.fname 名称,isnull(t2.fmodel,'') 规格型号,
	isnull(t2.F_105,'') 描述,t1.fqty 用量,t1.forder 优先级
	from #data t1
	inner join t_icitem t2 on t1.fsubsitemid=t2.fitemid
	inner join t_icitem t3 on t3.fitemid=t1.fitemid
	order by t1.fentryid,t1.forder

	truncate table #data
end

	
if @ftype=4  --多级展开
begin
	--declare @fproductid int set @fproductid=66597 --select fitemid from t_icitem where fshortnumber=''
	
	Create Table #Mutidata     (  FIndex int IDENTITY,FEntryID INT, FBomInterid int, FItemID int null, FNeedQty decimal(28,14) default(0) null, FBOMLevel int null, 
	FItemType int null, FParentID int default(0)null, FRate   decimal(28,14) default(0) null, FHistory int default(0) null, FHaveMrp smallint default(0) null, 
	FLevelString varchar(300) null, FBom int, FMaterielType int  default(371) null,FOperSN Int NULL DEFAULT(0),FOperID int default(0)) 
	 
	Create Table #MutiParentItem(  FIndex int IDENTITY,FEntryID INT default(0), FBomInterid int, FItemID int null, FNeedQty decimal(28,14) default(0) null, FBOMLevel 
	int null, FItemType int null,  FParentID int default(0)null, FRate   decimal(28,14) default(0) null, FHistory int default(0) null, FHaveMrp smallint default(0) 
	null, FLevelString varchar(300) null , FBom int, FMaterielType int  default(371) null,FOperSN Int NULL DEFAULT(0),FOperID int default(0)) 
	
	Create Table #Errors ( FIndex int IDENTITY, FType smallint default(0), FErrText nvarchar(655) )

	Insert into #mutiParentItem (fbominterid,FItemID,FNeedQty,FBOMLevel,FParentID,FItemType,FBom)
	Select a.finterid, t1.FItemID,a.fqty, 0,0,(case t5.FID when 'WG' then 
	0 when 'ZZ' then 1 when 'WWJG' then 1 else 2 end) FItemtype,t1.FItemID 
	From icbom a
	inner join t_ICItem t1 on t1.FItemID = a.fitemid
	left join t_Submessage t5 on t1.FErpClsID = t5.FInterID 
	where --t5.FTypeID = 210 and  
	t1.fitemid =@fproductid and a.fusestatus=1072 

	declare @p5 int
	set @p5=0
	declare @p6 nchar(400)
	set @p6=''
	exec PlanMutiBomExpand 50,1,'1900-01-01 00:00:00:000','2100-01-01 00:00:00:000',@p5 output,@p6 output
 
	insert into #data(fproductid, findex,   fitemid   ,fqty,       forder,fsubsitemid,flevelstring)
	select            t4.fitemid, t1.findex,t1.fitemid,t1.fneedqty,0,     t1.fitemid,t1.flevelstring
	from #Mutidata t1 
	inner join t_icitem t2 on t1.fitemid=t2.fitemid 
	inner join icbomchild t3 on t1.fbominterid=t3.finterid and t3.fentryid=t1.fentryid
	inner join icbom t4 on t4.finterid=t3.finterid

	insert into #data(fproductid,   findex,   fitemid   ,fqty,   forder,   fsubsitemid,   flevelstring)
	select            t1.fproductid,t1.findex,t1.fitemid,t1.fqty,t1.forder,t1.fsubsitemid,t1.flevelstring
	from
	(
		select t1.fproductid,t2.fitemid,t2.fsubsitemid,t2.forder,t1.fqty,t1.findex,t1.flevelstring
		from #data t1
		inner join t_subsItem t2 on t1.fproductid=t2.FApplicableItem and t1.fitemid=t2.fitemid
		union all
		select t1.fproductid,t2.fitemid,t2.fsubsitemid,t2.forder,t1.fqty,t1.findex,t1.flevelstring
		from #data t1
		inner join t_subsItem t2 on t1.fitemid=t2.fitemid
		where t2.FApplicableItem=0
	) t1 inner join t_icitem t2 on t1.fitemid=t2.fitemid
	inner join t_icitem t3 on t3.fitemid=t1.fsubsitemid

	select t1.findex 序号,t1.flevelstring 级次,t2.fnumber 物料编码,t2.fname 名称,isnull(t2.fmodel,'') 规格型号,
	isnull(t2.F_105,'') 描述,t1.fqty 用量,t1.forder 优先级
	from #data t1
	inner join t_icitem t2 on t1.fsubsitemid=t2.fitemid
	inner join t_icitem t3 on t3.fitemid=t1.fitemid
	order by t1.findex,t1.forder


	truncate table #data
	drop table #Mutidata
	drop table #mutiParentItem
	drop table #Errors
end


if @ftype=5  --单级反查  --select fitemid from t_icitem where fshortnumber='000006'
begin
	insert into #data(fproductid,fitemid   ,forder,    fsubsitemid)
	select   distinct t1.fitemid,t4.fitemid,t5.forder, t5.fsubsitemid
	from icbom t1
	inner join t_icitem t2 on t1.fitemid=t2.fitemid
	inner join icbomchild t4 on t1.finterid=t4.finterid --and t4.fitemid=68175
	inner join t_icitem t3 on t3.fitemid=t4.fitemid
	inner join t_subsItem t5 on t5.fitemid=t4.fitemid and t5.FApplicableItem=t1.fitemid
	where t4.fitemid=@fitemid


	insert into #data(fproductid,fitemid   ,forder,   fsubsitemid)
	select   distinct t1.fitemid,t4.fitemid,t5.forder,t5.fsubsitemid
	from icbom t1
	inner join t_icitem t2 on t1.fitemid=t2.fitemid
	inner join icbomchild t4 on t1.finterid=t4.finterid --and t4.fitemid=68175
	inner join t_icitem t3 on t3.fitemid=t4.fitemid
	inner join t_subsItem t5 on t5.fitemid=t4.fitemid and t5.FApplicableItem=0
	where t4.fitemid=@fitemid

	select t4.fnumber 产品编码,t4.fname+'///'+isnull(t4.fmodel,'')+'///'+isnull(t4.F_105,'') 产品名称,--isnull(t4.fmodel,'') 产品规格型号,isnull(t4.F_105,'') 产品描述,
	t2.fnumber 物料编码,t2.fname+'///'+isnull(t2.fmodel,'')+'///'+isnull(t2.F_105,'') 物料名称,--isnull(t2.fmodel,'') 规格型号,isnull(t2.F_105,'') 描述,
	t3.fnumber 替代编码,t3.fname+'///'+isnull(t3.fmodel,'')+'///'+isnull(t3.F_105,'') 替代名称,--isnull(t3.fmodel,'') 替代规格型号,isnull(t3.F_105,'') 替代描述,
	t1.forder 优先级
	from #data t1
	inner join t_icitem t3 on t1.fsubsitemid=t3.fitemid
	inner join t_icitem t2 on t2.fitemid=t1.fitemid
	inner join t_icitem t4 on t4.fitemid=t1.fproductid
	order by t4.fnumber,t2.fnumber,t1.forder

	truncate table #data
end

drop table #data

set nocount off

go

-------------------------------------------------------------------------

select t2.fshortnumber 产品编码,t2.fname 产品名称,isnull(t2.fmodel,'')+'///'+isnull(t2.F_105,'') 产品规格型号,
t3.fshortnumber 子项编码,t3.fname 子项名称,isnull(t3.fmodel,'')+'///'+isnull(t3.F_105,'') 子项规格型号,t4.fqty 子项用量
from icbom t1
inner join t_icitem t2 on t1.fitemid=t2.fitemid
inner join icbomchild t4 on t1.finterid=t4.finterid 
inner join t_icitem t3 on t3.fitemid=t4.fitemid

from icbom t1
inner join t_icitem t2 on t1.fitemid=t2.fitemid
inner join icbomchild t4 on t1.finterid=t4.finterid 
inner join t_icitem t3 on t3.fitemid=t4.fitemid
where 

-------------------------------------------------------------------------------
declare @fmaxnum int,@fdate datetime,@fmaxbill int,@fmaxbillno varchar

set @fmaxnum=1000
select @fmaxnum=fmaxnum from icmaxnum where ftablename='t_subsItem'

--select @fdate=replace(convert(varchar(10),getdate(),111),'/','-')
--select @fmaxbill=cast(max(right(FBomNumber,6)) as int) from icbom where FBomNumber like 'BOM%'

create table #mybom(fid int identity(1,1),fproductid int,fitemid int,frepitemid int,forder int)

insert into #mybom(fproductid,   fitemid,   frepitemid    ,forder)
select distinct    t1.fproductid,t2.fitemid,t2.frepitemid ,t2.forder
from t_BOSICItemReplace t1 
inner join t_BOSICItemReplaceEntry t2 on t1.fid=t2.fid
where isnull(t1.fproductid,0)=0

insert into #mybom(fproductid,   fitemid,   frepitemid ,   forder)
select distinct    t1.fproductid,t2.fitemid,t2.frepitemid ,t2.forder
from t_BOSICItemReplace t1 
inner join t_BOSICItemReplaceEntry t2 on t1.fid=t2.fid
inner join icbom t3 on t3.fitemid=t1.fproductid
where isnull(t1.fproductid,0)<>0 
and not exists(select 1 from #mybom where fitemid=t2.fitemid and frepitemid=t2.frepitemid)

Insert Into t_subsItem   (FInterID,       FItemID,   FSubsItemID,   FOrder,   FapplicableItem ,FapplicableBOM,       Frate,FsubsRate,FeachOther,Fnote,FPriorityID,FEnabledDate,FDisabledDate)  
select                    @fmaxnum+t1.fid,t1.fitemid,t1.frepitemid ,t1.forder,t1.fproductid,   isnull(t2.finterid,0),1,    1,        0,         '',   1,          '1900-01-01','9999-01-01'
from #mybom t1
left join icbom t2 on t1.fproductid=t2.fitemid
order by t1.fid


update icmaxnum set fmaxnum=(select max(FInterID) from t_subsItem) where ftablename='t_subsItem'

drop table #mybom  --truncate table t_subsItem


--select t2.fnumber,t1.* from t_subsItem t1 inner join t_icitem t2 on t1.fitemid=t2.fitemid where t2.fshortnumber='000006'

----------------------------------------------------------------------------------------------------------------------------------------------------------------

select t4.fitemid,t24.fitemid,t1.fnumber,t4.fnumber,t24.fnumber
--update t7 set fitemid=t24.fitemid
from t_icitem t1 
inner join icbom t6 on t6.fitemid=t1.fitemid
inner join icbomchild t7 on t7.finterid=t6.finterid
inner join t_icitem t4 on t4.fitemid=t7.fitemid
inner join sheet125$ t23 on cast(cast(t23.原代码 as int) as varchar(50))=t4.fshortnumber
inner join t_icitem t24 on cast(cast(t23.新代码 as int) as varchar(50))=t24.fshortnumber
where t1.fnumber like 'v.e%'

select t4.fitemid,t24.fitemid,t1.fnumber,t4.fnumber,t24.fnumber
--update t7 set fitemid=t24.fitemid
from t_icitem t1 
inner join icbom t6 on t6.fitemid=t1.fitemid
inner join icbomchild t7 on t7.finterid=t6.finterid
inner join t_icitem t4 on t4.fitemid=t7.fitemid
inner join sheet125$ t23 on t23.短代码=t1.fshortnumber
inner join t_icitem t24 on t23.子项编码=t24.fnumber
where t1.fnumber like 'v.e%' and left(t4.fnumber,1) in ('3','4','5','7','8')


select t5.fname 项目经理,replace(convert(varchar(10),isnull(t2.flastmoddate,t2.fcreatedate),111),'/','-') 修改日期,
isnull(t10.fname,'') 审核人,isnull(t14.fname,'') 打印机品牌,
t1.fshortnumber 短代码,t1.fnumber 长代码,t1.fname 产品名称,t3.ffullname 全称,t1.fmodel 规格型号,
isnull(t1.f_105,'') 描述,isnull(t1.f_106,'') 适用机型,isnull(t1.F_107,'') 适用区域 
into #data
from t_icitem t1
left join t_baseproperty t2 on t1.fitemid=t2.fitemid
left join t_item t13 on t13.fitemid=t1.F_103 and t13.fitemclassid=3004  --外盒尺寸  --select * from t_item where fitemclassid=3004
left join t_SubMessage t14 on t14.finterid=t1.F_102  --打印机品牌  select * from t_submessage where ftypeid=10001
inner join t_item t3 on t3.fitemid=t1.fitemid
left join t_user t4 on t4.fuserid=t3.FChkUserID and t4.fuserid<>0
left join t_SubMessage t5 on t5.finterid=t1.F_128  --select * from t_submestype
left join t_user t10 on t10.fuserid=t3.FChkUserID and t10.fuserid<>0
where --left(t1.fnumber,4) in ('a.01','p.01','j.01','x.01','y.01')
left(t1.fnumber,4) in ('v.e.') and t1.fdeleted=0
--and t9.fstatus=0  
--and t1.fname not like '%禁用%' 
--and t5.fname='汤传义'
--and t9.finterid in (select finterid from icbom where FOperatorID=16394 and FEnterTime='2015-01-20')
--and t1.fnumber='A.01.01.001.A00005'
order by --t5.fname,t14.fname,
t1.fnumber,t7.fnumber


select t5.fname 项目经理,replace(convert(varchar(10),isnull(t2.flastmoddate,t2.fcreatedate),111),'/','-') 修改日期,
isnull(t10.fname,'') 审核人,isnull(t14.fname,'') 打印机品牌,
t1.fshortnumber 短代码,t1.fnumber 长代码,t1.fname 产品名称,t3.ffullname 全称,t1.fmodel 规格型号,
isnull(t1.f_105,'') 描述,isnull(t1.f_106,'') 适用机型,isnull(t1.F_107,'') 适用区域,
t7.fnumber 子项编码,t7.fname 子项名称,t7.fmodel 子项规格型号,t6.fqty 用量 
into #data
from t_icitem t1
left join t_baseproperty t2 on t1.fitemid=t2.fitemid
left join t_item t13 on t13.fitemid=t1.F_103 and t13.fitemclassid=3004  --外盒尺寸  --select * from t_item where fitemclassid=3004
left join t_SubMessage t14 on t14.finterid=t1.F_102  --打印机品牌  select * from t_submessage where ftypeid=10001
inner join t_item t3 on t3.fitemid=t1.fitemid
left join t_user t4 on t4.fuserid=t3.FChkUserID and t4.fuserid<>0
left join t_supplier t8 on t8.fitemid=t1.F_117 --t3.fsource
inner join icbom t9 on t9.fitemid=t1.fitemid
left join t_SubMessage t5 on t5.finterid=t1.F_128  --select * from t_submestype
inner join icbomchild t6 on t6.finterid=t9.finterid
inner join t_icitem t7 on t7.fitemid=t6.fitemid
left join t_user t10 on t10.fuserid=t3.FChkUserID and t10.fuserid<>0
where --left(t1.fnumber,4) in ('a.01','p.01','j.01','x.01','y.01')
left(t1.fnumber,4) in ('v.e.') and t1.fdeleted=0
--and t9.fstatus=0  
--and t1.fname not like '%禁用%' 
--and t5.fname='汤传义'
--and t9.finterid in (select finterid from icbom where FOperatorID=16394 and FEnterTime='2015-01-20')
--and t1.fnumber='A.01.01.001.A00005'
order by --t5.fname,t14.fname,
t1.fnumber,t7.fnumber



select t5.fname 项目经理,replace(convert(varchar(10),isnull(t2.flastmoddate,t2.fcreatedate),111),'/','-') 修改日期,
isnull(t10.fname,'') 审核人,isnull(t14.fname,'') 打印机品牌,
t1.fshortnumber 短代码,t1.fnumber 长代码,t1.fname 产品名称,t3.ffullname 全称,t1.fmodel 规格型号,
isnull(t1.f_105,'') 描述,isnull(t1.f_106,'') 适用机型,isnull(t1.F_107,'') 适用区域,
t7.fnumber 子项编码,t7.fname 子项名称,t7.fmodel 子项规格型号,t6.fqty 用量 
from t_icitem t1
left join t_baseproperty t2 on t1.fitemid=t2.fitemid
left join t_item t13 on t13.fitemid=t1.F_103 and t13.fitemclassid=3004  --外盒尺寸  --select * from t_item where fitemclassid=3004
left join t_SubMessage t14 on t14.finterid=t1.F_102  --打印机品牌  select * from t_submessage where ftypeid=10001
inner join t_item t3 on t3.fitemid=t1.fitemid
left join t_user t4 on t4.fuserid=t3.FChkUserID and t4.fuserid<>0
left join t_supplier t8 on t8.fitemid=t1.F_117 --t3.fsource
inner join icbom t9 on t9.fitemid=t1.fitemid
left join t_SubMessage t5 on t5.finterid=t1.F_128  --select * from t_submestype
inner join icbomchild t6 on t6.finterid=t9.finterid
inner join t_icitem t7 on t7.fitemid=t6.fitemid
left join t_user t10 on t10.fuserid=t3.FChkUserID and t10.fuserid<>0
where --left(t1.fnumber,4) in ('a.01','p.01','j.01','x.01','y.01')
--left(t1.fnumber,4) in ('v.e.') and t1.fdeleted=0
--and t9.fstatus=0  
--and 
t1.fnumber in (select 子项编码 from #data where left(子项编码,1) in ('3','4','5'))
--and t1.fname not like '%禁用%' 
--and t5.fname='汤传义'
--and t9.finterid in (select finterid from icbom where FOperatorID=16394 and FEnterTime='2015-01-20')
--and t1.fnumber='A.01.01.001.A00005'
order by --t5.fname,t14.fname,
t1.fnumber,t7.fnumber


select t1.finterid,t2.fqty,t2.fauxqty
--update t2 set fqty=1,fauxqty=1
from icbom t1
inner join icbomchild t2 on t1.finterid=t2.finterid
inner join t_icitem t3 on t2.fitemid=t3.fitemid
inner join t_icitem t0 on t0.fitemid=t1.fitemid
where t3.fshortnumber='BXM06221'

select distinct t1.finterid,t0.fnumber,t0.fname,t0.fmodel 
--into #data
from icbom t1
inner join icbomchild t2 on t1.finterid=t2.finterid
inner join t_icitem t3 on t2.fitemid=t3.fitemid
inner join t_icitem t0 on t0.fitemid=t1.fitemid
where t0.fname like '%高配%' and t0.fname not like '%禁用%' 
and t1.finterid not in 
(
	select t1.finterid
	from icbom t1
	inner join icbomchild t2 on t1.finterid=t2.finterid
	inner join t_icitem t3 on t2.fitemid=t3.fitemid
	inner join t_icitem t0 on t0.fitemid=t1.fitemid
	where t3.fshortnumber='BXM06221'
)
and left(t0.fnumber,1) in ('a','p','j','x','y') 
and left(t0.fnumber,4) not in ('a.04','p.04','j.04','x.04','y.04') 
order by t0.fnumber

select distinct t1.finterid,t0.fnumber,t0.fname,t0.fmodel 
into #data
from icbom t1
inner join t_icitem t0 on t0.fitemid=t1.fitemid
where t0.fnumber like '%B3008%' or t0.fnumber like '%B2428%' or t0.fnumber like '%B3305%' or t0.fnumber like '%B1160%'


drop table #data


		select t1.finterid,t0.fnumber,t0.fname,t0.fmodel ,t2.fentryid,t0.fshortnumber
--delete t2
		from icbom t1
		inner join icbomchild t2 on t1.finterid=t2.finterid
		inner join t_icitem t3 on t2.fitemid=t3.fitemid
		inner join t_icitem t0 on t0.fitemid=t1.fitemid
		where t3.fshortnumber='211403'


select * from #data

INSERT INTO ICBomChild (FInterID,      FEntryID,FBrNo,FItemID,       FMachinePos,FNote,FAuxQty, FScrap,FOffSetDay,FUnitID,   FQty,  FMaterielType,FMarshalType,FBeginDay,   FEndDay,     FPercent,FPositionNo,FItemSize,FItemSuite,FOperSN,FOperID,FBackFlush,FStockID,      FSPID,FAuxPropID,FPDMImportDate,FDetailID) 
select                  t1.finterid,
			(select max(fentryid)+1 from icbomchild where finterid=t1.finterid),
						'0',  t2.fitemid,    '',         '',   2,       0,     0,         t2.FUnitID,2,     371,          385,         '1900-01-01','2100-01-01',100,     '',         '',       '',        '',     0,      1059,      t2.fdefaultloc,0,    0,         null,          NEWID() 
from #data t1
inner join t_icitem t2 on t2.fshortnumber='211403'

select * into #temp
from #data where finterid in (
	select finterid
	from
	(
		select t1.finterid,t0.fnumber,t0.fname,t0.fmodel ,t2.fentryid,t0.fshortnumber
		from icbom t1
		inner join icbomchild t2 on t1.finterid=t2.finterid
		inner join t_icitem t3 on t2.fitemid=t3.fitemid
		inner join t_icitem t0 on t0.fitemid=t1.fitemid
		where t3.fshortnumber='BXM06221'
	) t1 group by finterid having count(1)>1
)

select t1.finterid,t1.fentryid
--delete t1
from icbomchild t1
inner join
(
	select t1.finterid,max(t2.fentryid) fentryid
		from icbom t1
		inner join icbomchild t2 on t1.finterid=t2.finterid
		inner join t_icitem t3 on t2.fitemid=t3.fitemid
		inner join t_icitem t0 on t0.fitemid=t1.fitemid
		where t3.fshortnumber='BXM06221' and t1.finterid in (select finterid from #temp)
	group by t1.finterid
) t2 on t1.finterid=t2.finterid and t1.fentryid=t2.fentryid



select t7.fname 供应商,t2.fnumber 编码,t2.fname 名称,t2.fmodel 规格型号,
isnull(t2.f_105,'') 描述,isnull(t2.f_106,'') 适用机型,isnull(t2.F_107,'') 适用区域,
t1.fprice 销售单价,t5.fnumber 物料编码,t5.fname 物料名称,t5.fmodel 物料规格型号, t6.fprice 物料采购单价
from IcPrcPlyEntry t1
inner join t_icitem t2 on t1.fitemid=t2.fitemid
inner join icbom t3 on t2.fitemid=t3.fitemidinner join icbomchild t4 on t3.finterid=t4.finteridinner join t_icitem t5 on t5.fitemid=t4.fitemid
inner join t_supplyentry t6 on t5.fitemid=t6.fitemidinner join t_supplier t7 on t6.fsupid=t7.fitemidwhere left(t2.fnumber,4) in ('a.01','p.01','j.01','x.01','y.01') and t2.fname not like '%禁用%' and t2.fdeleted=0 and left(t5.fnumber,1) in ('7','8')
order by t7.fname,t2.fnumber

select t1.fnumber 编码,t1.fname 名称,t1.fmodel 规格型号,--isnull(t5.fprice,0) 售价,isnull(t4.fname,t14.fname) 项目经理,
isnull(t12.fname,'') 是否引擎,isnull(t11.fnumber,'') 引擎编码,isnull(t11.fname,'') 引擎名称,isnull(t11.fmodel,'') 引擎规格型号
--isnull(t2.fprice,0) 引擎售价
--update t6 set flastmoddate='2015-04-15'
--update t3 set f_127=t8.fitemid
--update t3 set F_129=isnull(t11.fnumber,'')
from t_icitem t1 
inner join t_ICItemCustom t3 on t1.fitemid=t3.fitemid
-- left join t_submessage t4 on t1.f_128=t4.finterid
left join t_icitem t11 on t11.fitemid=t1.f_127
left join t_submessage t12 on t12.finterid=t1.f_126
order by t1.fnumber

select t1.fnumber 编码,t1.fname 名称,t1.fmodel 规格型号,--isnull(t5.fprice,0) 售价,isnull(t4.fname,t14.fname) 项目经理,
isnull(t12.fname,'') 是否引擎,isnull(t11.fnumber,'') 引擎编码,isnull(t11.fname,'') 引擎名称,isnull(t11.fmodel,'') 引擎规格型号,
t8.fnumber,t8.fname,t8.fmodel,t6.flastmoddate
--isnull(t2.fprice,0) 引擎售价
--update t6 set flastmoddate='2015-04-15'
--update t3 set f_127=t8.fitemid
from t_icitem t1 
inner join t_ICItemCustom t3 on t1.fitemid=t3.fitemid
-- left join t_submessage t4 on t1.f_128=t4.finterid
inner join t_icitem t11 on t11.fitemid=t1.f_127
left join t_submessage t12 on t12.finterid=t1.f_126
inner join t_item t7 on t7.fitemid=t11.fparentid
inner join t_icitem t8 on t8.fparentid=t7.fitemid and t8.fitemid<>t11.fitemid and t8.fname like '%高配%' and t8.fname not like '%专利%' and t11.fname not like '%专利%' and t8.fname not like '%易加粉%'
-- left join icbom t13 on t13.fitemid=t1.fitemid
-- left join t_submessage t14 on t14.finterid=t13.fheadselfz0134
-- left join IcPrcPlyEntry t2 on t2.fitemid=t11.fitemid
-- left join IcPrcPlyEntry t5 on t5.fitemid=t1.fitemid
inner join t_baseproperty t6 on t6.fitemid=t1.fitemid
WHERE --t1.fshortnumber in ('vb01460','vb01461','vb01462','vb01463')
left(t1.fnumber,4) in ('v.b.') and left(t11.fnumber,1) not in ('v')
and ((t1.fname like '%高配%' and t11.fname like '%标配%'))



select t1.fnumber 编码,t1.fname 名称,t1.fmodel 规格型号,--isnull(t5.fprice,0) 售价,isnull(t4.fname,t14.fname) 项目经理,
isnull(t12.fname,'') 是否引擎,isnull(t11.fnumber,'') 引擎编码,isnull(t11.fname,'') 引擎名称,isnull(t11.fmodel,'') 引擎规格型号,
t8.fnumber,t8.fname,t8.fmodel,t6.flastmoddate
--isnull(t2.fprice,0) 引擎售价
--update t6 set flastmoddate='2015-04-15'
--update t3 set f_127=t8.fitemid
from t_icitem t1 
inner join t_ICItemCustom t3 on t1.fitemid=t3.fitemid
-- left join t_submessage t4 on t1.f_128=t4.finterid
inner join t_icitem t11 on t11.fitemid=t1.f_127
left join t_submessage t12 on t12.finterid=t1.f_126
inner join t_item t7 on t7.fitemid=t11.fparentid
inner join t_icitem t8 on t8.fparentid=t7.fitemid and t8.fitemid<>t11.fitemid and t8.fname like '%高配%'  --and t8.fname not like '%易加粉%' --and t8.fname not like '%专利%' and t11.fname not like '%专利%'
-- left join icbom t13 on t13.fitemid=t1.fitemid
-- left join t_submessage t14 on t14.finterid=t13.fheadselfz0134
-- left join IcPrcPlyEntry t2 on t2.fitemid=t11.fitemid
-- left join IcPrcPlyEntry t5 on t5.fitemid=t1.fitemid
inner join t_baseproperty t6 on t6.fitemid=t1.fitemid
WHERE --t1.fshortnumber in ('vb01460','vb01461','vb01462','vb01463')
left(t1.fnumber,4) in ('v.b.') and left(t11.fnumber,1) not in ('v')
and ((t1.fname like '%高配%' and t11.fname like '%标配%'))


select t1.fnumber 编码,t1.fname 名称,t1.fmodel 规格型号,--isnull(t5.fprice,0) 售价,isnull(t4.fname,t14.fname) 项目经理,
isnull(t12.fname,'') 是否引擎,isnull(t11.fnumber,'') 引擎编码,isnull(t11.fname,'') 引擎名称,isnull(t11.fmodel,'') 引擎规格型号,
t8.fnumber,t8.fname,t8.fmodel,t6.flastmoddate
--isnull(t2.fprice,0) 引擎售价
--update t6 set flastmoddate='2015-04-15'
--update t3 set f_127=t8.fitemid
from t_icitem t1 
inner join t_ICItemCustom t3 on t1.fitemid=t3.fitemid
-- left join t_submessage t4 on t1.f_128=t4.finterid
inner join t_icitem t11 on t11.fitemid=t1.f_127
left join t_submessage t12 on t12.finterid=t1.f_126
inner join t_item t7 on t7.fitemid=t11.fparentid
inner join t_icitem t8 on t8.fparentid=t7.fitemid and t8.fitemid<>t11.fitemid and t8.fname like '%标配%' and t8.fname not like '%专利%' and t8.fname not like '%禁用%' --and t11.fname not like '%专利%' and t8.fname not like '%易加粉%'
-- left join icbom t13 on t13.fitemid=t1.fitemid
-- left join t_submessage t14 on t14.finterid=t13.fheadselfz0134
-- left join IcPrcPlyEntry t2 on t2.fitemid=t11.fitemid
-- left join IcPrcPlyEntry t5 on t5.fitemid=t1.fitemid
inner join t_baseproperty t6 on t6.fitemid=t1.fitemid
WHERE --t1.fshortnumber in ('vb01460','vb01461','vb01462','vb01463')
left(t1.fnumber,4) in ('v.b.') and left(t11.fnumber,1) not in ('v')
and ((t1.fname like '%标配%' and t11.fname like '%高配%'))


select t1.fnumber 编码,t1.fname 名称,t1.fmodel 规格型号,--isnull(t5.fprice,0) 售价,isnull(t4.fname,t14.fname) 项目经理,
isnull(t12.fname,'') 是否引擎,isnull(t11.fnumber,'') 引擎编码,isnull(t11.fname,'') 引擎名称,isnull(t11.fmodel,'') 引擎规格型号,
t8.fnumber,t8.fname,t8.fmodel,t6.flastmoddate
--isnull(t2.fprice,0) 引擎售价
--update t6 set flastmoddate='2015-04-15'
--update t3 set f_127=t8.fitemid
from t_icitem t1 
inner join t_ICItemCustom t3 on t1.fitemid=t3.fitemid
-- left join t_submessage t4 on t1.f_128=t4.finterid
inner join t_icitem t11 on t11.fitemid=t1.f_127
left join t_submessage t12 on t12.finterid=t1.f_126
inner join t_item t7 on t7.fitemid=t11.fparentid
inner join t_icitem t8 on t8.fparentid=t7.fitemid and t8.fitemid<>t11.fitemid and t8.fname like '%标配%' -- and t8.fname not like '%禁用%'  --and t8.fname not like '%专利%' --and t11.fname not like '%专利%' and t8.fname not like '%易加粉%'
-- left join icbom t13 on t13.fitemid=t1.fitemid
-- left join t_submessage t14 on t14.finterid=t13.fheadselfz0134
-- left join IcPrcPlyEntry t2 on t2.fitemid=t11.fitemid
-- left join IcPrcPlyEntry t5 on t5.fitemid=t1.fitemid
inner join t_baseproperty t6 on t6.fitemid=t1.fitemid
WHERE --t1.fshortnumber in ('vb01460','vb01461','vb01462','vb01463')
left(t1.fnumber,4) in ('v.b.') and left(t11.fnumber,1) not in ('v')
and ((t1.fname like '%标配%' and t11.fname like '%高配%'))


select t1.fnumber 编码,t1.fname 名称,t1.fmodel 规格型号,--isnull(t5.fprice,0) 售价,isnull(t4.fname,t14.fname) 项目经理,
isnull(t12.fname,'') 是否引擎,isnull(t11.fnumber,'') 引擎编码,isnull(t11.fname,'') 引擎名称,isnull(t11.fmodel,'') 引擎规格型号,
t8.fnumber,t8.fname,t8.fmodel,
t6.flastmoddate
--isnull(t2.fprice,0) 引擎售价
--update t6 set flastmoddate='2015-04-15'
--update t3 set f_127=t8.fitemid
from t_icitem t1 
inner join t_ICItemCustom t3 on t1.fitemid=t3.fitemid
-- left join t_submessage t4 on t1.f_128=t4.finterid
inner join t_icitem t11 on t11.fitemid=t1.f_127
left join t_submessage t12 on t12.finterid=t1.f_126
inner join t_item t7 on t7.fitemid=t11.fparentid
inner join t_icitem t8 on t8.fparentid=t7.fitemid and t8.fitemid<>t11.fitemid and t8.fname not like '%禁用%' -- and t8.fname like '%标配%'   --and t8.fname not like '%专利%' --and t11.fname not like '%专利%' and t8.fname not like '%易加粉%'
-- left join icbom t13 on t13.fitemid=t1.fitemid
-- left join t_submessage t14 on t14.finterid=t13.fheadselfz0134
-- left join IcPrcPlyEntry t2 on t2.fitemid=t11.fitemid
-- left join IcPrcPlyEntry t5 on t5.fitemid=t1.fitemid
inner join t_baseproperty t6 on t6.fitemid=t1.fitemid
WHERE --t1.fshortnumber in ('vb01460','vb01461','vb01462','vb01463')
left(t1.fnumber,4) in ('v.b.') and left(t11.fnumber,1) not in ('v')
--and ((t1.fname like '%标配%' and t11.fname like '%高配%'))
and t11.fname like '%禁用%' and t1.fname not like '%禁用%'

select t3.fnumber,t3.fname,t3.fmodel,t5.FLastModDate,t11.fname+'[计划禁用]',t7.fqty
--update t11 set fname=t11.fname+'[计划禁用]'
--update t0 set fname=t0.fname+'[计划禁用]'
--update t2 set fcheckdate='2015-03-12'
--update t5 set flastmoddate='2015-03-12'
--update t2 set FChkUserID=16394
from t_icitem t3
inner join t_ICItemCore t0 on t0.fitemid=t3.fitemid
inner join t_item t11 on t11.fitemid=t0.fitemid
inner join t_item t2 on t2.fitemid=t3.fitemid
left join t_baseproperty t5 on t5.fitemid=t3.fitemid
left join icinventory t7 on t7.fitemid=t3.fitemid and t7.fqty>0
where --t3.fshortnumber not in ('q01527','q01528','q12001','q08001')
--and 
t3.fnumber like 'r%'
and t3.fname not like '%禁用%' --and t3.fname like '%傲威中性粉盒%'

select t3.fnumber,t3.fname,t3.fmodel,t11.fname,t5.FLastModDate,replace(t3.fname,'配','配-鼓架')
--update t2 set fcheckdate='2015-05-23'
--update t5 set flastmoddate='2015-05-23'
--update t2 set FChkUserID=16394
--update t2 set fname=replace(t2.fname,'配','配-鼓架')
--update t0 set fname=replace(t0.fname,'配','配-鼓架')
--update t2 set fname=t2.fname+'-鼓架'
--update t0 set fname=t0.fname+'-鼓架'
from t_icitem t3
inner join t_ICItemCore t0 on t0.fitemid=t3.fitemid
inner join t_item t11 on t11.fitemid=t3.fparentid
inner join t_item t2 on t2.fitemid=t3.fitemid
left join t_baseproperty t5 on t5.fitemid=t3.fitemid
where t0.fname like '%鼓架%' or t0.fname like '%粉筒%' 
 


select * from t_item where fitemclassid=3003

--海关产品分类
--update t6 set F_108=t5.F_108
--select distinct t3.fnumber,t3.fname,t3.fmodel
--update t12 set fcheckdate='2015-08-21'
--update t15 set flastmoddate='2015-08-21'
--update t12 set FChkUserID=16394
--update t12 set fname=t12.fname+'-粉筒'
--update t6 set fname=t6.fname+'-粉筒'
from t_icitem t3 
inner join icbom t1 on t1.fitemid=t3.fitemid
inner join icbomchild t2 on t1.finterid=t2.finterid
inner join t_icitem t5 on t5.fitemid=t2.fitemid 
inner join t_ICItemCore t6 on t6.fitemid=t3.fitemid
inner join t_item t16 on t16.fitemid=t5.F_108 and t16.fitemclassid=3003
inner join t_item t12 on t12.fitemid=t3.fitemid
inner join t_baseproperty t15 on t15.fitemid=t3.fitemid
where left(t3.fnumber,1) in ('a','p','j','x','y','v') and isnull(t5.F_108,0)<>0 and t16.fname like '粉筒' and t6.fname not like '%粉筒%'
and left(t5.fnumber,1) in ('3','4','5','7','8')
and isnull(t12.FChkUserID,0)<>0 --选择性加这个条件

--海关产品分类
--update t6 set F_108=t5.F_108
--select distinct t3.fnumber,t3.fname,t3.fmodel
--update t12 set fcheckdate='2015-08-21'
--update t15 set flastmoddate='2015-08-21'
--update t12 set FChkUserID=16394
--update t12 set fname=t12.fname+'-鼓架'
--update t6 set fname=t6.fname+'-鼓架'
from t_icitem t3 
inner join icbom t1 on t1.fitemid=t3.fitemid
inner join icbomchild t2 on t1.finterid=t2.finterid
inner join t_icitem t5 on t5.fitemid=t2.fitemid 
inner join t_ICItemCore t6 on t6.fitemid=t3.fitemid
inner join t_item t16 on t16.fitemid=t5.F_108 and t16.fitemclassid=3003
inner join t_item t12 on t12.fitemid=t3.fitemid
inner join t_baseproperty t15 on t15.fitemid=t3.fitemid
where left(t3.fnumber,1) in ('a','p','j','x','y','v') and isnull(t5.F_108,0)<>0 and t16.fname like '鼓架' and t6.fname not like '%鼓架%'
and left(t5.fnumber,1) in ('3','4','5','7','8')
and isnull(t12.FChkUserID,0)<>0 --选择性加这个条件

select t3.fnumber,t3.fname,t3.fmodel,t5.FLastModDate,t11.fname+'[计划禁用]'
--update t11 set fname=t11.fname+'[计划禁用]'
--update t0 set fname=t0.fname+'[计划禁用]'
--update t2 set fcheckdate='2015-03-12'
--update t5 set flastmoddate='2015-03-12'
--update t2 set FChkUserID=16394
from t_icitem t3
inner join t_ICItemCore t0 on t0.fitemid=t3.fitemid
inner join t_item t11 on t11.fitemid=t0.fitemid
inner join t_item t2 on t2.fitemid=t3.fitemid
left join t_baseproperty t5 on t5.fitemid=t3.fitemid
where left(t3.fnumber,4) in ('a.02','a.03','a.04','p.02','p.03','p.04','j.02','j.03','j.04','x.02','x.03','x.04','y.02','y.03','y.04','v.b.')
and t3.fname not like '%禁用%' --and t3.fname like '%傲威中性粉盒%'
and isnull(t3.F_125,'')=''

select fnumber,fname,fmodel,* 
from t_icitem t3
where fname like '%鼓架%' and left(t3.fnumber,1) in ('a','p','j','x','y')
order by t3.fnumber

select fnumber,fname,fmodel,* 
from t_icitem t3
where fname like '%鼓架%' and left(t3.fnumber,1) in ('y')
order by t3.fnumber

select t3.fnumber,t3.fname,t3.fmodel,t11.fname,t5.FLastModDate,replace(t3.fname,'配-','配-鼓架-')
--update t2 set fcheckdate='2015-05-21'
--update t5 set flastmoddate='2015-05-21'
--update t2 set FChkUserID=16394
--update t2 set fname=replace(t2.fname,'配-','配-鼓架-')
--update t0 set fname=replace(t0.fname,'配-','配-鼓架-')
from t_icitem t3
inner join t_ICItemCore t0 on t0.fitemid=t3.fitemid
inner join t_item t11 on t11.fitemid=t3.fparentid
inner join t_item t2 on t2.fitemid=t3.fitemid
left join t_baseproperty t5 on t5.fitemid=t3.fitemid
inner join icbom t21 on t21.fitemid=t3.fitemid
inner join icbomchild t22 on t21.finterid=t22.finterid
inner join t_icitem t23 on t23.fitemid=t22.fitemid
where t3.fnumber like 'v.b.%' and t0.fname not like '%鼓架%' 
and t23.fitemid in 
(
	select t23.fitemid
	from t_icitem t3
	inner join icbom t21 on t21.fitemid=t3.fitemid
	inner join icbomchild t22 on t21.finterid=t22.finterid
	inner join t_icitem t23 on t23.fitemid=t22.fitemid
	where t3.fname like '%鼓架%' and left(t3.fnumber,1) in ('a','p','j','x','y') and left(t23.fnumber,1) in ('3','4','5','7','8')

)

select t3.fnumber,t3.fname,t3.fmodel,t11.fname,t5.FLastModDate,replace(t3.fname,'配','配-粉筒')
--update t2 set fcheckdate='2015-05-23'
--update t5 set flastmoddate='2015-05-23'
--update t2 set FChkUserID=16394
--update t2 set fname=replace(t2.fname,'配','配-粉筒')
--update t0 set fname=replace(t0.fname,'配','配-粉筒')
--update t2 set fname=t2.fname+'-粉筒'
--update t0 set fname=t0.fname+'-粉筒'
from t_icitem t3
inner join t_ICItemCore t0 on t0.fitemid=t3.fitemid
inner join t_item t11 on t11.fitemid=t3.fparentid
inner join t_item t2 on t2.fitemid=t3.fitemid
left join t_baseproperty t5 on t5.fitemid=t3.fitemid
inner join sheet82$ t23 on t23.编码=t3.fnumber
where t0.fname not like '%粉筒%' 
and t23.粉筒='Y' 

select t3.fnumber,t3.fname,t3.fmodel,t11.fname,t5.FLastModDate,replace(t3.fname,'配','配-鼓架')
--update t2 set fcheckdate='2015-05-23'
--update t5 set flastmoddate='2015-05-23'
--update t2 set FChkUserID=16394
--update t2 set fname=replace(t2.fname,'配','配-鼓架')
--update t0 set fname=replace(t0.fname,'配','配-鼓架')
--update t2 set fname=t2.fname+'-鼓架'
--update t0 set fname=t0.fname+'-鼓架'
from t_icitem t3
inner join t_ICItemCore t0 on t0.fitemid=t3.fitemid
inner join t_item t11 on t11.fitemid=t3.fparentid
inner join t_item t2 on t2.fitemid=t3.fitemid
left join t_baseproperty t5 on t5.fitemid=t3.fitemid
inner join sheet82$ t23 on t23.编码=t3.fnumber
where t0.fname not like '%鼓架%' 
and t23.鼓架='Y' 



select t3.fnumber,t3.fname,t3.fmodel,t11.fname,t5.FLastModDate,replace(t3.fname,'配','配-鼓架')
--update t2 set fcheckdate='2015-05-23'
--update t5 set flastmoddate='2015-05-23'
--update t2 set FChkUserID=16394
--update t2 set fname=replace(t2.fname,'配','配-鼓架')
--update t0 set fname=replace(t0.fname,'配','配-鼓架')
--update t2 set fname=t2.fname+'-鼓架'
--update t0 set fname=t0.fname+'-鼓架'
from t_icitem t3
inner join t_ICItemCore t0 on t0.fitemid=t3.fitemid
inner join t_item t11 on t11.fitemid=t3.fparentid
inner join t_item t2 on t2.fitemid=t3.fitemid
left join t_baseproperty t5 on t5.fitemid=t3.fitemid
inner join sheet311$ t23 on t23.编码=t3.fnumber
where t0.fname not like '%鼓架%' 
and t23.鼓架='Y' 



select t3.fnumber,t3.fname,t3.fmodel,t11.fname,t5.FLastModDate,replace(t3.fname,'配-','配-粉筒-')
--update t2 set fcheckdate='2015-05-25'
--update t5 set flastmoddate='2015-05-25'
--update t2 set FChkUserID=16394
--update t2 set fname=replace(t2.fname,'配-','配-粉筒-')
--update t0 set fname=replace(t0.fname,'配-','配-粉筒-')
--update t2 set fname=t2.fname+'-粉筒'
--update t0 set fname=t0.fname+'-粉筒'
from t_icitem t3
inner join t_ICItemCore t0 on t0.fitemid=t3.fitemid
inner join t_item t11 on t11.fitemid=t3.fparentid
inner join t_item t2 on t2.fitemid=t3.fitemid
left join t_baseproperty t5 on t5.fitemid=t3.fitemid
inner join icbom t21 on t21.fitemid=t3.fitemid
inner join icbomchild t22 on t21.finterid=t22.finterid
inner join t_icitem t23 on t23.fitemid=t22.fitemid
where t0.fname not like '%粉筒%' and left(t23.fnumber,1) in ('3','4','5','7','8') and t23.fname like '%粉筒%' 
and left(t3.fnumber,1) in ('a','p','j','x','y','v')
-- (
-- 	select t23.fitemid
-- 	from t_icitem t3
-- 	inner join icbom t21 on t21.fitemid=t3.fitemid
-- 	inner join icbomchild t22 on t21.finterid=t22.finterid
-- 	inner join t_icitem t23 on t23.fitemid=t22.fitemid
-- 	where t23.fname like '%粉筒%' and left(t3.fnumber,1) in ('a','p','j','x','y','v') and left(t23.fnumber,1) in ('3','4','5','7','8')
-- )



select t3.fnumber,t3.fname,t3.fmodel,t11.fname,t5.FLastModDate,replace(t3.fname,'配-','配-鼓架-')
--update t2 set fcheckdate='2015-05-25'
--update t5 set flastmoddate='2015-05-25'
--update t2 set FChkUserID=16394
--update t2 set fname=replace(t2.fname,'配-','配-鼓架-')
--update t0 set fname=replace(t0.fname,'配-','配-鼓架-')
--update t2 set fname=t2.fname+'-鼓架'
--update t0 set fname=t0.fname+'-鼓架'
from t_icitem t3
inner join t_ICItemCore t0 on t0.fitemid=t3.fitemid
inner join t_item t11 on t11.fitemid=t3.fparentid
inner join t_item t2 on t2.fitemid=t3.fitemid
left join t_baseproperty t5 on t5.fitemid=t3.fitemid
inner join icbom t21 on t21.fitemid=t3.fitemid
inner join icbomchild t22 on t21.finterid=t22.finterid
inner join t_icitem t23 on t23.fitemid=t22.fitemid
where t0.fname not like '%鼓架%' and left(t23.fnumber,1) in ('3','4','5','7','8') and t23.fname like '%鼓架%' 
and left(t3.fnumber,1) in ('a','p','j','x','y','v')
-- (
-- 	select t23.fitemid
-- 	from t_icitem t3
-- 	inner join icbom t21 on t21.fitemid=t3.fitemid
-- 	inner join icbomchild t22 on t21.finterid=t22.finterid
-- 	inner join t_icitem t23 on t23.fitemid=t22.fitemid
-- 	where t23.fname like '%鼓架%' and left(t3.fnumber,1) in ('a','p','j','x','y','v') and left(t23.fnumber,1) in ('3','4','5','7','8')
-- )



select t3.fnumber,t3.fname,t3.fmodel,t11.fname,t5.FLastModDate,replace(t3.fname,'配-','配-鼓架-')
--update t2 set fcheckdate='2015-05-23'
--update t5 set flastmoddate='2015-05-23'
--update t2 set FChkUserID=16394
--update t2 set fname=replace(t2.fname,'配-','配-鼓架-')
--update t0 set fname=replace(t0.fname,'配-','配-鼓架-')
--update t2 set fname=t2.fname+'-鼓架'
--update t0 set fname=t0.fname+'-鼓架'
from t_icitem t3
inner join t_ICItemCore t0 on t0.fitemid=t3.fitemid
inner join t_item t11 on t11.fitemid=t3.fparentid
inner join t_item t2 on t2.fitemid=t3.fitemid
left join t_baseproperty t5 on t5.fitemid=t3.fitemid
inner join icbom t21 on t21.fitemid=t3.fitemid
inner join icbomchild t22 on t21.finterid=t22.finterid
inner join t_icitem t23 on t23.fitemid=t22.fitemid
where t0.fname not like '%鼓架%' 
and t23.fitemid in 
(
	select t23.fitemid
	from t_icitem t3
	inner join icbom t21 on t21.fitemid=t3.fitemid
	inner join icbomchild t22 on t21.finterid=t22.finterid
	inner join t_icitem t23 on t23.fitemid=t22.fitemid
	where t23.fname like '%鼓架%' and left(t3.fnumber,1) in ('a','p','j','x','y') and left(t23.fnumber,1) in ('3','4','5','7','8')
)


select t3.fnumber,t3.fname,t3.fmodel,t11.fname,t5.FLastModDate,replace(t3.fname,'配-','配-粉筒-')
--update t2 set fcheckdate='2015-05-21'
--update t5 set flastmoddate='2015-05-21'
--update t2 set FChkUserID=16394
--update t2 set fname=replace(t2.fname,'配-','配-粉筒-')
--update t0 set fname=replace(t0.fname,'配-','配-粉筒-')
from t_icitem t3
inner join t_ICItemCore t0 on t0.fitemid=t3.fitemid
inner join t_item t11 on t11.fitemid=t3.fparentid
inner join t_item t2 on t2.fitemid=t3.fitemid
left join t_baseproperty t5 on t5.fitemid=t3.fitemid
inner join icbom t21 on t21.fitemid=t3.fitemid
inner join icbomchild t22 on t21.finterid=t22.finterid
inner join t_icitem t23 on t23.fitemid=t22.fitemid
where t3.fnumber like 'v.b.%' and t0.fname not like '%粉筒%' 
and t23.fitemid in 
(
	select t23.fitemid
	from t_icitem t3
	inner join icbom t21 on t21.fitemid=t3.fitemid
	inner join icbomchild t22 on t21.finterid=t22.finterid
	inner join t_icitem t23 on t23.fitemid=t22.fitemid
	where t3.fname like '%粉筒%' and left(t3.fnumber,1) in ('a','p','j','x','y') and left(t23.fnumber,1) in ('3','4','5','7','8')

)

select t23.fnumber,t23.fname,t23.fmodel,t11.fname,t5.FLastModDate,replace(t23.fname,'配-','配-粉筒-')
--select distinct t23.fnumber into #data1
--update t2 set fcheckdate='2015-05-21'
--update t5 set flastmoddate='2015-05-21'
--update t2 set FChkUserID=16394
--update t2 set fname=replace(t2.fname,'配-','配-粉筒-')
--update t0 set fname=replace(t0.fname,'配-','配-粉筒-')
from t_icitem t3
inner join icbom t21 on t21.fitemid=t3.fitemid
inner join icbomchild t22 on t21.finterid=t22.finterid
inner join t_icitem t23 on t23.fitemid=t22.fitemid
inner join t_ICItemCore t0 on t0.fitemid=t23.fitemid
inner join t_item t2 on t2.fitemid=t23.fitemid
inner join t_item t11 on t11.fitemid=t23.fparentid
left join t_baseproperty t5 on t5.fitemid=t23.fitemid
where left(t3.fnumber,1) in ('a','p','j','x','y','v') and t3.fname like '%粉筒%' 
and left(t23.fnumber,1) in ('3','4','5','7','8')

select t23.fnumber,t23.fname,t23.fmodel,t11.fname,t5.FLastModDate,replace(t23.fname,'配-','配-鼓架-')
--select distinct t23.fnumber into #data2
--update t2 set fcheckdate='2015-05-21'
--update t5 set flastmoddate='2015-05-21'
--update t2 set FChkUserID=16394
--update t2 set fname=replace(t2.fname,'配-','配-鼓架-')
--update t0 set fname=replace(t0.fname,'配-','配-鼓架-')
from t_icitem t3
inner join icbom t21 on t21.fitemid=t3.fitemid
inner join icbomchild t22 on t21.finterid=t22.finterid
inner join t_icitem t23 on t23.fitemid=t22.fitemid
inner join t_ICItemCore t0 on t0.fitemid=t23.fitemid
inner join t_item t2 on t2.fitemid=t23.fitemid
inner join t_item t11 on t11.fitemid=t23.fparentid
left join t_baseproperty t5 on t5.fitemid=t23.fitemid
where left(t3.fnumber,1) in ('a','p','j','x','y','v') and t3.fname like '%鼓架%' 
and left(t23.fnumber,1) in ('3','4','5','7','8')

select t23.fnumber 编码,t23.fname 名称,t3.ffullname 全称,isnull(t23.fmodel,'/') 规格型号,isnull(t23.f_105,'/') 描述,isnull(t4.fname,'/') 项目经理,
(case when isnull(t1.fnumber,'')<>'' then 'Y' else '' end ) 粉筒,
(case when isnull(t2.fnumber,'')<>'' then 'Y' else '' end ) 鼓架
from t_icitem t23
left join #data1 t1 on t23.fnumber=t1.fnumber
left join #data2 t2 on t23.fnumber=t2.fnumber
inner join t_item t3 on t3.fitemid=t23.fitemid
left join t_submessage t4 on t23.f_128=t4.finterid
where left(t23.fnumber,1) in ('3','4','5','7','8')
order by t23.fnumber

select t3.fnumber,t3.fname,t3.fmodel,t11.fname,t5.FLastModDate,replace(t3.fname,'配-','配-粉筒-')
--update t2 set fname=replace(t2.fname,'配-','配-粉筒-')
--update t0 set fname=replace(t0.fname,'配-','配-粉筒-')
--update t2 set fcheckdate='2015-05-21'
--update t5 set flastmoddate='2015-05-21'
--update t2 set FChkUserID=16394
from t_icitem t3
inner join t_ICItemCore t0 on t0.fitemid=t3.fitemid
inner join t_item t11 on t11.fitemid=t3.fparentid
inner join t_item t2 on t2.fitemid=t3.fitemid
left join t_baseproperty t5 on t5.fitemid=t3.fitemid
where t3.fnumber like 'Y%' and t0.fname not like '%鼓架%' and t0.fname not like '%粉筒%' 


select t3.fnumber,t3.fname,t3.fmodel,t11.fname,t5.FLastModDate,replace(t3.fname,'配-','配-鼓架-')
--update t2 set fname=replace(t2.fname,'配-','配-鼓架-')
--update t0 set fname=replace(t0.fname,'配-','配-鼓架-')
--update t2 set fcheckdate='2015-03-31'
--update t5 set flastmoddate='2015-03-31'
--update t2 set FChkUserID=16394
from t_icitem t3
inner join t_ICItemCore t0 on t0.fitemid=t3.fitemid
inner join t_item t11 on t11.fitemid=t3.fparentid
inner join t_item t2 on t2.fitemid=t3.fitemid
left join t_baseproperty t5 on t5.fitemid=t3.fitemid
where t3.fnumber like 'Y%' and t0.fname not like '%鼓架%' 

select t2.fnumber,t2.fname,t2.fmodel,t3.fnumber,t3.fname,t3.fmodel,t4.fprice
from
(
	select distinct t1.fitemid,
	(
		select top 1 m4.fitemid 
		from t_icitem m1 
		inner join icbomchild m2 on m1.fitemid=m2.fitemid
		inner join icbom m3 on m2.finterid=m3.finterid
		inner join t_icitem m4 on m3.fitemid=m4.fitemid
		where m4.fnumber like '5.%' and m4.fname like '%拆盒%' and m1.fitemid=t5.fitemid 
	) fchiheitemid
	from t_icitem t1
	inner join icbomchild t2 on t1.fitemid=t2.fitemid
	inner join icbom t3 on t1.fitemid=t3.fitemid
	inner join icbomchild t4 on t4.finterid=t3.finterid
	inner join t_icitem t5 on t5.fitemid=t4.fitemid
	where t1.fnumber like '5.%' and t1.fname not like '%拆盒%' and t5.fnumber like '1.02.%'
) t1 inner join t_icitem t2 on t1.fitemid=t2.fitemid
left join t_icitem t3 on t3.fitemid=t1.fchiheitemid
left join t_supplyentry t4 on t4.fitemid=t1.fchiheitemid
order by t2.fnumber


select distinct t1.fnumber,t1.fname,t1.fmodel
from t_icitem t1
inner join icbomchild t2 on t1.fitemid=t2.fitemid
where t1.fnumber like '5.%' and t1.fname not like '%拆盒%' and t1.fitemid not in 
(
	select t1.fitemid
	from t_icitem t1
	inner join icbomchild t2 on t1.fitemid=t2.fitemid
	inner join icbom t3 on t1.fitemid=t3.fitemid
	inner join icbomchild t4 on t4.finterid=t3.finterid
	inner join t_icitem t5 on t5.fitemid=t4.fitemid
	where t1.fnumber like '5.%' and t1.fname not like '%拆盒%' and t5.fnumber like '1.02.%'
)

select t2.fnumber,t2.fname,t2.fmodel,t3.fnumber,t3.fname,t3.fmodel,t4.fprice
from
(
	select distinct t1.fitemid,(select top 1 fitemid from t_icitem where fparentid=t1.fparentid and fname like '%拆盒%' ) fchiheitemid
	from t_icitem t1
	inner join icbomchild t2 on t1.fitemid=t2.fitemid
	where t1.fnumber like '5.%' and t1.fname not like '%拆盒%'
) t1 inner join t_icitem t2 on t1.fitemid=t2.fitemid
left join t_icitem t3 on t3.fitemid=t1.fchiheitemid
left join t_supplyentry t4 on t4.fitemid=t1.fchiheitemid
order by t2.fnumber

select t3.fnumber,t3.fname,t3.fmodel,t11.fname,t5.FLastModDate,replace(t3.fname,'配-','配-鼓架-')
--update t2 set fname=replace(t2.fname,'配-','配-鼓架-')
--update t0 set fname=replace(t0.fname,'配-','配-鼓架-')
--update t2 set fcheckdate='2015-03-31'
--update t5 set flastmoddate='2015-03-31'
--update t2 set FChkUserID=16394
from t_icitem t3
inner join t_ICItemCore t0 on t0.fitemid=t3.fitemid
inner join t_item t11 on t11.fitemid=t3.fparentid
inner join t_item t2 on t2.fitemid=t3.fitemid
left join t_baseproperty t5 on t5.fitemid=t3.fitemid
where left(t3.fnumber,1) in ('a','p','j','x','y')
and t3.fname not like '%禁用%' --and t3.fname like '%傲威中性粉盒%'
and t11.fname like '%dr%'

select t1.fitemid,t3.f_127
--update t3 set f_127=t1.fitemid
from
(
	select fitemid,max(fbanitemid) fbanitemid,max(fxinitemid) fxinitemid
	from
	(
		select t1.fitemid,
		case when left(t4.fnumber,1) in ('3','4','5','7','8') then t4.fitemid else 0 end fbanitemid,
		case when left(t4.fnumber,10) in ('1.01.0010.') then t4.fitemid else 0 end fxinitemid
		from t_icitem t1
		inner join icbom t2 on t1.fitemid=t2.fitemid
		inner join icbomchild t3 on t2.finterid=t3.finterid
		inner join t_icitem t4 on t3.fitemid=t4.fitemid
		where left(t1.fnumber,4) in ('a.01','p.01','j.01','x.01','y.01') and t1.fname not like '%禁用%' and t1.fdeleted=0
	) t1 group by t1.fitemid
) t1 inner join
( 
	select fitemid,max(fbanitemid) fbanitemid,max(fxinitemid) fxinitemid
	from
	(
		select t1.fitemid,
		case when left(t4.fnumber,1) in ('3','4','5','7','8') then t4.fitemid else 0 end fbanitemid,
		case when left(t4.fnumber,10) in ('1.01.0010.') then t4.fitemid else 0 end fxinitemid
		from t_icitem t1
		inner join icbom t2 on t1.fitemid=t2.fitemid
		inner join icbomchild t3 on t2.finterid=t3.finterid
		inner join t_icitem t4 on t3.fitemid=t4.fitemid
		where left(t1.fnumber,4) in ('v.b.') --and t1.fname not like '%禁用%' and t1.fdeleted=0
	) t1 group by t1.fitemid
) t2 on t1.fbanitemid=t2.fbanitemid --and t1.fxinitemid=t2.fxinitemid
inner join t_ICItemCustom t3 on t3.fitemid=t2.fitemid
where isnull(t3.f_126,0)<>40019 and isnull(t3.f_127,0)=0
select distinct t1.fitemid,t3.f_127
--update t3 set f_127=t1.fitemid
from
(
	select fitemid,max(fbanitemid) fbanitemid,max(fxinitemid) fxinitemid
	from
	(
		select t1.fitemid,
		case when left(t4.fnumber,1) in ('3','4','5','7','8') then t4.fitemid else 0 end fbanitemid,
		case when left(t4.fnumber,10) in ('1.01.0010.') then t4.fitemid else 0 end fxinitemid
		from t_icitem t1
		inner join icbom t2 on t1.fitemid=t2.fitemid
		inner join icbomchild t3 on t2.finterid=t3.finterid
		inner join t_icitem t4 on t3.fitemid=t4.fitemid
		where left(t1.fnumber,4) in ('a.01','p.01','j.01','x.01','y.01') and t1.fname not like '%禁用%' and t1.fdeleted=0
	) t1 group by t1.fitemid
) t1 inner join
( 
	select fitemid,max(fbanitemid) fbanitemid,max(fxinitemid) fxinitemid
	from
	(
		select t1.fitemid,
		case when left(t4.fnumber,1) in ('3','4','5','7','8') then t4.fitemid else 0 end fbanitemid,
		case when left(t4.fnumber,10) in ('1.01.0010.') then t4.fitemid else 0 end fxinitemid
		from t_icitem t1
		inner join icbom t2 on t1.fitemid=t2.fitemid
		inner join icbomchild t3 on t2.finterid=t3.finterid
		inner join t_icitem t4 on t3.fitemid=t4.fitemid
		where left(t1.fnumber,4) in ('v.b.') --and t1.fname not like '%禁用%' and t1.fdeleted=0
		and t1.fshortnumber not in (select 产品代码 from sheet93$) 
		--and t1.fshortnumber not in  (select * from sheet91$ where 核准后半成品代码)
	) t1 group by t1.fitemid
) t2 on t1.fbanitemid=t2.fbanitemid --and t1.fxinitemid=t2.fxinitemid
inner join t_ICItemCustom t3 on t3.fitemid=t2.fitemidinner join t_icitem t4 on t3.fitemid=t4.fitemid
where isnull(t3.f_126,0)=40019 --and isnull(t3.f_127,0)=0


select t1.fnumber 编码,t1.fname 名称,t1.fmodel 规格型号,isnull(t5.fprice,0) 售价,isnull(t4.fname,t14.fname) 项目经理,
isnull(t12.fname,'') 是否引擎,isnull(t11.fnumber,'') 引擎编码,isnull(t11.fname,'') 引擎名称,isnull(t11.fmodel,'') 引擎规格型号,
isnull(t2.fprice,0) 引擎售价
from t_icitem t1 
inner join t_ICItemCustom t3 on t1.fitemid=t3.fitemid
left join t_submessage t4 on t1.f_128=t4.finterid
left join t_icitem t11 on t11.fitemid=t1.f_127
left join t_submessage t12 on t12.finterid=t1.f_126
left join icbom t13 on t13.fitemid=t1.fitemid
left join t_submessage t14 on t14.finterid=t13.fheadselfz0134
left join IcPrcPlyEntry t2 on t2.fitemid=t11.fitemid
left join IcPrcPlyEntry t5 on t5.fitemid=t1.fitemid
WHERE t1.fnumber like '%@@ItemNumber@@%'


select t1.fnumber 编码,t1.fname 名称,t1.fmodel 规格型号,isnull(t4.fname,t14.fname) 项目经理,
isnull(t12.fname,'') 是否引擎,isnull(t11.fnumber,'') 引用引擎编码,isnull(t11.fname,'') 引用引擎名称,isnull(t11.fmodel,'') 引用引擎规格型号
--update t3 set f_126=0
from t_icitem t1 
inner join t_ICItemCustom t3 on t1.fitemid=t3.fitemid
left join t_submessage t4 on t1.f_128=t4.finterid
left join t_icitem t11 on t11.fitemid=t1.f_127
left join t_submessage t12 on t12.finterid=t1.f_126
left join icbom t13 on t13.fitemid=t1.fitemid
left join t_submessage t14 on t14.finterid=t13.fheadselfz0134
where isnull(t1.f_126,0) not in (40020,0) and isnull(t1.f_127,0)<>0
and t11.fnumber like 'y.01%'
and t1.fshortnumber not in (select 产品代码 from sheet93$) 
and t1.fnumber not in  (select 产品编码 from sheet91$ where 核准后半成品代码=半成品编码)


select t1.fnumber 代码,t1.fname 名称,t1.fmodel 规格型号,isnull(t4.fname,t14.fname) 项目经理,
isnull(t12.fname,'') 是否引擎,isnull(t11.fnumber,'') 对应引擎,'未指定' 备注
from t_icitem t1 
inner join t_ICItemCustom t3 on t1.fitemid=t3.fitemid
left join t_submessage t4 on t1.f_128=t4.finterid
left join t_icitem t11 on t11.fitemid=t1.f_127
left join t_submessage t12 on t12.finterid=t1.f_126
left join icbom t13 on t13.fitemid=t1.fitemid
left join t_submessage t14 on t14.finterid=t13.fheadselfz0134
where left(t1.fnumber,1) in('a','p','x','y','j','v') 
and isnull(t1.f_126,0) in (40020,0) and isnull(t1.f_127,0)=0
union all
select t1.fnumber 代码,t1.fname 名称,t1.fmodel 规格型号,isnull(t4.fname,t14.fname) 项目经理,
isnull(t12.fname,'') 是否引擎,isnull(t11.fnumber,'') 对应引擎,'重复'  备注
from t_icitem t1 
inner join t_ICItemCustom t3 on t1.fitemid=t3.fitemid
left join t_submessage t4 on t1.f_128=t4.finterid
left join t_icitem t11 on t11.fitemid=t1.f_127
left join t_submessage t12 on t12.finterid=t1.f_126
left join icbom t13 on t13.fitemid=t1.fitemid
left join t_submessage t14 on t14.finterid=t13.fheadselfz0134
where left(t1.fnumber,1) in('a','p','x','y','j','v') 
and isnull(t1.f_126,0)=40019 and isnull(t1.f_127,0)<>0
union all
select t1.fnumber 代码,t1.fname 名称,t1.fmodel 规格型号,isnull(t4.fname,t14.fname) 项目经理,
isnull(t12.fname,'') 是否引擎,isnull(t11.fnumber,'') 对应引擎,'错误指定'  备注
from t_icitem t1 
inner join t_ICItemCustom t3 on t1.fitemid=t3.fitemid
left join t_submessage t4 on t1.f_128=t4.finterid
left join t_icitem t11 on t11.fitemid=t1.f_127
left join t_submessage t12 on t12.finterid=t1.f_126
left join icbom t13 on t13.fitemid=t1.fitemid
left join t_submessage t14 on t14.finterid=t13.fheadselfz0134
where left(t1.fnumber,1) in('a','p','x','y','j','v') 
and isnull(t1.f_127,0)<>0 and not exists(select 1 from t_icitem where fitemid=t1.f_127 and isnull(f_126,0)=40019)
order by 备注,代码
select *
--update t1 set 核准后半成品代码=t2.fnumber
from sheet91$ t1
inner join t_icitem t2 on t1.核准后半成品代码=t2.fshortnumber


select t1.fnumber,t1.fname,t1.fmodel,t4.fnumber,t4.fname,t4.fmodel,t3.f_125,t1.fdeleted,t7.fitemid
--update t3 set f_126=40019
--update t3 set f_127=0
from t_icitem t1 
inner join t_ICItemCustom t3 on t1.fitemid=t3.fitemid
inner join icbom t7 on t7.fitemid=t1.fitemid
inner join icbomchild t2 on t2.finterid=t7.finterid
inner join t_icitem t4 on t4.fitemid=t2.fitemid
where left(t4.fnumber,1) in ('7','8') and left(t1.fnumber,4) in ('v.b.') --,
and isnull(t3.f_126,0)<>40019 and isnull(t3.f_126,0)=0 and t1.fname not like '%禁用%'


select t1.fshortnumber 短代码,t1.fnumber 长代码,t1.fname 产品名称,t3.ffullname 全称,t1.fmodel 规格型号,
isnull(t1.f_105,'') 描述,isnull(t1.f_106,'') 适用机型,isnull(t1.F_107,'') 适用区域,
(case when isnull(t1.F_109,'')='' then '0*0*0' else t1.F_109 end) [标准外箱尺寸(mm)],
(case when isnull(t1.F_111,'')='' then '0*0*0' else t1.F_111 end) [标准外盒尺寸(mm)],
cast(isnull(t1.F_112,0) as decimal(24,2)) [整箱净重(kg)],cast(isnull(t1.F_119,0) as decimal(24,2)) [整箱毛重(kg)],isnull(t1.F_110,0) 标准装箱数,
(case when isnull(t1.F_120,'')='' then '0*0*0' else t1.F_120 end) [裸包标准外箱尺寸(mm)],
isnull(t1.F_122,0) [裸包整箱净重(kg)],isnull(t1.F_123,0) [裸包整箱毛重(kg)],isnull(t1.F_121,0) 裸包标准装箱数,
(case when isnull(t13.fname,'')='' then '小' else t13.fname end) 外盒尺寸,isnull(t14.fname,'') 打印机品牌,isnull(t8.fshortname,'') 主供应商,
(case when t1.fdeleted=1 then 'Y' else '' end) 禁用,t9.fname 单位,isnull(t5.fname,'') 物料分类,
(case when t1.F_126=40019 then 'Y' else '' end) 是否引擎,(case when t1.F_126=40019 then '' else isnull(t7.fnumber,'') end) 引用引擎,t1.F_125,
replace(convert(varchar(10),isnull(t2.flastmoddate,t2.fcreatedate),111),'/','-') 修改日期,isnull(t4.fname,'') 审核人--,
--t2.fcreatedate 创建时间,t2.fcreateuser 创建人,t2.flastmoddate 最后修改时间,t2.flastmoduser 最后修改人,t2.fdeletedate 禁用时间,t2.fdeleteuser 禁用人
from t_icitem t1
inner join t_baseproperty t2 on t1.fitemid=t2.fitemid
left join t_item t13 on t13.fitemid=t1.F_103 and t13.fitemclassid=3004  --外盒尺寸  --select * from t_item where fitemclassid=3004
left join t_SubMessage t14 on t14.finterid=t1.F_102  --打印机品牌
inner join t_item t3 on t3.fitemid=t1.fitemid
left join t_user t4 on t4.fuserid=t3.FChkUserID and t4.fuserid<>0
left join t_supplier t8 on t8.fitemid=t1.F_117 --t3.fsource
inner join t_measureunit t9 on t9.FItemID=t1.funitid
left join t_submessage t5 on t5.finterid=t1.ftypeid
left join t_icitem t7 on t7.fitemid=t1.F_127
left join icbom t11 on t11.fitemid=t1.fitemid
where left(t1.fnumber,1) in (select fitemtype from v_myitemtype where ftype=0)
and left(t1.fnumber,4) not in('V.A.','V.C.','V.D.','V.E.','v.b.') and t1.fmodel like '%c-dr720/3300/3302%'
--and t11.fitemid is null 
and t1.fname not like '%禁用%'
order by t1.fnumber

select * from t_itempropdesc where fitemclassid=4  F_109  F_111

select *
--update t1 set 核准后半成品代码=t2.fnumber
from sheet91$ t1
inner join t_icitem t2 on t1.核准后半成品代码=t2.fshortnumber



--modify at 2015-03-28
select t1.fnumber,t1.fname,t1.fmodel,t4.fnumber,t4.fname,t4.fmodel,t3.f_125,t1.fdeleted,t5.FLastModDate,t7.fitemid
--update t3 set f_126=0
--update t3 set f_127=t4.fitemid
from t_icitem t1 
inner join t_ICItemCustom t3 on t1.fitemid=t3.fitemid
left join t_submessage t2 on t1.f_126=t2.finterid 
inner join t_icitem t4 on t4.fmodel=t1.fmodel and t4.fitemid<>t1.fitemid
left join t_baseproperty t5 on t5.fitemid=t1.fitemid
left join icbom t7 on t7.fitemid=t1.fitemid
where left(t4.fnumber,4) in ('a.01','p.01','j.01','x.01','y.01')  --('v.b.')
and left(t1.fnumber,4) in ('v.b.')
--and isnull(t3.f_126,0)<>40019
--and t3.f_127=0 
and t4.fname not like '%禁用%'




set nocount on

select --identity(int,1,1) as 序号,
distinct isnull(t1.f_126,0),
t2.fname as 项目经理,isnull(t8.fshortname,'') 主供应商,t3.fbomnumber BOM编号,
t1.fnumber 代码,t1.fname 名称,t1.fmodel 规格,t1.f_105 描述,t1.f_106 适用机型,t1.f_107 适用区域,t5.fnumber 半成品编码,t5.fname 半成品名称,t15.fprice 半成品采购单价 
--into #ls
from t_icitem t1 
left JOIN t_submessage t2 ON t1.f_128=t2.finterid
left join t_supplier t8 on t8.fitemid=t1.F_117 --t3.fsource
inner join icbom t3 on t3.fitemid=t1.fitemid
inner join icbomchild t4 on t3.finterid=t4.finterid
inner join t_icitem t5 on t4.fitemid=t5.fitemid and left(t5.fnumber,1) in ('3','4','5','7','8')
left join (select fitemid,max(fentryid) fentryid from t_supplyentry group by fitemid) t14 on t5.fitemid=t14.fitemid
left join t_supplyentry t15 on t14.fitemid=t15.fitemid and t14.fentryid=t15.fentryid
WHERE t1.fshortnumber='VB05457' and --left(t1.fnumber,5) in ('a.01.','p.01.','j.01.','x.01.','y.01.') 
isnull(t1.f_126,0)=40019
and t1.fitemid not in(select fitemid from IcPrcPlyEntry) 
AND t1.fname not like '%禁用%'
and left(t1.fnumber,4) not in('V.A.','V.C.','V.D.','V.E.')
ORDER by t2.fname,t1.fnumber

-- SELECT * into #lls FROM #ls ORDER BY 序号
-- 
-- insert into #lls
-- SELECT  项目经理,''主供应商,'' BOM编号,count(*) as 代码,'','','','','' FROM #ls group by 项目经理
-- 
-- SELECT * FROM #lls order by 项目经理,序号
-- 
-- drop table #ls
-- drop table #lls

set nocount off



select t4.f_126,t4.f_127,t1.*
--update t4 set f_126=40019
--update t4 set f_127=0
from sheet93$ t1
inner join t_icitem t3 on t1.产品代码=t3.fshortnumber
inner join t_ICItemCustom t4 on t3.fitemid=t4.fitemid
where t1.产品代码='VB05457'

select * from sheet93$  VB05457?

select t3.fnumber,t3.f_126,t3.f_127,*
--update t4 set f_126=40019
--update t4 set f_127=0
from sheet91$ t1
--inner join t_icitem t2 on t1.核准后半成品代码=t2.fshortnumber
inner join t_icitem t3 on t1.产品编码=t3.fnumber
inner join t_ICItemCustom t4 on t3.fitemid=t4.fitemid
where t1.半成品编码=t1.核准后半成品代码

select t3.fnumber,t3.f_126,t3.f_127,t8.fnumber,t8.fname,t9.fnumber,t9.fname,t1.半成品编码,t1.核准后半成品代码,t1.*
--update t6 set fitemid=t9.fitemid
--select t1.*
from sheet91$ t1
inner join t_icitem t3 on t1.产品编码=t3.fnumber
inner join icbom t5 on t3.fitemid=t5.fitemid
inner join icbomchild t6 on t5.finterid=t6.finterid
inner join t_icitem t7 on t7.fitemid=t6.fitemid
inner join t_icitem t8 on t1.半成品编码=t8.fnumber and t7.fitemid=t8.fitemid
inner join t_icitem t9 on t1.核准后半成品代码=t9.fnumber
where t1.半成品编码<>t1.核准后半成品代码

select * from sheet91$

select t1.fnumber,t1.fname,t1.fmodel,t2.fname 是否引擎 ,t4.fnumber,t4.fname,t4.fmodel,t3.f_125,t1.fdeleted,t5.FLastModDate,t5.flastmoduser,t7.fitemid
--update t3 set f_126=0
--update t3 set f_127=t4.fitemid
from t_icitem t1 
inner join t_ICItemCustom t3 on t1.fitemid=t3.fitemid
left join t_submessage t2 on t1.f_126=t2.finterid 
left join t_icitem t4 on t4.fnumber=t1.f_125
left join t_baseproperty t5 on t5.fitemid=t1.fitemid
left join icbom t7 on t7.fitemid=t1.fitemid
where --left(t1.fnumber,4) in ('a.01','p.01','j.01','x.01','y.01')  --('v.b.')
left(t1.fnumber,4) in ('a.02','a.03','a.04','p.02','p.03','p.04','j.02','j.03','j.04','x.02','x.03','x.04','y.02','y.03','y.04') --,'v.b.'
and isnull(t3.f_125,'')<>'' --and t1.fmodel like '%c-dr720/3300/3302%'
and t3.f_127<>t4.fitemid
and t1.fname not like '%禁用%'

--标准外箱尺寸(mm)
select t3.fnumber,t3.F_109
--update t2 set F_109='0*0*0'
from t_icitem t3 
inner join t_ICItemCustom t2 on t3.fitemid=t2.fitemid
where isnull(t3.F_109,'') not like '%*%*%'

select t3.fnumber,t3.F_111
--update t2 set F_111='0*0*0'
from t_icitem t3 
inner join t_ICItemCustom t2 on t3.fitemid=t2.fitemid
where isnull(t3.F_111,'') not like '%*%*%'

select distinct t6.fnumber,t6.fname,t6.fmodel--,t1.fnumber,t1.fname,t2.*
from t_ICItem t1
inner join icbom t2 on t1.fitemid=t2.fitemid --and t2.fstatus>0
inner join icbomchild t3 on t2.finterid=t3.finterid
left join icbom t11 on t11.fitemid=t3.fitemid
inner join t_icitem t6 on t6.fitemid=t3.fitemid
where left(t6.fnumber,1) in ('3','4','5') and t11.fitemid is null
and t1.fname not like '%禁用%'


select distinct t6.fnumber,t6.fname,t6.fmodel--,t1.fnumber,t1.fname,t2.*
from t_ICItem t1
inner join icbom t2 on t1.fitemid=t2.fitemid --and t2.fstatus>0
inner join icbomchild t3 on t2.finterid=t3.finterid
inner join t_icitem t6 on t6.fitemid=t3.fitemid
where t1.fname not like '%禁用%' and t6.fname like '%禁用%'

select t2.fnumber,t2.fname,t1.fnote,t1.FStatus,t1.FCheckerID
--Update t1 Set FUseStatus=1072,FStatus = 1, FCheckerID = 16456, FAudDate = Convert(Varchar(10),Getdate(),120), FBeenChecked = 1
from ICBOM t1
inner join t_icitem t2 on t1.fitemid=t2.fitemid
where left(t2.fnumber,4) in ('a.02','a.03','p.02','p.03','j.02','j.03','x.02','x.03','y.02','y.03') 
and isnull(t2.F_125,'')<>'' and isnull(t1.FCheckerID,0)=0 
 and t2.fshortnumber='p22004'

select * from t_user  16456

白盒代码 咖啡盒代码 STARINK代码 傲威中性代码

select t3.fnumber,t3.fname,t3.fmodel,t4.fnumber,t4.fname,t4.fmodel,t8.fnumber,t8.fname,t8.fmodel
--update t6 set fitemid=t8.fitemid
from t_icitem t3 
inner join icbom t5 on t5.fitemid=t3.fitemid
inner join icbomchild t6 on t6.finterid=t5.finterid
inner join t_icitem t4 on t4.fitemid=t6.fitemid
where left(t3.fnumber,4) in ('a.04','p.04','j.04','x.04','y.04') --,'p.02','p.03','p.04','j.02','j.03','j.04','x.02','x.03','x.04','y.02','y.03','y.04'
and isnull(t3.f_125,'')<>''
order by t3.fnumber,t4.fnumber


select t3.fnumber,t3.fname,t3.fmodel,t4.fnumber,t4.fname,t4.fmodel,t8.fnumber,t8.fname,t8.fmodel
--update t6 set fitemid=t8.fitemid
from t_icitem t3 
inner join icbom t5 on t5.fitemid=t3.fitemid
inner join icbomchild t6 on t6.finterid=t5.finterid
inner join t_icitem t4 on t4.fitemid=t6.fitemid
inner join sheet81$ t7 on t7.傲威中性代码=t4.fshortnumber
inner join t_icitem t8 on t8.fshortnumber=t7.咖啡盒代码
where left(t3.fnumber,4) in ('y.03') --,'p.02','p.03','p.04','j.02','j.03','j.04','x.02','x.03','x.04','y.02','y.03','y.04'
and isnull(t3.f_125,'')<>''
order by t3.fnumber,t4.fnumber



select t3.fnumber,t3.fname,t3.fmodel,T5.F_125,replace(t5.f_125,'Y.03','Y.01')
--update t5 set F_125=replace(t5.f_125,'Y.03','Y.01')
from t_icitem t3
inner join t_ICItemCore t0 on t0.fitemid=t3.fitemid
inner join t_item t11 on t11.fitemid=t0.fitemid
inner join t_item t2 on t2.fitemid=t3.fitemid
inner join t_ICItemCustom t5 on t5.fitemid=t3.fitemid
where left(t3.fnumber,4) in ('a.02','a.03','a.04','p.02','p.03','p.04','j.02','j.03','j.04','x.02','x.03','x.04','y.02','y.03','y.04') --,'v.b.'
and t3.fname not like '%禁用%' --and t3.fname like '%傲威中性粉盒%'
and isnull(t3.F_125,'')<>'' and t5.f_125 like 'y.03%'

select t2.fname,t1.* from t_log t1 inner join t_user t2 on t1.fuserid=t2.fuserid where t1.fdescription like '%BC000391%'
---------------------------------------------------------------------------------------------------------------------------------------

declare @fminid int,@fmaxid int,@fentryminid int,@fentrymaxid int,@fpreitemid int
declare @fshortnumber varchar(50),@fparentnumber varchar(50),@fitemid int
declare @fmaxshortnumber varchar(50),@flefttnumber varchar(50),@fnumber varchar(50)

create table #Cursor(FID int identity(1,1),finterid int,fentryid int,fitemid int,FQty decimal(24,2))

set @fparentnumber='Y'

select @fmaxshortnumber=isnull(left('00000',(len('00000')-len((max(cast(right(fshortnumber,5) as int))+1))))+CAST((max(cast(right(fshortnumber,5) as int))+1) as varchar(10)),'00000') 
from t_item where fnumber like @fparentnumber+'%' and fitemclassid=4 and fdetail=1 and fnumber not like '%取消%'

truncate table #Cursor
insert into #Cursor(fitemid)
select t1.fitemid
from t_icitem t1
inner join t_item t13 on t13.fitemid=t1.fitemid 
where left(t1.fnumber,4) in ('Y.02','Y.03','Y.04') --,'p.02','p.03','p.04','j.02','j.03','j.04','x.02','x.03','x.04','y.02','y.03','y.04'

select @fminid=0,@fmaxid=0
select @fminid=isnull(min(fid),0),@fmaxid=isnull(max(fid),0) from #Cursor

WHILE @fmaxid>0 and @fminid<=@fmaxid --@@FETCH_STATUS = 0  --先把可用库存按物料先分配下去
BEGIN 
	select @fitemid=fitemid from #Cursor where fid=@fminid
	select @flefttnumber=left(fnumber,dbo.My_F_Charindex(fnumber,'.',4)) from t_item where fitemid=@fitemid
	
	select @fshortnumber=isnull(left('00000',(len('00000')-len((max(cast(right(@fmaxshortnumber,5) as int))+1))))
	+CAST((max(cast(right(@fmaxshortnumber,5) as int))+1) as varchar(10)),'00000')

	set @fmaxshortnumber=@fshortnumber
	set @fshortnumber=@fparentnumber+@fshortnumber
	set @fnumber=@flefttnumber+@fshortnumber
	
	--print @fshortnumber
	--print @fnumber

	update t1 set fshortnumber=@fshortnumber,fnumber=@fnumber,FFullNumber=@fnumber from t_item t1 where fitemid=@fitemid
	update t1 set fshortnumber=@fshortnumber,fnumber=@fnumber from t_ICItemCore t1 where fitemid=@fitemid

	set @fminid=@fminid+1
END

drop table #Cursor

go

select fshortnumber from t_icitem group by fshortnumber having count(1)>1

select t1.fnumber,t1.fname,t1.fmodel,t2.fname 是否引擎,t4.fnumber,t4.fname,t4.fmodel,t1.f_126,t1.f_127
--update t3 set f_126=0
from t_icitem t1 
inner join t_ICItemCustom t3 on t1.fitemid=t3.fitemid
left join t_submessage t2 on t1.f_126=t2.finterid 
left join t_icitem t4 on t4.fitemid=t1.f_127
where left(t1.fnumber,4) in ('a.02','a.03','a.04','p.02','p.03','p.04','j.02','j.03','j.04','x.02','x.03','x.04','y.02','y.03','y.04') --,'v.b.'
--and t1.fname not like '%禁用%'
AND ISNULL(T3.f_126,0)<>0


select t1.fnumber,t1.fname,t1.fmodel,t2.fname 是否引擎,t4.fnumber,t4.fname,t4.fmodel,t1.f_126,t1.f_127,t5.*
--update t3 set F_126=40019
--update t3 set f_127=0
from t_icitem t1 
inner join t_ICItemCustom t3 on t1.fitemid=t3.fitemid
left join t_submessage t2 on t1.f_126=t2.finterid 
left join t_icitem t4 on t4.fitemid=t1.f_127
inner join t_baseproperty t5 on t5.fitemid=t1.fitemid
where left(t1.fnumber,4) in ('a.02','a.03','a.04','p.02','p.03','p.04','j.02','j.03','j.04','x.02','x.03','x.04','y.02','y.03','y.04','v.b.') --,
and t1.fname not like '%禁用%'
AND ISNULL(T3.f_127,0)=0 and ISNULL(T3.f_126,0)<>40019

select t3.fnumber,t3.fname,t3.fmodel,t5.FLastModDate,t7.F_125,t7.f_126,t7.f_127
--update t7 set F_125=t3.fnumber
--update t7 set F_126=40019
--update t7 set F_127=0
from t_icitem t3
inner join t_ICItemCore t0 on t0.fitemid=t3.fitemid
inner join t_item t11 on t11.fitemid=t0.fitemid
inner join t_item t2 on t2.fitemid=t3.fitemid
left join t_baseproperty t5 on t5.fitemid=t3.fitemid
inner JOIN t_ICItemCustom t7 ON t0.FItemID=t7.FItemID
where left(t3.fnumber,4) in ('a.01','p.01','j.01','x.01','y.01')
and t3.fname not like '%禁用%' --and t3.fname like '%傲威中性粉盒%'

select * from t_itempropdesc where fitemclassid=4

IF EXISTS (select * from sysobjects where name='My_Tri_ICItemCore'  and xtype='TR')  drop  TRIGGER My_Tri_ICItemCore

select t3.fnumber,t3.fname,t3.fmodel,t5.FLastModDate,t7.F_125
--update t0 set fdeleted=1
--update t11 set fdeleted=1
from t_icitem t3
inner join t_ICItemCore t0 on t0.fitemid=t3.fitemid
inner join t_item t11 on t11.fitemid=t0.fitemid
inner join t_item t2 on t2.fitemid=t3.fitemid
left join t_baseproperty t5 on t5.fitemid=t3.fitemid
inner JOIN t_ICItemCustom t7 ON t0.FItemID=t7.FItemID
where left(t3.fnumber,4) in ('a.01','p.01','j.01','x.01','y.01') or t3.fname like '%禁用%'


select t3.fnumber,t3.fname,t3.fmodel,t5.FLastModDate,t7.F_125
--update t11 set fdeleted=1
from t_item t11 
where --left(t11.fnumber,4) in ('a.01','p.01','j.01','x.01','y.01')
--and 
t11.fitemclassid=4

select T11.*
--update t11 set fdeleted=0
from t_item t11 
where --left(t11.fnumber,4) in ('a.01','p.01','j.01','x.01','y.01')
--and 
t11.fitemclassid=4 and (fnumber='2' or fnumber='2.06' or fnumber='2.06.A0001' or fnumber='2.06.A0001.01' or fnumber = '2.06.A0001.01.BXM09370')

select T11.*
--update t11 set fdeleted=1
from t_item t11 
where --left(t11.fnumber,4) in ('a.01','p.01','j.01','x.01','y.01')
--and 
t11.fitemclassid=4 AND FNUMBER LIKE '2.06.%'

select t3.fnumber,t3.fname,t3.fmodel,t5.FLastModDate,t7.F_125
--update t11 set fdeleted=0
from t_item t11 
where left(t11.fnumber,1) in ('a','p','j','x','y')
and t11.fitemclassid=4

select t3.fnumber,t3.fname,t3.fmodel,t5.FLastModDate,t7.F_125
--update t0 set fdeleted=1
--update t11 set fdeleted=1
from t_icitem t3
inner join t_ICItemCore t0 on t0.fitemid=t3.fitemid
inner join t_item t11 on t11.fitemid=t0.fitemid
inner join t_item t2 on t2.fitemid=t3.fitemid
left join t_baseproperty t5 on t5.fitemid=t3.fitemid
inner JOIN t_ICItemCustom t7 ON t0.FItemID=t7.FItemID
where isnull(t3.F_125,'')=''


drop  TRIGGER My_Tri_Item
drop  TRIGGER My_Tri_ICItemCore
drop   TRIGGER My_Tri_ICItem_In



select fnumber from t_icitem where fdeleted=0

select * from t_item where fdeleted=0 and fitemclassid=4

--drop table #data11

select distinct t4.fnumber 长代码,t4.fshortnumber 编码,t4.fname 名称,t4.fmodel 规格型号
from t_icitem t1
inner join t_item t13 on t13.fitemid=t1.fitemid 
inner join icbom t2 on t1.fitemid=t2.fitemid
inner join icbomchild t3 on t2.finterid=t3.finterid
inner join t_icitem t4 on t3.fitemid=t4.fitemid
left join t_SubMessage t5 on t5.finterid=t1.F_128
where left(t4.fnumber,4) in ('2.01','2.05','2.06') and
t1.fname not like '%禁用%' and isnull(t1.f_125,'')<>''
--and t4.fname like '%高配%'
and left(t1.fnumber,4) in ('a.04','p.04','j.04','x.04','y.04')
order by t4.fnumber


白盒代码 咖啡盒代码 STARINK代码 傲威中性代码

select * from sheet81$ where 傲威中性代码 not in (select 编码 from #data11)
select * from #data11 where 编码 not in (select 傲威中性代码 from sheet81$)

select * from sheet81$ where 白盒代码 not in (select fshortnumber from t_icitem)

select * from sheet81$ where 咖啡盒代码 not in (select fshortnumber from t_icitem)

select * from sheet81$ where STARINK代码 not in (select fshortnumber from t_icitem)


select fnumber from t_icitem where fshortnumber in (select 白盒代码 from sheet81$)


BXH02393



select fchildnumber,fchildname,fchildmodel,fnumber,fname,fmodel
from
(
	select t4.fnumber fchildnumber,t4.fname fchildname,t4.fmodel fchildmodel,t1.fnumber,t1.fname,t1.fmodel
	from t_icitem t1
	inner join t_item t13 on t13.fitemid=t1.fitemid 
	inner join icbom t2 on t1.fitemid=t2.fitemid
	inner join icbomchild t3 on t2.finterid=t3.finterid
	inner join t_icitem t4 on t3.fitemid=t4.fitemid
	left join t_SubMessage t5 on t5.finterid=t1.F_128
	where --t4.fnumber like '2.02.a9999%' or  
	(t4.fnumber like '2.02.%' or t4.fnumber like '2.03.%' or t4.fnumber like '2.04.%') and
	t1.fname not like '%禁用%'
	--and t4.fname like '%高配%'
	and left(t1.fnumber,4) in ('a.01','p.01','j.01','x.01','y.01')
) t1 where fchildnumber not like '2.02.a9999%' 
order by t4.fshortnumber


select t4.fshortnumber 编码,t4.fname 名称,t4.fmodel,t1.fnumber,t1.fname,t1.fmodel
--into #data
from t_icitem t1
inner join t_item t13 on t13.fitemid=t1.fitemid 
inner join icbom t2 on t1.fitemid=t2.fitemid
inner join icbomchild t3 on t2.finterid=t3.finterid
inner join t_icitem t4 on t3.fitemid=t4.fitemid
left join t_SubMessage t5 on t5.finterid=t1.F_128
where (t4.fnumber like '2.02.a9999%' or t4.fnumber like '2.03.%' or t4.fnumber like '2.04.%') and
t1.fname not like '%禁用%'
--and t4.fname like '%高配%'
and left(t1.fnumber,1) in ('a','p','j','x','y')
order by t4.fmodel,t4.fshortnumber,t1.fnumber


select t3.fnumber,t3.fname,t3.fmodel,replace(t0.fname,'Starnk','Starink')
--update t11 set fcheckdate='2015-12-01'
--update t5 set flastmoddate='2015-12-01'
--update t11 set FChkUserID=16394
--update t11 set fname=replace(t0.fname,'Starnk','Starink')
--update t0 set fname=replace(t0.fname,'Starnk','Starink')
from t_icitem t3
inner join t_ICItemCore t0 on t0.fitemid=t3.fitemid
inner join t_item t11 on t11.fitemid=t0.fitemid
left join t_baseproperty t5 on t5.fitemid=t3.fitemid
where  t3.fname like '%Starnk%'

select t3.fnumber,t3.fname,t3.fmodel,t3.F_125,t11.fnumber,replace(t3.fnumber,t3.fshortnumber,t3.F_125),t11.ffullnumber
--update t11 set fcheckdate='2015-12-01'
--update t5 set flastmoddate='2015-12-01'
--update t11 set FChkUserID=16394
--update t11 set fname=replace(t0.fname,'Starnk','Starink')
--update t0 set fname=replace(t0.fname,'Starnk','Starink')
--update t11 set fnumber=replace(t3.fnumber,t3.fshortnumber,t3.F_125)
--update t0 set fnumber=replace(t3.fnumber,t3.fshortnumber,t3.F_125)
--update t11 set fshortnumber=t3.F_125
--update t0 set fshortnumber=t3.F_125
--update t11 set ffullnumber=t11.fnumber
from t_icitem t3
inner join t_ICItemCore t0 on t0.fitemid=t3.fitemid
inner join t_item t11 on t11.fitemid=t0.fitemid
left join t_baseproperty t5 on t5.fitemid=t3.fitemid
where t3.fnumber like 'v.%' and t3.fname like '%Starink%'
--and isnull(t3.F_125,'')<>'' -- t3.fnumber<>'V.B.B2041.01.A07208'


select t3.fnumber,t3.fname,t3.fmodel,t3.F_125,t11.fnumber,replace(t3.fnumber,t3.fshortnumber,t3.F_125),t11.ffullnumber
--update t11 set fcheckdate='2015-12-01'
--update t5 set flastmoddate='2015-12-01'
--update t11 set FChkUserID=16394
--update t11 set fname=replace(t0.fname,'Starnk','Starink')
--update t0 set fname=replace(t0.fname,'Starnk','Starink')
--update t11 set fnumber=replace(t3.fnumber,t3.fshortnumber,t3.F_125)
--update t0 set fnumber=replace(t3.fnumber,t3.fshortnumber,t3.F_125)
--update t11 set fshortnumber=t3.F_125
--update t0 set fshortnumber=t3.F_125
--update t11 set ffullnumber=t11.fnumber
from t_icitem t3
inner join t_ICItemCore t0 on t0.fitemid=t3.fitemid
inner join t_item t11 on t11.fitemid=t0.fitemid
left join t_baseproperty t5 on t5.fitemid=t3.fitemid
where t3.fnumber like 'v.%' and t3.fname like '%Starink%'
and isnull(t3.F_125,'')='' and t3.fshortnumber like 'a%'


select t3.fnumber,t3.fname,t3.fmodel,t3.F_125,t11.fnumber,replace(t3.fnumber,t3.fshortnumber,t3.F_125),t3.*
--update t11 set fcheckdate='2015-12-01'
--update t5 set flastmoddate='2015-12-01'
--update t11 set FChkUserID=16394
--update t11 set fname=replace(t0.fname,'Starnk','Starink')
--update t0 set fname=replace(t0.fname,'Starnk','Starink')
--update t11 set fnumber=replace(t3.fnumber,t3.fshortnumber,t3.F_125)
--update t0 set fnumber=replace(t3.fnumber,t3.fshortnumber,t3.F_125)
--update t11 set fshortnumber=t3.F_125
--update t0 set fnumber=t11.fnumber
from t_icitem t3
inner join t_ICItemCore t0 on t0.fitemid=t3.fitemid
inner join t_item t11 on t11.fitemid=t0.fitemid
left join t_baseproperty t5 on t5.fitemid=t3.fitemid
where t11.fnumber like 'v.%' and t3.fname like '%Starink%'
and t3.fshortnumber like 'a%' and isnull(t3.F_125,'')<>'' -- t3.fnumber<>'V.B.B2041.01.A07208'



select * from t_itempropdesc where fitemclassid=4

select t3.fnumber,t3.fname,t3.fmodel,t1.fitemid,replace(t0.fnumber,'A.04.','V.B.'),left(replace(t0.fnumber,'A.04.','V.B.'),12)
--update t11 set fcheckdate='2015-12-01'
--update t5 set flastmoddate='2015-12-01'
--update t11 set FChkUserID=16394
--update t11 set fname=replace(t0.fname,'Starnk','Starink')
--update t0 set fname=replace(t0.fname,'Starnk','Starink')
--update t11 set FParentID=t1.fitemid
--update t0 set FParentID=t1.fitemid
--update t11 set fnumber=replace(t0.fnumber,'A.04.','V.B.')
--update t0 set fnumber=replace(t0.fnumber,'A.04.','V.B.')
from t_icitem t3
inner join t_ICItemCore t0 on t0.fitemid=t3.fitemid
inner join t_item t11 on t11.fitemid=t0.fitemid
left join t_baseproperty t5 on t5.fitemid=t3.fitemid
left join t_item t1 on t1.fnumber=left(replace(t0.fnumber,'A.04.','V.B.'),12) and t1.fitemclassid=4 and t1.fdetail=0
where  t3.fnumber like '%a.04.b%'
order by t3.fnumber



select t3.fnumber,t3.fname,t3.fmodel,t5.FLastModDate,replace(t0.fname,'傲威中性粉盒','傲威中性彩盒')
--update t11 set fname=replace(t0.fname,'傲威中性粉盒','傲威中性彩盒')
--update t0 set fname=replace(t0.fname,'傲威中性粉盒','傲威中性彩盒')
--update t11 set fname=t11.fname+'-傲威中性彩盒'
--update t0 set fname=t0.fname+'-傲威中性彩盒'
from t_icitem t3
inner join t_ICItemCore t0 on t0.fitemid=t3.fitemid
inner join t_item t11 on t11.fitemid=t0.fitemid
inner join t_item t2 on t2.fitemid=t3.fitemid
inner join IcPrcPlyEntry t4 on t4.fitemid=t3.fitemid
left join t_baseproperty t5 on t5.fitemid=t3.fitemid
where left(t3.fnumber,4) in ('a.01','p.01','j.01','x.01','y.01') --,'v.b.'
and t3.fname not like '%傲威中性彩盒%'
and t3.fname not like '%禁用%' --and t3.fname like '%傲威中性粉盒%'

select t1.fnumber,t7.F_105,t5.FLastModDate,replace(t7.F_105,'Standard','Premium'),replace(t0.fname,'高配','高配-高附'),t1.*
--update t11 set fname=replace(t0.fname,'高配','高配-高附')
--update t0 set fname=replace(t0.fname,'高配','高配-高附')
from t_icitem t1
inner join t_ICItemCore t0 on t0.fitemid=t1.fitemid
inner join t_item t11 on t11.fitemid=t0.fitemid
inner JOIN t_ICItemCustom t7 ON t0.FItemID=t7.FItemID
left join t_baseproperty t5 on t5.fitemid=t0.fitemid
left join IcPrcPlyEntry t4 on t4.fitemid=t0.fitemid
where t1.fname like '%高配%' and t1.fname not like '%高附%'
and left(t1.fnumber,1) in (select fitemtype from v_myitemtype where ftype=0)


F_126
F_127

select * from t_itempropdesc where fitemclassid=4

select t1.fnumber,t7.F_105,t5.FLastModDate,replace(t7.F_105,'Black','Black/NEW OPC'),replace(t0.fname,'高配','高配-高附'),t1.*
--update t7 set F_105=replace(t7.F_105,'Black','Black/NEW OPC')
from t_icitem t1
inner join t_ICItemCore t0 on t0.fitemid=t1.fitemid
inner join t_item t11 on t11.fitemid=t0.fitemid
inner JOIN t_ICItemCustom t7 ON t0.FItemID=t7.FItemID
left join t_baseproperty t5 on t5.fitemid=t0.fitemid
left join IcPrcPlyEntry t4 on t4.fitemid=t0.fitemid
where t1.F_105 not like '%opc%' and t1.fmodel not like '%d307%'
and t1.fnumber like 'j.01.04%'
and left(t1.fnumber,1) in (select fitemtype from v_myitemtype where ftype=0)

select t11.fdeleted,t1.fnumber,t1.fname,t7.F_105,t5.FLastModDate,replace(t0.fname,'全新高配-高附','全新高配'),t1.*
--update t11 set fname=replace(t0.fname,'全新高配-高附','全新高配')
--update t0 set fname=replace(t0.fname,'全新高配-高附','全新高配')
from t_icitem t1
inner join t_ICItemCore t0 on t0.fitemid=t1.fitemid
inner join t_item t11 on t11.fitemid=t0.fitemid
inner JOIN t_ICItemCustom t7 ON t0.FItemID=t7.FItemID
left join t_baseproperty t5 on t5.fitemid=t0.fitemid
left join IcPrcPlyEntry t4 on t4.fitemid=t0.fitemid
where t1.fname like '%标配%' and t1.F_105 not like '%Standard%' --and t1.F_105 not like '%Premium%'
--and t1.fname not like '%高配版彩盒%'
and left(t1.fnumber,1) in (select fitemtype from v_myitemtype where ftype=0)



select t1.fshortnumber 短代码,t1.fnumber 长代码,t1.fname 产品名称,t3.ffullname 全称,t1.fmodel 规格型号,
isnull(t1.f_105,'') 描述,isnull(t1.f_106,'') 适用机型,isnull(t1.F_107,'') 适用区域,
(case when isnull(t1.F_109,'')='' then '0*0*0' else t1.F_109 end) [标准外箱尺寸(mm)],
(case when isnull(t1.F_111,'')='' then '0*0*0' else t1.F_111 end) [标准外盒尺寸(mm)],
isnull(t1.F_112,0) [整箱净重(kg)],isnull(t1.F_119,0) [整箱毛重(kg)],isnull(t1.F_110,0) 标准装箱数,
--(case when isnull(t1.F_120,'')='' then '0*0*0' else t1.F_120 end) [裸包标准外箱尺寸(mm)],
--isnull(t1.F_122,0) [裸包整箱净重(kg)],isnull(t1.F_123,0) [裸包整箱毛重(kg)],isnull(t1.F_121,0) 裸包标准装箱数,
isnull(t13.fname,'') 外盒尺寸,isnull(t14.fname,'') 打印机品牌,t1.FGrossWeight [毛重(kg)],t1.FNetWeight [净重(kg)]
--t2.fcreatedate 创建时间,t2.fcreateuser 创建人,t2.flastmoddate 最后修改时间,t2.flastmoduser 最后修改人,t2.fdeletedate 禁用时间,t2.fdeleteuser 禁用人
from t_icitem t1
left join t_baseproperty t2 on t1.fitemid=t2.fitemid
left join t_item t13 on t13.fitemid=t1.F_103 and t13.fitemclassid=3004  --外盒尺寸  --select * from t_item where fitemclassid=3004
left join t_SubMessage t14 on t14.finterid=t1.F_102  --打印机品牌
inner join t_item t3 on t3.fitemid=t1.fitemid
left join t_user t4 on t4.fuserid=t3.FChkUserID and t4.fuserid<>0
left join t_supplier t8 on t8.fitemid=t1.F_117 --t3.fsource
inner join icbom t9 on t9.fitemid=t1.fitemid
--inner join t_item t5 on t5.
where left(t1.fnumber,1) in (select fitemtype from v_myitemtype where ftype=0)
and (isnull(t14.fname,'') not in ('hp','canon','brother','samsung') or CHARINDEX('再生',t1.fname)>0)
and t1.fname not like '%禁用%' and t1.fname not like '%高配%' 
--and t1.fname not like '%鑫威白盒%' and t1.fname not like '%鑫威咖啡盒%' 
and t1.fnumber like 'v.b.%'
--and t1.fnumber='A.01.01.001.A00005'
order by t1.fnumber



select t2.fnumber,t2.fname,t2.fmodel,t9.fnumber,t9.fname,t9.fmodel
				from t_icitem t2 
				inner join icbom t11 on t11.fitemid=t2.fitemid --and t11.fusestatus=1072
				inner join icbomchild t12 on t11.finterid=t12.finterid
				inner join t_icitem t9 on t9.fitemid=t12.fitemid  --
				left join t_supplyentry t4 on t4.fitemid=t12.fitemid
				where t2.fdeleted=0 and t2.fname not like '%禁用%'
and left(t9.fnumber,1) in ('3','4','5','7','8') and ((CHARINDEX('再生',t2.fname)>0 and CHARINDEX('全新',t9.fname)>0) or (CHARINDEX('全新',t2.fname)>0 and CHARINDEX('再生',t9.fname)>0))

order by t9.fnumber 



select distinct t9.fnumber,t9.fname,t9.fmodel
				from t_icitem t2 
				inner join icbom t11 on t11.fitemid=t2.fitemid --and t11.fusestatus=1072
				inner join icbomchild t12 on t11.finterid=t12.finterid
				inner join t_icitem t9 on t9.fitemid=t12.fitemid  --
				left join t_supplyentry t4 on t4.fitemid=t12.fitemid
				where --(t2.fname like '%拆合%' or t2.fname like '%拆盒%' or left(t9.fnumber,1) in ('7','8')) and 
				t4.fitemid is null and t9.ferpclsid=1 and t2.fdeleted=0 and t2.fname not like '%禁用%'
order by t9.fnumber 

select t2.fnumber,t2.fname,t2.fmodel,t9.fnumber,t9.fname,t9.fmodel
				from t_icitem t2 
				inner join icbom t11 on t11.fitemid=t2.fitemid --and t11.fusestatus=1072
				inner join icbomchild t12 on t11.finterid=t12.finterid
				inner join t_icitem t9 on t9.fitemid=t12.fitemid  --
				left join t_supplyentry t4 on t4.fitemid=t12.fitemid
				where --(t2.fname like '%拆合%' or t2.fname like '%拆盒%' or left(t9.fnumber,1) in ('7','8')) and 
				t4.fitemid is null and t9.ferpclsid=1 and t2.fdeleted=0 and t2.fname not like '%禁用%'
order by t9.fnumber 


select fnumber,fname,fmodel
--update t1 set ferpclsid=2
from t_icitem t3
inner join t_ICItemBase t1 on t3.fitemid=t1.fitemid
where left(t3.fnumber,1) in ('a','p','j','x','y','v','q','r')
and t3.ferpclsid=1


select fnumber,fname,fmodel,t3.fsource
--update t1 set fsource=176
from t_icitem t3
inner join t_ICItemBase t1 on t3.fitemid=t1.fitemid
where left(t3.fnumber,1) in ('a','p','j','x','y','v','q')
and t3.fsource<>176 order by t3.fsource


select * from t_department

select * from t_itempropdesc where fitemclassid=4
--是否引擎	F_126
--引用引擎	F_127
--引擎代码	F_129
SELECT t4.FGrossWeight, t4.FNetWeight,t1.FUnitID, t1.FUnitGroupID,t1.FSecUnitID,t1.FOrderUnitID, t1.FSaleUnitID,t1.FStoreUnitID, t1.FProductUnitID,t3.FCUUnitID, t8.FFirstUnit, t8.FSecondUnit,
t0.FItemID, t0.FModel, t0.FName, t0.FHelpCode, t0.FDeleted, t0.FShortNumber, t0.FNumber, t0.FModifyTime, t0.FParentID, t0.FBrNo, t0.FTopID, t0.FRP, 
                      t0.FOmortize, t0.FOmortizeScale, t0.FForSale, t0.FStaCost, t0.FOrderPrice, t0.FOrderMethod, t0.FPriceFixingType, t0.FSalePriceFixingType, 
                      t0.FPerWastage, t0.FARAcctID, t0.FPlanPriceMethod, t0.FPlanClass, t1.FErpClsID, t1.FUnitID, t1.FUnitGroupID, t1.FDefaultLoc, t1.FSPID, t1.FSource, 
                      t1.FQtyDecimal, t1.FLowLimit, t1.FHighLimit, t1.FSecInv, t1.FUseState, t1.FIsEquipment, t1.FEquipmentNum, t1.FIsSparePart, t1.FFullName, 
                      t1.FSecUnitID, t1.FSecCoefficient, t1.FSecUnitDecimal, t1.FAlias, t1.FOrderUnitID, t1.FSaleUnitID, t1.FStoreUnitID, t1.FProductUnitID, t1.FApproveNo, 
                      t1.FAuxClassID, t1.FTypeID, t1.FPreDeadLine, t1.FSerialClassID, t2.FOrderRector, t2.FPOHghPrcMnyType, t2.FPOHighPrice, t2.FWWHghPrc, 
                      t2.FWWHghPrcMnyType, t2.FSOLowPrc, t2.FSOLowPrcMnyType, t2.FIsSale, t2.FProfitRate, t2.FSalePrice, t2.FBatchManager, t2.FISKFPeriod, 
                      t2.FKFPeriod, t2.FTrack, t2.FPlanPrice, t2.FPriceDecimal, t2.FAcctID, t2.FSaleAcctID, t2.FCostAcctID, t2.FAPAcctID, t2.FGoodSpec, t2.FCostProject, 
                      t2.FIsSnManage, t2.FStockTime, t2.FBookPlan, t2.FBeforeExpire, t2.FTaxRate, t2.FAdminAcctID, t2.FNote, t2.FIsSpecialTax, t2.FSOHighLimit, 
                      t2.FSOLowLimit, t2.FOIHighLimit, t2.FOILowLimit, t2.FDaysPer, t2.FLastCheckDate, t2.FCheckCycle, t2.FCheckCycUnit, t2.FStockPrice, t2.FABCCls, 
                      t2.FBatchQty, t2.FClass, t2.FCostDiffRate, t2.FDepartment, t2.FSaleTaxAcctID, t2.FCBBmStandardID, t3.FPlanTrategy, t3.FOrderTrategy, t3.FLeadTime, 
                      t3.FFixLeadTime, t3.FTotalTQQ, t3.FQtyMin, t3.FQtyMax, t3.FCUUnitID, t3.FOrderInterVal, t3.FBatchAppendQty, t3.FOrderPoint, t3.FBatFixEconomy, 
                      t3.FBatChangeEconomy, t3.FRequirePoint, t3.FPlanPoint, t3.FDefaultRoutingID, t3.FDefaultWorkTypeID, t3.FProductPrincipal, t3.FDailyConsume, 
                      t3.FMRPCon, t3.FPlanner, t3.FPutInteger, t3.FInHighLimit, t3.FInLowLimit, t3.FLowestBomCode, t3.FMRPOrder, t3.FIsCharSourceItem, 
                      t3.FCharSourceItemID, --t7.F_102, t7.F_103, t7.F_104, t7.F_105, t7.F_106, t7.F_107, t7.F_108, t7.F_109, t7.F_110, 
					  t4.FChartNumber, t4.FIsKeyItem, 
                      t4.FMaund, t4.FGrossWeight, t4.FNetWeight, t4.FCubicMeasure, t4.FLength, t4.FWidth, t4.FHeight, t4.FSize, t4.FVersion, t5.FStandardCost, 
                      t5.FStandardManHour, t5.FStdPayRate, t5.FChgFeeRate, t5.FStdFixFeeRate, t5.FOutMachFee, t5.FPieceRate, t6.FInspectionLevel, t6.FInspectionProject,
                       t6.FIsListControl, t6.FProChkMde, t6.FWWChkMde, t6.FSOChkMde, t6.FWthDrwChkMde, t6.FStkChkMde, t6.FOtherChkMde, t6.FStkChkPrd, 
                      t6.FStkChkAlrm, t6.FIdentifier, t8.FNameEn, t8.FModelEn, t8.FHSNumber, t8.FFirstUnit, t8.FSecondUnit, t8.FFirstUnitRate, t8.FSecondUnitRate, 
                      t8.FIsManage, t8.FPackType, t8.FLenDecimal, t8.FCubageDecimal, t8.FWeightDecimal, t8.FImpostTaxRate, t8.FConsumeTaxRate, 
                      t8.FManageType
--update t4 set FGrossWeight=0,FNetWeight=0
--update t2 set FCostAcctID=1473
FROM         dbo.t_ICItemCore AS t0 LEFT OUTER JOIN
                      dbo.t_ICItemBase AS t1 ON t0.FItemID = t1.FItemID LEFT OUTER JOIN
                      dbo.t_ICItemMaterial AS t2 ON t0.FItemID = t2.FItemID LEFT OUTER JOIN
                      dbo.t_ICItemPlan AS t3 ON t0.FItemID = t3.FItemID LEFT OUTER JOIN
                      dbo.t_ICItemDesign AS t4 ON t0.FItemID = t4.FItemID LEFT OUTER JOIN
                      dbo.t_ICItemStandard AS t5 ON t0.FItemID = t5.FItemID LEFT OUTER JOIN
                      dbo.t_ICItemQuality AS t6 ON t0.FItemID = t6.FItemID LEFT OUTER JOIN
                      dbo.t_ICItemCustom AS t7 ON t0.FItemID = t7.FItemID LEFT OUTER JOIN
                      dbo.T_BASE_ICItemEntrance AS t8 ON t0.FItemID = t8.FItemID
where t0.fnumber like 'R%' --and (t4.FGrossWeight<>0 or t4.FNetWeight<>0)

select * from t_account order by fnumber

select t2.facctid,t9.fnumber,t9.fname,t9.fmodel--,t11.fname
--select distinct t11.fname,t11.fnumber
--update t2 set facctid=1312
FROM         dbo.t_ICItemCore AS t0 LEFT OUTER JOIN
                      dbo.t_ICItemBase AS t1 ON t0.FItemID = t1.FItemID LEFT OUTER JOIN
                      dbo.t_ICItemMaterial AS t2 ON t0.FItemID = t2.FItemID LEFT OUTER JOIN
                      dbo.t_ICItemPlan AS t3 ON t0.FItemID = t3.FItemID LEFT OUTER JOIN
                      dbo.t_ICItemDesign AS t4 ON t0.FItemID = t4.FItemID LEFT OUTER JOIN
                      dbo.t_ICItemStandard AS t5 ON t0.FItemID = t5.FItemID LEFT OUTER JOIN
                      dbo.t_ICItemQuality AS t6 ON t0.FItemID = t6.FItemID LEFT OUTER JOIN
                      dbo.t_ICItemCustom AS t7 ON t0.FItemID = t7.FItemID LEFT OUTER JOIN
                      dbo.T_BASE_ICItemEntrance AS t8 ON t0.FItemID = t8.FItemID
                      inner join t_icitem t9 on t9.fitemid=t0.fitemid
                      --inner join AIS20120820103535.dbo.t_icitem t10 on t9.fshortnumber=t10.fshortnumber
inner join t_account  t11 on t11.faccountid=t9.facctid
--inner join t_baseproperty t11 on t11.fitemid=t0.fitemid and t11.FCreateDate>'2014-12-25'
where left(t9.fnumber,1) not in ('1','2','6','3','4','5','7','8')


select t2.facctid,t9.fnumber,t9.fname,t9.fmodel,t11.fname
--select distinct t11.fname,t11.fnumber
--update t2 set facctid=1314
FROM         dbo.t_ICItemCore AS t0 LEFT OUTER JOIN
                      dbo.t_ICItemBase AS t1 ON t0.FItemID = t1.FItemID LEFT OUTER JOIN
                      dbo.t_ICItemMaterial AS t2 ON t0.FItemID = t2.FItemID LEFT OUTER JOIN
                      dbo.t_ICItemPlan AS t3 ON t0.FItemID = t3.FItemID LEFT OUTER JOIN
                      dbo.t_ICItemDesign AS t4 ON t0.FItemID = t4.FItemID LEFT OUTER JOIN
                      dbo.t_ICItemStandard AS t5 ON t0.FItemID = t5.FItemID LEFT OUTER JOIN
                      dbo.t_ICItemQuality AS t6 ON t0.FItemID = t6.FItemID LEFT OUTER JOIN
                      dbo.t_ICItemCustom AS t7 ON t0.FItemID = t7.FItemID LEFT OUTER JOIN
                      dbo.T_BASE_ICItemEntrance AS t8 ON t0.FItemID = t8.FItemID
                      inner join t_icitem t9 on t9.fitemid=t0.fitemid
                      --inner join AIS20120820103535.dbo.t_icitem t10 on t9.fshortnumber=t10.fshortnumber
inner join t_account  t11 on t11.faccountid=t9.facctid
--inner join t_baseproperty t11 on t11.fitemid=t0.fitemid and t11.FCreateDate>'2014-12-25'
where t9.fnumber like '6%'

--select * from t_account where fnumber like '1403%' fname like '%成本%' faccountid=1016


update t2 set FCostAcctID=(select faccountid from t_account where fnumber='科目代码')
FROM dbo.t_ICItemCore AS t0 LEFT OUTER JOIN
dbo.t_ICItemBase AS t1 ON t0.FItemID = t1.FItemID LEFT OUTER JOIN
dbo.t_ICItemMaterial AS t2 ON t0.FItemID = t2.FItemID 
inner join t_icitem t9 on t9.fitemid=t0.fitemid




--材料成本
select t1.*
--update t1 set fplanprice=t2.fprice
from t_ICItemMaterial t1
inner join 
(
	select t1.fitemid,sum(fprice) fprice
	from
	(
		select t2.fitemid,(t3.fqty*t5.fprice) fprice
		from t_ICItem t1
		inner join icbom t2 on t1.fitemid=t2.fitemid --and t2.fstatus>0
		inner join icbomchild t3 on t2.finterid=t3.finterid
		inner join (select fitemid,max(fentryid) fentryid from t_supplyentry group by fitemid) t4 on t3.fitemid=t4.fitemid
		inner join t_supplyentry t5 on t4.fitemid=t5.fitemid and t4.fentryid=t5.fentryid
		inner join t_icitem t6 on t6.fitemid=t3.fitemid
		where left(t6.fnumber,1) not in ('3','4','5')
		union all
		select t2.fitemid,(t12.fqty*t5.fprice) fprice
		from t_ICItem t1
		inner join icbom t2 on t1.fitemid=t2.fitemid --and t2.fstatus>0
		inner join icbomchild t3 on t2.finterid=t3.finterid
		inner join icbom t11 on t11.fitemid=t3.fitemid
		inner join icbomchild t12 on t11.finterid=t12.finterid
		inner join (select fitemid,max(fentryid) fentryid from t_supplyentry group by fitemid) t4 on t12.fitemid=t4.fitemid
		inner join t_supplyentry t5 on t4.fitemid=t5.fitemid and t4.fentryid=t5.fentryid
		inner join t_icitem t6 on t6.fitemid=t3.fitemid
		where left(t6.fnumber,1) in ('3','4','5')
	) t1 group by t1.fitemid
) t2 on t1.fitemid=t2.fitemid
inner join t_icitem t3 on t1.fitemid=t3.fitemid
where left(t3.fnumber,1) in (select fitemtype from v_myitemtype where ftype=0)


select t1.*
--update t1 set fplanprice=t5.fprice
from t_ICItemMaterial t1
inner join (select fitemid,max(fentryid) fentryid from t_supplyentry group by fitemid) t4 on t1.fitemid=t4.fitemid
inner join t_supplyentry t5 on t4.fitemid=t5.fitemid and t4.fentryid=t5.fentryid
inner join t_icitem t3 on t1.fitemid=t3.fitemid



select t1.*
--update t1 set fplanprice=t2.fprice
from t_ICItemMaterial t1
inner join 
(
	select t1.fitemid,sum(fprice) fprice
	from
	(
		select t2.fitemid,(t3.fqty*t5.fprice) fprice
		from t_ICItem t1
		inner join icbom t2 on t1.fitemid=t2.fitemid --and t2.fstatus>0
		inner join icbomchild t3 on t2.finterid=t3.finterid
		inner join (select fitemid,max(fentryid) fentryid from t_supplyentry group by fitemid) t4 on t3.fitemid=t4.fitemid
		inner join t_supplyentry t5 on t4.fitemid=t5.fitemid and t4.fentryid=t5.fentryid
		inner join t_icitem t6 on t6.fitemid=t3.fitemid
		where left(t1.fnumber,1) in ('3','4','5')
	) t1 group by t1.fitemid
) t2 on t1.fitemid=t2.fitemid
inner join t_icitem t3 on t1.fitemid=t3.fitemid



select t2.fnumber,t2.FNetWeight,t5.[净重(g)]
--update t3 set FGrossWeight=t5.[净重(g)],FNetWeight=t5.[净重(g)]
from t_icitem t2
left join icbom t1 on t1.fitemid=t2.fitemid
inner join t_ICItemCustom AS t7 ON t2.FItemID = t7.FItemID
inner join t_ICItemDesign t3 on t3.fitemid=t2.fitemid
inner join sheet71$ t5 on t5.编码=t2.fnumber

select t2.fname,t5.*
from sheet72$ t5 
inner join t_icitem t2 on t5.产品编码=t2.fnumber
left join IcPrcPlyEntry t3 on t3.fitemid=t2.fitemid
where t5.产品编码 not like 'v%'
and t3.fitemid is null and t5.是否引擎='Y'

select * from t_itempropdesc where fitemclassid=4 and fsqlcolumnname='fname'


select * from sheet71$

select distinct t9.fnumber,t9.fname,t9.fmodel
from t_icitem t2 
inner join icbom t11 on t11.fitemid=t2.fitemid --and t11.fusestatus=1072
inner join icbomchild t12 on t11.finterid=t12.finterid
inner join t_icitem t9 on t9.fitemid=t12.fitemid  --
left join t_supplyentry t4 on t4.fitemid=t12.fitemid
where (t2.fname like '%拆合%' or t2.fname like '%拆盒%' or left(t9.fnumber,1) in ('7','8')) and t4.fitemid is null /*and t9.fplanprice=0*/

select t1.* ,t2.fnumber 取消编码,t2.fname 取消名称,t2.fmodel 取消型号,t3.fnumber 物料编码,t3.fname 物料名称,t3.fmodel 物料型号,'' 项目经理,'' 打印机品牌
from sheet16$ t1
inner join t_icitem t2 on t1.取消物料=t2.fshortnumber 
inner join t_icitem t3 on t1.替代物料=t3.fshortnumber 
union all
select t1.* ,t2.fnumber,t2.fname,t2.fmodel,t3.fnumber,t3.fname,t3.fmodel,t15.fname,t14.fname
from sheet16$ t1
inner join t_icitem t2 on t1.取消物料=t2.fshortnumber 
inner join icbomchild t4 on t4.fitemid=t2.fitemid
inner join icbom t5 on t5.finterid=t4.finterid
inner join t_icitem t3 on t5.fitemid=t3.fitemid 
left join t_SubMessage t14 on t14.finterid=t3.F_102  --打印机品牌  select * from t_submessage where ftypeid=10001
left join t_SubMessage t15 on t15.finterid=t3.F_128  --select * from t_submestype
where t3.fname not like '%禁用%'
order by 取消编码,项目经理,打印机品牌

select i.*,0 FMinFInterID,0 FFormatID,0 FInterID,
convert(varchar(255),' ') FBillNo,convert(varchar(10),isnull(FFormat,'')) as FFormat,FCurNo,
convert(varchar(10),isnull(FPreLetter,'')) as FPreLetter,convert(varchar(10),isnull(FSufLetter,'')) as FSufLetter,
0 FYtdDebitFor,0 FYtdDebit,0 FYtdCreditFor,0 FYtdCredit, b.FBeginBalanceFor FEndBalanceFor,b.FBeginBalance FEndBalance, cast(case c.FOperator when '*' then b.FBeginBalance/b.FBeginBalanceFor else b.FBeginBalanceFor/b.FBeginBalance end as decimal(20,10)) as FExchangeRate,
c.FCurrencyID,a.FDC,d.*,Q.FEndQty as FEndQty, 
t.FDate,convert(varchar(255),' ') FTransNo  Into #tempt_rp_begdataInfo1
from t_balance b 
inner join #tmpInputAccountInfo i on b.FAccountID=i.FAccountID inner join t_currency c on b.FCurrencyID =c.FCurrencyID 
inner join t_account a on b.FAccountID=a.FAccountID 
inner join t_itemdetail d on b.FDetailID=d.FDetailID 
inner join ICBillNo f on f.FBillID=i.FClassTypeid
left join t_quantitybalance q on b.FYear=q.FYear and b.FPeriod=q.FPeriod and b.FAccountID=q.FAccountID and b.FDetailID=q.FDetailID and b.FCurrencyID=q.FCurrencyID 
left join t_lastcontactdate t on b.FAccountID=t.FAccountID and b.FDetailID=t.FDetailID and b.FCurrencyID=t.FCurrencyID 
where b.FCurrencyID<>0 and b.FDetailID>0 and b.FBeginBalance<>0 and b.FBeginBalanceFor<>0   and b.FPeriod=1 and b.FYear=2015 order by i.FClassTypeID

SELECT a.FAccountID,a.FDetailID,a.FNumber,FName,FLevel,a.FDetail,FGroupID,FDC,FHelperCode,FQuantities,a.FDelete, FYtdDebit,FYtdCredit,FYtdDebitQty,
FYtdCreditQty,FYtdAmount,  FBeginBalance,FDebit,FCredit, FEndBalance,  Coef, MeasName,  FBeginQty,FEndQty 
From t_Account a  
Left Outer Join  (Select * from t_Balance Where  FDetailID=0 AND FYear=2015 And FPeriod=1 And FCurrencyID=0 ) b  on a.FAccountID = b.FAccountID  
Left Outer Join  (Select u.FUnitGroupID,m.FCoefficient Coef,m.FName MeasName  
From   t_unitgroup u,  
t_MeasureUnit m   
Where u.fdefaultunitid=m.fmeasureunitid) u   on a.FUnitGroupID = u.FUnitGroupID  
Left Outer Join  (Select * from t_ProfitandLoss Where  FDetailID=0 AND FYear=2015 And FPeriod =1 And FCurrencyID=0  ) p  on a.FAccountID=p.FAccountID  
 Left Outer Join  (Select * from t_QuantityBalance Where  FDetailID=0 AND FYear=2015 And FPeriod =1 AND FCurrencyID=0 ) q  on a.FAccountID=q.FAccountID  
Order by a.FNumber

select t3.fnumber,t3.fname,t3.fmodel
--update t2 set fcheckdate='2015-03-13'
--update t5 set flastmoddate='2015-03-13'
--update t2 set FChkUserID=16394
from t_icitem t3
inner join t_item t2 on t2.fitemid=t3.fitemid
--inner join IcPrcPlyEntry t4 on t4.fitemid=t3.fitemid
inner join t_baseproperty t5 on t5.fitemid=t3.fitemid
where --left(t3.fnumber,4) in ('a.04','p.04','j.04','x.04','y.04') --,'v.b.'
left(t3.fnumber,4) in ('v.b.')
--and isnull(t2.FChkUserID,0)=0 --and t3.fname not like '%禁用%'
--and t3.fshortnumber='P21382'

Y.01.02.023.Y00313

select t1.*
--update t2 set fcheckdate=null,FChkUserID=0
from icbom t1
inner join t_icitem t2 on t1.fitemid=t2.fitemid
where t2.fshortnumber='x00442'

select t1.*
--update t2 set fcheckdate=null,FChkUserID=0
from icbom t1
inner join t_item t2 on t1.fitemid=t2.fitemid
where t1.fstatus=0 and t2.FChkUserID>0

select * from t_log where fdescription like '%bxm10974%'

select t1.fnumber 编码,t1.fname 名称,isnull(t1.fmodel,'') 规格型号,isnull(t5.fname,'') 项目经理
from t_icitem t1
left join t_SubMessage t5 on t5.finterid=t1.F_128
where left(t1.fnumber,1) in ('4','5')  and t1.fdeleted=0 and t1.fname not like '%禁用%' and t1.fname not like '%拆盒%'
order by t5.fname,t1.fnumber 

select distinct t5.fname 项目经理,t1.fnumber 编码,t1.fname 名称,t1.fmodel 规格型号,t4.fnumber 半成品编码,t4.fname 半成品名称
--into #data
from t_icitem t1
inner join t_item t13 on t13.fitemid=t1.fitemid 
inner join icbom t2 on t1.fitemid=t2.fitemid
inner join icbomchild t3 on t2.finterid=t3.finterid
inner join t_icitem t4 on t3.fitemid=t4.fitemid
left join t_SubMessage t5 on t5.finterid=t1.F_128
where left(t4.fnumber,1) in ('3','4','5','7','8') 
and t1.fname not like '%标配%' and t1.fname not like '%高配%' and t1.fname not like '%经济%'
--and t4.fname like '%高配%'
and left(t1.fnumber,4) in ('a.01','p.01','j.01','x.01','y.01','v.b.')
order by t5.fname,t1.fnumber

select distinct t5.fname 项目经理,t1.fnumber 编码,t1.fname 名称,t1.fmodel 规格型号,t4.fnumber 半成品编码,t4.fname 半成品名称
from t_icitem t1
inner join t_item t13 on t13.fitemid=t1.fitemid 
inner join icbom t2 on t1.fitemid=t2.fitemid
inner join icbomchild t3 on t2.finterid=t3.finterid
inner join t_icitem t4 on t3.fitemid=t4.fitemid
left join t_SubMessage t5 on t5.finterid=t1.F_128
where left(t4.fnumber,1) in ('3','4','5','7','8') 
and ((t1.fname like '%再生%' and t4.fname like '%全新%') or (t1.fname like '%全新%' and t4.fname like '%再生%') or (t1.fname not like '%禁用%' and t4.fname like '%禁用%'))
--and t4.fname like '%高配%'
and left(t1.fnumber,4) in ('a.01','p.01','j.01','x.01','y.01','v.b.')
order by t5.fname,t1.fnumber

select * from #data

select t7.F_105,replace(t7.F_105,'Standard','Premium'),replace(t0.fname,'全新','全新高配'),t1.*
--update t11 set fname=replace(t0.fname,'全新','全新高配')
--update t0 set fname=replace(t0.fname,'全新','全新高配')
--update t7 set F_105=replace(t7.F_105,'Standard','Premium')
--update t11 set fcheckdate='2015-01-28'
--update t5 set flastmoddate='2015-01-28'
--update t11 set FChkUserID=16394
from #data t1
inner join t_ICItemCore t0 on t0.fnumber=t1.编码
inner join t_item t11 on t11.fitemid=t0.fitemid
inner JOIN t_ICItemCustom t7 ON t0.FItemID=t7.FItemID
inner join t_baseproperty t5 on t5.fitemid=t0.fitemid
left join IcPrcPlyEntry t4 on t4.fitemid=t0.fitemid
where 项目经理='刘均庆' --and left(半成品编码,1) in ('7','8') 
and t1.名称 not like '%高配%'  --
and t1.名称 like '%高附%' and t1.名称 like '%全新%'

select distinct t4.fnumber,t4.fname,t4.fmodel
from t_icitem t1
inner join t_item t13 on t13.fitemid=t1.fitemid 
inner join icbom t2 on t1.fitemid=t2.fitemid
inner join icbomchild t3 on t2.finterid=t3.finterid
inner join t_icitem t4 on t3.fitemid=t4.fitemid
where (left(t4.fnumber,1) in ('3','4','5','7','8') --or left(t4.fnumber,4) in ('2.01','2.02','2.03','2.04','2.08')
)
and t4.fnetweight=0
order by t4.fnumber


select distinct t4.fnumber,t4.fname,t4.fmodel
from t_icitem t1
inner join t_item t13 on t13.fitemid=t1.fitemid 
inner join icbom t2 on t1.fitemid=t2.fitemid
inner join icbomchild t3 on t2.finterid=t3.finterid
inner join t_icitem t4 on t3.fitemid=t4.fitemid
where left(t4.fnumber,4) in ('2.01','2.02','2.03','2.04','2.08')
and t4.fnetweight=0
order by t4.fnumber


select distinct t4.fnumber,t4.fname,t4.fmodel
from t_icitem t1
inner join t_item t13 on t13.fitemid=t1.fitemid 
inner join icbom t2 on t1.fitemid=t2.fitemid
inner join icbomchild t3 on t2.finterid=t3.finterid
inner join t_icitem t4 on t3.fitemid=t4.fitemid
where left(t4.fnumber,4) in ('a.01','p.01','j.01','x.01','y.01')
)
and t4.fnetweight=0
order by t4.fnumber

3.04.036.3004968.05.01.805043

select * from t_submestype

select t1.*
--update t2 set fcheckdate=null,FChkUserID=0
from t_icitem t3
left join icbom t1 on t3.fitemid=t1.fitemid
inner join t_item t2 on t2.fitemid=t3.fitemid
where isnull(t1.fstatus,0)=0 and t2.FChkUserID>0
and left(t3.fnumber,4) in ('a.01','p.01','j.01','x.01','y.01') --,'v.b.'

--select t2.*
--update t13 set fcheckdate='2015-01-23'
--update t3 set flastmoddate='2015-01-23'
from t_icitem t1
inner join t_item t13 on t13.fitemid=t1.fitemid 
inner join icbom t2 on t1.fitemid=t2.fitemid
inner join t_baseproperty t3 on t3.fitemid=t1.fitemid
where left(t1.fnumber,4) in ('a.01','p.01','j.01','x.01','y.01') --,'v.b.'
and t2.fstatus>0

select t1.*
from icbom t1
inner join t_item t2 on t1.fitemid=t2.fitemid
where t1.fstatus>0 and isnull(t2.FChkUserID,0)=0
and left(t2.fnumber,4) in ('a.01','p.01','j.01','x.01','y.01')

--select t2.*
--update t13 set fcheckdate='2015-01-25'
--update t3 set flastmoddate='2015-01-25'
--update t13 set FChkUserID=16394
from t_icitem t1
inner join t_item t13 on t13.fitemid=t1.fitemid 
inner join icbom t2 on t1.fitemid=t2.fitemid
inner join t_baseproperty t3 on t3.fitemid=t1.fitemid
where --t2.fstatus>0 and 
isnull(t13.FChkUserID,0)=0
and left(t1.fnumber,4) in ('a.01','p.01','j.01','x.01','y.01') --,'v.b.'

select t1.fnumber,t1.fname,t1.fmodel
from t_icitem t1 
inner join t_ICItemCustom t3 on t1.fitemid=t3.fitemid
where t1.fnumber like 'v.b.%' and isnull(t1.f_106,'')='' 
order by t1.fnumber

select * from t_icitem where f_105 not like '%patent%' and fname like '%专利%' and fname not like '%禁用%'

select t1.fnumber,t1.f_106,t2.fnumber,t2.f_106,t3.f_106
--update t3 set f_106=t2.f_106
from t_icitem t1 
inner join (select fmodel,f_106,fnumber from t_icitem t1 where left(t1.fnumber,4) in ('a.01','p.01','j.01','x.01','y.01')) t2 on t1.fmodel=t2.fmodel
inner join t_ICItemCustom t3 on t1.fitemid=t3.fitemid
where t1.fnumber like 'v%' and isnull(t1.f_106,'')='' 
order by t1.fnumber

select t1.fdeleted,t3.FChkUserID,t1.fshortnumber 短代码,t1.fnumber 长代码,t1.fname 产品名称,t3.ffullname 全称,t1.fmodel 规格型号,
isnull(t1.f_105,'') 描述,isnull(t1.f_106,'') 适用机型,isnull(t1.F_107,'') 适用区域,
(case when isnull(t1.F_109,'')='' then '0*0*0' else t1.F_109 end) [标准外箱尺寸(mm)],
(case when isnull(t1.F_111,'')='' then '0*0*0' else t1.F_111 end) [标准外盒尺寸(mm)],
isnull(t1.F_112,0) [整箱净重(kg)],isnull(t1.F_119,0) [整箱毛重(kg)],isnull(t1.F_110,0) 标准装箱数,
(case when isnull(t1.F_120,'')='' then '0*0*0' else t1.F_120 end) [裸包标准外箱尺寸(mm)],
isnull(t1.F_122,0) [裸包整箱净重(kg)],isnull(t1.F_123,0) [裸包整箱毛重(kg)],isnull(t1.F_121,0) 裸包标准装箱数,
(case when isnull(t13.fname,'')='' then '小' else t13.fname end) 外盒尺寸,isnull(t14.fname,'') 打印机品牌,isnull(t8.fshortname,'') 主供应商,
(case when t1.fdeleted=1 then 'Y' else '' end) 禁用,t9.fname 单位,
replace(convert(varchar(10),isnull(t2.flastmoddate,t2.fcreatedate),111),'/','-') 修改日期,isnull(t4.fname,'') 审核人--,
--t2.fcreatedate 创建时间,t2.fcreateuser 创建人,t2.flastmoddate 最后修改时间,t2.flastmoduser 最后修改人,t2.fdeletedate 禁用时间,t2.fdeleteuser 禁用人
from t_icitem t1
inner join t_baseproperty t2 on t1.fitemid=t2.fitemid
left join t_item t13 on t13.fitemid=t1.F_103 and t13.fitemclassid=3004  --外盒尺寸  --select * from t_item where fitemclassid=3004
left join t_SubMessage t14 on t14.finterid=t1.F_102  --打印机品牌
inner join t_item t3 on t3.fitemid=t1.fitemid
left join t_user t4 on t4.fuserid=t3.FChkUserID and t4.fuserid<>0
left join t_supplier t8 on t8.fitemid=t1.F_117 --t3.fsource
inner join t_measureunit t9 on t9.FItemID=t1.funitid
where left(t1.fnumber,1) in (select fitemtype from v_myitemtype where ftype=0)
and left(t1.fnumber,4) not in('V.A.','V.C.','V.D.','V.E.')
and t1.fshortnumber in ('p21284') 
--and replace(convert(varchar(10),isnull(t2.flastmoddate,t2.fcreatedate),111),'/','-')>='********'
--and replace(convert(varchar(10),isnull(t2.flastmoddate,t2.fcreatedate),111),'/','-')<='########'
--order by t1.fnumber


-------------------------------------------------------------------------------------------
select t3.fnumber,t3.fname,t1.FOperatorID
--update t1 set t1.fheadselfz0134 =t9.F_128
from icbom t1
inner join t_icitem t3 on t1.fitemid=t3.fitemid
inner join t_ICItemCustom t9 on t9.fitemid=t1.fitemid
where isnull(t9.F_128,0)<>0 and isnull(t1.fheadselfz0134 ,0)=0


select t3.fnumber,t3.fname,t1.FOperatorID,t1.fnote,t5.fname
--update t1 set t1.fnote =t5.fname
from icbom t1
inner join t_icitem t3 on t1.fitemid=t3.fitemid
inner join t_ICItemCustom t9 on t9.fitemid=t1.fitemid
inner join t_SubMessage t5 on t5.finterid=t1.fheadselfz0134 
where isnull(t1.fheadselfz0134 ,0)<>0 and isnull(t1.fnote,'')='' 
---------------------------------------------------------------------------------------------------------------------

select ftype,month(t1.fdate),count(1)
from
(
	select distinct t1.fbillno,t1.fdate,substring(t4.ffullname,1,dbo.My_F_Charindex(t4.ffullname,'_',2)-1) ftype
	from poinstock t1
	inner join poinstockentry t2 on t1.finterid=t2.finterid
	inner join t_icitem t3 on t2.fitemid=t3.fitemid
	inner join t_item t4 on t3.fitemid=t4.fitemid
	where year(t1.fdate)=2014 and left(t3.fnumber,1) in ('1','2','6') 
	and t1.ftrantype=72
) t1
group by ftype,month(t1.fdate)
order by ftype,month(t1.fdate)

select ftype,month(t1.fdate),count(1)
from
(
	select distinct t1.fbillno,t1.fdate,substring(t4.ffullname,1,dbo.My_F_Charindex(t4.ffullname,'_',2)-1) ftype
	from poinstock t1
	inner join poinstockentry t2 on t1.finterid=t2.finterid
	inner join t_icitem t3 on t2.fitemid=t3.fitemid
	inner join t_item t4 on t3.fitemid=t4.fitemid
	where year(t1.fdate)=2014 and left(t3.fnumber,1) in ('1','2','6') 
	and t1.ftrantype=73
) t1
group by ftype,month(t1.fdate)
order by ftype,month(t1.fdate)


select * from ictranstype  --72	采购收货 73	采购退货

select * from sheet52$
---------------------------------------------------------------------------------------------------------------------
--产品描述需要芯片但BOM无芯片
select t4.fstatus,t5.fname fmanager,t2.fnumber,t2.fname,t2.fmodel,t2.f_105 fdesc,isnull(t2.f_106,'') fsuitmodel
from
(
	select fitemid,max(fbanitemid) fbanitemid,max(fxinitemid) fxinitemid
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
		and t2.fstatus>0
	) t1 group by t1.fitemid
) t1 inner join t_icitem t2 on t1.fitemid=t2.fitemid
left join t_SubMessage t5 on t5.finterid=t2.F_128
inner join t_icitem t3 on t1.fbanitemid=t3.fitemid
left join icbom t4 on t4.fitemid=t1.fitemid
where (t2.f_105 like '%with chip%' and t1.fxinitemid=0) and left(t3.fnumber,1) not in ('7','8')
order by t5.fname,t2.fnumber

--产品描述不需要芯片但BOM有芯片
select t5.fname fmanager,t2.fnumber,t2.fname,t2.fmodel,t2.f_105 fdesc,isnull(t2.f_106,'') fsuitmodel
from
(
	select fitemid,max(fbanitemid) fbanitemid,max(fxinitemid) fxinitemid
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
		and t2.fstatus>0
	) t1 group by t1.fitemid
) t1 inner join t_icitem t2 on t1.fitemid=t2.fitemid
left join t_SubMessage t5 on t5.finterid=t2.F_128
where (t2.f_105 like '%without chip%' or t2.f_105 like '%no chip%' )and t1.fxinitemid>0
order by t5.fname,t2.fnumber

--无半成品
select t5.fname fmanager,t2.fnumber,t2.fname,t2.fmodel,t2.f_105 fdesc,isnull(t2.f_106,'') fsuitmodel
from
(
	select fitemid,max(fbanitemid) fbanitemid,max(fxinitemid) fxinitemid
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
		and t2.fstatus>0
	) t1 group by t1.fitemid
) t1 inner join t_icitem t2 on t1.fitemid=t2.fitemid
left join t_SubMessage t5 on t5.finterid=t2.F_128
where t1.fbanitemid=0 and left(t2.fnumber,1) not in ('q','r') 
order by t5.fname,t2.fnumber


-------------------------------------------------------------------------------------------------
select t1.fnumber,t1.fname,t1.fmodel,t3.f_126,t2.fname 是否引擎 ,t4.fnumber,t4.fname,t4.fmodel,t3.f_125,t1.fdeleted,t5.FLastModDate,t7.fitemid
--update t3 set f_126=0
--update t3 set f_127=0
from t_icitem t1 
inner join t_ICItemCustom t3 on t1.fitemid=t3.fitemid
left join t_submessage t2 on t1.f_126=t2.finterid 
left join t_icitem t4 on t4.fitemid=t1.f_127
left join t_baseproperty t5 on t5.fitemid=t1.fitemid
left join icbom t7 on t7.fitemid=t1.fitemid
where --left(t1.fnumber,4) in ('a.01','p.01','j.01','x.01','y.01')  --('v.b.')
left(t1.fnumber,4) in ('a.02','a.03','a.04','p.02','p.03','p.04','j.02','j.03','j.04','x.02','x.03','x.04','y.02','y.03','y.04','v.b.')
and isnull(t3.f_127,0)=0 and isnull(t3.f_126,0)<> 40019
and t1.fname not like '%禁用%'


select t1.fnumber,t1.fname,t1.fmodel,t2.fname 是否引擎 ,t4.fnumber,t4.fname,t4.fmodel,t3.f_125,t1.fdeleted,t5.FLastModDate,t7.fitemid
--update t3 set f_126=0
--update t3 set f_127=t4.fitemid
from t_icitem t1 
inner join t_ICItemCustom t3 on t1.fitemid=t3.fitemid
left join t_submessage t2 on t1.f_126=t2.finterid 
left join t_icitem t4 on t4.fnumber=t1.f_125
left join t_baseproperty t5 on t5.fitemid=t1.fitemid
left join icbom t7 on t7.fitemid=t1.fitemid
where --left(t1.fnumber,4) in ('a.01','p.01','j.01','x.01','y.01')  --('v.b.')
left(t1.fnumber,4) in ('a.02','a.03','a.04','p.02','p.03','p.04','j.02','j.03','j.04','x.02','x.03','x.04','y.02','y.03','y.04') --,'v.b.'
and isnull(t3.f_125,'')<>''
and t3.f_127=0 and t1.fname not like '%禁用%'


select t1.fnumber,t1.fname,t1.fmodel,t3.f_125,t1.fdeleted,t5.FLastModDate,t7.fitemid
--update t3 set f_126=0
--update t3 set f_127=t4.fitemid
from t_icitem t1 
inner join t_ICItemCustom t3 on t1.fitemid=t3.fitemid
left join t_submessage t2 on t1.f_126=t2.finterid 
left join t_baseproperty t5 on t5.fitemid=t1.fitemid
left join icbom t7 on t7.fitemid=t1.fitemid
where left(t1.fnumber,4) in ('a.02','a.03','a.04','p.02','p.03','p.04','j.02','j.03','j.04','x.02','x.03','x.04','y.02','y.03','y.04') --,'v.b.'
--and isnull(t3.f_125,'')<>''
and t3.f_127=0 and t1.fname not like '%禁用%'


select t1.fnumber,t1.fname,t1.fmodel,t4.fnumber,t4.fname,t4.fmodel,t3.f_125,t1.fdeleted,t5.FLastModDate,t7.fitemid
--update t3 set f_126=0
--update t3 set f_127=t4.fitemid
from t_icitem t1 
inner join t_ICItemCustom t3 on t1.fitemid=t3.fitemid
left join t_submessage t2 on t1.f_126=t2.finterid 
inner join t_icitem t4 on t4.fmodel=t1.fmodel and t4.fitemid<>t1.fitemid
left join t_baseproperty t5 on t5.fitemid=t1.fitemid
left join icbom t7 on t7.fitemid=t1.fitemid
where left(t4.fnumber,4) in ('a.01','p.01','j.01','x.01','y.01')  --('v.b.')
and left(t1.fnumber,4) in ('a.02','a.03','a.04','p.02','p.03','p.04','j.02','j.03','j.04','x.02','x.03','x.04','y.02','y.03','y.04') --,'v.b.'
--and isnull(t3.f_125,'')<>''
and t3.f_127=0 and t4.fname not like '%禁用%'




select t1.fnumber,t1.fname,t1.fmodel,t2.fname 是否引擎 ,t4.fnumber,t4.fname,t4.fmodel,t3.f_125,t1.fdeleted,t5.FLastModDate,t7.fitemid
--update t3 set f_126=0
--update t3 set f_127=0
from t_icitem t1 
inner join t_ICItemCustom t3 on t1.fitemid=t3.fitemid
left join t_submessage t2 on t1.f_126=t2.finterid 
left join t_icitem t4 on t4.fitemid=t1.f_127
left join t_baseproperty t5 on t5.fitemid=t1.fitemid
left join icbom t7 on t7.fitemid=t1.fitemid
where --left(t1.fnumber,4) in ('a.01','p.01','j.01','x.01','y.01')  --('v.b.')
left(t1.fnumber,4) in ('v.b.') --,
and t3.f_127=0 and t1.fname not like '%禁用%'


select * from t_submessage where fname ='是'

select t1.fitemid,t3.f_127
--update t3 set f_127=t1.fitemid
from
(
	select fitemid,max(fbanitemid) fbanitemid,max(fxinitemid) fxinitemid
	from
	(
		select t1.fitemid,
		case when left(t4.fnumber,1) in ('3','4','5','7','8') then t4.fitemid else 0 end fbanitemid,
		case when left(t4.fnumber,10) in ('1.01.0010.') then t4.fitemid else 0 end fxinitemid
		from t_icitem t1
		inner join icbom t2 on t1.fitemid=t2.fitemid
		inner join icbomchild t3 on t2.finterid=t3.finterid
		inner join t_icitem t4 on t3.fitemid=t4.fitemid
		where left(t1.fnumber,4) in ('a.01','p.01','j.01','x.01','y.01') and t1.fname not like '%禁用%' and t1.fdeleted=0
	) t1 group by t1.fitemid
) t1 inner join
( 
	select fitemid,max(fbanitemid) fbanitemid,max(fxinitemid) fxinitemid
	from
	(
		select t1.fitemid,
		case when left(t4.fnumber,1) in ('3','4','5','7','8') then t4.fitemid else 0 end fbanitemid,
		case when left(t4.fnumber,10) in ('1.01.0010.') then t4.fitemid else 0 end fxinitemid
		from t_icitem t1
		inner join icbom t2 on t1.fitemid=t2.fitemid
		inner join icbomchild t3 on t2.finterid=t3.finterid
		inner join t_icitem t4 on t3.fitemid=t4.fitemid
		where left(t1.fnumber,4) in ('a.02','a.03','a.04','p.02','p.03','p.04','j.02','j.03','j.04','x.02','x.03','x.04','y.02','y.03','y.04','v.b.') --and t1.fname not like '%禁用%' and t1.fdeleted=0
	) t1 group by t1.fitemid
) t2 on t1.fbanitemid=t2.fbanitemid and t1.fxinitemid=t2.fxinitemid
inner join t_ICItemCustom t3 on t3.fitemid=t2.fitemid



select distinct t2.fitemid,t3.f_127
--update t3 set f_127=t1.fitemid
from
(
	select fitemid,max(fbanitemid) fbanitemid,max(fxinitemid) fxinitemid
	from
	(
		select t1.fitemid,
		case when left(t4.fnumber,1) in ('3','4','5','7','8') then t4.fitemid else 0 end fbanitemid,
		case when left(t4.fnumber,10) in ('1.01.0010.') then t4.fitemid else 0 end fxinitemid
		from t_icitem t1
		inner join icbom t2 on t1.fitemid=t2.fitemid
		inner join icbomchild t3 on t2.finterid=t3.finterid
		inner join t_icitem t4 on t3.fitemid=t4.fitemid
		where left(t1.fnumber,4) in ('a.01','p.01','j.01','x.01','y.01') and t1.fname not like '%禁用%' and t1.fdeleted=0
	) t1 group by t1.fitemid
) t1 inner join
( 
	select fitemid,max(fbanitemid) fbanitemid,max(fxinitemid) fxinitemid
	from
	(
		select t1.fitemid,
		case when left(t4.fnumber,1) in ('3','4','5','7','8') then t4.fitemid else 0 end fbanitemid,
		case when left(t4.fnumber,10) in ('1.01.0010.') then t4.fitemid else 0 end fxinitemid
		from t_icitem t1
		inner join icbom t2 on t1.fitemid=t2.fitemid
		inner join icbomchild t3 on t2.finterid=t3.finterid
		inner join t_icitem t4 on t3.fitemid=t4.fitemid
		where left(t1.fnumber,4) in ('v.b.') --and t1.fname not like '%禁用%' and t1.fdeleted=0
	) t1 group by t1.fitemid
) t2 on t1.fbanitemid=t2.fbanitemid
inner join t_ICItemCustom t3 on t3.fitemid=t2.fitemid
where isnull(t3.f_127,0)=0



--drop table #data
select fitemid,max(fbanitemid) fbanitemid,max(fxinitemid) fxinitemid,0 fisyinqing,0 fyinqingitemid into #data
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
	and left(t1.fnumber,1) not in ('q','r') and t1.fname not like '%禁用%' and t1.fdeleted=0
) t1 group by t1.fitemid

--相同半成品--无芯片
select t4.fnumber,t4.fname,t4.fmodel,t7.*
--update t6 set --f_126=
--update t5 set --f_127=t2.fitemid
--update t7 set fisyinqing=1,fyinqingitemid=t7.fitemid
from #data t7
inner join
(
	select t1.fbanitemid,min(t2.fitemid) fitemid
	from #data t1
	inner join t_icitem t2 on t1.fitemid=t2.fitemid
	where left(t2.fnumber,4) in ('a.01','p.01','j.01','x.01','y.01')
	and (t1.fxinitemid)=0
	group by t1.fbanitemid
) t2 on t7.fitemid=t2.fitemid
inner join t_icitem t4 on t2.fitemid=t4.fitemid

select t3.fnumber,t3.fname,t3.fmodel,t4.fnumber,t4.fname,t4.fmodel,t7.*
--update t6 set --f_126=
--update t5 set --f_127=t2.fitemid
--update t7 set fyinqingitemid=t2.fitemid
from (select fitemid,fbanitemid from #data where fisyinqing=0 and fxinitemid=0) t1 
inner join (select fitemid,fbanitemid from #data where fisyinqing=1 and fxinitemid=0) t2 on t1.fbanitemid=t2.fbanitemid
inner join t_icitem t3 on t1.fitemid=t3.fitemid
inner join t_icitem t4 on t2.fitemid=t4.fitemid
inner join #data t7 on t7.fitemid=t1.fitemid

select * from #data where fbanitemid=0 and fxinitemid=0
select * from #data where fisyinqing=0 and fyinqingitemid=0
select * from #data where fisyinqing<>0 or fyinqingitemid<>0


--相同半成品--有芯片
select t4.fnumber,t4.fname,t4.fmodel,t7.*
--update t6 set --f_126=
--update t5 set --f_127=t2.fitemid
--update t7 set fisyinqing=1,fyinqingitemid=t7.fitemid
from #data t7
inner join
(
	select t1.fbanitemid,min(t2.fitemid) fitemid
	from #data t1
	inner join t_icitem t2 on t1.fitemid=t2.fitemid
	where left(t2.fnumber,4) in ('a.01','p.01','j.01','x.01','y.01')
	and (t1.fxinitemid)>0
	group by t1.fbanitemid
) t2 on t7.fitemid=t2.fitemid
inner join t_icitem t4 on t2.fitemid=t4.fitemid



select t3.fnumber,t3.fname,t3.fmodel,t4.fnumber,t4.fname,t4.fmodel,t7.*
--update t6 set --f_126=
--update t5 set --f_127=t2.fitemid
--update t7 set fyinqingitemid=t2.fitemid
from (select fitemid,fbanitemid from #data where fisyinqing=0 and fxinitemid>0) t1
inner join (select fitemid,fbanitemid from #data where fisyinqing=1 and fxinitemid>0) t2 on t1.fbanitemid=t2.fbanitemid
inner join t_icitem t3 on t1.fitemid=t3.fitemid
inner join t_icitem t4 on t2.fitemid=t4.fitemid
inner join #data t7 on t7.fitemid=t1.fitemid


select * from #data where fbanitemid=0 and fxinitemid=0

select t3.fnumber 产品编码,t3.fname 产品名称,t3.fmodel 产品型号,t4.fnumber 引擎编码,t4.fname 引擎名称,t4.fmodel 引擎型号,
t7.fnumber 半成品编码,t7.fname 半成品名称,t7.fmodel 半成品型号,t8.fnumber 芯片编码,t8.fname 芯片名称,t8.fmodel 芯片型号,
(case when t1.fisyinqing=1 then 'Y' end) 是否引擎,(case when t1.fisyinqing=0 and t1.fyinqingitemid=0 then 'Y' end) 是否个性化产品,t9.fprice 出厂价
from #data t1
inner join t_icitem t3 on t1.fitemid=t3.fitemid
left join t_icitem t4 on t1.fyinqingitemid=t4.fitemid
left join t_icitem t7 on t1.fbanitemid=t7.fitemid
left join t_icitem t8 on t1.fxinitemid=t8.fitemid
left join IcPrcPlyEntry t9 on t9.fitemid=t1.fitemid
-- inner join t_ICItemCustom t5 on t1.fitemid=t5.fitemid
-- inner join t_ICItemCustom t6 on t2.fitemid=t6.fitemid --产品引擎 Y
where left(t3.fnumber,4) in ('a.01','p.01','j.01','x.01','y.01','v.b.')
order by t4.fnumber,t3.fnumber


select t1.fnumber
	from t_icitem t1
		inner join t_item t13 on t13.fitemid=t1.fparentid 
		inner join icbom t2 on t1.fitemid=t2.fitemid
		inner join icbomchild t3 on t2.finterid=t3.finterid
		inner join t_icitem t4 on t3.fitemid=t4.fitemid
where t4.fnumber='3.01.002.300002'

select * from #data where fisyinqing<>0 or fyinqingitemid<>0


--相同的半成品和芯片
select t3.fnumber,t3.fname,t3.fmodel,t4.fnumber,t4.fname,t4.fmodel,t1.*,t2.*
--update t5 set f_127=t2.fitemid
from
(
	select t1.fitemid,t1.fbanitemid,t1.fxinitemid  --t2.fnumber,t2.fname,t2.fmodel, --个性化产品
	from #data t1
	inner join t_icitem t2 on t1.fitemid=t2.fitemid
	where left(t2.fnumber,4) not in ('a.01','p.01','j.01','x.01','y.01')
	and left(t2.fnumber,4) in ('v.b.')
	and (t1.fbanitemid+t1.fxinitemid)>0
) t1
inner join
(
	select t1.fitemid,t1.fbanitemid,t1.fxinitemid  --t2.fnumber,t2.fname,t2.fmodel,  --傲威中性
	from #data t1
	inner join t_icitem t2 on t1.fitemid=t2.fitemid
	where left(t2.fnumber,4) in ('a.01','p.01','j.01','x.01','y.01')
	and (t1.fbanitemid+t1.fxinitemid)>0
) t2 on t1.fbanitemid=t2.fbanitemid and t1.fxinitemid=t2.fxinitemid
inner join t_icitem t3 on t1.fitemid=t3.fitemid
inner join t_icitem t4 on t2.fitemid=t4.fitemid
inner join t_ICItemCustom t5 on t1.fitemid=t5.fitemid




----无纸箱--有可能客户提供纸箱
--select t5.fname fmanager,t2.fnumber,t2.fname,t2.fmodel,t2.f_105 fdesc,isnull(t2.f_106,'') fsuitmodel
--from
--(
--	select fitemid,max(fzhixiangitemid) fzhixiangitemid,max(fzhiheitemid) fzhiheitemid
--	from
--	(
--		select t1.fitemid,
--		case when left(t4.fnumber,5) in ('2.01.') then t4.fitemid else 0 end fzhixiangitemid,
--		case when left(t4.fnumber,5) in ('2.02','2.03','2.04') then t4.fitemid else 0 end fzhiheitemid
--		from t_icitem t1
--		inner join t_item t13 on t13.fitemid=t1.fparentid 
--		inner join icbom t2 on t1.fitemid=t2.fitemid
--		inner join icbomchild t3 on t2.finterid=t3.finterid
--		inner join t_icitem t4 on t3.fitemid=t4.fitemid
--		where --left(t1.fnumber,4) in ('a.01','p.01','j.01','x.01','y.01') 
--		left(t1.fnumber,1) in (select fitemtype from v_myitemtype where ftype=0)
--		and t2.fstatus>0
--	) t1 group by t1.fitemid
--) t1 inner join t_icitem t2 on t1.fitemid=t2.fitemid
--left join t_SubMessage t5 on t5.finterid=t2.F_128
--where t1.fzhixiangitemid=0 and left(t2.fnumber,1) not in ('q','r') 
--order by t5.fname,t2.fnumber

declare @fbegdate datetime ,@fenddate datetime
select @fbegdate='********',@fenddate='########'
 
select month(t1.fdate) 月份,t4.fname 类别,sum(t2.fqty) 数量
from icstockbill t1
inner join icstockbillentry t2 on t1.finterid=t2.finterid
inner join t_icitem t3 on t2.fitemid=t3.fitemid
inner join t_submessage t4 on t4.finterid=t3.ftypeid
where t1.fdate>=@fbegdate and t1.fdate<=@fenddate --and left(t3.fnumber,1) in ('a','p')
and t1.frob=1 --and t4.fname not like '其它'
and t1.ftrantype=21
group by month(t1.fdate),t4.fname
union all
select month(t1.fdate) 月份,'ZZZZZZZ' 类别,sum(t2.fqty) 数量
from icstockbill t1
inner join icstockbillentry t2 on t1.finterid=t2.finterid
inner join t_icitem t3 on t2.fitemid=t3.fitemid
inner join t_submessage t4 on t4.finterid=t3.ftypeid
where t1.fdate>=@fbegdate and t1.fdate<=@fenddate --and left(t3.fnumber,1) in ('a','p')
and t1.frob=1 --and t4.fname not like '其它'
and t1.ftrantype=21
group by month(t1.fdate)
order by 月份,类别


select month(t1.fdate) 月份,sum(t2.fqty) 数量
from icstockbill t1
inner join icstockbillentry t2 on t1.finterid=t2.finterid
inner join t_icitem t3 on t2.fitemid=t3.fitemid
inner join icbom t4 on t4.fitemid=t3.fitemid
inner join icbomchild t5 on t4.finterid=t5.finterid
inner join t_icitem t6 on t5.fitemid=t6.fitemid
where t1.fdate>='2015-01-01' and t1.fdate<='2015-12-31' and left(t6.fnumber,1) in ('3','4','5','7','8')
and t1.frob=1
and t1.ftrantype=21
group by month(t1.fdate)
order by month(t1.fdate)
-------------------------------------------------------------------------------------------------------------
select t5.fname 项目经理,isnull(t14.fname,'') 打印机品牌,
t1.fshortnumber 短代码,t1.fnumber 长代码,t1.fname 产品名称,t3.ffullname 全称,t1.fmodel 规格型号,
isnull(t1.f_105,'') 描述,isnull(t1.f_106,'') 适用机型,isnull(t1.F_107,'') 适用区域,
t7.fnumber 子项编码,t7.fname 子项名称,t7.fmodel 子项规格型号,t6.fqty 用量 
from t_icitem t1
left join t_baseproperty t2 on t1.fitemid=t2.fitemid
left join t_item t13 on t13.fitemid=t1.F_103 and t13.fitemclassid=3004  --外盒尺寸  --select * from t_item where fitemclassid=3004
left join t_SubMessage t14 on t14.finterid=t1.F_102  --打印机品牌  select * from t_submessage where ftypeid=10001
inner join t_item t3 on t3.fitemid=t1.fitemid
left join t_user t4 on t4.fuserid=t3.FChkUserID and t4.fuserid<>0
left join t_supplier t8 on t8.fitemid=t1.F_117 --t3.fsource
inner join icbom t9 on t9.fitemid=t1.fitemid
left join t_SubMessage t5 on t5.finterid=t1.F_128  --select * from t_submestype
inner join icbomchild t6 on t6.finterid=t9.finterid
inner join t_icitem t7 on t7.fitemid=t6.fitemid
where --left(t1.fnumber,4) in ('a.01','p.01','j.01','x.01','y.01')
left(t1.fnumber,4) in ('v.b.')
and t9.fstatus=0  
and t1.fname not like '%禁用%' 
--and t5.fname='汤传义'
--and t9.finterid in (select finterid from icbom where FOperatorID=16394 and FEnterTime='2015-01-20')
--and t1.fnumber='A.01.01.001.A00005'
order by --t5.fname,t14.fname,
t1.fnumber,t7.fnumber


select t5.fname 项目经理,isnull(t14.fname,'') 打印机品牌,
(case when left(t7.fnumber,4) in ('2.05') then 'Y' else '' end ) 粉盒标签,
(case when left(t7.fnumber,4) in ('2.06') then 'Y' else '' end ) 纸盒标签,
t1.fshortnumber 短代码,t1.fnumber 长代码,t1.fname 产品名称,t3.ffullname 全称,t1.fmodel 规格型号,
isnull(t1.f_105,'') 描述,isnull(t1.f_106,'') 适用机型,isnull(t1.F_107,'') 适用区域,
t7.fnumber 子项编码,t7.fname 子项名称,t7.fmodel 子项规格型号,t6.fqty 用量 
into #data
from t_icitem t1
left join t_baseproperty t2 on t1.fitemid=t2.fitemid
left join t_item t13 on t13.fitemid=t1.F_103 and t13.fitemclassid=3004  --外盒尺寸  --select * from t_item where fitemclassid=3004
left join t_SubMessage t14 on t14.finterid=t1.F_102  --打印机品牌  select * from t_submessage where ftypeid=10001
inner join t_item t3 on t3.fitemid=t1.fitemid
left join t_user t4 on t4.fuserid=t3.FChkUserID and t4.fuserid<>0
left join t_supplier t8 on t8.fitemid=t1.F_117 --t3.fsource
inner join icbom t9 on t9.fitemid=t1.fitemid
left join t_SubMessage t5 on t5.finterid=t1.F_128  --select * from t_submestype
inner join icbomchild t6 on t6.finterid=t9.finterid
inner join t_icitem t7 on t7.fitemid=t6.fitemid
where left(t1.fnumber,4) in ('a.01','p.01','j.01','x.01','y.01')
--left(t1.fnumber,4) in ('v.b.')
and t9.fstatus=0  
and t1.fname not like '%禁用%' 
--and t5.fname='汤传义'
--and t9.finterid in (select finterid from icbom where FOperatorID=16394 and FEnterTime='2015-01-20')
--and t1.fnumber='A.01.01.001.A00005'
order by --t5.fname,t14.fname,
t1.fnumber,t7.fnumber

update t1 set 粉盒标签='Y'
from #data t1
inner join (select 短代码 from #data where 粉盒标签='Y') t2 on t1.短代码=t2.短代码

update t1 set 纸盒标签='Y'
from #data t1
inner join (select 短代码 from #data where 纸盒标签='Y') t2 on t1.短代码=t2.短代码

select * from #data where 粉盒标签='' or 纸盒标签='' order by 项目经理,打印机品牌,长代码,子项编码

-------------------------------------------------------------------------------------------
--select * from t_itempropdesc where fitemclassid=4  --drop table #data456

select t5.fname 项目经理,isnull(t14.fname,'') 打印机品牌,isnull(t16.fshortname,'') 主供应商,
t1.fshortnumber 短代码,t1.fnumber 长代码,t1.fname 产品名称,t3.ffullname 全称,t1.fmodel 规格型号,
isnull(t1.f_105,'') 描述,isnull(t1.f_106,'') 适用机型,isnull(t1.F_107,'') 适用区域,
(case when isnull(t1.F_109,'')='' then '0*0*0' else t1.F_109 end) [标准外箱尺寸(mm)],
(case when isnull(t1.F_111,'')='' then '0*0*0' else t1.F_111 end) [标准外盒尺寸(mm)],
isnull(t1.F_112,0) [整箱净重(kg)],isnull(t1.F_119,0) [整箱毛重(kg)],isnull(t1.F_110,0) 标准装箱数,
--(case when isnull(t1.F_120,'')='' then '0*0*0' else t1.F_120 end) [裸包标准外箱尺寸(mm)],
--isnull(t1.F_122,0) [裸包整箱净重(kg)],isnull(t1.F_123,0) [裸包整箱毛重(kg)],isnull(t1.F_121,0) 裸包标准装箱数,
isnull(t13.fname,'') 外盒尺寸,t1.FGrossWeight [毛重(kg)],t1.FNetWeight [净重(kg)],
isnull(t9.fbomnumber,'') BOM编号,cast('' as varchar(50)) 是否计划禁用,cast('' as varchar(50)) 是否自制,
cast('' as varchar(50)) 是否需要新增,cast('' as varchar(50)) 是否需要先补BOM  ,cast('' as varchar(50)) 引用BOM编号
into #data456
--t2.fcreatedate 创建时间,t2.fcreateuser 创建人,t2.flastmoddate 最后修改时间,t2.flastmoduser 最后修改人,t2.fdeletedate 禁用时间,t2.fdeleteuser 禁用人
from t_icitem t1
left join t_baseproperty t2 on t1.fitemid=t2.fitemid
left join t_item t13 on t13.fitemid=t1.F_103 and t13.fitemclassid=3004  --外盒尺寸  --select * from t_item where fitemclassid=3004
left join t_SubMessage t14 on t14.finterid=t1.F_102  --打印机品牌  select * from t_submessage where ftypeid=10001
inner join t_item t3 on t3.fitemid=t1.fitemid
left join t_user t4 on t4.fuserid=t3.FChkUserID and t4.fuserid<>0
left join t_supplier t8 on t8.fitemid=t1.F_117 --t3.fsource
inner join icbom t9 on t9.fitemid=t1.fitemid
left join t_SubMessage t5 on t5.finterid=t1.F_128  --select * from t_submestype
left join t_supplier t16 on t16.fitemid=t1.F_117 
where left(t1.fnumber,4) in ('a.01','p.01','j.01','x.01','y.01','v.b.') 
--left(t1.fnumber,4) in ('v.b.') 
--and t9.finterid in (select finterid from icbom where FOperatorID=16394 and FEnterTime='2015-01-20')
--and t1.fnumber='A.01.01.001.A00005'
order by t5.fname,t14.fname,t1.fnumber

--select * from #data456 t1 where isnull(t1.项目经理,'')=''

select t2.项目经理,t1.*
--update t4 set F_128=t5.finterid
from #data456 t1 
inner join #data456 t2 on left(t1.长代码,11)=left(t2.长代码,11) and isnull(t2.项目经理,'')<>''
inner join t_SubMessage t5 on t5.fname=t2.项目经理 and t5.ftypeid=10020
inner join t_icitem t3 on t3.fnumber=t1.长代码
inner join t_ICItemCustom t4 on t3.fitemid=t4.fitemid
where isnull(t1.项目经理,'')=''

--------------------------------------------------------------------
select distinct t3.*
--update t3 set funitid=t2.funitid
from t_icitem t2 
inner join icbom t3 on t2.fitemid=t3.fitemid
inner join icbomchild t4 on t4.finterid=t3.finterid
inner join t_icitem t5 on t5.fitemid=t4.fitemid
where --t2.fnumber like 'p.01.05.065%'
t3.funitid=0

select * from t_icitem where funitid=0

select t5.fnumber,t5.fname,t5.fmodel,len(t1.长代码), *
--update t1 set 是否自制='Y'
from #data456 t1
inner join t_icitem t2 on t1.长代码=t2.fnumber
inner join icbom t3 on t2.fitemid=t3.fitemid
inner join icbomchild t4 on t4.finterid=t3.finterid
inner join t_icitem t5 on t5.fitemid=t4.fitemid
where left(t5.fnumber,1) in ('3','4','5') 

Black/NEW OPC/Without Chip/Premium
BlacK/NEW OPC/With Chip/Standard

select * from #data456 where 打印机品牌 not in ('hp','canon','brother','samsung') and 是否自制=''

select t0.fname,t11.fname,t7.F_105,replace(t7.F_105,'Standard','Premium'),replace(t0.fname,'标配','高配-高附'),t5.FLastModDate,t1.*
--update t11 set fname=replace(t0.fname,'标配','高配-高附')
--update t0 set fname=replace(t0.fname,'标配','高配-高附')
--update t7 set F_105=replace(t7.F_105,'Standard','Premium')
--update t7 set F_105=t7.F_105+'/Premium'
from #data456 t1
inner join t_ICItemCore t0 on t0.fnumber=t1.长代码
inner join t_item t11 on t11.fitemid=t0.fitemid
inner JOIN t_ICItemCustom t7 ON t0.FItemID=t7.FItemID
left join t_baseproperty t5 on t5.fitemid=t0.fitemid
left join IcPrcPlyEntry t4 on t4.fitemid=t0.fitemid
where (打印机品牌 not in ('hp','canon','brother','samsung') or (CHARINDEX('再生',t1.产品名称)>0 and 是否自制='Y'))
and (CHARINDEX('高配',t1.产品名称)=0 or CHARINDEX('Premium',t7.F_105)=0) and t1.产品名称 not like '%禁用%'
and t1.产品名称 like '%标配%'  

and t1.产品名称 like '%高附%' 
and t7.F_105 not like '%Premium%'



select t0.fname,t11.fname,t7.F_105,replace(t7.F_105,'Premium','Standard'),replace(t0.fname,'高配-高附','标配'),t5.FLastModDate,t1.*
--update t11 set fname=replace(t0.fname,'高配-高附','标配')
--update t0 set fname=replace(t0.fname,'高配-高附','标配')
--update t7 set F_105=replace(t7.F_105,'Premium','Standard')
--update t7 set F_105=t7.F_105+'/Premium'
from #data456 t1
inner join t_ICItemCore t0 on t0.fnumber=t1.长代码
inner join t_item t11 on t11.fitemid=t0.fitemid
inner JOIN t_ICItemCustom t7 ON t0.FItemID=t7.FItemID
left join t_baseproperty t5 on t5.fitemid=t0.fitemid
left join IcPrcPlyEntry t4 on t4.fitemid=t0.fitemid
where (打印机品牌 in ('hp','canon','brother','samsung')  and 是否自制<>'Y') and t11.fnumber not like 'y%'
and (CHARINDEX('标配',t1.产品名称)=0 ) and t1.产品名称 not like '%禁用%'

and t1.产品名称 like '%标配%'  

and t1.产品名称 like '%高附%' 
and t7.F_105 not like '%Premium%'


select t7.F_105,replace(t7.F_105,'Standard','Premium'),replace(t0.fname,'标配','高配-高附'),t1.*
--update t11 set fname=replace(t0.fname,'标配','高配-高附')
--update t0 set fname=replace(t0.fname,'标配','高配-高附')
--update t7 set F_105=replace(t7.F_105,'Standard','Premium')
--update t7 set F_105=t7.F_105+'/Premium'
from #data456 t1
inner join t_ICItemCore t0 on t0.fnumber=t1.长代码
inner join t_item t11 on t11.fitemid=t0.fitemid
inner JOIN t_ICItemCustom t7 ON t0.FItemID=t7.FItemID
--inner join t_baseproperty t5 on t5.fitemid=t0.fitemid
left join IcPrcPlyEntry t4 on t4.fitemid=t0.fitemid
where (打印机品牌 not in ('hp','canon','brother','samsung') or (CHARINDEX('再生',t1.产品名称)>0 and 是否自制='Y')) 
and t1.产品名称 like '%标配%' and t1.产品名称 not like '%高附%'
and t7.F_105 not like '%Premium%'


select t6.fname,t7.F_105,replace(t7.F_105,'Standard','Premium'),replace(t0.fname,'标配','高配-高附'),t1.*
from #data456 t1
inner join t_ICItemCore t0 on t0.fnumber=t1.长代码
inner join t_item t11 on t11.fitemid=t0.fitemid
inner JOIN t_ICItemCustom t7 ON t0.FItemID=t7.FItemID
--inner join t_baseproperty t5 on t5.fitemid=t0.fitemid
left join IcPrcPlyEntry t4 on t4.fitemid=t0.fitemid
inner join t_icitem t8 on t8.fitemid=t0.fitemid
inner join t_submessage t6 on t6.finterid=t8.ftypeid
where (打印机品牌 not in ('hp','canon','brother','samsung') or (CHARINDEX('再生',t1.产品名称)>0 and 是否自制='Y')) 
and t1.产品名称 like '%标配%' --and t1.产品名称 not like '%高附%'
--and t7.F_105 not like '%Premium%'
order by t6.fname

--select * from t_itempropdesc where fitemclassid=4

select t7.F_105,replace(t7.F_105,'Standard','Premium'),replace(t0.fname,'标配','高配-高附'),t1.*
--update t11 set fname=replace(t0.fname,'标配','高配-高附')
--update t0 set fname=replace(t0.fname,'标配','高配-高附')
--update t7 set F_105=replace(t7.F_105,'Standard','Premium')
--update t11 set fcheckdate='2015-01-28'
--update t5 set flastmoddate='2015-01-28'
--update t11 set FChkUserID=16394
from #data456 t1
inner join t_ICItemCore t0 on t0.fnumber=t1.长代码
inner join t_item t11 on t11.fitemid=t0.fitemid
inner JOIN t_ICItemCustom t7 ON t0.FItemID=t7.FItemID
inner join t_baseproperty t5 on t5.fitemid=t0.fitemid
left join IcPrcPlyEntry t4 on t4.fitemid=t0.fitemid
where 打印机品牌 not in ('hp','canon','brother','samsung') and 是否自制='' and t1.产品名称 like '%标配%'
and substring(t1.长代码,1,dbo.My_F_Charindex(t1.长代码,'.',4)-1) not in 
(
	select distinct substring(t1.长代码,1,dbo.My_F_Charindex(t1.长代码,'.',4)-1)
	--select t1.*
	from #data456 t1 
	where 打印机品牌 not in ('hp','canon','brother','samsung')  --and t1.长代码 like 'A.01.05.011%'
	and t1.产品名称 like '%高配%' --and 是否自制='' 
) order by 项目经理,长代码

select * from #data456 where 产品名称 not like '%高配%' and 产品名称 not like '%标配%' and 产品名称 not like '%经济%'

select len(t1.长代码), *
--update t1 set 是否计划禁用='Y'
from #data456 t1
where 项目经理='唐勇' and t1.产品名称 like '%标配%' and 是否自制='Y'

select *
--update t1 set 是否需要新增='Y'
from #data456 t1
where 项目经理='唐勇' and t1.产品名称 like '%标配%' and 是否自制='Y'
and substring(t1.长代码,1,dbo.My_F_Charindex(t1.长代码,'.',4)-1) not in 
(
	select distinct substring(t1.长代码,1,dbo.My_F_Charindex(t1.长代码,'.',4)-1)
	from #data456 t1
	where 项目经理='唐勇' and t1.产品名称 like '%高配%' --and 是否自制='Y'
)

select *
--update t1 set 是否需要先补BOM='Y'
from #data456 t1
where 项目经理='唐勇' 
and substring(t1.长代码,1,dbo.My_F_Charindex(t1.长代码,'.',4)-1) not in 
(
	select distinct substring(t1.长代码,1,dbo.My_F_Charindex(t1.长代码,'.',4)-1)
	from #data456 t1
	where 项目经理='唐勇' and t1.BOM编号 <>''
)


select * from #data456 t1 where 项目经理='唐勇'
---------------------------------------------------------------------------------------

select len(t1.长代码), *
--update t1 set 是否计划禁用='Y'
from #data456 t1
where 项目经理='汤传义' and t1.产品名称 like '%标配%'

select *
--update t1 set 是否需要新增='Y'
from #data456 t1
where 项目经理='汤传义' and t1.产品名称 like '%标配%'
and substring(t1.长代码,1,dbo.My_F_Charindex(t1.长代码,'.',4)-1) not in 
(
	select distinct substring(t1.长代码,1,dbo.My_F_Charindex(t1.长代码,'.',4)-1)
	from #data456 t1
	where 项目经理='汤传义' and t1.产品名称 like '%高配%'
)

select *
--update t1 set 是否需要先补BOM='Y'
from #data456 t1
where 项目经理='汤传义' 
and substring(t1.长代码,1,dbo.My_F_Charindex(t1.长代码,'.',4)-1) not in 
(
	select distinct substring(t1.长代码,1,dbo.My_F_Charindex(t1.长代码,'.',4)-1)
	from #data456 t1
	where 项目经理='汤传义' and t1.BOM编号 <>''
)

--------------------------------------------------------------------

select len(t1.长代码), *
--update t1 set 是否计划禁用='Y'
from #data456 t1
where 项目经理='刘均庆' and 打印机品牌<>'Samsung' and t1.产品名称 like '%标配%'

select *
--update t1 set 是否需要新增='Y'
from #data456 t1
where 项目经理='刘均庆' and 打印机品牌<>'Samsung' and t1.产品名称 like '%标配%'
and substring(t1.长代码,1,dbo.My_F_Charindex(t1.长代码,'.',4)-1) not in 
(
	select distinct substring(t1.长代码,1,dbo.My_F_Charindex(t1.长代码,'.',4)-1)
	from #data456 t1
	where 项目经理='刘均庆' and 打印机品牌<>'Samsung' and t1.产品名称 like '%高配%'
)

select *
--update t1 set 是否需要先补BOM='Y'
from #data456 t1
where 项目经理='刘均庆' and 打印机品牌<>'Samsung'
and substring(t1.长代码,1,dbo.My_F_Charindex(t1.长代码,'.',4)-1) not in 
(
	select distinct substring(t1.长代码,1,dbo.My_F_Charindex(t1.长代码,'.',4)-1)
	from #data456 t1
	where 项目经理='刘均庆' and 打印机品牌<>'Samsung' and t1.BOM编号 <>''
)

--------------------------------------------------------------------

select substring(t1.长代码,1,dbo.My_F_Charindex(t1.长代码,'.',4)-1),replace(产品名称,'标配','高配'),replace(描述,'Standard','Premium'),* from #data456 t1 where 项目经理='唐勇' and 是否需要新增='Y' order by 长代码


--先新增高配编码
select t3.产品名称,t1.*,'////////////',t2.*
--update t3 set 引用BOM编号=t1.BOM编号
from
(
	select substring(t1.长代码,1,dbo.My_F_Charindex(t1.长代码,'.',4)-1) 上级组,*
	from #data456 t1
	where 项目经理='唐勇' and 是否自制='Y' and t1.产品名称 like '%标配%' and t1.BOM编号 <>''
) t1 inner join 
(
	select substring(t1.长代码,1,dbo.My_F_Charindex(t1.长代码,'.',4)-1) 上级组,*
	from #data456 t1
	where 项目经理='唐勇' and t1.产品名称 like '%高配%' and t1.BOM编号 =''
) t2 on t1.上级组=t2.上级组 and t1.规格型号=t2.规格型号
inner join #data456 t3 on t3.长代码=t2.长代码



select t1.*,'////////////',t2.*
--update t3 set 引用BOM编号=t1.BOM编号
from
(
	select substring(t1.长代码,1,dbo.My_F_Charindex(t1.长代码,'.',4)-1) 上级组,*
	from #data456 t1
	where 项目经理='刘均庆' and 打印机品牌<>'Samsung' and t1.产品名称 like '%标配%' and t1.BOM编号 <>''
) t1 inner join 
(
	select substring(t1.长代码,1,dbo.My_F_Charindex(t1.长代码,'.',4)-1) 上级组,*
	from #data456 t1
	where 项目经理='刘均庆' and 打印机品牌<>'Samsung' and t1.产品名称 like '%高配%' and t1.BOM编号 =''
) t2 on t1.上级组=t2.上级组 and t1.规格型号=t2.规格型号
inner join #data456 t3 on t3.长代码=t2.长代码


select t1.*,'////////////',t2.*
--update t3 set 引用BOM编号=t1.BOM编号
from
(
	select substring(t1.长代码,1,dbo.My_F_Charindex(t1.长代码,'.',4)-1) 上级组,*
	from #data456 t1
	where 项目经理='汤传义' and t1.产品名称 like '%标配%' and t1.BOM编号 <>''
) t1 inner join 
(
	select substring(t1.长代码,1,dbo.My_F_Charindex(t1.长代码,'.',4)-1) 上级组,*
	from #data456 t1
	where 项目经理='汤传义' and t1.产品名称 like '%高配%' and t1.BOM编号 =''
) t2 on t1.上级组=t2.上级组 and t1.规格型号=t2.规格型号
inner join #data456 t3 on t3.长代码=t2.长代码


SELECT t10.fname+'[计划禁用]',t10.fdeleted,
t0.FItemID,t0.FModel,t0.FName,t0.FHelpCode,t0.FDeleted,t0.FShortNumber,t0.FNumber,
t1.FErpClsID,t1.FUnitID,t1.FUnitGroupID,t1.FDefaultLoc
--update t10 set fname=t10.fname+'[计划禁用]'
--update t0 set fname=t0.fname+'[计划禁用]'
FROM t_ICItemCore t0
LEFT JOIN t_ICItemBase t1 ON t0.FItemID=t1.FItemID
inner join t_icitem t9 on t9.fitemid=t0.fitemid
inner join t_item t10 on t9.fitemid=t10.fitemid
inner join 
(
	select *
	from
	(
-- 		select * from #data456 t1 where 项目经理='刘均庆' and 是否计划禁用='Y' and 是否需要先补BOM=''
-- 		union all
-- 		select * from #data456 t1 where 项目经理='汤传义' and 是否计划禁用='Y' and 是否需要先补BOM=''
-- 		union all 
		select * from #data456 t1 where 项目经理='唐勇' and 是否计划禁用='Y' and 是否需要先补BOM=''
	) t1 
) t11 on t11.长代码=t9.fnumber	
where CHARINDEX('禁用',t0.fname)=0 

select * from #data456


--select t5.fdefaultloc,t14.FInterID fbomgroupid,t5.funitid,t5.fitemid,t4.fitemid fproductid,t3.fqty
--from
--(
--	select *
--	from
--	(
--		select * from #data456 t1 where 项目经理='刘均庆' 
--		union all
--		select * from #data456 t1 where 项目经理='汤传义' 
--	) t1 where 引用BOM编号<>''
--) t1 inner join icbom t2 on t1.引用BOM编号=t2.fbomnumber
--inner join icbomchild t3 on t2.finterid=t3.finterid
--inner join t_icitem t4 on t4.fnumber=t1.长代码
--inner join t_icitem t5 on t5.fitemid=t3.fitemid
--inner join t_item t13 on t4.FParentID=t13.fitemid
--inner join ICBomGroup t14 on t14.fnumber=t13.fnumber
--where not exists(select 1 from icbom where fitemid=t4.fitemid)
----and t4.fdeleted=0 and t4.fdeleted=0
--order by t4.fitemid,t3.fentryid



select t1.fbomnumber,t3.fnumber,t3.fmodel,t4.fnumber,t4.fname,t4.fmodel ,t2.fqty
from icbom t1
inner join icbomchild t2 on t1.finterid=t2.finterid
inner join t_icitem t3 on t1.fitemid=t3.fitemid
inner join t_icitem t4 on t2.fitemid=t4.fitemid
where left(t3.fnumber,4) in ('a.01','p.01','j.01','x.01','y.01') 
order by t1.fbomnumber


select t1.fbomnumber,t3.fnumber,t3.fname,t3.fmodel,t4.fnumber,t4.fname,t4.fmodel ,t2.fqty
--select distinct t4.fnumber,t4.fname,t4.fmodel
from icbom t1
inner join icbomchild t2 on t1.finterid=t2.finterid
inner join t_icitem t3 on t1.fitemid=t3.fitemid
inner join t_icitem t4 on t2.fitemid=t4.fitemid
where --left(t3.fnumber,4) in ('a.01','p.01','j.01','x.01','y.01') 
t4.fnumber like '2.01.%' --and t4.fname like '%鑫威通用%' --and t4.fname not like '%合并%'
and t2.fqty=1
order by t1.fbomnumber



select * from t_submestype

declare @fminid int,@fmaxid int,@fentryminid int,@fentrymaxid int,@fpreitemid int

create table #Cursor(FID int identity(1,1),finterid int,fentryid int,fitemid int,FQty decimal(24,2))
create table #CursorEntry(FID int identity(1,1),finterid int,fentryid int,fitemid int,FQty decimal(24,2),frepitemid int)

select @fpreitemid=0,@fcanuseqty=0

truncate table #Cursor
insert into #Cursor(fitemid,fparentid)
select t1.fitemid,t1.fparentid
from t_icitem t1
inner join t_item t13 on t13.fitemid=t1.fparentid 
inner join t_SubMessage t14 on t14.finterid=t1.F_102  --打印机品牌
where t14.finterid not in () and t1.fname like '%标配%'

select @fminid=0,@fmaxid=0
select @fminid=isnull(min(fid),0),@fmaxid=isnull(max(fid),0) from #Cursor

WHILE @fmaxid>0 and @fminid<=@fmaxid --@@FETCH_STATUS = 0  --先把可用库存按物料先分配下去
BEGIN 
	select @fparentid=fparentid,@fitemid=fitemid from #Cursor where fid=@fminid
	select @fparentnumber=fnumber+'%' from t_item where fitemid=@fparentid
	
	if exists(select 1 from t_icitem where fnumber like @fparentnumber and fname like '%高配%')
	begin
	    select @fgaopeiitemid=fitemid from t_icitem where fnumber like @fparentnumber and fname like '%高配%'
		if exists(select 1 from icbom where fitemid=@fgaopeiitemid)
		begin
		
		end
		else
		begin
			insert into icbom
			select from icbom where fitemid=
		end
	end
	else --如果该组别的高配编码不存在,则将标配的编码复制成高配编码，并将名称和描述改掉
	begin
		INSERT INTO t_Item (ffullnumber,FItemClassID,FParentID, FLevel, FName,  FNumber, FShortNumber,  FDetail,UUID,     FDeleted) 
		VALUES 			   (@fnumber,   4,           @FParentID,@FLevel,@fname, @fnumber,@FShortNumber, 1,      newid() , 0)

		select @fitemid=FItemID,@ffullname=ffullname from t_Item where fdetail=1 and fitemclassid=4 and fnumber=@fnumber


		INSERT INTO t_ICItem (F_123,           F_126,             F_125,            FHelpCode,FModel,   FAuxClassID,FErpClsID,FTypeID,FUnitGroupID,FUnitID,FOrderUnitID,FSaleUnitID,FProductUnitID,FStoreUnitID,FSecUnitID,FSecCoefficient,  FDefaultLoc,FSPID,FSource,      FQtyDecimal,FLowLimit,FHighLimit,FSecInv,FUseState,FIsEquipment,FEquipmentNum,FIsSparePart,FFullName,  FApproveNo,FAlias,FOrderRector,FPOHighPrice,FPOHghPrcMnyType,FWWHghPrc,FWWHghPrcMnyType,FSOLowPrc,FSOLowPrcMnyType,FIsSale,FProfitRate,FOrderPrice,FSalePrice,FIsSpecialTax,FISKFPeriod,FKFPeriod,FStockTime,FBatchManager,FBookPlan,FBeforeExpire,FCheckCycUnit,FOIHighLimit,FOILowLimit,FSOHighLimit,FSOLowLimit,FInHighLimit,FInLowLimit,FTrack,FPlanPrice,FPriceDecimal,FAcctID,FSaleAcctID,FCostAcctID,FAPAcctID,FAdminAcctID,FGoodSpec,FTaxRate,FCostProject,FIsSNManage,FNote,F_102,         F_104,F_103,         F_105, F_109,        F_122,        F_110,          F_119,             F_118,      F_121,        F_117,        F_116,          F_115,       FPlanTrategy,FOrderTrategy,FFixLeadTime,FLeadTime,FTotalTQQ,FOrderInterVal,FQtyMin,FQtyMax,FBatchAppendQty,FOrderPoint,FBatFixEconomy,FBatChangeEconomy,FRequirePoint,FPlanPoint,FDefaultRoutingID,FDefaultWorkTypeID,FProductPrincipal,FPlanner,FPutInteger,FDailyConsume,FMRPCon,FMRPOrder,FChartNumber,FIsKeyItem,FGrossWeight,FNetWeight, FMaund,FLength, FWidth, FHeight,  FSize,FCubicMeasure,FStandardCost,FStandardManHour,FStdPayRate,FChgFeeRate,FStdFixFeeRate,FOutMachFee,FPieceRate,FInspectionLevel,FProChkMde,FWWChkMde,FSOChkMde,FWthDrwChkMde,FStkChkMde,FOtherChkMde,FStkChkPrd,FStkChkAlrm,FInspectionProject,FIdentifier,FVersion,FNameEn,FModelEn,FHSNumber,FFirstUnit,FSecondUnit,FImpostTaxRate,FConsumeTaxRate,FFirstUnitRate,FSecondUnitRate,FIsManage,FManageType,FLenDecimal,FCubageDecimal,FWeightDecimal,FIsCharSourceItem,FShortNumber, FNumber, FName, FParentID, FItemID)   
		select top 1          @FStdNudeBoxSize,@FStdNudeNetWeight,@FStandardNudeQty,NULL,     @fmodel,  0,          1,        0,      FUnitGroupID,FUnitID,FOrderUnitID,FSaleUnitID,FProductUnitID,FStoreUnitID,0,         0,                0,          0,    FSource,      0,          0,        0,         0,      341,      0,            NULL,        0,           @ffullname, NULL,      NULL,  0,           0,           1,               0,        1,               0,        1,               0,      0,          0,          0,         0,            0,          0,        0,         FBatchManager,0,        0,            0,            0,           0,          0,           0,          0,           0,          80,    0,         FPriceDecimal,FAcctID,FSaleAcctID,FCostAcctID,0,        0,           0,        FTaxRate,0,           0,          NULL, @FCompatModel, 0,    @fdescription, F_105, @FCompatArea, @FMainSupName,@fprintbrandid, @FColourSizeTypeID,@FNetWeight,@FGrossWeight,@FStandardQty,@FStdColourSize,@FStdBoxSize,321,         331,          0,           1,        0,        0,             1,      10000,  1,              0,          0,             1,                1,            1,         0,                0,                 0,                0,       0,          0,            1,      0,        NULL,        0,         0,           0,          0,     @FLength,@FWidth,@FHeight, 0,    0,            0,            0,               0,          0,          0,             0,          0,         352,             352,       352,      352,      352,          352,       352,         9999,      0,          0,                 0,          NULL,    NULL,   NULL,    0,        NULL,      NULL,       0,             0,              0,             0,              0,        0,          2,          4,             2,             0,                @FShortNumber,@FNumber,@FName,@FParentID,@FItemID
		from t_icitem where fnumber like left(@FParentNumber,1)+'.%'

		if not exists (select 1 from t_BaseProperty where FItemID=@fitemid)
		begin
			Insert Into t_BaseProperty(FTypeID, FItemID,  FCreateDate, FCreateUser, FLastModDate, FLastModUser, FDeleteDate, FDeleteUser)
								Values(4,       @fitemid, getdate(),   @fusername,  Null,         Null,         Null,        Null)
		end 
		
		update t1 set from t_icitem t1 where 
		
		--如果标配的BOM存在，则将标配的BOM插入到高配的BOM中
		if exists(select 1 from icbom where fitemid=@fitemid)
		begin
			insert into icbom
			select from icbom where fitemid=			
		end
	end
	
	set @fminid=@fminid+1
END

go

--标准BOM建立统计
select t2.fcheckdate 建立时间,t4.fname 建立人,count(1) 条数	
from dbo.t_icitem t1
inner join dbo.icbom t2 on t1.fitemid=t2.fitemid
inner join t_item t3 on t1.fitemid=t3.fitemid
inner join t_user t4 on t4.fuserid=t2.fcheckid
where left(t1.fnumber,4) in ('a.01','p.01','j.01','x.01','y.01') 
and t2.fcheckdate>='2015-01-06'
group by t2.fcheckdate,t4.fname
order by t4.fname,t2.fcheckdate

----------------------------------------------------
select '0','2015','1',t4.fitemid fstockid,t3.fitemid,t1.fbatchno,t1.fqty fendqty,0,0,0,0,0,0 fendbal,0,0,0,0,0,0,0,0,0,0,0,0,'',0,0,0,0,0,0,0,0,0,'' 
from AIS20120820103535.dbo.icinventory t1
inner join AIS20120820103535.dbo.t_icitem t2 on t1.fitemid=t2.fitemid
inner join AIS20120820103535.dbo.t_stock t13 on t1.fstockid=t13.fitemid
inner join t_icitem t3 on t2.fshortnumber=t3.fshortnumber
inner join t_stock t4 on t4.fname=t13.fname
where left(t2.fnumber ,1) not in ('A','P')

--计划禁用
SELECT t10.fname+'[计划禁用]',t10.fdeleted,
t0.FItemID,t0.FModel,t0.FName,t0.FHelpCode,t0.FDeleted,t0.FShortNumber,t0.FNumber,
t1.FErpClsID,t1.FUnitID,t1.FUnitGroupID,t1.FDefaultLoc
--update t10 set fname=t10.fname+'[计划禁用]'
--update t0 set fname=t0.fname+'[计划禁用]'
FROM t_ICItemCore t0
LEFT JOIN t_ICItemBase t1 ON t0.FItemID=t1.FItemID
inner join t_icitem t9 on t9.fitemid=t0.fitemid
inner join t_item t10 on t9.fitemid=t10.fitemid
where CHARINDEX('禁用',t0.fname)=0 and left(t0.fnumber ,2) in ('za','zp')

--计划禁用
SELECT t10.fname+'[计划禁用]',t10.fdeleted,
t0.FItemID,t0.FModel,t0.FName,t0.FHelpCode,t0.FDeleted,t0.FShortNumber,t0.FNumber,
t1.FErpClsID,t1.FUnitID,t1.FUnitGroupID,t1.FDefaultLoc
--update t10 set fname=t10.fname+'[计划禁用]'
--update t0 set fname=t0.fname+'[计划禁用]'
FROM t_ICItemCore t0
LEFT JOIN t_ICItemBase t1 ON t0.FItemID=t1.FItemID
inner join t_icitem t9 on t9.fitemid=t0.fitemid
inner join t_item t10 on t9.fitemid=t10.fitemid
inner join sheet41$ t2 on t2.删除编码=t9.fnumber
where CHARINDEX('禁用',t0.fname)=0 
    
select t2.fnumber,t2.fname,t3.*
from sheet41$ t1
inner join t_icitem t2 on t1.删除编码=t2.fnumber
inner join poorderentry t3 on t2.fitemid=t3.fitemid    
-----------------------------------------------------------------------------------------------------------     
select t4.fbatchmanager,t2.fbatchno,t2.fqty,t2.fstockid,t4.fnumber--,t3.fqty,t3.fbatchno,t3.fdcstockid,t3.fscstockid,t5.fbatchno,t5.fqty,t5.fstockid
--update t2 set fbatchno=''
from poinstock t1
inner join poinstockentry t2 on t1.finterid=t2.finterid
inner join t_icitem t4 on t4.fitemid=t2.fitemid
where t4.fbatchmanager=0 and isnull(t2.fbatchno,'')<>''


select t1.fnumber,t1.fname
--update t3 set fbatchmanager=0
from t_icitem t1 
inner join icinvbal t2 on t1.fitemid=t2.fitemid
inner join t_ICItemMaterial t3 on t1.fitemid=t3.fitemid
where t1.fbatchmanager=1 and t2.fbatchno=''


select t4.fbatchmanager,t2.fbatchno,t2.fqty,t2.fstockid,t4.fnumber--,t3.fqty,t3.fbatchno,t3.fdcstockid,t3.fscstockid,t5.fbatchno,t5.fqty,t5.fstockid
--update t1 set fdate='2015-01-01'
from poinstock t1
inner join poinstockentry t2 on t1.finterid=t2.finterid
inner join t_icitem t4 on t4.fitemid=t2.fitemid
where t1.fdate<='2014-12-31'

select t4.fbatchmanager,t2.fbatchno,t2.fqty,t2.fdcstockid,t4.fnumber--,t3.fqty,t3.fbatchno,t3.fdcstockid,t3.fscstockid,t5.fbatchno,t5.fqty,t5.fstockid
--update t2 set fbatchno=''
from icstockbill t1
inner join icstockbillentry t2 on t1.finterid=t2.finterid
inner join t_icitem t4 on t4.fitemid=t2.fitemid
where t4.fbatchmanager=0 and isnull(t2.fbatchno,'')<>'' --and t1.ftrantype=1

select t4.fbatchmanager,t2.fbatchno,t2.fqty,t2.fstockid,t4.fnumber,t3.fqty,t3.fbatchno,t3.fdcstockid,t3.fscstockid--,t5.fbatchno,t5.fqty,t5.fstockid
--update t2 set fbatchno=t3.fbatchno
from poinstock t1
inner join poinstockentry t2 on t1.finterid=t2.finterid
inner join icstockbillentry t3 on t3.fsourcetrantype=t1.ftrantype and t3.fsourceinterid=t2.finterid and t3.fsourceentryid=t2.fentryid
inner join t_icitem t4 on t4.fitemid=t3.fitemid
where t4.fbatchmanager=1 and isnull(t3.fbatchno,'')=''           
 
select t4.fbatchmanager,t2.fbatchno,t2.fqty,t2.fstockid,t4.fnumber,t3.fqty,t3.fbatchno,t3.fdcstockid,t3.fscstockid,t5.fbatchno,t5.fqty,t5.fstockid
--update t2 set fbatchno=t3.fbatchno
from poinstock t1
inner join poinstockentry t2 on t1.finterid=t2.finterid
inner join icstockbillentry t3 on t3.fsourcetrantype=t1.ftrantype and t3.fsourceinterid=t2.finterid and t3.fsourceentryid=t2.fentryid
inner join t_icitem t4 on t4.fitemid=t3.fitemid
inner join poinventory t5 on t5.fitemid=t4.fitemid
where t4.fshortnumber='000564'
                         
select t4.fbatchmanager,t2.fbatchno,t2.fqty,t2.fstockid,t4.fnumber,t3.fqty,t3.fbatchno,t3.fdcstockid,t3.fscstockid--,t5.fbatchno,t5.fqty,t5.fstockid
--update t2 set fbatchno=t3.fbatchno
from poinstock t1
inner join poinstockentry t2 on t1.finterid=t2.finterid
inner join icstockbillentry t3 on t3.fsourcetrantype=t1.ftrantype and t3.fsourceinterid=t2.finterid and t3.fsourceentryid=t2.fentryid
inner join t_icitem t4 on t4.fitemid=t3.fitemid
where t2.fbatchno<>t3.fbatchno

-----------------------------------------------------------------------------------------------------------    

--update t1 set FDefaultLoc=39615
--select t9.fnumber,t1.FDefaultLoc,t1.fsource,t9.FBatchManager
FROM         dbo.t_ICItemCore AS t0 LEFT OUTER JOIN
                      dbo.t_ICItemBase AS t1 ON t0.FItemID = t1.FItemID LEFT OUTER JOIN
                      dbo.t_ICItemMaterial AS t2 ON t0.FItemID = t2.FItemID LEFT OUTER JOIN
                      dbo.t_ICItemPlan AS t3 ON t0.FItemID = t3.FItemID LEFT OUTER JOIN
                      dbo.t_ICItemDesign AS t4 ON t0.FItemID = t4.FItemID LEFT OUTER JOIN
                      dbo.t_ICItemStandard AS t5 ON t0.FItemID = t5.FItemID LEFT OUTER JOIN
                      dbo.t_ICItemQuality AS t6 ON t0.FItemID = t6.FItemID LEFT OUTER JOIN
                      dbo.t_ICItemCustom AS t7 ON t0.FItemID = t7.FItemID LEFT OUTER JOIN
                      dbo.T_BASE_ICItemEntrance AS t8 ON t0.FItemID = t8.FItemID
                      inner join t_icitem t9 on t9.fitemid=t0.fitemid
                      --inner join AIS20120820103535.dbo.t_icitem t10 on t9.fshortnumber=t10.fshortnumber
--inner join t_baseproperty t11 on t11.fitemid=t0.fitemid and t11.FCreateDate>'2014-12-25'
where --t9.fdefaultloc not in (select fitemid from t_stock)
left(t9.fnumber,1) in ('1','2') --and t9.fsource=0
and t9.fdefaultloc=16475

select * from t_stock
------------------------------------------------------------------------------------------------
select t3.fnumber,t3.fname,t1.*
from icmo t1
left join ppbom t2 on t1.finterid=t2.ficmointerid
inner join t_icitem t3 on t1.fitemid=t3.fitemid
where t2.fitemid is null

select t4.fstockid,t5.fdefaultloc,t3.fnumber,t3.fname,t5.fnumber,t5.fname,t4.*
--update t4 set fstockid=t5.fdefaultloc
from icbom t1
inner join t_icitem t3 on t1.fitemid=t3.fitemid
inner join icbomchild t4 on t4.finterid=t1.finterid
inner join t_icitem t5 on t4.fitemid=t5.fitemid
where t5.fdefaultloc<>t4.fstockid
and t5.fshortnumber='100148'

select t4.fstockid,t5.fdefaultloc,t3.fnumber,t3.fname,t4.*
--update t4 set fstockid=t5.fdefaultloc
from icmo t1
left join ppbom t2 on t1.finterid=t2.ficmointerid
inner join t_icitem t3 on t1.fitemid=t3.fitemid
inner join ppbomentry t4 on t4.finterid=t2.finterid
inner join t_icitem t5 on t4.fitemid=t5.fitemid
where t5.fdefaultloc<>t4.fstockid
--and t5.fshortnumber='002426'

select t4.fstockid,t5.fdefaultloc,t3.fnumber,t3.fname,t4.*
--select distinct t7.fbillno
--update t4 set fstockid=t5.fdefaultloc
--update t2 set fstatus=0,fcheckerid=0
--DELETE T2
from icmo t1
left join ppbom t2 on t1.finterid=t2.ficmointerid
inner join t_icitem t3 on t1.fitemid=t3.fitemid
inner join ppbomentry t4 on t4.finterid=t2.finterid
inner join t_icitem t5 on t4.fitemid=t5.fitemid
inner join seorderentry t6 on t6.finterid=t1.forderinterid and t6.fentryid=t1.fsourceentryid
inner join seorder t7 on t6.finterid=t7.finterid
where t7.fbillno not in ('XW1412122','XW1412004','XW1412069','XW1412030','XW1412125','XW1412027') --and t4.fstockid=0 and t1.fbillno='work035184'

select t1.*
--update t1 set fstatus=0
--DELETE T1
from icmo t1
inner join seorderentry t6 on t6.finterid=t1.forderinterid and t6.fentryid=t1.fsourceentryid
inner join seorder t7 on t6.finterid=t7.finterid
where t7.fbillno not in ('XW1412122','XW1412004','XW1412069','XW1412030','XW1412125','XW1412027') --and t4.fstockid=0 and t1.fbillno='work035184'

select fstatus=0,fcheckerid=0,fmultichecklevel1=0,fmultichecklevel2=0,fmulticheckdate1=null,fmulticheckdate2=null,t7.*
--update t7 set fstatus=0,fcheckerid=0,fmultichecklevel1=0,fmultichecklevel2=0,fmulticheckdate1=null,fmulticheckdate2=null,fcurchecklevel=0
from seorder t7 
where t7.fbillno not in ('XW1412122','XW1412004','XW1412069','XW1412030','XW1412125','XW1412027') --and t4.fstockid=0 and t1.fbillno='work035184'


select
--update t3 set fentryselfp0338=t5.fprice,jin'e
from poinstockentry t3 
inner join poinstock t4 on t3.finterid=t4.finterid
inner join t_bosPlasticPoInStockEntry t5 on t5.fid=t3.fsourceinterid and t5.fentryid=t3.fsourceentryid and t3.fsourcetrantype=200000022
inner join t_bosPlasticPoInStock t6 on t6.fid=t5.fid
where isnull(t3.u1.fentryselfp0338,0)=0


select t13.fname 仓库,t2.fnumber 编码,t2.fname 名称,t2.fmodel 规格型号,t4.fname 单位,t1.fqty 数量,isnull(t3.fprice,0) 单价,t1.fqty*isnull(t3.fprice,0) 金额
from icinventory t1
inner join t_icitem t2 on t1.fitemid=t2.fitemid
inner join t_stock t13 on t1.fstockid=t13.fitemid
left join t_supplyentry t3 on t3.fitemid=t2.fitemid
inner join t_measureunit t4 on t4.fitemid=t2.funitid
where t1.fqty>0 and t2.fitemid not in (select fitemid from icbomchild)
and t2.fitemid not in (select FRepItemId from t_BOSICItemReplaceEntry)
and t2.fitemid not in (select fitemid from icbom)
and t13.fname not like '%报废%' and t13.fname not like '%标签%' and t13.fname not like '%包材%'
and t13.fname not like '%不良%' and t13.fname not like '%辅料%'
and t13.fname not like '%回收%'and t13.fname not like '%塑胶%'
order by t13.fname,t2.fnumber,t1.fqty desc


select
--update t5 set fentryselfa0154=t3.fprice,jine=cast(t3.fprice*t5.fqty as decimal(24,2))
from poinstockentry t3 
inner join poinstock t4 on t3.finterid=t4.finterid
inner join icstockbillEntry t5 on t3.finterid=t5.fsourceinterid and t3.fentryid=t5.fsourceentryid and t5.fsourcetrantype=72
inner join icstockbill t6 on t6.finterid=t5.finterid
where isnull(t5.u1.fentryselfa0154,0)=0


select t1.fqty,t2.fnumber,t2.fname,t2.fmodel,t13.fname
from AIS20120820103535.dbo.icinventory t1
inner join AIS20120820103535.dbo.t_icitem t2 on t1.fitemid=t2.fitemid
inner join AIS20120820103535.dbo.t_stock t13 on t1.fstockid=t13.fitemid
left join t_icitem t3 on t2.fshortnumber=t3.fshortnumber
left join t_stock t4 on t4.fname=t13.fname
where left(t2.fnumber ,1) not in ('A','P') and t3.fitemid is null
and t1.fqty>0

select t13.fname,sum(t1.fqty)
from AIS20120820103535.dbo.icinventory t1
inner join AIS20120820103535.dbo.t_icitem t2 on t1.fitemid=t2.fitemid
inner join AIS20120820103535.dbo.t_stock t13 on t1.fstockid=t13.fitemid
where left(t2.fnumber ,1) not in ('A','P')
group by t13.fname

select t13.fname,sum(t1.fbegqty)
from icinvbal t1
inner join t_icitem t2 on t1.fitemid=t2.fitemid
inner join t_stock t13 on t1.fstockid=t13.fitemid
where left(t2.fnumber ,1) not in ('A','P')
group by t13.fname

select t1.fnumber,t1.fname,t1.fmodel,t1.fdefaultloc,*
from t_icitem t1 where fdefaultloc not in (select fitemid from t_stock)

select t1.fnumber,t1.fname,t1.fmodel,t1.fdefaultloc,*
from t_icitem t1 where fsource=0 and ferpclsid=2


select '0','2015','1',t4.fitemid fstockid,t3.fitemid,t1.fbatchno,t1.fqty fendqty,0,0,0,0,0,0 fendbal,0,0,0,0,0,0,0,0,0,0,0,0,'',0,0,0,0,0,0,0,0,0,'' 
--select t2.fshortnumber,t2.fnumber,t2.fname,t7.ffullname,t2.fmodel,t1.fqty
from AIS20120820103535.dbo.poinventory t1
inner join AIS20120820103535.dbo.t_icitem t2 on t1.fitemid=t2.fitemid
inner join AIS20120820103535.dbo.t_stock t13 on t1.fstockid=t13.fitemid
inner join AIS20120820103535.dbo.t_item t7 on t2.fitemid=t7.fitemid
left join t_icitem t3 on t2.fshortnumber=t3.fshortnumber
left join t_stock t4 on t4.fname=t13.fname
left join poinvbal t5 on t5.fitemid=t3.fitemid and t5.fstockid=t4.fitemid
where (t5.fitemid is null or t5.fstockid is null)
and t13.fname ='代管仓'
order by t2.fnumber

select '0','2015','1',t4.fitemid fstockid,t3.fitemid,t1.fbatchno,t1.fqty fendqty,0,0,0,0,0,0 fendbal,0,0,0,0,0,0,0,0,0,0,0,0,'',0,0,0,0,0,0,0,0,0,'' 
--select t2.fshortnumber,t2.fnumber,t2.fname,t7.ffullname,t2.fmodel,t1.fqty
from AIS20120820103535.dbo.poinventory t1
inner join AIS20120820103535.dbo.t_icitem t2 on t1.fitemid=t2.fitemid
inner join AIS20120820103535.dbo.t_stock t13 on t1.fstockid=t13.fitemid
inner join AIS20120820103535.dbo.t_item t7 on t2.fitemid=t7.fitemid
left join t_icitem t3 on t2.fshortnumber=t3.fshortnumber
where t3.fitemid is null 
and t13.fname ='代管仓'
order by t2.fnumber


select '0','2015','1',t4.fitemid fstockid,t3.fitemid,t1.fbatchno,t1.fqty fendqty,0,0,0,0,0,0 fendbal,0,0,0,0,0,0,0,0,0,0,0,0,'',0,0,0,0,0,0,0,0,0,'' 
from AIS20120820103535.dbo.icinventory t1
inner join AIS20120820103535.dbo.t_icitem t2 on t1.fitemid=t2.fitemid
inner join AIS20120820103535.dbo.t_stock t13 on t1.fstockid=t13.fitemid
left join t_icitem t3 on t2.fshortnumber=t3.fshortnumber
left join t_stock t4 on t4.fname=t13.fname
where left(t2.fnumber ,1) not in ('A','P') and t1.fqty>0
and t3.fitemid is null

select sum(fbegqty),sum(fbegbal) from icinvbal  
select sum(fbegqty),sum(fbegbal) from icbal

select * from t_itempropdesc where fitemclassid=4

select *--sum(fendbal) 
from AIS20120820103535.dbo.icinvbal 
where fyear=2014 and fperiod=12 and fitemid=11270

select *--sum(fendbal) 
from AIS20120820103535.dbo.icbal 
where fyear=2014 and fperiod=12 and fitemid=11270


--delete from icinvbal
--delete from icbal


select '0','2015','1',t4.fitemid fstockid,t3.fitemid,t1.fbatchno,t1.fendqty,0,0,0,0,0,t5.fbegqty,t5.fbegbal,t1.fendbal,t2.fnumber,t2.fname,t2.fmodel
--update t5 set fbegbal=t1.fendbal
from AIS20120820103535.dbo.icinvbal t1
inner join AIS20120820103535.dbo.t_icitem t2 on t1.fitemid=t2.fitemid
inner join AIS20120820103535.dbo.t_stock t13 on t1.fstockid=t13.fitemid
inner join t_icitem t3 on t2.fshortnumber=t3.fshortnumber
inner join icinvbal t5 on t5.fitemid=t3.fitemid and t5.fstockid=t1.fstockid and t5.fbatchno=t1.fbatchno --and t5.fbegqty=t1.fendqty
inner join t_stock t4 on t4.fname=t13.fname
where left(t2.fnumber ,1) not in ('A','P') and t1.fyear=2014 and t1.fperiod=12 and t5.fbegbal=0
and t5.fbegqty<>0


update icinvbal set fbegbal=cast(fbegbal as decimal(24,2))


select t6.fname,t2.fshortnumber,t2.fmodel,t2.fname,t1.fendbal,t13.fname
from AIS20120820103535.dbo.icinvbal t1
inner join AIS20120820103535.dbo.t_icitem t2 on t1.fitemid=t2.fitemid
inner join AIS20120820103535.dbo.t_stock t13 on t1.fstockid=t13.fitemid
inner join AIS20120820103535.dbo.t_account t6 on t2.facctid=t6.faccountid
-- inner join t_icitem t3 on t2.fshortnumber=t3.fshortnumber
-- inner join t_stock t4 on t4.fname=t13.fname
where left(t2.fnumber ,1) not in ('A','P')
and t2.fshortnumber not in (select t2.fshortnumber from icinvbal t1 inner join t_icitem t2 on t1.fitemid=t2.fitemid)
and t1.fyear=2014 and t1.fperiod=12 and t1.fendbal<>0
order by t6.fname,t2.fshortnumber

select t2.fnumber,t2.fname,t2.fmodel,t13.fname,t1.fbegqty,t1.fbegbal,t1.fendbal,t2.fplanprice
--update t1 set fbegbal=cast(t1.fbegqty*t2.fplanprice as decimal(24,2))
from icinvbal t1 
inner join t_icitem t2 on t1.fitemid=t2.fitemid
inner join t_stock t13 on t1.fstockid=t13.fitemid
where fbegbal=0 and fbegqty<>0

select t2.fbegbal,t1.fbegbal
--update t2 set fbegbal=t1.fbegbal
from(select fitemid,fbatchno,sum(fbegbal) fbegbal from icinvbal group by fitemid,fbatchno) t1
inner join icbal t2 on t1.fitemid=t2.fitemid and t1.fbatchno=t2.fbatchno

select t1.*
from icbal t1 
where fbegbal=0 and fbegqty<>0


insert into icinvbal
select '0','2015','1',t4.fitemid fstockid,t3.fitemid,t1.fbatchno,t1.fqty fendqty,0,0,0,0,0,0 fendbal,0,0,0,0,0,0,0,0,0,0,0,0,'',0,0,0,0,0,0,0,0,0,'' 
from AIS20120820103535.dbo.icinventory t1
inner join AIS20120820103535.dbo.t_icitem t2 on t1.fitemid=t2.fitemid
inner join AIS20120820103535.dbo.t_stock t13 on t1.fstockid=t13.fitemid
inner join t_icitem t3 on t2.fshortnumber=t3.fshortnumber
inner join t_stock t4 on t4.fname=t13.fname
where left(t2.fnumber ,1) not in ('A','P')

insert into icbal(FBrNo,   FYear,   FPeriod,   FItemID,  FBatchNo,    FBegQty,        FReceive,FSend,FYtdReceive,FYtdSend,FEndQty,FBegBal,         FDebit,FCredit,FYtdDebit,FYtdCredit,FEndBal,FBegDiff,FReceiveDiff,FSendDiff,FEndDiff,FBillInterID,FEntryID,FStockGroupID,FYtdReceiveDiff,FYtdSendDiff,FSecBegQty,FSecReceive,FSecSend,FSecYtdReceive,FSecYtdSend,FSecEndQty,FStockInDate,FAuxPropID)
select            t1.fbrno,t1.fyear,t1.fperiod,t1.fitemid,t1.fbatchno,sum(t1.fbegqty),0,       0,    0,          0,       0,       sum(t1.fbegbal),0,     0,      0,        0,         0,      0,       0,           0,        0,       '0',         '0',     '0',          0,              0,           0,         0,          0,       0,             0,          0,         '',          '0' 
from icinvbal t1
group by t1.fbrno,t1.fyear,t1.fperiod,t1.fitemid,t1.fbatchno


select *
from AIS20120820103535.dbo.poinvbal where fyear=2014 and fperiod=11

select *
from AIS20120820103535.dbo.icinvbal where fyear=2014 and fperiod=11

insert into poinvbal(FBrNo,FYear, FPeriod,FStockID,           FItemID,   FBatchNo,   FBegQty,        FReceive,FSend,FYtdReceive,FYtdSend,FEndQty,FBegBal,  FDebit,FCredit,FYtdDebit,FYtdCredit,FEndBal,FBegDiff,FReceiveDiff,FSendDiff,FEndDiff,FBillInterID,FKFDate,FKFPeriod,FSPID,FDCSPID,FSecBegQty,FSecReceive,FSecSend,FSecYtdReceive,FSecYtdSend,FSecEndQty,FAuxPropID)
select   distinct    '0',  '2015','1',    t4.fitemid fstockid,t3.fitemid,t1.fbatchno,t1.fqty fendqty,0,       0,    0,          0,       0,      0 fendbal,0,     0,      0,        0,         0,      0,       0,           0,        0,       0,           '',     0,        0,    0,      0,         0,          0,       0,             0,          0,         0 
from AIS20120820103535.dbo.poinventory t1
inner join AIS20120820103535.dbo.t_icitem t2 on t1.fitemid=t2.fitemid
inner join AIS20120820103535.dbo.t_stock t13 on t1.fstockid=t13.fitemid
inner join t_icitem t3 on t2.fshortnumber=t3.fshortnumber
inner join t_stock t4 on t4.fname=t13.fname
where left(t2.fnumber ,1) not in ('A','P') and t1.fstockid<>16482 and t13.ftypeid=503 --代管仓
and t3.fitemid not in (select fitemid from poinvbal)

select * from t_stock
select * from poinvbal

select t2.fnumber,t2.fname,t2.fmodel,t13.fname,t1.fbegqty,t1.fbegbal,t1.fendbal,cast(t1.fbegqty*t14.fprice as decimal(24,4))
--update t1 set fbegbal=cast(t1.fbegqty*t14.fprice as decimal(24,2))
from icinvbal t1 
inner join t_icitem t2 on t1.fitemid=t2.fitemid
inner join t_stock t13 on t1.fstockid=t13.fitemid
inner join t_supplyentry t14 on t14.fitemid=t2.fitemid
where t1.fbegbal=0 and t1.fbegqty<>0



select * 
--update t1 set fvalue=1
from t_SystemProfile t1 where fkey like '%CurrentPeriod%' and fcategory='IC'

select * 
--update t1 set fvalue=2015
from t_SystemProfile t1 where fkey like '%CurrentYear%' and fcategory='IC'

select *
--delete t1
from t_BosPlasticPoInStock  t1
where fdate<='2014-11-30'

select *
--delete t1
from t_BosPlasticPoInStockEntry  t1
where fid not in (select fid from t_BosPlasticPoInStock)

select *
--delete t1
from t_BOSBackOrOutStock  t1
where fdate<='2014-11-30'

select *
--delete t1
from t_BOSBackOrOutStockEntry  t1
where fid not in (select fid from t_BOSBackOrOutStock)


select * from t_BOSFreezeRequest

----------------------------------------------------------------------------------------------------
--truncate table icmo  truncate table ppbom  truncate table ppbomentry  
--select * from icmo  select * from ppbom  select * from ppbomentry

insert into icmo
select t1.* 
from AIS20120820103535.dbo.icmo t1 
inner join AIS20120820103535.dbo.t_icitem t2 on t1.fitemid=t2.fitemid
where t1.fstatus in (1,2) and left(t2.fnumber,1) in ('3','4')
--242

insert into ppbom
select t3.* 
from AIS20120820103535.dbo.icmo t1 
inner join AIS20120820103535.dbo.t_icitem t2 on t1.fitemid=t2.fitemid
inner join AIS20120820103535.dbo.ppbom t3 on t1.finterid=t3.ficmointerid
where t1.fstatus in (1,2) and left(t2.fnumber,1) in ('3','4')
--242

insert into ppbomentry
select t4.* 
from AIS20120820103535.dbo.icmo t1 
inner join AIS20120820103535.dbo.t_icitem t2 on t1.fitemid=t2.fitemid
inner join AIS20120820103535.dbo.ppbom t3 on t1.finterid=t3.ficmointerid
inner join AIS20120820103535.dbo.ppbomentry t4 on t3.finterid=t4.finterid
where t1.fstatus in (1,2) and left(t2.fnumber,1) in ('3','4')
--7693

select t1.*
--update t1 set fitemid=t3.fitemid
from icmo t1 
inner join AIS20120820103535.dbo.t_icitem t2 on t1.fitemid=t2.fitemid
left join t_icitem t3 on t2.fshortnumber=t3.fshortnumber
where t3.fitemid is null

select t1.*
--update t1 set fbominterid=0
--update t1 set fbominterid=isnull(t4.finterid,0)
--update t1 set fcostobjid=0
--update t1 set fcostobjid=isnull(t5.fitemid,0)
from icmo t1 
inner join t_icitem t3 on t1.fitemid=t3.fitemid
left join icbom t4 on t3.fitemid=t4.fitemid
left join cbcostobj t5 on t5.FStdProductID=t3.fitemid


select t1.*
--update t6 set fitemid=t1.fitemid
from icmo t1 
inner join ppbom t6 on t6.ficmointerid=t1.finterid

select distinct t2.fnumber,t2.fname,t2.fmodel
--update t1 set fitemid=t3.fitemid
from ppbomentry t1 
inner join AIS20120820103535.dbo.t_icitem t2 on t1.fitemid=t2.fitemid
left join t_icitem t3 on t2.fshortnumber=t3.fshortnumber
where t3.fitemid is null

select t2.fnumber,t2.fname,t2.fmodel,t1.fqtymust,t1.fstockqty,t1.*
--update t1 set fqtymust=0,fauxqtymust=0
from ppbomentry t1 
left join t_icitem t2 on t1.fitemid=t2.fitemid
inner join icmo t3 on t1.ficmointerid=t3.finterid
where t1.fqtymust<=t1.fstockqty  --已经发完
--and t3.fbillno='ZP201404191'

select t2.fnumber,t2.fname,t2.fmodel,t1.fqtymust,t1.fstockqty,t1.*
--update t1 set fqtymust=t1.fqtymust-t1.fstockqty,fauxqtymust=fauxqtymust-fauxstockqty,fqty=0,fauxqty=0,fstockqty=0,fauxstockqty=0
from ppbomentry t1 
left join t_icitem t2 on t1.fitemid=t2.fitemid
where t1.fqtymust>t1.fstockqty  --未发完

select t2.fnumber,t2.fname,t2.fmodel,t1.fqtymust,t1.fstockqty,t1.*
--update t1 set fqtypick=t1.fqtymust,fauxqtypick=t1.fauxqtymust,FBomInputAuxQty=t1.fauxqtymust,FBomInputQty=t1.fqtymust
from ppbomentry t1 
left join t_icitem t2 on t1.fitemid=t2.fitemid


----------------------------------------------------------------------------------------------------
delete from icbom where finterid in (
select min(finterid) finterid from icbom group by fitemid having count(1)>1)

select t1.* 
--update t1 set fusestatus=1072,fstatus=1,fcheckerid=16394,fcheckdate='2014-12-31',fauddate='2014-12-31',fbeenchecked=1
from icbom t1 
inner join t_icitem t2 on t1.fitemid=t2.fitemid
where left(t2.fnumber,1) in ('q','r','1')

select t1.* 
--update t1 set fusestatus=1072
from icbom t1 
inner join t_icitem t2 on t1.fitemid=t2.fitemid
where t1.fstatus>0 and t1.fusestatus<>1072

----------------------------------------------------------------------------------------------------

-- truncate table t_SupplyEntry  truncate table t_Supply
SET NOCOUNT ON

declare @iMaxIndex int
declare @FInterID int ,@fcheckerid int,@FTaxPrice decimal(24,5)
declare @FMyInterID int ,@FSupplyId int
declare @fcurrencyid int,@FPType int,@fstartqty int,@fendqty int,@fnote varchar(500)
declare @fbillno varchar(30),@fitemid int,@fprice decimal(24,5),@ftempprice decimal(24,5)
declare @ftrantype int ,@funitid int
declare @fstatus int
declare @fdate datetime,@freasonid int
declare @fuserid int 
select @fdate=replace(convert(varchar(10),getdate(),111),'/','-')  --制单日期

-- Insert statements for trigger here
--select @iMaxIndex=isnull(max(findex)+1,1) from MY_T_NETCONTROL where fuserid=1 and fbilltype=-1
select  @fcheckerid=16394,@fuserid=16394  --@fbillno=fbillno,@FInterID=finterid,

--select * from AIS20120820103535.dbo.t_supplier where fitemid not in (select fitemid from t_supplier)
DECLARE icbom_cursor CURSOR FOR	

select isnull(t1.ftaxprice,0) ftaxprice,(case when t2.ferpclsid=1 then 1 else 0 end) fptype,
t1.FCyID fcurrency,t1.fprice,t1.FStartQty,
t1.fendqty,t1.fremark fnote,t1.FSupID fsupplyid,t4.fitemid,t4.funitid
from AIS20120820103535.dbo.t_SupplyEntry t1 
inner join AIS20120820103535.dbo.t_icitem t2 on t1.fitemid=t2.fitemid
inner join t_supplier t3 on t3.fitemid=t1.FSupID
inner join t_icitem t4 on t4.fshortnumber=t2.fshortnumber
order by t1.fentryid

OPEN icbom_cursor

FETCH NEXT FROM icbom_cursor 
INTO @FTaxPrice,@fptype,@fcurrencyid,@fprice,@fstartqty,@fendqty,@fnote,@FSupplyId,@fitemid,@funitid

WHILE @@FETCH_STATUS = 0
BEGIN 
	exec GetICMaxNum 't_Supply',@iMaxIndex output

	if not exists(select 1 from t_Supply t3 
				  where t3.fsupid=@FSupplyId and t3.fitemid=@FItemId and t3.fptype=@FPType )
	begin
		INSERT INTO t_Supply (FBrNo, FItemID, FSupID,    FCurrencyID, FPOHighPrice,FPType) 
					  VALUES ('0',   @FItemId,@FSupplyId,@fcurrencyid,0,           @FPType)
	end

	if not exists(select 1
		from t_SupplyEntry m1  
		inner join t_supplier m2 on m1.FSupID=m2.fitemid  
		where m1.fsupid=@FSupplyId and m1.fitemid=@FItemId )  --and m1.fptype=@FPType  and m1.fcyid=@fcurrencyid  and m1.fstartqty=@FStartQty  and m1.fendqty= @FEndQty
	begin
		INSERT INTO t_SupplyEntry (FBrNo,FUsed  ,FEntryID,   FSupID,     FItemID,  FUnitID,   FStartQty,   FEndQty,   FPType,   FPrice,  FTaxPrice, FCyID,        FDisCount,  FLeadTime,  FQuoteTime, FDisableDate,   FRemark,     FLastModifiedBy,FLastModifiedDate)  
				 VALUES (          '0',  1,     @iMaxIndex , @FSupplyId, @FItemId, @FUnitId , @FStartQty , @FEndQty , @FPType , @FPrice, @FTaxPrice,@fcurrencyid ,0,          0,          @fdate,    '2100-01-01',    @FNote ,     @fuserid,       @fdate) 
	end
	else
	begin
		update t3 set FQuoteTime=@fdate,FRemark=@fnote,fprice=@FPrice,fstartqty=@fstartqty,fendqty=@fendqty,ftaxprice=@FTaxPrice,fcyid=@fcurrencyid,FLastModifiedBy=@fuserid,FLastModifiedDate=@fdate from t_SupplyEntry t3 where t3.fsupid=@FSupplyId and t3.fitemid=@FItemId
	end

	--update t1 set forderprice=@FPrice from t_ICItemCore t1 where t1.fitemid=@FItemId

	FETCH NEXT FROM icbom_cursor 
	INTO @FTaxPrice,@fptype,@fcurrencyid,@fprice,@fstartqty,@fendqty,@fnote,@FSupplyId,@fitemid,@funitid
END

CLOSE icbom_cursor
DEALLOCATE icbom_cursor


----------------------------------------------------------------------------------------------------------------

select t3.fnumber,t3.fmodel,t4.fnumber,t3.fname,t3.fmodel 
from icbom t1
inner join icbomchild t2 on t1.finterid=t2.finterid
inner join t_icitem t3 on t1.fitemid=t3.fitemid
inner join t_icitem t4 on t2.fitemid=t4.fitemid
where t3.fnumber='P.01.01.001.P00002'


----------------------------------------------------------------------------------------------------------------
select t3.fitemid,* 
--delete t2
from ICBomGroup t2 
left join icbom t3 on t3.fparentid=t2.finterid
where left(t2.fnumber,1) in ('7','8')

select t3.fitemid,t2.fnumber,* 
--delete t2
from ICBomGroup t2 
left join icbom t3 on t3.fparentid=t2.finterid
where left(t2.fnumber,1) in ('1') and t2.fnumber not like '1.02%'
and t2.fnumber <>'1' 
order by t2.fnumber

--新增BOM组别
declare @finterid int,@s varchar(500),@fnumber varchar(50),@fname varchar(500)
declare @FParentNumber varchar(50),@FParentID int,@FBootID int

DECLARE icbom_cursor CURSOR FOR	
select t1.fnumber,t1.fname 
from t_item t1
left join ICBomGroup t2 on t1.fnumber=t2.fnumber
where t1.fitemclassid=4 and 
((left(t1.fnumber,1) in ('3','4','5','A','P','R','Q','J','X','Y','V') ) or (left(t1.fnumber,1) in ('1')))
and t1.fdetail=0 
and t2.fnumber is null
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

--BOM组别更新

select t1.fnumber,t1.fname,t3.fnumber,
REVERSE(right(REVERSE(t1.fnumber),len(t1.fnumber)-CHARINDEX('.',REVERSE(t1.fnumber)))) ,t4.fnumber
--update t2 set fparentid=t14.finterid
from t_icitem t1
inner join icbom t2 on t1.fitemid=t2.fitemid
inner join t_item t13 on t1.FParentID=t13.fitemid
inner join ICBomGroup t14 on t14.fnumber=t13.fnumber

---------------------------------------------------------------------------------------------------------

select distinct t4.fnumber 编码,t4.fname 名称,t4.fmodel 规格型号,t4.fnetweight 净重
--,cast(cast(left(t4.F_111,CHARINDEX('*',t4.F_111)-1) as decimal(24,4))/10 as decimal(24,4)) 长,
--cast(cast(substring(t4.F_111,CHARINDEX('*',t4.F_111)+1,charindex('*',t4.F_111,charindex('*',t4.F_111)+1)-CHARINDEX('*',t4.F_111)-1) as decimal(24,4))/10 as decimal(24,4)) 宽,
--cast(cast(substring(t4.F_111,charindex('*',t4.F_111,charindex('*',t4.F_111)+1)+1,len(t4.F_111)-charindex('*',t4.F_111,charindex('*',t4.F_111)+1)) as decimal(24,4))/10 as decimal(24,4)) as decimal(24,4)) 高
from t_icitem t2
inner join icbom t1 on t1.fitemid=t2.fitemid
inner join dbo.icbomchild t3 on t1.finterid=t3.finterid
inner join dbo.t_icitem t4 on t3.fitemid=t4.fitemid
inner join t_measureunit t5 on t5.fitemid=t4.funitid
where (left(t4.fnumber,4) in ('2.01','2.02','2.03','2.04','2.08') --and t4.fmodel like '%*%*%mm%'
or left(t4.fnumber,1) in ('3','4','5','7','8'))
order by t4.fnumber
	
	

select distinct t2.fentryselfs0158,t2.fitemid from seorder t1 inner join seorderentry t2 on t1.finterid=t2.finterid
inner join t_icitem t3 on t2.fitemid=t3.fitemid
inner join t_item t19 on t19.fitemclassid=3002 and t19.fitemid=t2.fentryselfs0158 and t19.fdeleted=0  --包装方式
where left(t3.fnumber,1) in ('a','p') and
t19.FName not in ( '傲威中性','Starink2010', 'Starink2014', '鑫威白盒', '鑫威咖啡盒')
and t19.FName like '%IES%'
and year(t1.fdate)=2014 and t2.fentryselfs0158<>0 

--drop table #data

---------------------------------------------------------------------------------------------------------

--drop table #abcd


select isnull(t19.FName,'') 包装方式,isnull(t0.fnumber,'') 产品编码,isnull(t0.FName,'') 产品名称,
isnull(t0.F_105,'')+'///'+ isnull(t0.fmodel,'') 规格型号,
t4.fnumber 包材编码,t4.fname 包材名称,t4.fmodel 包材规格型号,t2.fqty 用量
from AIS20120820103535.dbo.t_icitem t0
inner join AIS20120820103535.dbo.t_BOSPackSub t1 on t1.fproductid=t0.fitemid
inner join AIS20120820103535.dbo.t_BOSPackSubEntry t2 on t1.fid=t2.fid
inner join AIS20120820103535.dbo.t_icitem t4 on t2.fitemid=t4.fitemid
inner join AIS20120820103535.dbo.t_item t19 on t19.fitemclassid=3002 and t19.fitemid=t1.fbrandid --包装方式
where left(t0.fnumber,1) in ('A','P')  AND  
(t19.FName = '傲威中性'
  OR  
t19.FName = 'Starink2010'
  OR  
t19.FName = 'Starink2014'
  OR  
t19.FName = '鑫威白盒'
  OR  
t19.FName = '鑫威咖啡盒')
order by isnull(t0.fnumber,''),isnull(t19.fnumber,'')


select distinct identity(int,1,1) findex,isnull(t16.fshortname,'') 主供应商,
isnull(t7.fitemid,0) 产品内码,isnull(t7.fshortnumber,'') 产品编码,isnull(t7.FName,'') 产品名称,isnull(t7.F_105,'')+'///'+ isnull(t7.fmodel,'') 规格型号,
isnull(t10.fnumber,'') 芯片编码,isnull(t10.FName,'') 芯片名称,isnull(t10.F_105,'')+'///'+ isnull(t10.fmodel,'') 芯片规格型号,
isnull(t11.fnumber,'') 半成品编码,isnull(t11.FName,'') 半成品名称,isnull(t11.F_105,'')+'///'+ isnull(t11.fmodel,'') 半成品规格型号,
isnull(t13.fnumber,'') 芯片版本编码,isnull(t13.FName,'') 芯片版本名称,
isnull(t19.fitemid,0) 包装方式内码,isnull(t19.fnumber,'') 包装方式编码,isnull(t19.FName,'') 包装方式名称
into #data
from AIS20120820103535.dbo.seorder t1   
inner join AIS20120820103535.dbo.SeorderEntry t12 on t1.finterid=t12.finterid  
inner join AIS20120820103535.dbo.t_icitem t7 on t12.fitemid=t7.fitemid 
left join AIS20120820103535.dbo.t_icitem t10 on t10.fitemid=t12.fentryselfs0161  --芯片
left join AIS20120820103535.dbo.t_icitem t11 on t11.fitemid=t12.fentryselfs0164  --半成品
left join AIS20120820103535.dbo.t_item t13 on t13.fitemid=t12.fentryselfs0160  --芯片版本
left join AIS20120820103535.dbo.t_supplier t16 on t16.fitemid=t7.F_117 
inner join AIS20120820103535.dbo.t_item t19 on t19.fitemclassid=3002 and t19.fitemid=t12.fentryselfs0158 and t19.fdeleted=0  --包装方式
where year(t1.fdate)=2014 and t1.FCancellation=0 and left(t7.fnumber,1) in ('A','P')  AND  
(t19.FName = '傲威中性'
  OR  
t19.FName = 'Starink2010'
  OR  
t19.FName = 'Starink2014'
  OR  
t19.FName = '鑫威白盒'
  OR  
t19.FName = '鑫威咖啡盒')
order by isnull(t7.fshortnumber,''),isnull(t19.fnumber,'')


select t0.findex 索引,主供应商,产品编码,产品名称,规格型号,芯片编码,
芯片名称,芯片规格型号,
半成品编码,
半成品名称,半成品规格型号,--芯片版本编码,
芯片版本名称,--包装方式编码,
包装方式名称,
t4.fshortnumber 包材编码,
t4.fname 包材名称,t4.fmodel 包材规格型号,t2.fqty 用量
into #abcd
from #data t0
inner join AIS20120820103535.dbo.t_BOSPackSub t1 on t1.fproductid=t0.产品内码 and t1.fbrandid=t0.包装方式内码
inner join AIS20120820103535.dbo.t_BOSPackSubEntry t2 on t1.fid=t2.fid
inner join AIS20120820103535.dbo.t_icitem t4 on t2.fitemid=t4.fitemid
order by t0.findex

select * from sheet38$ where 产品代码 like '%P00002%'

select * from #abcd where 包装方式名称 not in (select 包装方式名称 from sheet38$)

select * --update t1 set 旧系统代码=t2.产品编码
from sheet38$ t1inner join sheet39$ t2 on t1.索引=t2.索引 where t1.旧系统代码 is null order by t1.索引select t2.*,t1.*
--update t1 set 旧系统代码=t2.旧系统代码from sheet38$ t1inner join
(
	select 索引,min(旧系统代码) 旧系统代码 
	from sheet38$
	where 旧系统代码 is not null
group by 索引) t2 on t1.索引=t2.索引
select * from #abcd

select t1.用量,t2.用量,t1.子件编码
--update t1 set t1.用量=t2.用量
from sheet38$ t1
inner join #abcd t2 on t1.包装方式名称=t2.包装方式名称 
and REVERSE(left(REVERSE(t1.旧系统代码),CHARINDEX('.',REVERSE(t1.旧系统代码))-1))=t2.产品编码
and REVERSE(left(REVERSE(t1.子件编码),CHARINDEX('.',REVERSE(t1.子件编码))-1))=t2.包材编码
where t1.用量<>t2.用量

select t1.FCheckID,t2.fshortnumber fnumber,t2.fname,t2.fmodel,t4.fshortnumber fchildnumber,t4.fname,t4.fmodel,
t3.fqty,cast(t11.用量 as decimal(24,4))
--update t3 set fauxqty=cast(t11.用量 as decimal(24,4)),fqty=cast(t11.用量 as decimal(24,4))
from dbo.icbom t1
inner join dbo.t_icitem t2 on t1.fitemid=t2.fitemid
inner join dbo.icbomchild t3 on t1.finterid=t3.finterid
inner join dbo.t_icitem t4 on t3.fitemid=t4.fitemid
inner join dbo.sheet38$ t11 on REVERSE(left(REVERSE(t11.产品代码),CHARINDEX('.',REVERSE(t11.产品代码))-1))=t2.fshortnumber 
                       and REVERSE(left(REVERSE(t11.子件编码),CHARINDEX('.',REVERSE(t11.子件编码))-1))=t4.fshortnumber 
                       and t3.fqty<>cast(t11.用量 as decimal(24,4))
where t2.fshortnumber='400173'


select --t13.fbrandid,t11.包装方式名称,t12.f_116,t11.旧系统代码,
t1.FCheckID,t2.fshortnumber fnumber,t2.fname,t2.fmodel,t4.fshortnumber fchildnumber,t4.fname,t4.fmodel,
t3.fqty--,cast(t11.用量 as decimal(24,4)),cast(cast(1 as decimal(24,4))/cast(t13.fboxcount as decimal(24,4)) as decimal(24,4)) fboxcount,t13.*
--update t3 set fauxqty=cast(t11.用量 as decimal(24,4)),fqty=cast(t11.用量 as decimal(24,4))
--update t3 set fauxqty=cast(cast(1 as decimal(24,4))/cast(t13.fboxcount as decimal(24,4)) as decimal(24,4)),fqty=cast(cast(1 as decimal(24,4))/cast(t13.fboxcount as decimal(24,4)) as decimal(24,4))
from dbo.icbom t1
inner join dbo.t_icitem t2 on t1.fitemid=t2.fitemid
inner join dbo.icbomchild t3 on t1.finterid=t3.finterid
inner join dbo.t_icitem t4 on t3.fitemid=t4.fitemid
inner join dbo.sheet38$ t11 on REVERSE(left(REVERSE(t11.产品代码),CHARINDEX('.',REVERSE(t11.产品代码))-1))=t2.fshortnumber 
                       and REVERSE(left(REVERSE(t11.子件编码),CHARINDEX('.',REVERSE(t11.子件编码))-1))=t4.fshortnumber 
--inner join AIS20120820103535.dbo.t_icitem t12 on t12.fnumber=t11.旧系统代码
--inner join AIS20120820103535.dbo.t_item t19 on t19.fitemclassid=3002 and t19.fname=t11.包装方式名称
--inner join AIS20120820103535.dbo.t_bospacksub t13 on t13.fproductid=t12.fitemid and t19.fitemid=t13.fbrandid
where t4.fnumber like '2.01%' and t3.fqty>=1



select t13.fbrandid,t11.包装方式名称,t12.f_116,t11.旧系统代码,t1.FCheckID,t2.fshortnumber fnumber,t2.fname,t2.fmodel,t4.fshortnumber fchildnumber,t4.fname,t4.fmodel,
t3.fqty,cast(t11.用量 as decimal(24,4)),cast(cast(1 as decimal(24,4))/cast(t13.fboxcount as decimal(24,4)) as decimal(24,4)) fboxcount
--update t3 set fauxqty=cast(t11.用量 as decimal(24,4)),fqty=cast(t11.用量 as decimal(24,4))
--update t3 set fauxqty=cast(cast(1 as decimal(24,4))/cast(t13.fboxcount as decimal(24,4)) as decimal(24,4)),fqty=cast(cast(1 as decimal(24,4))/cast(t13.fboxcount as decimal(24,4)) as decimal(24,4))
from dbo.icbom t1
inner join dbo.t_icitem t2 on t1.fitemid=t2.fitemid
inner join dbo.icbomchild t3 on t1.finterid=t3.finterid
inner join dbo.t_icitem t4 on t3.fitemid=t4.fitemid
inner join dbo.sheet38$ t11 on REVERSE(left(REVERSE(t11.产品代码),CHARINDEX('.',REVERSE(t11.产品代码))-1))=t2.fshortnumber 
                       and REVERSE(left(REVERSE(t11.子件编码),CHARINDEX('.',REVERSE(t11.子件编码))-1))=t4.fshortnumber 
inner join AIS20120820103535.dbo.t_icitem t12 on t12.fnumber=t11.旧系统代码
inner join AIS20120820103535.dbo.t_item t19 on t19.fitemclassid=3002 and t19.fname=t11.包装方式名称
inner join AIS20120820103535.dbo.t_bospacksub t13 on t13.fproductid=t12.fitemid and t19.fitemid=t13.fbrandid
where t3.fqty<>cast(t11.用量 as decimal(24,4))
---------------------------------------------------------------------------------------------------------
select t2.fnumber,t2.fname,t2.fmodel,t4.fnumber,t4.fname,t4.fmodel,t3.fqty
--update t3 set fqty=0.0666,fauxqty=0.0666
from dbo.icbom t1
inner join dbo.t_icitem t2 on t1.fitemid=t2.fitemid
inner join dbo.icbomchild t3 on t1.finterid=t3.finterid
inner join dbo.t_icitem t4 on t3.fitemid=t4.fitemid
where t2.fnumber like 'a.01%' order by t2.fnumber
and t4.fnumber like '2.01%'
---------------------------------------------------------------------------------------------------------

select t1.fnumber,t1.fname,t1.fmodel,t1.fitemid
into #data
--delete t3
from dbo.t_icitem t1
left join dbo.icbom t2 on t1.fitemid=t2.fitemid
inner join t_item t3 on t1.fitemid=t3.fitemid
where left(t1.fnumber,4) in ('a.01','p.01','j.01','x.01','y.01') and t2.fitemid is null
---------------------------------------------------------------------------------------------------------

select t1.fnumber,t1.fname,t1.fmodel,t1.fitemid
from dbo.t_icitem t1
left join dbo.icbom t2 on t1.fitemid=t2.fitemid
inner join t_item t3 on t1.fitemid=t3.fitemid
where left(t1.fnumber,1) in ('v') and t2.fitemid is null

select * from t_icitem where fshortnumber in ('713007','713008','800004')

select t2.fnumber,t2.fname,t2.fmodel,t4.fnumber,t4.fname,t4.fmodel,t3.fqty
--update t3 set fitemid=t6.fitemid
from dbo.icbom t1
inner join dbo.t_icitem t2 on t1.fitemid=t2.fitemid
inner join dbo.icbomchild t3 on t1.finterid=t3.finterid
inner join dbo.t_icitem t4 on t3.fitemid=t4.fitemid

select * 
--update t1 set fitemid=107754
from icbomchild t1 where fitemid not in (select fitemid from t_icitem)

select * 
--update t1 set fitemid=107754
--delete t1
from t_supply t1 where fitemid not in (select fitemid from t_icitem) and fitemid=107755

select * 
--update t1 set fitemid=107754
--delete t1
from t_supplyentry t1 where fitemid not in (select fitemid from t_icitem) and fitemid=107755

select * 
--update t1 set fitemid=107754
from poorderentry t1 where fitemid not in (select fitemid from t_icitem)

--select * from sheet15$
select t2.fnumber,t2.fname,t2.fmodel,t4.fnumber,t4.fname,t4.fmodel,t3.fqty
--update t3 set fitemid=t6.fitemid
from dbo.icbom t1
inner join dbo.t_icitem t2 on t1.fitemid=t2.fitemid
inner join dbo.icbomchild t3 on t1.finterid=t3.finterid
inner join dbo.t_icitem t4 on t3.fitemid=t4.fitemid
inner join sheet41$ t5 on t5.删除编码=t4.fnumber
inner join t_icitem t6 on t6.fnumber=t5.保留编码
where t5.删除编码 not like '%713008%'

select t2.fitemid into #data
--delete t3
from sheet41$ t1
inner join t_icitem t2 on t1.删除编码=t2.fnumber
left join t_item t3 on t3.fitemid=t2.fitemid

drop table #data


DELETE t_ICItemCore 
FROM t_ICItemCore INNER JOIN #data  
ON t_ICItemCore.FItemID=#data.FItemID  

DELETE t_ICItemBase FROM t_ICItemBase INNER JOIN #data  
ON t_ICItemBase.FItemID=#data.FItemID  

DELETE t_ICItemMaterial FROM t_ICItemMaterial INNER JOIN #data  
ON t_ICItemMaterial.FItemID=#data.FItemID   

DELETE t_ICItemPlan FROM t_ICItemPlan INNER JOIN #data   
ON t_ICItemPlan.FItemID=#data.FItemID  

DELETE t_ICItemDesign FROM t_ICItemDesign INNER JOIN #data   
ON t_ICItemDesign.FItemID=#data.FitemID  

DELETE t_ICItemStandard FROM t_ICItemStandard INNER JOIN #data  
ON t_ICItemStandard.FItemID=#data.FItemID  

DELETE t_ICItemQuality FROM t_ICItemQuality INNER JOIN #data  
ON t_ICItemQuality.FItemID=#data.FItemID  

DELETE T_BASE_ICItemEntrance FROM T_BASE_ICItemEntrance INNER JOIN #data  
ON T_BASE_ICItemEntrance.FItemID=#data.FItemID 

DELETE t_ICItemCustom FROM t_ICItemCustom INNER JOIN #data  
ON t_ICItemCustom.FItemID=#data.FItemID  

select * from t_itempropdesc where fitemclassid=4
---------------------------------------------------------------------------------------------------------
--物料单位信息
SELECT t1.FUnitID, t1.FUnitGroupID,t1.FSecUnitID,t1.FOrderUnitID, t1.FSaleUnitID,t1.FStoreUnitID, t1.FProductUnitID,t3.FCUUnitID, t8.FFirstUnit, t8.FSecondUnit,
t0.FItemID, t0.FModel, t0.FName, t0.FHelpCode, t0.FDeleted, t0.FShortNumber, t0.FNumber, t0.FModifyTime, t0.FParentID, t0.FBrNo, t0.FTopID, t0.FRP, 
                      t0.FOmortize, t0.FOmortizeScale, t0.FForSale, t0.FStaCost, t0.FOrderPrice, t0.FOrderMethod, t0.FPriceFixingType, t0.FSalePriceFixingType, 
                      t0.FPerWastage, t0.FARAcctID, t0.FPlanPriceMethod, t0.FPlanClass, t1.FErpClsID, t1.FUnitID, t1.FUnitGroupID, t1.FDefaultLoc, t1.FSPID, t1.FSource, 
                      t1.FQtyDecimal, t1.FLowLimit, t1.FHighLimit, t1.FSecInv, t1.FUseState, t1.FIsEquipment, t1.FEquipmentNum, t1.FIsSparePart, t1.FFullName, 
                      t1.FSecUnitID, t1.FSecCoefficient, t1.FSecUnitDecimal, t1.FAlias, t1.FOrderUnitID, t1.FSaleUnitID, t1.FStoreUnitID, t1.FProductUnitID, t1.FApproveNo, 
                      t1.FAuxClassID, t1.FTypeID, t1.FPreDeadLine, t1.FSerialClassID, t2.FOrderRector, t2.FPOHghPrcMnyType, t2.FPOHighPrice, t2.FWWHghPrc, 
                      t2.FWWHghPrcMnyType, t2.FSOLowPrc, t2.FSOLowPrcMnyType, t2.FIsSale, t2.FProfitRate, t2.FSalePrice, t2.FBatchManager, t2.FISKFPeriod, 
                      t2.FKFPeriod, t2.FTrack, t2.FPlanPrice, t2.FPriceDecimal, t2.FAcctID, t2.FSaleAcctID, t2.FCostAcctID, t2.FAPAcctID, t2.FGoodSpec, t2.FCostProject, 
                      t2.FIsSnManage, t2.FStockTime, t2.FBookPlan, t2.FBeforeExpire, t2.FTaxRate, t2.FAdminAcctID, t2.FNote, t2.FIsSpecialTax, t2.FSOHighLimit, 
                      t2.FSOLowLimit, t2.FOIHighLimit, t2.FOILowLimit, t2.FDaysPer, t2.FLastCheckDate, t2.FCheckCycle, t2.FCheckCycUnit, t2.FStockPrice, t2.FABCCls, 
                      t2.FBatchQty, t2.FClass, t2.FCostDiffRate, t2.FDepartment, t2.FSaleTaxAcctID, t2.FCBBmStandardID, t3.FPlanTrategy, t3.FOrderTrategy, t3.FLeadTime, 
                      t3.FFixLeadTime, t3.FTotalTQQ, t3.FQtyMin, t3.FQtyMax, t3.FCUUnitID, t3.FOrderInterVal, t3.FBatchAppendQty, t3.FOrderPoint, t3.FBatFixEconomy, 
                      t3.FBatChangeEconomy, t3.FRequirePoint, t3.FPlanPoint, t3.FDefaultRoutingID, t3.FDefaultWorkTypeID, t3.FProductPrincipal, t3.FDailyConsume, 
                      t3.FMRPCon, t3.FPlanner, t3.FPutInteger, t3.FInHighLimit, t3.FInLowLimit, t3.FLowestBomCode, t3.FMRPOrder, t3.FIsCharSourceItem, 
                      t3.FCharSourceItemID, t7.F_102, t7.F_103, t7.F_104, t7.F_105, t7.F_106, t7.F_107, t7.F_108, t7.F_109, t7.F_110, t4.FChartNumber, t4.FIsKeyItem, 
                      t4.FMaund, t4.FGrossWeight, t4.FNetWeight, t4.FCubicMeasure, t4.FLength, t4.FWidth, t4.FHeight, t4.FSize, t4.FVersion, t5.FStandardCost, 
                      t5.FStandardManHour, t5.FStdPayRate, t5.FChgFeeRate, t5.FStdFixFeeRate, t5.FOutMachFee, t5.FPieceRate, t6.FInspectionLevel, t6.FInspectionProject,
                       t6.FIsListControl, t6.FProChkMde, t6.FWWChkMde, t6.FSOChkMde, t6.FWthDrwChkMde, t6.FStkChkMde, t6.FOtherChkMde, t6.FStkChkPrd, 
                      t6.FStkChkAlrm, t6.FIdentifier, t8.FNameEn, t8.FModelEn, t8.FHSNumber, t8.FFirstUnit, t8.FSecondUnit, t8.FFirstUnitRate, t8.FSecondUnitRate, 
                      t8.FIsManage, t8.FPackType, t8.FLenDecimal, t8.FCubageDecimal, t8.FWeightDecimal, t8.FImpostTaxRate, t8.FConsumeTaxRate, 
                      t8.FManageType
--update t1 set t1.FUnitID=211, t1.FUnitGroupID=210,t1.FOrderUnitID=211, t1.FSaleUnitID=211,t1.FStoreUnitID=211, t1.FProductUnitID=211
--update t2 set FPriceDecimal=4
--update t1 set FDefaultLoc=t10.FDefaultLoc
--update t1 set FDefaultLoc=16474
--select t9.fnumber,t1.FDefaultLoc,t1.fsource,t9.FBatchManager
--update t4 set FGrossWeight=t10.FGrossWeight,FNetWeight=t10.FNetWeight
--update t1 set fsource=175
--update t2 set FBatchManager=t10.FBatchManager
--update t2 set FBatchManager=1
--update t2 set FTrack=76
--update t2 set FSaleAcctID=1435
--update t2 set facctid=t10.facctid
FROM         dbo.t_ICItemCore AS t0 LEFT OUTER JOIN
                      dbo.t_ICItemBase AS t1 ON t0.FItemID = t1.FItemID LEFT OUTER JOIN
                      dbo.t_ICItemMaterial AS t2 ON t0.FItemID = t2.FItemID LEFT OUTER JOIN
                      dbo.t_ICItemPlan AS t3 ON t0.FItemID = t3.FItemID LEFT OUTER JOIN
                      dbo.t_ICItemDesign AS t4 ON t0.FItemID = t4.FItemID LEFT OUTER JOIN
                      dbo.t_ICItemStandard AS t5 ON t0.FItemID = t5.FItemID LEFT OUTER JOIN
                      dbo.t_ICItemQuality AS t6 ON t0.FItemID = t6.FItemID LEFT OUTER JOIN
                      dbo.t_ICItemCustom AS t7 ON t0.FItemID = t7.FItemID LEFT OUTER JOIN
                      dbo.T_BASE_ICItemEntrance AS t8 ON t0.FItemID = t8.FItemID
                      inner join t_icitem t9 on t9.fitemid=t0.fitemid
                      inner join AIS20120820103535.dbo.t_icitem t10 on t9.fshortnumber=t10.fshortnumber
--inner join t_baseproperty t11 on t11.fitemid=t0.fitemid and t11.FCreateDate>'2014-12-25'
where t2.FSaleAcctID<>1444 and t1.FUnitID=0--t9.fdefaultloc not in (select fitemid from t_stock)
--(t9.fnumber) like '2.06.b2038.01.%'
--and t9.ferpclsid=2 order by t9.fnumber
--left(t9.fnumber,4) in ('2.02','2.02')
t2.FTrack<>76
left(t9.fnumber,1) in ('1','2','6','3','4','5','7','8') --and
--t2.FBatchManager=0
and isnull(t9.fsource,0)<>175
and t1.FDefaultLoc<>16474

select * from t_account where fnumber like '6001.01.%' and fname like '%%收入%'

select * from t_department
select * from t_stock
---------------------------------------------------------------------------------------------------------

select t1.fbillno,t4.fnumber,t2.fentryid
from seorder t1
inner join seorderentry t2 on t1.finterid=t2.finterid
left join icbom t3 on t2.fitemid=t3.fitemid
inner join t_icitem t4 on t4.fitemid=t2.fitemid
where t3.fitemid is null

--2、傲威中性产品标准化资料检查、录入,共2092条傲威中性产品需检查
select t3.fname as 项目经理,t1.fnumber 代码,t1.fname 名称,t1.fmodel 规格,t1.f_105 描述,f_106 适用机型,f_107 适用区域,fnetweight 产品净重,fgrossweight 产品毛重,
f_109 标准外箱尺寸,f_110 标准装箱数,f_111 标准外盒,f_112 整箱净重,f_119 整箱毛重,t2.fname 是否引擎 
from t_icitem t1 
left join t_submessage t2 on t1.f_126=t2.finterid 
LEFT JOIN t_submessage t3 ON t1.f_128=t3.finterid
where left(t1.fnumber,1) in ('a','p','j','x','y')  order by fnumber


select substring(t4.ffullname,dbo.My_F_CharIndex(t4.ffullname,'_',1)+1,(dbo.My_F_CharIndex(t4.ffullname,'_',2)-dbo.My_F_CharIndex(t4.ffullname,'_',1)-1)),
t4.ffullname,t3.fname as 项目经理,t1.fnumber 代码,t1.fname 名称,t1.fmodel 规格,t1.f_105 描述,f_106 适用机型,f_107 适用区域,
fnetweight 产品净重,fgrossweight 产品毛重,f_109 标准外箱尺寸,f_110 标准装箱数,f_111 标准外盒,f_112 整箱净重,f_119 整箱毛重,t2.fname 是否引擎 
from t_icitem t1 
left join t_submessage t2 on t1.f_126=t2.finterid 
LEFT JOIN t_submessage t3 ON t1.f_128=t3.finterid
inner join t_item t4 on t4.fitemid=t1.fitemid
where left(t1.fnumber,1) in ('v')  order by t1.fnumber



select substring(t4.ffullname,dbo.My_F_CharIndex(t4.ffullname,'_',1)+1,(dbo.My_F_CharIndex(t4.ffullname,'_',2)-dbo.My_F_CharIndex(t4.ffullname,'_',1)-1)),count(1)
from t_icitem t1 
left join t_submessage t2 on t1.f_126=t2.finterid 
LEFT JOIN t_submessage t3 ON t1.f_128=t3.finterid
inner join t_item t4 on t4.fitemid=t1.fitemid
where left(t1.fnumber,1) in ('v')  
group by substring(t4.ffullname,dbo.My_F_CharIndex(t4.ffullname,'_',1)+1,(dbo.My_F_CharIndex(t4.ffullname,'_',2)-dbo.My_F_CharIndex(t4.ffullname,'_',1)-1))

超彩客户	1160
诚华客户	341
鑫威客户	484
傲威客户	4407
泰格客户	1383


select t3.fname as 项目经理,count(1)
from t_icitem t1 
left join t_submessage t2 on t1.f_126=t2.finterid 
LEFT JOIN t_submessage t3 ON t1.f_128=t3.finterid
where left(t1.fnumber,1) in ('a','p','j','x','y')
group by t3.fname

--left(t1.fnumber,4) in ('a.01','p.01','j.01','x.01','y.01') 



--查询个性化产品未审核BOM详情
select t3.fname as 研发经理,

select sum(case t1.fstatus when 0 then 1 else 0 end) as fnocheck,
sum(case t1.fstatus when 1 then 1 else 0 end) as fcheck
from icbom t1
inner join t_icitem t2 on t1.fitemid=t2.fitemid
left join t_submessage t3 on t2.f_128=t3.finterid
where left(t2.fnumber,1) in ('v') --and t1.fstatus=1


select sum(case t1.fstatus when 0 then 1 else 0 end) as fnocheck,
sum(case t1.fstatus when 1 then 1 else 0 end) as fcheck
from icbom t1
inner join t_icitem t2 on t1.fitemid=t2.fitemid
left join t_submessage t3 on t2.f_128=t3.finterid
where left(t2.fnumber,1) in ('3','4','5') --and t1.fstatus=1


select t3.fname,sum(case t1.fstatus when 0 then 1 else 0 end) as fnocheck,
sum(case t1.fstatus when 1 then 1 else 0 end) as fcheck
from icbom t1
inner join t_icitem t2 on t1.fitemid=t2.fitemid
left join t_submessage t3 on t2.f_128=t3.finterid
where left(t2.fnumber,1) in ('a','p','j','x','y') --and t1.fstatus=1
group by t3.fname


select t3.fname as 研发经理,count(*) as 未审核BOM数 from icbom t1
inner join t_icitem t2 on t1.fitemid=t2.fitemid
left join t_submessage t3 on t2.f_128=t3.finterid
where left(t2.fnumber,1) in ('a','p','j','x','y') --and t1.fstatus=0
group by t3.fname

select count(*) as 未审核BOM数 from icbom t1
inner join t_icitem t2 on t1.fitemid=t2.fitemid
left join t_submessage t3 on t2.f_128=t3.finterid
where left(t2.fnumber,1) in ('a','p','j','x','y') --and t1.fstatus=0
group by t3.fname

--------------------------------------------------------------------------------------------------

select t2.fnumber,t2.fname,t2.fmodel,t4.fqty,t4.fauxqty
--update t4 set t4.fqty=0.0833,t4.fauxqty=0.0833
from icbom t1
inner join t_icitem t2 on t1.fitemid=t2.fitemid
inner join 
	(
	select distinct t1.finterid
	from
	(
		select distinct t12.finterid
		from dbo.t_icitem t11
		inner join dbo.icbom t12 on t11.fitemid=t12.fitemid
		inner join dbo.icbomchild t15 on t15.finterid=t12.finterid
		inner join dbo.t_icitem t16 on t16.fitemid=t15.fitemid
		where t16.fshortnumber='200018'
	) t1
	inner join
	(
		select distinct t12.finterid
		from dbo.t_icitem t11
		inner join dbo.icbom t12 on t11.fitemid=t12.fitemid
		inner join dbo.icbomchild t15 on t15.finterid=t12.finterid
		inner join dbo.t_icitem t16 on t16.fitemid=t15.fitemid
		where t16.fshortnumber='BXH01983'
	) t2 on t1.finterid=t2.finterid
) t3 on t1.finterid=t3.finterid	
inner join icbomchild t4 on t3.finterid=t4.finterid
inner join t_icitem t5 on t4.fitemid=t5.fitemid
where t5.fshortnumber='200018'

------------------------------------------------------------------------------------

--查询个性化产品未审核BOM详情
select t3.fname as 研发经理,fbomnumber,t2.fnumber,t2.fname,t2.fmodel,
case t1.fstatus when 0 then '未审核' else '审核' end as BOM审核状态,case t2.f_126 when 40019 then '是' else ' 'end as 是否产品引擎 
from icbom t1
inner join t_icitem t2 on t1.fitemid=t2.fitemid
left join t_submessage t3 on t2.f_128=t3.finterid
where left(t2.fnumber,1) in ('v') and t1.fstatus=1
order by t2.f_128,t2.fnumber

select * from t_itempropdesc where fitemclassid=4
t2.f_126=40019 and 

---------------------------------------------------------------------------------------------------------

select fnumber,FUnitID, t1.FUnitGroupID,t1.FOrderUnitID, t1.FSaleUnitID,t1.FStoreUnitID, t1.FProductUnitID
from t_icitem t1 where fnumber like '1.02.0002%'

--select FPutInteger ,fnumber from t_icitem where FPutInteger=1
--select * from t_measureunit where fitemid=235
标准外箱尺寸(mm)	     F_109
标准装箱数	             F_110
标准外盒尺寸(mm)	     F_111
整箱净重(kg)	         F_112
--标准用量	             F_116
主供应商	             F_117
打印机品牌	             F_102
外盒尺寸类别	         F_103
工厂结算类别	         F_104
整箱毛重(kg)	         F_119
裸包标准外箱尺寸(mm)	 F_120
裸包标准装箱数	         F_121
裸包整箱净重(kg)	     F_122
裸包整箱毛重(kg)	     F_123

投料自动取整	FPutInteger
毛重	        FGrossWeight
净重	        FNetWeight
长度	        FLength
宽度	        FWidth
高度	        FHeight
体积	        FSize

select t2.fnumber,t2.fname,t3.fnumber,t3.fname,t1.* 
--update t4 set fitemid=t2.fitemid
from sheet4$ t1
inner join t_icitem t2 on t1.保留编码=t2.fnumber
inner join t_icitem t3 on t1.删除编码=t3.fnumber
inner join icbomchild t4 on t3.fitemid=t4.fitemid

select * 
--delete t4
--delete t3
from sheet4$ t1
inner join t_icitem t3 on t1.删除编码=t3.fnumber
inner join t_item t4 on t4.fitemid=t3.fitemid

---------------------------------------------------------------------------------------------------------
select t2.fnumber
--update t3 set FGrossWeight=0,FNetWeight=0
--update t7 set F_109='0*0*0',F_111='0*0*0',F_110=0,F_112=0,F_119=0,F_103=0
from t_icitem t2
left join icbom t1 on t1.fitemid=t2.fitemid
inner join t_ICItemCustom AS t7 ON t2.FItemID = t7.FItemID
inner join t_ICItemDesign t3 on t3.fitemid=t2.fitemid
where left(t2.fnumber,1) in ('A','P','J','X','Y','V')
and t1.fitemid is null
---------------------------------------------------------------------------------------------------------
select t2.fnumber,t2.fname,t2.fmodel,t2.F_111,t2.FPutInteger
--update t3 set FPutInteger=1
from t_icitem t2 
inner join t_ICItemCustom AS t7 ON t2.FItemID = t7.FItemID
inner join t_ICItemPlan t3 on t3.fitemid=t2.fitemid
where t2.fnumber like '2.01%'
---------------------------------------------------------------------------------------------------------

--打印机品牌	             F_102
select t2.fnumber,t2.fname,t2.fmodel,
t4.fnumber fchildnumber,t4.fname fchildname,t4.fmodel fchildmodel,t3.fqty,left(t4.fnumber,4) fnumber,t8.fname,t9.finterid
--update t7 set F_102=t9.finterid 
from t_icitem t2
inner join icbom t1 on t1.fitemid=t2.fitemid
inner join dbo.icbomchild t3 on t1.finterid=t3.finterid
inner join dbo.t_icitem t4 on t3.fitemid=t4.fitemid
inner join t_measureunit t5 on t5.fitemid=t4.funitid
inner join t_ICItemCustom AS t7 ON t2.FItemID = t7.FItemID
inner join t_item t8 on t8.fitemclassid=4 and t8.fnumber=left(t4.fnumber,4)
left join t_submessage t9 on t9.ftypeid=10001 and t9.fname=t8.fname
where left(t2.fnumber,1) in ('A','P','J','X','Y','V')
and left(t4.fnumber,1) in ('3','4','5','7','8')
and isnull(t7.F_102,0)=0
order by t9.finterid,t2.fnumber,t4.fnumber

select t2.fnumber,t2.fname,t2.fmodel,t7.F_102,t9.finterid
--update t7 set F_102=t9.finterid 
from t_icitem t2
inner join t_ICItemCustom AS t7 ON t2.FItemID = t7.FItemID
left join t_submessage t9 on t9.ftypeid=10001 and Charindex(t9.fname,t2.fname,1)>0
where left(t2.fnumber,1) in ('A','P','J','X','Y','V')
and isnull(t9.finterid,0)<>0 and isnull(t7.F_102,0)=0
order by t9.finterid,t2.fnumber

select * from t_submessage where ftypeid=10001 and fname='Brother'
---------------------------------------------------------------------------------------------------------
select fitemid,fname,* from t_item where fitemclassid=3005 fnumber='1.01'

--工厂结算类别	         F_104
--389	A
--390	B
--391	C
--392	D

select t2.fnumber
--update t1 set F_104=389
from t_ICItemCustom t1
inner join t_icitem t2 on t1.fitemid=t2.fitemid
where Charindex('高配',t2.fname,1)>0
and left(t2.fnumber,1) in ('A','P','J','X','Y','V')
and isnull(t2.F_104,0)=0

select t2.fnumber,t2.F_102
--update t1 set F_104=390
from t_ICItemCustom t1
inner join t_icitem t2 on t1.fitemid=t2.fitemid
where Charindex('高配',t2.fname,1)=0
and left(t2.fnumber,1) in ('A','P','J','X','Y','V')
and isnull(t2.F_104,0)=0

select cast(round(2.158,2) as numeric(5,2))
---------------------------------------------------------------------------------------------------------
--标准装箱数	             F_110
select t2.fnumber,t2.fname,t2.fmodel,round(cast(cast(1 as decimal(24,4))/t3.fqty as decimal(24,4)),0),t3.fqty,
t4.fnumber fchildnumber,t4.fname fchildname,t4.fmodel fchildmodel,
--substring(t4.fmodel,1,dbo.My_F_Charindex(t4.fmodel,'cm',1)-1) fsize,
t3.fqty,cast(1/t3.fqty as int) fboxqty,t7.F_110
--update t7 set F_110=round(cast(cast(1 as decimal(24,4))/t3.fqty as decimal(24,4)),0)
--update t3 set fauxqty=0.1666,fqty=0.1666
from t_icitem t2
inner join icbom t1 on t1.fitemid=t2.fitemid
inner join dbo.icbomchild t3 on t1.finterid=t3.finterid
inner join dbo.t_icitem t4 on t3.fitemid=t4.fitemid
inner join t_measureunit t5 on t5.fitemid=t4.funitid
inner join t_ICItemCustom AS t7 ON t2.FItemID = t7.FItemID
where t4.fnumber like '2.01.%' 
--and t2.fshortnumber='VB03382'
--and t3.fqty=1
order by t2.fnumber,t4.fnumber

---------------------------------------------------------------------------------------------------------
--整箱净重(kg)	         F_112  --单个净重=除掉彩盒、除掉纸箱的重量  --整箱净重=单个净重×装箱数
select t2.fnumber,t2.fname,t2.fmodel,
t4.FNetWeight,t2.F_110,t1.FNetWeight*t2.F_110
--update t4 set FNetWeight=t1.FNetWeight
--update t7 set F_112=t1.FNetWeight*t2.F_110
from  t_icitem t2
inner join
(
	select t2.fitemid,sum(t4.FNetWeight*t3.fqty)/1000 FNetWeight --单个
	from t_icitem t2
	inner join icbom t1 on t1.fitemid=t2.fitemid
	inner join dbo.icbomchild t3 on t1.finterid=t3.finterid
	inner join dbo.t_icitem t4 on t3.fitemid=t4.fitemid
	inner join t_measureunit t5 on t5.fitemid=t4.funitid
	where left(t2.fnumber,1) in ('A','P','J','X','Y','V')
	and left(t4.fnumber,4) not in ('2.01','2.02','2.03','2.04') --and t4.fmodel like '%*%*%mm%'
	--and t2.fshortnumber='A00001'
	and t4.FNetWeight<>0
	group by t2.fitemid
) t1 on t1.fitemid=t2.fitemid
inner join t_ICItemCustom AS t7 ON t2.FItemID = t7.FItemID
inner join t_ICItemDesign AS t4 ON t2.FItemID = t4.FItemID
order by t2.fnumber

---------------------------------------------------------------------------------------------------------
			
--整箱毛重(kg)	         F_119  --单个毛重=除掉纸箱的重量  --整箱毛重=单个毛重*装箱数+单个纸箱重量
select t2.fnumber,t2.fname,t2.fmodel,t2.F_110,
t4.FNetWeight,t2.FGrossWeight*t2.F_110 FGrossWeight,t2.FGrossWeight*t2.F_110+t1.FBoxWeight,t1.FNoBoxWeight
--update t4 set FGrossWeight=t1.FNoBoxWeight
--update t7 set F_119=t2.FGrossWeight*t2.F_110+t1.FBoxWeight
from  t_icitem t2
inner join
(
	select t2.fitemid,sum((case when left(t4.fnumber,4) not in ('2.01') then t4.FNetWeight else 0 end)*t3.fqty)/1000 FNoBoxWeight, --单个
			  sum((case when left(t4.fnumber,4) in ('2.01') then t4.FNetWeight else 0 end))/1000 FBoxWeight --一个纸箱的重量
	--select t4.fnumber,t4.fname,t4.fmodel,t4.FNetWeight,t3.fqty,t4.FNetWeight*t3.fqty
	from t_icitem t2
	inner join icbom t1 on t1.fitemid=t2.fitemid
	inner join dbo.icbomchild t3 on t1.finterid=t3.finterid
	inner join dbo.t_icitem t4 on t3.fitemid=t4.fitemid
	inner join t_measureunit t5 on t5.fitemid=t4.funitid
	where left(t2.fnumber,1) in ('A','P','J','X','Y','V')
	and t4.FNetWeight<>0 
	--and t2.fshortnumber='A00001'
	group by t2.fitemid
) t1 on t1.fitemid=t2.fitemid
inner join t_ICItemCustom AS t7 ON t2.FItemID = t7.FItemID
inner join t_ICItemDesign AS t4 ON t2.FItemID = t4.FItemID
order by t2.fnumber
---------------------------------------------------------------------------------------------------------

select t1.fnumber,t1.fname,t2.FGrossWeight,t2.fnetweight,t2.FGrossWeight/1000
--update t2 set FGrossWeight=0,fnetweight=0
from t_icitem t1
inner join t_ICItemDesign t2 on t1.fitemid=t2.fitemid
where t2.FGrossWeight>1 and t1.fnumber not like 'f%' and t1.fnumber not like '2.01%'
order by t1.fnumber

---------------------------------------------------------------------------------------------------------


select t9.fnumber,t9.FBatchManager,T1.*
--update t1 set fshortnumber=replace(t1.fshortnumber,'A','ZA')
--update t1 set fnumber=replace(t1.fnumber,'.A','.ZA'),ffullnumber=replace(t1.ffullnumber,'.A','.ZA')
FROM         dbo.t_ICItemCore  t0
inner join dbo.t_item AS t1 ON t0.FItemID = t1.FItemID 
inner join t_icitem t9 on t9.fitemid=t0.fitemid
where left(t9.fnumber,1)  in ('a')

select t9.fnumber,t9.FBatchManager,t9.*
--update t0 set fshortnumber=replace(t0.fshortnumber,'A','ZA')
--update t0 set fnumber=replace(t0.fnumber,'.A','.ZA')
FROM         dbo.t_ICItemCore  t0
inner join dbo.t_item AS t1 ON t0.FItemID = t1.FItemID 
inner join t_icitem t9 on t9.fitemid=t0.fitemid
where left(t9.fnumber,1)  in ('a')


select t9.fnumber,t9.FBatchManager,T1.*
--update t1 set fshortnumber=replace(t1.fshortnumber,'P','ZP')
--update t1 set fnumber=replace(t1.fnumber,'.P','.ZP'),ffullnumber=replace(t1.ffullnumber,'.P','.ZP')
FROM         dbo.t_ICItemCore  t0
inner join dbo.t_item AS t1 ON t0.FItemID = t1.FItemID 
inner join t_icitem t9 on t9.fitemid=t0.fitemid
where left(t9.fnumber,1)  in ('p')

select t9.fnumber,t9.FBatchManager,t9.*
--update t0 set fshortnumber=replace(t0.fshortnumber,'P','ZP')
--update t0 set fnumber=replace(t0.fnumber,'.P','.ZP')
FROM         dbo.t_ICItemCore  t0
inner join dbo.t_item AS t1 ON t0.FItemID = t1.FItemID 
inner join t_icitem t9 on t9.fitemid=t0.fitemid
where left(t9.fnumber,1)  in ('P')

---------------------------------------------------------------------------------------------------------

select t4.fnumber,t4.fname,t4.fmodel,replace(t4.fmodel,'x','*')
--update t6 set fmodel=replace(t4.fmodel,'x','*')
from t_icitem t4
--left join icbomchild t5 on t4.fitemid=t5.fitemid
inner join t_ICItemCore t6 on t6.fitemid=t4.fitemid
where left(t4.fnumber,4) in ('2.02','2.03','2.04') and t4.fmodel like '%x%x%mm%'


select t4.fnumber,t4.fname,t4.fmodel,replace(t4.fmodel,'x','*')
--update t6 set fmodel=replace(t4.fmodel,'x','*')
from t_icitem t4
--left join icbomchild t5 on t4.fitemid=t5.fitemid
inner join t_ICItemCore t6 on t6.fitemid=t4.fitemid
where left(t4.fnumber,4) in ('2.02','2.03','2.04') and t4.fmodel like '%*%*%%' and dbo.My_F_Charindex(t4.fmodel,'mm',1)=0


select t4.fnumber,t4.fname,t4.fmodel,replace(t4.fmodel,'x','*')
--update t6 set fmodel=replace(t4.fmodel,'x','*')
from t_icitem t4
--left join icbomchild t5 on t4.fitemid=t5.fitemid
inner join t_ICItemCore t6 on t6.fitemid=t4.fitemid
where left(t4.fnumber,4) not in ('2.02','2.03','2.04') and t4.fname like '%彩盒%'
and t4.fnumber like '2%'

--标准外盒尺寸(mm)	     F_111
select t2.fnumber,t2.fname,t2.fmodel,
t4.fnumber fchildnumber,t4.fname fchildname,t4.fmodel fchildmodel,
substring(t4.fmodel,1,dbo.My_F_Charindex(t4.fmodel,'mm',1)-1) fsize,t3.fqty
--update t7 set F_111=substring(t4.fmodel,1,dbo.My_F_Charindex(t4.fmodel,'mm',1)-1)  
from t_icitem t2
inner join icbom t1 on t1.fitemid=t2.fitemid
inner join dbo.icbomchild t3 on t1.finterid=t3.finterid
inner join dbo.t_icitem t4 on t3.fitemid=t4.fitemid
inner join t_measureunit t5 on t5.fitemid=t4.funitid
inner join t_ICItemCustom AS t7 ON t2.FItemID = t7.FItemID
where left(t2.fnumber,1) in ('A','P','J','X','Y','V')
and left(t4.fnumber,4) in ('2.02','2.03','2.04') and t4.fmodel like '%*%*%mm%'
order by t2.fnumber,t4.fnumber



---------------------------------------------------------------------------------------------------------

--drop table #data

select t7.fnumber,t7.fname,t7.fmodel,t7.F_111,
cast(1*
cast(cast(left(t7.F_111,CHARINDEX('*',t7.F_111)-1) as decimal(24,4))/10 as decimal(24,4))*
cast(cast(substring(t7.F_111,CHARINDEX('*',t7.F_111)+1,charindex('*',t7.F_111,charindex('*',t7.F_111)+1)-CHARINDEX('*',t7.F_111)-1) as decimal(24,4))/10 as decimal(24,4))*
cast(cast(substring(t7.F_111,charindex('*',t7.F_111,charindex('*',t7.F_111)+1)+1,len(t7.F_111)-charindex('*',t7.F_111,charindex('*',t7.F_111)+1)) as decimal(24,4))/10 as decimal(24,4)) as decimal(24,4)) 体积
into #data
from t_icitem t7
where left(t7.fnumber,1) in ('A','P','J','X','Y','V')
and t7.F_111 like '%*%*%' and t7.F_111 not like '%0*0*0%'
order by t7.F_111

--外盒尺寸类别	         F_103
select (case when t1.体积<=8000 then 395 when t1.体积>8000 and t1.体积<=13000 then 394 when t1.体积>13000 then 393 end),t1.*
--update t7 set F_103= (case when t1.体积<=8000 then 395 when t1.体积>8000 and t1.体积<=13000 then 394 when t1.体积>13000 then 393 end)           
from #data t1
inner join t_icitem t2 on t1.fnumber=t2.fnumber
inner join t_ICItemCustom AS t7 ON t2.FItemID = t7.FItemID

select fitemid,fname,* from t_item where fitemclassid=3004 fname='大'
393	大
394	中
395	小

---------------------------------------------------------------------------------------------------------


select t1.fshortnumber 短代码,t1.fnumber 长代码,t1.fname 产品名称,t3.ffullname 全称,t1.fmodel 规格型号,
isnull(t1.f_105,'') 描述,isnull(t1.f_106,'') 适用机型,isnull(t1.F_107,'') 适用区域,
(case when isnull(t1.F_109,'')='' then '0*0*0' else t1.F_109 end) [标准外箱尺寸(mm)],
(case when isnull(t1.F_111,'')='' then '0*0*0' else t1.F_111 end) [标准外盒尺寸(mm)],
isnull(t1.F_112,0) [整箱净重(kg)],isnull(t1.F_119,0) [整箱毛重(kg)],isnull(t1.F_110,0) 标准装箱数,
--(case when isnull(t1.F_120,'')='' then '0*0*0' else t1.F_120 end) [裸包标准外箱尺寸(mm)],
--isnull(t1.F_122,0) [裸包整箱净重(kg)],isnull(t1.F_123,0) [裸包整箱毛重(kg)],isnull(t1.F_121,0) 裸包标准装箱数,
isnull(t13.fname,'') 外盒尺寸,isnull(t14.fname,'') 打印机品牌,t1.FGrossWeight [毛重(kg)],t1.FNetWeight [净重(kg)]
--t2.fcreatedate 创建时间,t2.fcreateuser 创建人,t2.flastmoddate 最后修改时间,t2.flastmoduser 最后修改人,t2.fdeletedate 禁用时间,t2.fdeleteuser 禁用人
from t_icitem t1
left join t_baseproperty t2 on t1.fitemid=t2.fitemid
left join t_item t13 on t13.fitemid=t1.F_103 and t13.fitemclassid=3004  --外盒尺寸  --select * from t_item where fitemclassid=3004
left join t_SubMessage t14 on t14.finterid=t1.F_102  --打印机品牌
inner join t_item t3 on t3.fitemid=t1.fitemid
left join t_user t4 on t4.fuserid=t3.FChkUserID and t4.fuserid<>0
left join t_supplier t8 on t8.fitemid=t1.F_117 --t3.fsource
inner join icbom t9 on t9.fitemid=t1.fitemid
--inner join t_item t5 on t5.
where left(t1.fnumber,1) in (select fitemtype from v_myitemtype where ftype=0)
--and t1.fnumber='A.01.01.001.A00005'
order by t1.fnumber

select t2.fnumber,t2.fname,t2.fmodel,t4.fnumber,t4.fname,t4.fmodel,t4.FNetWeight,t3.fqty,t4.FNetWeight*t3.fqty fweight
	from t_icitem t2
	inner join icbom t1 on t1.fitemid=t2.fitemid
	inner join dbo.icbomchild t3 on t1.finterid=t3.finterid
	inner join dbo.t_icitem t4 on t3.fitemid=t4.fitemid
	inner join t_measureunit t5 on t5.fitemid=t4.funitid
	where left(t2.fnumber,1) in ('A','P','J','X','Y','V')
	--and t4.FNetWeight<>0 
	--and t2.fnumber='A.01.01.002.A00008'
order by t2.fnumber,t4.fnumber

select * from sysdatabases
---------------------------------------------------------------------------------------------------------

--drop table #data

select t2.fnumber,t2.fname,t2.fmodel,
t4.fnumber fchildnumber,t4.fname fchildname,t4.fmodel fchildmodel,
substring(t4.fmodel,1,dbo.My_F_Charindex(t4.fmodel,'cm',1)-1) fsize,t3.fqty
into #data
from t_icitem t2
inner join icbom t1 on t1.fitemid=t2.fitemid
inner join dbo.icbomchild t3 on t1.finterid=t3.finterid
inner join dbo.t_icitem t4 on t3.fitemid=t4.fitemid
inner join t_measureunit t5 on t5.fitemid=t4.funitid
where left(t2.fnumber,1) in ('A','P','R','Q','J','X','Y','V')
and t4.fnumber like '2.01.%' and t4.fmodel like '%*%*%cm%'
order by t2.fnumber,t4.fnumber

--select * from #data order by fsize



select --t1.*,
t1.fnumber,cast(cast(cast(substring(t1.fsize,1,dbo.My_F_CharIndex(t1.fsize,'*',1)-1) as decimal(24,4))*10 as int) as varchar)+'*'+
cast(cast(cast(substring(t1.fsize,dbo.My_F_CharIndex(t1.fsize,'*',1)+1,(dbo.My_F_CharIndex(t1.fsize,'*',2)-dbo.My_F_CharIndex(t1.fsize,'*',1)-1)) as decimal(24,4))*10 as int) as varchar)+'*'+
cast(cast(cast(substring(t1.fsize,dbo.My_F_CharIndex(t1.fsize,'*',2)+1,len(t1.fsize)-(dbo.My_F_CharIndex(t1.fsize,'*',2)-1))  as decimal(24,4))*10 as int) as varchar) fsize ,
cast(cast(cast(substring(t1.fsize,1,dbo.My_F_CharIndex(t1.fsize,'*',1)-1) as decimal(24,4))*10 as int) as varchar) flength,
cast(cast(cast(substring(t1.fsize,dbo.My_F_CharIndex(t1.fsize,'*',1)+1,(dbo.My_F_CharIndex(t1.fsize,'*',2)-dbo.My_F_CharIndex(t1.fsize,'*',1)-1)) as decimal(24,4))*10 as int) as varchar) fwidth,
cast(cast(cast(substring(t1.fsize,dbo.My_F_CharIndex(t1.fsize,'*',2)+1,len(t1.fsize)-(dbo.My_F_CharIndex(t1.fsize,'*',2)-1))  as decimal(24,4))*10 as int) as varchar) fheight 
into #size
from #data t1
inner join t_icitem t4 on t1.fnumber=t4.fnumber

--select * from #size

--标准外箱尺寸(mm)	     F_109
select distinct t4.fnumber,t4.F_109,t1.fsize
--update t7 set F_109=t1.fsize
--update t2 set FLength=t1.FLength, FWidth=t1.FWidth, FHeight=t1.FHeight
from #size t1
inner join t_icitem t4 on t1.fnumber=t4.fnumber
inner join t_ICItemCustom AS t7 ON t4.FItemID = t7.FItemID
inner join t_ICItemDesign t2 on t2.fitemid=t4.fitemid

--drop table #data  drop table #size

---------------------------------------------------------------------------------------------------------

select t0.fparentid,identity(int,1,1) findex,t3.fitemid fchilditemid,t3.fqty
into #temp
from
(
	select t2.fparentid,min(t2.fitemid) fitemid
	from t_icitem t2
	inner join t_item t6 on t2.fparentid=t6.fitemid
	where left(t2.fnumber,4) in ('A.01','P.01','J.01','X.01','Y.01')
	group by t2.fparentid
) t0 inner join t_icitem t2 on t0.fitemid=t2.fitemid 
inner join icbom t1 on t1.fitemid=t2.fitemid
inner join icbomchild t3 on t1.finterid=t3.finterid
inner join t_icitem t4 on t3.fitemid=t4.fitemid
inner join t_measureunit t5 on t5.fitemid=t4.funitid
order by t2.fnumber,t4.fnumber

create table #data(fitemid int,fchilditemid int,fqty decimal(24,4),findex int)

declare @fparentid int,@fitemid int

DECLARE authors_cursor CURSOR FOR	
select t2.fparentid,t2.fitemid
from t_icitem t2
where left(t2.fnumber,4) in ('A.01','P.01','J.01','X.01','Y.01')
and t2.fitemid not in (select fitemid from icbom)

OPEN authors_cursor

FETCH NEXT FROM authors_cursor 
INTO @fparentid,@fitemid

WHILE @@FETCH_STATUS = 0
BEGIN
	insert into #data(fitemid ,fchilditemid ,fqty ,findex)
	select @fitemid fitemid ,fchilditemid ,fqty ,findex
	from #temp 
	where fparentid=@fparentid
	
    FETCH NEXT FROM authors_cursor 
    INTO @fparentid,@fitemid
END

CLOSE authors_cursor
DEALLOCATE authors_cursor

go

-- drop table #data

---------------------------------------------------------------------------------------------------------

select t2.fnumber,t2.fname,t2.fmodel,--t1.findex,
t4.fnumber fchildnumber,t4.fname fchildname,t4.fmodel fchildmodel,t1.fqty,t5.fname funitname
from #data t1
inner join t_icitem t2 on t1.fitemid=t2.fitemid
inner join t_icitem t4 on t1.fchilditemid=t4.fitemid
inner join t_measureunit t5 on t5.fitemid=t4.funitid
order by t2.fnumber,t4.fnumber



select t2.fnumber,t2.fname,t2.fmodel,
t4.fnumber fchildnumber,t4.fname fchildname,t4.fmodel fchildmodel,t3.fqty,t5.fname
from t_icitem t2
left join icbom t1 on t1.fitemid=t2.fitemid
left join dbo.icbomchild t3 on t1.finterid=t3.finterid
left join dbo.t_icitem t4 on t3.fitemid=t4.fitemid
left join t_measureunit t5 on t5.fitemid=t4.funitid
where left(t2.fnumber,4) in ('A.01','P.01','J.01','X.01','Y.01')
--and t4.fnumber like '2.01.%' and t4.fmodel like '%cm%'
order by t2.fnumber,t4.fnumber

select F_109,t1.fnumber,t1.fmodel,t1.fname,t1.FNetWeight,t1.FGrossWeight
from t_icitem t1
where t1.fnumber like 'a%'

select t1.fnumber,t1.fmodel,t1.fname,t1.FNetWeight,t1.FGrossWeight
from t_icitem t1
where t1.fnumber like '2.02%'

select fname,fsqlcolumnname,* from t_itempropdesc where fitemclassid=4
select fitemid,fname,* from t_stock

16475	成品仓



select * from t_itempropdesc where fitemclassid=4

select finterid,fname,* from t_submessage where ftypeid=10002 and fname='是'

40019	是
40020	否

select 是否为引擎产品,借用产品引擎,t3.*
--update t2 set F_126=40019
from t_icitem t1
inner join t_ICItemCustom t2 on t1.fitemid=t2.fitemid
inner join engintemp$ t3 on t1.fnumber=t3.代码
where t3.是否为引擎产品='Y'

select t3.*
--update t2 set F_127=t4.fitemid
from t_icitem t1
inner join t_ICItemCustom t2 on t1.fitemid=t2.fitemid
inner join engintemp$ t3 on t1.fnumber=t3.代码
inner join t_icitem t4 on t4.fnumber=t3.借用产品引擎
where t3.是否为引擎产品 is null

是否引擎 F_126	
产品引擎 F_127	

select t1.fnumber,t1.fname,t1.fmodel
from dbo.t_icitem t1
left join dbo.icbom t2 on t1.fitemid=t2.fitemid
inner join t_item t3 on t1.fitemid=t3.fitemid
where left(t1.fnumber,4) in ('a.01','p.01','j.01','x.01','y.01') --and t2.fitemid is null
and isnull(t1.F_126,0)<>40019 and isnull(t1.F_127,0)=0

select replace(物料,'老代码','老代码.'),* 
--update t1 set 物料=replace(物料,'老代码','老代码.')
from sheet31$ t1
where 物料 like '%老代码%'

select replace(物料,'老系统代码','老系统代码.'),* 
--update t1 set 物料=replace(物料,'老系统代码','老系统代码.')
from sheet31$ t1
where 物料 like '%老系统代码%'

select * from aaccch order by 物料

select * from sheet31$ where CHARINDEX('.',REVERSE(物料))-1))

select distinct fnumber,fname,fmodel
from
(
	select REVERSE(left(REVERSE(产品代码),CHARINDEX('.',REVERSE(产品代码))-1)) fnumber,产品名称 fname,规格型号 fmodel
	from sheet38$
	union all
	select REVERSE(left(REVERSE(子件编码),CHARINDEX('.',REVERSE(子件编码))-1)) fnumber,子件名称 fname,子件规格型号 fmodel
	from sheet38$ where 子件编码 like '%700128'
) t1 where fnumber not in (select fshortnumber from t_icitem)
order by fnumber

700128
select * 
--update t1 set 子件编码='2.06.A001.06.203394'
from sheet38$  t1
where 子件编码 like '%700128'

--drop table sheet28$  --select * from sheet28$

select * 
--update t1 set 物料代码='.'+物料代码
from sheet53$  t1
where CHARINDEX('.',物料代码)=0

select distinct fnumber,fname,fmodel
from
(
	select REVERSE(left(REVERSE(产品代码),CHARINDEX('.',REVERSE(产品代码))-1)) fnumber,产品名称 fname,产品规格型号 fmodel
	from sheet53$
	union all
	select REVERSE(left(REVERSE(物料代码),CHARINDEX('.',REVERSE(物料代码))-1)) fnumber,物料名称 fname,物料规格型号 fmodel
	from sheet53$
) t1 where fnumber not in (select fshortnumber from t_icitem)
order by fnumber

--delete from sheet21$ where 索引=52

select * from t_itempropdesc where fitemclassid=4

select isnull(t2.f_105,'') 描述,t1.* 
--update t7 set f_105=t1.fdescription
from (	select distinct REVERSE(left(REVERSE(成品代码),CHARINDEX('.',REVERSE(成品代码))-1)) fnumber,产品名称 fname,规格型号 fmodel,产品描述 fdescription
	from sheet3$ where 产品描述 is not null) t1
inner join t_icitem t2 on t1.fnumber=t2.fshortnumber
inner join t_ICItemCustom t7 ON t2.FItemID = t7.FItemID

select isnull(t2.f_105,'') 描述,t1.* 
--update t7 set f_105=t1.fdescription
from (	select distinct REVERSE(left(REVERSE(新代码),CHARINDEX('.',REVERSE(新代码))-1)) fnumber,产品名称 fname,规格型号 fmodel,产品描述 fdescription
	from sheet31$ where 产品描述 is not null) t1
inner join t_icitem t2 on t1.fnumber=t2.fshortnumber
inner join t_ICItemCustom t7 ON t2.FItemID = t7.FItemID

go

select t1.* --,t4.finterid,t4.fentryid
--delete t4
--delete t3
from sheet29$ t1
inner join t_icitem t2 on t1.产品代码=t2.fnumber
inner join icbom t3 on t2.fitemid=t3.fitemid
inner join icbomchild t4 on t3.finterid=t4.finterid
where t1.父项代码 like '%vc00946%'

select * from sysdatabases

select t2.fshortnumber fsourcenumber,t2.fname fsourcename,t2.fmodel fsourcemodel,
t4.fshortnumber fsourcechildnumber,t4.fname fsourcechildname,t4.fmodel fsourcechildmodel,t3.fqty fsourceqty
into #data
from AIS20120820103535.dbo.icbom t1
inner join AIS20120820103535.dbo.t_icitem t2 on t1.fitemid=t2.fitemid
inner join AIS20120820103535.dbo.icbomchild t3 on t1.finterid=t3.finterid
inner join AIS20120820103535.dbo.t_icitem t4 on t3.fitemid=t4.fitemid
where left(t2.fnumber,1) in ('3','4')

select t2.fshortnumber fnumber,t2.fname,t2.fmodel,
t4.fshortnumber fchildnumber,t4.fname fchildname,t4.fmodel fchildmodel,t3.fqty
into #temp
from dbo.icbom t1
inner join dbo.t_icitem t2 on t1.fitemid=t2.fitemid
inner join dbo.icbomchild t3 on t1.finterid=t3.finterid
inner join dbo.t_icitem t4 on t3.fitemid=t4.fitemid
where left(t2.fnumber,1) in ('3','4','7','8')

--drop table #data drop table #temp

select t1.*,t2.*
from #data t1
full join #temp t2 on t1.fsourcenumber=t2.fnumber and t1.fsourcechildnumber=t2.fchildnumber and t1.fsourceqty=t2.fqty
where t1.fsourcenumber is null or t1.fsourcechildnumber is null or t1.fsourceqty is null
or t2.fnumber is null or t2.fchildnumber is null or t2.fqty is null
order by t1.fsourcenumber,t2.fnumber



sheet3$ OK
sheet11$  OK
sheet31$  OK
sheet33$  OK
sheet37$ ok
sheet29$ ok
sheet22$ 物料替换表
  
V.B.B1220.01.VB00697
V.B.B1375.01.VB01327
V.B.B2402.01.VB01751

select t4.f_106,t3.f_106
--update t5 set f_106=t3.f_106
from
(
	select distinct 单据编号,产品代码
	from
	(
		select 单据编号,产品代码 from dbo.sheet21$ 
		union all
		select 单据编号,成品代码 from dbo.sheet3$
		union all
		select 单据编号,新代码 from dbo.sheet31$
		union all
		select 单据编号,产品代码 from dbo.sheet33$
		union all
		select 单据编号,产品代码 from dbo.sheet37$
	) t1 where 单据编号 is not null and 产品代码 is not null
) t1 inner join AIS20120820103535.dbo.t_bospacksub t2 on t1.单据编号=t2.fbillno
inner join AIS20120820103535.dbo.t_icitem t3 on t2.fproductid=t3.fitemid
inner join t_icitem t4 on t4.fnumber=t1.产品代码
inner join t_ICItemCustom t5 on t4.fitemid=t5.fitemid

select * from dbo.sheet38$ where 子件编码 is null --youwu
select * from dbo.sheet37$ where 物料 is null  --ok
select * from dbo.sheet33$ where 子件代码 is null order by 产品代码
select * from dbo.sheet31$ where 物料 is null and len(新代码)>=len('V.D.DA044.VD00017')
select * from dbo.sheet11$ where 子件代码 is null  --OK
select * from dbo.sheet3$ where 物料 is null  --youwu

select t1.FCheckID,t2.fshortnumber fnumber,t2.fname,t2.fmodel,t4.fshortnumber fchildnumber,t4.fname,t4.fmodel,
t3.fqty,cast(t11.数量 as decimal(24,4))
--update t3 set fauxqty=cast(t11.数量 as decimal(24,4)),fqty=cast(t11.数量 as decimal(24,4))
from dbo.icbom t1
inner join dbo.t_icitem t2 on t1.fitemid=t2.fitemid
inner join dbo.icbomchild t3 on t1.finterid=t3.finterid
inner join dbo.t_icitem t4 on t3.fitemid=t4.fitemid
inner join dbo.sheet18$ t11 on REVERSE(left(REVERSE(t11.新代码),CHARINDEX('.',REVERSE(t11.新代码))-1))=t2.fshortnumber 
                       and REVERSE(left(REVERSE(t11.子件代码),CHARINDEX('.',REVERSE(t11.子件代码))-1))=t4.fshortnumber 
                       and t3.fqty<>cast(t11.数量 as decimal(24,4))

select fitemid,finterid from icbomchild group by fitemid,finterid having count(1) >1

---------------------------------------------------------------------------------------------------------

--同一BOM有相同的物料
delete from icbom where finterid in 
(
	--select t2.fnumber,t2.fname,t2.fmodel,max(t1.finterid) finterid
	select max(t1.finterid) finterid
	from dbo.icbom t1
	inner join dbo.t_icitem t2 on t1.fitemid=t2.fitemid
	group by t2.fnumber,t2.fname,t2.fmodel
	having count(1)>1
)

delete from icbom where finterid not in (select finterid from icbomchild)

delete from icbomchild where finterid not in (select finterid from icbom)

---------------------------------------------------------------------------------------------------------
--同一BOM有相同的物料
select t2.fnumber,t2.fname,t2.fmodel,t4.fnumber,t4.fname,t4.fmodel
from dbo.icbom t1
inner join dbo.t_icitem t2 on t1.fitemid=t2.fitemid
inner join (select fitemid,finterid from icbomchild group by fitemid,finterid having count(1) >1) t3 on t1.finterid=t3.finterid
inner join dbo.t_icitem t4 on t3.fitemid=t4.fitemid
order by t2.fnumber
---------------------------------------------------------------------------------------------------------

select t1.FCheckID,t2.fshortnumber fnumber,t2.fname,t2.fmodel,t4.fshortnumber fchildnumber,t4.fname,t4.fmodel,
t3.fqty,cast(t11.数量 as decimal(24,4))
--update t3 set fauxqty=cast(t11.数量 as decimal(24,4)),fqty=cast(t11.数量 as decimal(24,4))
from dbo.icbom t1
inner join dbo.t_icitem t2 on t1.fitemid=t2.fitemid
inner join dbo.icbomchild t3 on t1.finterid=t3.finterid
inner join dbo.t_icitem t4 on t3.fitemid=t4.fitemid
inner join dbo.sheet28$ t11 on REVERSE(left(REVERSE(t11.产品代码),CHARINDEX('.',REVERSE(t11.产品代码))-1))=t2.fshortnumber 
                       and REVERSE(left(REVERSE(t11.子件代码),CHARINDEX('.',REVERSE(t11.子件代码))-1))=t4.fshortnumber 
                       and t3.fqty<>cast(t11.数量 as decimal(24,4))
where t2.fshortnumber='400173'


select t1.FCheckID,t2.fshortnumber fnumber,t2.fname,t2.fmodel,t4.fshortnumber fchildnumber,t4.fname,t4.fmodel,t3.fqty
--update t3 set fauxqty=0.045,fqty=0.045
from dbo.icbom t1
inner join dbo.t_icitem t2 on t1.fitemid=t2.fitemid
inner join dbo.icbomchild t3 on t1.finterid=t3.finterid
inner join dbo.t_icitem t4 on t3.fitemid=t4.fitemid
where t3.fqty=0 and t2.fshortnumber='300379'

select t4.fdefaultloc,t14.FInterID fbomgroupid,t4.funitid,t4.fitemid,t3.fitemid fproductid,cast(t1.数量 as decimal(24,5)) fqty
--select t3.fnumber,t1.*
from sheet37$ t1
left join t_icitem t3 on REVERSE(left(REVERSE(t1.产品代码),CHARINDEX('.',REVERSE(t1.产品代码))-1))=t3.fshortnumber --父件
inner join t_icitem t4 on REVERSE(left(REVERSE(t1.物料),CHARINDEX('.',REVERSE(t1.物料))-1))=t4.fshortnumber --子件
inner join t_item t13 on t3.FParentID=t13.fitemid
inner join ICBomGroup t14 on t14.fnumber=t13.fnumber
where --t3.fshortnumber='300379' --and
not exists(select 1 from icbom where fitemid=t3.fitemid)
and t3.fdeleted=0 and t4.fdeleted=0
order by t3.fnumber,t4.fnumber

---------------------------------------------------------------------------------------------------------
--select * from sheet21$ t1 where 产品代码 like '%X00001%'  --select * from t_icitem where fitemid=98020

select t4.fdefaultloc,t14.FInterID fbomgroupid,t4.funitid,t4.fitemid,t3.fitemid fproductid,cast(t1.用量 as decimal(24,5)) fqty
--select t4.fitemid,t1.子件编码,t4.fshortnumber,REVERSE(left(REVERSE(t1.子件编码),CHARINDEX('.',REVERSE(t1.子件编码))-1))
--into #data
from sheet38$ t1
inner join t_icitem t3 on REVERSE(left(REVERSE(t1.产品代码),CHARINDEX('.',REVERSE(t1.产品代码))-1))=t3.fshortnumber --父件
inner join t_icitem t4 on REVERSE(left(REVERSE(t1.子件编码),CHARINDEX('.',REVERSE(t1.子件编码))-1))=t4.fshortnumber --子件
inner join t_item t13 on t3.FParentID=t13.fitemid
inner join ICBomGroup t14 on t14.fnumber=t13.fnumber
where t3.fshortnumber='P00002' --and

order by t3.fnumber,t4.fnumber

select * from t_icitem where fitemid=78598
select * from t_item where fitemid=78598
select * from sheet28$
select * from t_item where fshortnumber='BXK00931'
select * from t_icitem where fitemid=98020

---------------------------------------------------------------------------------------------------------

select * from sheet51$ where 用量 is null --drop table sheet51$

select t4.fdefaultloc,t14.FInterID fbomgroupid,t4.funitid,t4.fitemid,t3.fitemid fproductid,cast(t1.用量 as decimal(24,5)) fqty
--select t4.fitemid,t1.物料代码,t4.fshortnumber,REVERSE(left(REVERSE(t1.物料代码),CHARINDEX('.',REVERSE(t1.物料代码))-1)),用量
into #data123
from sheet53$ t1
inner join t_icitem t3 on REVERSE(left(REVERSE(t1.产品代码),CHARINDEX('.',REVERSE(t1.产品代码))-1))=t3.fshortnumber --父件
inner join t_icitem t4 on REVERSE(left(REVERSE(t1.物料代码),CHARINDEX('.',REVERSE(t1.物料代码))-1))=t4.fshortnumber --子件
inner join t_item t13 on t3.FParentID=t13.fitemid
inner join ICBomGroup t14 on t14.fnumber=t13.fnumber
where --t3.fshortnumber='X00001' --and
not exists(select 1 from icbom where fitemid=t3.fitemid)
and t3.fdeleted=0 and t4.fdeleted=0
order by t3.fnumber,t4.fnumber


select t5.fdefaultloc,t14.FInterID fbomgroupid,t5.funitid,t5.fitemid,t4.fitemid fproductid,t3.fqty
into #data123
from
(
	select *
	from
	(
		select * from #data456 t1 where 项目经理='唐勇' 
-- 		union all
-- 		select * from #data456 t1 where 项目经理='汤传义' 
	) t1 where 引用BOM编号<>''
) t1 inner join icbom t2 on t1.引用BOM编号=t2.fbomnumber
inner join icbomchild t3 on t2.finterid=t3.finterid
inner join t_icitem t4 on t4.fnumber=t1.长代码
inner join t_icitem t5 on t5.fitemid=t3.fitemid
inner join t_item t13 on t4.FParentID=t13.fitemid
inner join ICBomGroup t14 on t14.fnumber=t13.fnumber
where not exists(select 1 from icbom where fitemid=t4.fitemid)
--and t4.fdeleted=0 and t4.fdeleted=0
order by t4.fitemid,t3.fentryid

--select f_125 from t_icitem t3 where left(t3.fnumber,4) in ('a.02','a.03','a.04','p.02','p.03','p.04','j.02','j.03','j.04','x.02','x.03','x.04','y.02','y.03','y.04') AND ISNULL(F_125,'')<>''

select t4.fdefaultloc,t14.FInterID fbomgroupid,t4.funitid,t4.fitemid,t3.fitemid fproductid,cast(t6.fqty as decimal(24,5)) fqty
--select t4.fitemid,t1.物料代码,t4.fshortnumber,REVERSE(left(REVERSE(t1.物料代码),CHARINDEX('.',REVERSE(t1.物料代码))-1)),用量
into #data123
--select t1.*
from t_icitem t1
inner join t_icitem t3 on t3.f_125=t1.fnumber --父件
inner join icbom t5 on t5.fitemid=t1.fitemid
inner join icbomchild t6 on t6.finterid=t5.finterid
inner join t_icitem t4 on t4.fitemid=t6.fitemid
inner join t_item t13 on t3.FParentID=t13.fitemid
inner join ICBomGroup t14 on t14.fnumber=t13.fnumber
where --t3.fshortnumber='X00001' --and
not exists(select 1 from icbom where fitemid=t3.fitemid)
and left(t3.fnumber,4) in ('a.02','a.03','a.04','p.02','p.03','p.04','j.02','j.03','j.04','x.02','x.03','x.04','y.02','y.03','y.04')
and left(t1.fnumber,4) in ('a.01','p.01','j.01','x.01','y.01')
order by t3.fnumber,t4.fnumber

-- select t4.fdefaultloc,t14.FInterID fbomgroupid,t4.funitid,t4.fitemid,t3.fitemid fproductid,cast(t7.fqty as decimal(24,5)) fqty
-- --select t4.fitemid,t1.物料代码,t4.fshortnumber,REVERSE(left(REVERSE(t1.物料代码),CHARINDEX('.',REVERSE(t1.物料代码))-1)),用量
-- into #data123
-- from sheet125$ t1
-- inner join t_icitem t23 on t23.fshortnumber=cast(cast(t1.原代码 as int) as varchar(50))
-- inner join t_icitem t3 on t3.fshortnumber=cast(cast(t1.新代码 as int) as varchar(50))
-- inner join icbom t6 on t6.fitemid=t23.fitemid
-- inner join icbomchild t7 on t7.finterid=t6.finterid
-- inner join t_icitem t4 on t4.fitemid=t7.fitemid
-- inner join t_item t13 on t3.FParentID=t13.fitemid
-- inner join ICBomGroup t14 on t14.fnumber=t13.fnumber
-- where --t3.fshortnumber='X00001' --and
-- not exists(select 1 from icbom where fitemid=t3.fitemid)
-- and t3.fdeleted=0 and t4.fdeleted=0
-- order by t3.fnumber,t4.fnumber

--select t4.fdefaultloc,t14.FInterID fbomgroupid,t4.funitid,t4.fitemid,t3.fitemid fproductid,cast(t15.fqty as decimal(24,5)) fqty
----select distinct t11.fnumber
--into #data123
--from AIS20120820103535.dbo.t_icitem t11
--inner join AIS20120820103535.dbo.icbom t12 on t11.fitemid=t12.fitemid
--inner join AIS20120820103535.dbo.icbomchild t15 on t15.finterid=t12.finterid
--inner join AIS20120820103535.dbo.t_icitem t16 on t16.fitemid=t15.fitemid
--inner join t_icitem t3 on t11.fnumber=t3.fnumber --父件
--inner join t_icitem t4 on t16.fshortnumber=t4.fshortnumber --子件
--inner join t_item t13 on t3.FParentID=t13.fitemid
--inner join ICBomGroup t14 on t14.fnumber=t13.fnumber
--where left(t3.fnumber,1) in ('Q','R','1') and
--not exists(select 1 from icbom where fitemid=t3.fitemid)
--and t3.fdeleted=0 and t4.fdeleted=0
--order by t3.fnumber,t4.fnumber

--drop table #data123 drop table #mybom drop table #mybomchild

declare @fmaxnum int,@fdate datetime,@fmaxbill int,@fmaxbillno varchar

select @fmaxnum=fmaxnum from icmaxnum where ftablename='icbom'

select @fdate=replace(convert(varchar(10),getdate(),111),'/','-')
select @fmaxbill=cast(max(right(FBomNumber,6)) as int) from icbom where FBomNumber like 'BOM%'

create table #mybom(fid int identity(1,1),fproductid int,fbomgroupid int)

insert into #mybom(fproductid,fbomgroupid)
select distinct    fproductid,fbomgroupid 
from #data123 t1 

--select fproductid,fbrandid from #mybom group by fproductid,fbrandid having count(1)>1
--select * from #mybom 

INSERT INTO ICBom(FInterID,        FBomNumber,                                                             FItemID,      FOperatorID,FEnterTime,FBrNo,FTranType,FCancellation,FStatus,FVersion,FUseStatus,FUnitID,   FAuxPropID,FAuxQty,fqty,FYield,FNote,FCheckID,FCheckDate,FRoutingID,FBomType,FCustID,FParentID,     FAudDate,FImpMode,FPDMImportDate,FBOMSkip) 
select            @fmaxnum+t1.fid,'BOM'+left('000000',6-len(@fmaxbill))+cast(@fmaxbill+t1.fid as varchar), t1.fproductid,16394,      @fdate,    '0',  50,       0,            0,      '',      1073,      t2.FUnitID,0,         1,      1,   100,   '',   0,       null,      0,         0,       0,      t1.fbomgroupid,null,    0,       null,          1059
from #mybom t1
inner join t_icitem t2 on t1.fproductid=t2.fitemid
order by t1.fid

--delete from t_bospacksub  delete from t_bospacksubentry

create table #mybomchild(fid int,fentryid int identity(1,1),fitemid int,funitid int,fqty decimal(28,4),fdefaultloc int)

insert into #mybomchild(fid,  fitemid,  funitid,  fqty,  fdefaultloc)
select                  a.fid,b.fitemid,b.funitid,b.fqty,b.fdefaultloc
from #mybom a 
inner join #data123 b on a.fproductid=b.fproductid 

--select * from #mybomchild order by fid

INSERT INTO ICBomChild (FInterID,      FEntryID,FBrNo,FItemID,      FMachinePos,FNote,FAuxQty, FScrap,FOffSetDay,FUnitID,  FQty,  FMaterielType,FMarshalType,FBeginDay,   FEndDay,     FPercent,FPositionNo,FItemSize,FItemSuite,FOperSN,FOperID,FBackFlush,FStockID,     FSPID,FAuxPropID,FPDMImportDate,FDetailID) 
select                  @fmaxnum+a.fid,
								       (select count(fentryid) from #mybomchild where fid=a.fid and fentryid<=a.fentryid),
												'0',  a.fitemid,    '',         '',   a.fqty,  0,     0,         a.FUnitID,a.fqty,371,          385,         '1900-01-01','2100-01-01',100,     '',         '',       '',        '',     0,      1059,      a.fdefaultloc,0,    0,         null,          NEWID() 
from #mybomchild a 
order by a.fid,a.fentryid

update icmaxnum set fmaxnum=(select max(finterid) from icbom) where ftablename='icbom'

drop table #data123 drop table #mybom drop table #mybomchild

--select * from #data123 --select * from #mybom --select * from #mybomchild
--select t2.fnumber,t1.* from icbom t1 inner join t_icitem t2 on t1.fitemid=t2.fitemid where FOperatorID=16394 and FEnterTime='2015-01-20'
--select * from icbomchild where finterid in (select finterid from icbom where FOperatorID=16394 and FEnterTime='2015-01-20')
--drop table #data

go


---------------------------------------------------------------------------------------------------------


----------------------------------------------------------------------------------------------
select t4.fname,sum(t2.famount) famount
from poorder t1
inner join poorderentry t2 on t1.finterid=t2.finterid
inner join t_icitem t3 on t2.fitemid=t3.fitemid
inner join t_supplier t4 on t4.fitemid=t1.fsupplyid
where t2.famount>0
group by t4.fname

select t4.fname
from poorder t1
inner join poorderentry t2 on t1.finterid=t2.finterid
inner join t_icitem t3 on t2.fitemid=t3.fitemid
inner join t_supplier t4 on t4.fitemid=t1.fsupplyid
where t2.famount>0 and t1.fdate>='2015-01-01'
group by t4.fname


----------------------------------------------------------------------------------------------
select t1.fname,count(1) fcount
from
(
	select t1.fsupplyid,t2.ffullname fname
	from
	(
		select distinct t1.fsupplyid,left(t3.fnumber,dbo.My_F_Charindex(t3.fnumber,'.',3)-1) fnumber
		from poorder t1
		inner join poorderentry t2 on t1.finterid=t2.finterid
		inner join t_icitem t3 on t2.fitemid=t3.fitemid
		where t3.fnumber like '1.01.%' --t3.fnumber not like '6%' and 
	) t1 inner join t_item t2 on t1.fnumber=t2.fnumber and t2.fdetail=0 and t2.fitemclassid=4
) t1 group by t1.fname
union all
select t1.fname,count(1) fcount
from
(
	select t1.fsupplyid,t2.ffullname fname
	from
	(
		select distinct t1.fsupplyid,left(t3.fnumber,dbo.My_F_Charindex(t3.fnumber,'.',2)-1) fnumber
		from poorder t1
		inner join poorderentry t2 on t1.finterid=t2.finterid
		inner join t_icitem t3 on t2.fitemid=t3.fitemid
		where t3.fnumber like '1.02.%' --t3.fnumber not like '6%' and 
	) t1 inner join t_item t2 on t1.fnumber=t2.fnumber and t2.fdetail=0 and t2.fitemclassid=4
) t1 group by t1.fname
union all
select t1.fname,count(1) fcount
from
(
	select t1.fsupplyid,t2.ffullname fname
	from
	(
		select distinct t1.fsupplyid,left(t3.fnumber,dbo.My_F_Charindex(t3.fnumber,'.',3)-1) fnumber
		from poorder t1
		inner join poorderentry t2 on t1.finterid=t2.finterid
		inner join t_icitem t3 on t2.fitemid=t3.fitemid
		where t3.fnumber like '1.03.%' --t3.fnumber not like '6%' and 
	) t1 inner join t_item t2 on t1.fnumber=t2.fnumber and t2.fdetail=0 and t2.fitemclassid=4
) t1 group by t1.fname
union all
select t1.fname,count(1) fcount
from
(
	select t1.fsupplyid,t2.ffullname fname
	from
	(
		select distinct t1.fsupplyid,left(t3.fnumber,dbo.My_F_Charindex(t3.fnumber,'.',3)-1) fnumber
		from poorder t1
		inner join poorderentry t2 on t1.finterid=t2.finterid
		inner join t_icitem t3 on t2.fitemid=t3.fitemid
		where t3.fnumber like '1.04.%' --t3.fnumber not like '6%' and 
	) t1 inner join t_item t2 on t1.fnumber=t2.fnumber and t2.fdetail=0 and t2.fitemclassid=4
) t1 group by t1.fname
union all
select t1.fname,count(1) fcount
from
(
	select t1.fsupplyid,t2.ffullname fname
	from
	(
		select distinct t1.fsupplyid,left(t3.fnumber,dbo.My_F_Charindex(t3.fnumber,'.',2)-1) fnumber
		from poorder t1
		inner join poorderentry t2 on t1.finterid=t2.finterid
		inner join t_icitem t3 on t2.fitemid=t3.fitemid
		where t3.fnumber like '2.%' --t3.fnumber not like '6%' and 
	) t1 inner join t_item t2 on t1.fnumber=t2.fnumber and t2.fdetail=0 and t2.fitemclassid=4
) t1 group by t1.fname
union all
select t1.fname,count(1) fcount
from
(
	select t1.fsupplyid,t2.ffullname fname
	from
	(
		select distinct t1.fsupplyid,left(t3.fnumber,dbo.My_F_Charindex(t3.fnumber,'.',1)-1) fnumber
		from poorder t1
		inner join poorderentry t2 on t1.finterid=t2.finterid
		inner join t_icitem t3 on t2.fitemid=t3.fitemid
		where t3.fnumber like '7.%' or t3.fnumber like '8.%'
	) t1 inner join t_item t2 on t1.fnumber=t2.fnumber and t2.fdetail=0 and t2.fitemclassid=4
) t1 group by t1.fname
order by fname,fcount



----------------------------------------------------------------------------------------------
select t1.fname,t1.fsupname,sum(famount) famount
from
(
	select t1.fsupname,t2.ffullname fname,t1.famount
	from
	(
		select t4.fname fsupname,left(t3.fnumber,dbo.My_F_Charindex(t3.fnumber,'.',3)-1) fnumber,t2.famount
		from poorder t1
		inner join poorderentry t2 on t1.finterid=t2.finterid
		inner join t_icitem t3 on t2.fitemid=t3.fitemid
		inner join t_supplier t4 on t4.fitemid=t1.fsupplyid
		where t3.fnumber like '1.01.%' and t2.famount>0
	) t1 inner join t_item t2 on t1.fnumber=t2.fnumber and t2.fdetail=0 and t2.fitemclassid=4
) t1 group by t1.fname,t1.fsupname
union all
select t1.fname,t1.fsupname,sum(famount) famount
from
(
	select t1.fsupname,t2.ffullname fname,t1.famount
	from
	(
		select t4.fname fsupname,left(t3.fnumber,dbo.My_F_Charindex(t3.fnumber,'.',2)-1) fnumber,t2.famount
		from poorder t1
		inner join poorderentry t2 on t1.finterid=t2.finterid
		inner join t_icitem t3 on t2.fitemid=t3.fitemid
		inner join t_supplier t4 on t4.fitemid=t1.fsupplyid
		where t3.fnumber like '1.02.%' and t2.famount>0
	) t1 inner join t_item t2 on t1.fnumber=t2.fnumber and t2.fdetail=0 and t2.fitemclassid=4
) t1 group by t1.fname,t1.fsupname
union all
select t1.fname,t1.fsupname,sum(famount) famount
from
(
	select t1.fsupname,t2.ffullname fname,t1.famount
	from
	(
		select t4.fname fsupname,left(t3.fnumber,dbo.My_F_Charindex(t3.fnumber,'.',3)-1) fnumber,t2.famount
		from poorder t1
		inner join poorderentry t2 on t1.finterid=t2.finterid
		inner join t_icitem t3 on t2.fitemid=t3.fitemid
		inner join t_supplier t4 on t4.fitemid=t1.fsupplyid
		where t3.fnumber like '1.03.%' and t2.famount>0
	) t1 inner join t_item t2 on t1.fnumber=t2.fnumber and t2.fdetail=0 and t2.fitemclassid=4
) t1 group by t1.fname,t1.fsupname
union all
select t1.fname,t1.fsupname,sum(famount) famount
from
(
	select t1.fsupname,t2.ffullname fname,t1.famount
	from
	(
		select t4.fname fsupname,left(t3.fnumber,dbo.My_F_Charindex(t3.fnumber,'.',3)-1) fnumber,t2.famount
		from poorder t1
		inner join poorderentry t2 on t1.finterid=t2.finterid
		inner join t_icitem t3 on t2.fitemid=t3.fitemid
		inner join t_supplier t4 on t4.fitemid=t1.fsupplyid
		where t3.fnumber like '1.04.%' and t2.famount>0
	) t1 inner join t_item t2 on t1.fnumber=t2.fnumber and t2.fdetail=0 and t2.fitemclassid=4
) t1 group by t1.fname,t1.fsupname
union all
select t1.fname,t1.fsupname,sum(famount) famount
from
(
	select t1.fsupname,t2.ffullname fname,t1.famount
	from
	(
		select t4.fname fsupname,left(t3.fnumber,dbo.My_F_Charindex(t3.fnumber,'.',2)-1) fnumber,t2.famount
		from poorder t1
		inner join poorderentry t2 on t1.finterid=t2.finterid
		inner join t_icitem t3 on t2.fitemid=t3.fitemid
		inner join t_supplier t4 on t4.fitemid=t1.fsupplyid
		where t3.fnumber like '2.%' and t2.famount>0
	) t1 inner join t_item t2 on t1.fnumber=t2.fnumber and t2.fdetail=0 and t2.fitemclassid=4
) t1 group by t1.fname,t1.fsupname
union all
select t1.fname,t1.fsupname,sum(famount) famount
from
(
	select t1.fsupname,t2.ffullname fname,t1.famount
	from
	(
		select t4.fname fsupname,left(t3.fnumber,dbo.My_F_Charindex(t3.fnumber,'.',1)-1) fnumber,t2.famount
		from poorder t1
		inner join poorderentry t2 on t1.finterid=t2.finterid
		inner join t_icitem t3 on t2.fitemid=t3.fitemid
		inner join t_supplier t4 on t4.fitemid=t1.fsupplyid
		where t3.fnumber like '7.%' or t3.fnumber like '8.%' and t2.famount>0
	) t1 inner join t_item t2 on t1.fnumber=t2.fnumber and t2.fdetail=0 and t2.fitemclassid=4
) t1 group by t1.fname,t1.fsupname
order by t1.fname,t1.famount


------------------------------------------------------------------------------------------------------

declare @fminid int,@fmaxid int,@fentryminid int,@fentrymaxid int,@fpreitemid int

create table #Cursor(FID int identity(1,1),finterid int,fentryid int,fitemid int,FQty decimal(24,2))
create table #CursorEntry(FID int identity(1,1),finterid int,fentryid int,fitemid int,FQty decimal(24,2),frepitemid int)

select @fpreitemid=0,@fcanuseqty=0

truncate table #Cursor
insert into #Cursor(fitemid,fparentid)
select t1.fitemid,t1.fparentid
from t_icitem t1
inner join t_item t13 on t13.fitemid=t1.fparentid 
inner join t_SubMessage t14 on t14.finterid=t1.F_102  --打印机品牌
where t14.finterid not in () and t1.fname like '%标配%'

select @fminid=0,@fmaxid=0
select @fminid=isnull(min(fid),0),@fmaxid=isnull(max(fid),0) from #Cursor

WHILE @fmaxid>0 and @fminid<=@fmaxid --@@FETCH_STATUS = 0  --先把可用库存按物料先分配下去
BEGIN 
	select @fparentid=fparentid,@fitemid=fitemid from #Cursor where fid=@fminid
	select @fparentnumber=fnumber+'%' from t_item where fitemid=@fparentid
	
	if exists(select 1 from t_icitem where fnumber like @fparentnumber and fname like '%高配%')
	begin
	    select @fgaopeiitemid=fitemid from t_icitem where fnumber like @fparentnumber and fname like '%高配%'
		if exists(select 1 from icbom where fitemid=@fgaopeiitemid)
		begin
		
		end
		else
		begin
			insert into icbom
			select from icbom where fitemid=
		end
	end
	else --如果该组别的高配编码不存在,则将标配的编码复制成高配编码，并将名称和描述改掉
	begin
		INSERT INTO t_Item (ffullnumber,FItemClassID,FParentID, FLevel, FName,  FNumber, FShortNumber,  FDetail,UUID,     FDeleted) 
		VALUES 			   (@fnumber,   4,           @FParentID,@FLevel,@fname, @fnumber,@FShortNumber, 1,      newid() , 0)

		select @fitemid=FItemID,@ffullname=ffullname from t_Item where fdetail=1 and fitemclassid=4 and fnumber=@fnumber


		INSERT INTO t_ICItem (F_123,           F_126,             F_125,            FHelpCode,FModel,   FAuxClassID,FErpClsID,FTypeID,FUnitGroupID,FUnitID,FOrderUnitID,FSaleUnitID,FProductUnitID,FStoreUnitID,FSecUnitID,FSecCoefficient,  FDefaultLoc,FSPID,FSource,      FQtyDecimal,FLowLimit,FHighLimit,FSecInv,FUseState,FIsEquipment,FEquipmentNum,FIsSparePart,FFullName,  FApproveNo,FAlias,FOrderRector,FPOHighPrice,FPOHghPrcMnyType,FWWHghPrc,FWWHghPrcMnyType,FSOLowPrc,FSOLowPrcMnyType,FIsSale,FProfitRate,FOrderPrice,FSalePrice,FIsSpecialTax,FISKFPeriod,FKFPeriod,FStockTime,FBatchManager,FBookPlan,FBeforeExpire,FCheckCycUnit,FOIHighLimit,FOILowLimit,FSOHighLimit,FSOLowLimit,FInHighLimit,FInLowLimit,FTrack,FPlanPrice,FPriceDecimal,FAcctID,FSaleAcctID,FCostAcctID,FAPAcctID,FAdminAcctID,FGoodSpec,FTaxRate,FCostProject,FIsSNManage,FNote,F_102,         F_104,F_103,         F_105, F_109,        F_122,        F_110,          F_119,             F_118,      F_121,        F_117,        F_116,          F_115,       FPlanTrategy,FOrderTrategy,FFixLeadTime,FLeadTime,FTotalTQQ,FOrderInterVal,FQtyMin,FQtyMax,FBatchAppendQty,FOrderPoint,FBatFixEconomy,FBatChangeEconomy,FRequirePoint,FPlanPoint,FDefaultRoutingID,FDefaultWorkTypeID,FProductPrincipal,FPlanner,FPutInteger,FDailyConsume,FMRPCon,FMRPOrder,FChartNumber,FIsKeyItem,FGrossWeight,FNetWeight, FMaund,FLength, FWidth, FHeight,  FSize,FCubicMeasure,FStandardCost,FStandardManHour,FStdPayRate,FChgFeeRate,FStdFixFeeRate,FOutMachFee,FPieceRate,FInspectionLevel,FProChkMde,FWWChkMde,FSOChkMde,FWthDrwChkMde,FStkChkMde,FOtherChkMde,FStkChkPrd,FStkChkAlrm,FInspectionProject,FIdentifier,FVersion,FNameEn,FModelEn,FHSNumber,FFirstUnit,FSecondUnit,FImpostTaxRate,FConsumeTaxRate,FFirstUnitRate,FSecondUnitRate,FIsManage,FManageType,FLenDecimal,FCubageDecimal,FWeightDecimal,FIsCharSourceItem,FShortNumber, FNumber, FName, FParentID, FItemID)   
		select top 1          @FStdNudeBoxSize,@FStdNudeNetWeight,@FStandardNudeQty,NULL,     @fmodel,  0,          1,        0,      FUnitGroupID,FUnitID,FOrderUnitID,FSaleUnitID,FProductUnitID,FStoreUnitID,0,         0,                0,          0,    FSource,      0,          0,        0,         0,      341,      0,            NULL,        0,           @ffullname, NULL,      NULL,  0,           0,           1,               0,        1,               0,        1,               0,      0,          0,          0,         0,            0,          0,        0,         FBatchManager,0,        0,            0,            0,           0,          0,           0,          0,           0,          80,    0,         FPriceDecimal,FAcctID,FSaleAcctID,FCostAcctID,0,        0,           0,        FTaxRate,0,           0,          NULL, @FCompatModel, 0,    @fdescription, F_105, @FCompatArea, @FMainSupName,@fprintbrandid, @FColourSizeTypeID,@FNetWeight,@FGrossWeight,@FStandardQty,@FStdColourSize,@FStdBoxSize,321,         331,          0,           1,        0,        0,             1,      10000,  1,              0,          0,             1,                1,            1,         0,                0,                 0,                0,       0,          0,            1,      0,        NULL,        0,         0,           0,          0,     @FLength,@FWidth,@FHeight, 0,    0,            0,            0,               0,          0,          0,             0,          0,         352,             352,       352,      352,      352,          352,       352,         9999,      0,          0,                 0,          NULL,    NULL,   NULL,    0,        NULL,      NULL,       0,             0,              0,             0,              0,        0,          2,          4,             2,             0,                @FShortNumber,@FNumber,@FName,@FParentID,@FItemID
		from t_icitem where fnumber like left(@FParentNumber,1)+'.%'

		if not exists (select 1 from t_BaseProperty where FItemID=@fitemid)
		begin
			Insert Into t_BaseProperty(FTypeID, FItemID,  FCreateDate, FCreateUser, FLastModDate, FLastModUser, FDeleteDate, FDeleteUser)
								Values(4,       @fitemid, getdate(),   @fusername,  Null,         Null,         Null,        Null)
		end 
		
		update t1 set from t_icitem t1 where 
		
		--如果标配的BOM存在，则将标配的BOM插入到高配的BOM中
		if exists(select 1 from icbom where fitemid=@fitemid)
		begin
			insert into icbom
			select from icbom where fitemid=			
		end
	end
	
	set @fminid=@fminid+1
END

go

---------------------------------------------------------------------------------------------------------

declare @fuserid int,@fsourceitemid int,@fitemid int output,@fnumber varchar(30) output,@ftypeno varchar(30))
--with encryption 
as
SET NOCOUNT ON

--declare @fuserid int,@fsourceitemid int,@fitemid int select @fuserid=16394,@fsourceitemid=32099,@fitemid=0
declare @iMaxIndex int,@fname varchar(2000),@fmodel varchar(2000),@fdescription varchar(2000)
declare @FCompatArea varchar(2000),@FCompatModel varchar(2000),@FNetWeight decimal(24,2)
declare @FLength decimal(24,2),@FWidth decimal(24,2),@FHeight decimal(24,2)
declare @FStdBoxSize varchar(300),@FStdColourSize varchar(300),@FStandardQty int
declare @FInterID int ,@fcheckerid int,@fsource int,@fprintbrandid int
declare @FMyInterID int ,@FSupplyId int,@fusername varchar(30),@FLevel int,@ftempshortnumber varchar(20)
declare @fcurrencyid int,@FPType int,@fstartqty int,@fendqty int,@fnote varchar(500)
declare @fbillno varchar(30),@fprice decimal(24,4),@ftempprice decimal(24,4)
declare @funitid int,@FColourSizeTypeID int,@ftempnumber varchar(20),@ftempname varchar(2000)
declare @fstatus int,@fsubid int,@foldprice1 decimal(24,4),@foldprice2 decimal(24,4),@foldprice3 decimal(24,4)
declare @fdate datetime,@freasonid int,@FShortNumber varchar(20),@FParentNumber varchar(100),@FParentNamd varchar(2000)
declare @ftrantype varchar(50),@FParentID int,@ffullname varchar(3000)
declare @InterID int,@BillNo varchar (20),@fbomgroupid int,@TmpID INT ,@FBomInterID int,@iLength int
declare @fprojectval  varchar(200),@ferpclsname varchar(20),@sDateFormat  varchar(200)

select @fdate=replace(convert(varchar(10),getdate(),111),'/','-')  --制单日期
select @fusername=t1.fname from t_user t1 where t1.fuserid=@fuserid

if not exists(select t4.fnumber from t_icitem t1 inner join icbomchild t2 on t1.fitemid=t2.fitemid
			  inner join icbom t3 on t2.finterid=t3.finterid inner join t_icitem t4 on t4.fitemid=t3.fitemid 
			  where t4.fnumber like 'R.%' and t1.fitemid=@fsourceitemid and t2.fentryid=1)
begin
	select @FShortNumber='RX'+isnull(left('00000',(len('00000')-len((max(cast(right(fshortnumber,5) as int))+1))))+CAST((max(cast(right(fshortnumber,5) as int))+1) as varchar(10)),'00000') from t_icitem where fnumber like 'R.%'

	if @ftypeno='黑色'
		select @FParentNumber='R.01.002'
	else
		select @FParentNumber='R.02.002'

	select @fnumber=@FParentNumber+'.'+@FShortNumber
	select @FParentID=fitemid,@FLevel=FLevel+1 from t_item where fnumber=@FParentNumber and fdetail=0 and fitemclassid=4

	select @fname='配件/'+fname,@fmodel=fmodel from t_icitem where fitemid=@fsourceitemid

	INSERT INTO t_Item (ffullnumber,FItemClassID,FParentID, FLevel, FName,  FNumber, FShortNumber,  FDetail,UUID,     FDeleted) 
	VALUES 		   (@fnumber,   4,           @FParentID,@FLevel,@fname, @fnumber,@FShortNumber, 1,      newid() , 0)

	INSERT INTO t_Log (FDate,    FUserID,    FFunctionID,FStatement,FDescription,                                  FMachineName,FIPAddress) 
	VALUES 		      (getdate(),@fuserid,  'A00701',   5,         '新建核算项目:'+@fnumber+' 核算项目类别:物料','KSW103',    '192.168.0.89')

	select @fitemid=FItemID,@ffullname=ffullname from t_Item where fdetail=1 and fitemclassid=4 and fnumber=@fnumber

	INSERT INTO t_ICItem (FHelpCode,FModel,   FAuxClassID,FErpClsID,FTypeID,FUnitGroupID,FUnitID,FOrderUnitID,FSaleUnitID,FProductUnitID,FStoreUnitID,FSecUnitID,FSecCoefficient,  FDefaultLoc,FSPID,FSource,F_114,F_115,F_117,f_110,F_109,  F_111,  FQtyDecimal,FLowLimit,FHighLimit,FSecInv,FUseState,FIsEquipment,FEquipmentNum,FIsSparePart,FFullName,  FApproveNo,FAlias,FOrderRector,FPOHighPrice,FPOHghPrcMnyType,FWWHghPrc,FWWHghPrcMnyType,FSOLowPrc,FSOLowPrcMnyType,FIsSale,FProfitRate,FOrderPrice,FSalePrice,FIsSpecialTax,FISKFPeriod,FKFPeriod,FStockTime,FBatchManager,FBookPlan,FBeforeExpire,FCheckCycUnit,FOIHighLimit,FOILowLimit,FSOHighLimit,FSOLowLimit,FInHighLimit,FInLowLimit,FTrack,FPlanPrice,FPriceDecimal,FAcctID,FSaleAcctID,FCostAcctID,FAPAcctID,FAdminAcctID,FGoodSpec,FTaxRate,FCostProject,FIsSNManage,FNote,FPlanTrategy,FOrderTrategy,FFixLeadTime,FLeadTime,FTotalTQQ,FOrderInterVal,FQtyMin,FQtyMax,FBatchAppendQty,FOrderPoint,FBatFixEconomy,FBatChangeEconomy,FRequirePoint,FPlanPoint,FDefaultRoutingID,FDefaultWorkTypeID,FProductPrincipal,FPlanner,FPutInteger,FDailyConsume,FMRPCon,FMRPOrder,FChartNumber,FIsKeyItem,FGrossWeight,FNetWeight, FMaund,FLength, FWidth, FHeight,  FSize,FCubicMeasure,FStandardCost,FStandardManHour,FStdPayRate,FChgFeeRate,FStdFixFeeRate,FOutMachFee,FPieceRate,FInspectionLevel,FProChkMde,FWWChkMde,FSOChkMde,FWthDrwChkMde,FStkChkMde,FOtherChkMde,FStkChkPrd,FStkChkAlrm,FInspectionProject,FIdentifier,FVersion,FNameEn,FModelEn,FHSNumber,FFirstUnit,FSecondUnit,FImpostTaxRate,FConsumeTaxRate,FFirstUnitRate,FSecondUnitRate,FIsManage,FManageType,FLenDecimal,FCubageDecimal,FWeightDecimal,FIsCharSourceItem,FShortNumber, FNumber, FName, FParentID, FItemID)   
	select top 1          NULL,     @fmodel,  0,          2,        FTypeID,FUnitGroupID,FUnitID,FOrderUnitID,FSaleUnitID,FProductUnitID,FStoreUnitID,FSecUnitID,FSecCoefficient,  FDefaultLoc,FSPID,176,    F_114,F_115,25952,0,    '0*0*0','0*0*0',FQtyDecimal,FLowLimit,FHighLimit,FSecInv,FUseState,FIsEquipment,FEquipmentNum,FIsSparePart,@ffullname, FApproveNo,FAlias,FOrderRector,FPOHighPrice,FPOHghPrcMnyType,FWWHghPrc,FWWHghPrcMnyType,FSOLowPrc,FSOLowPrcMnyType,FIsSale,FProfitRate,FOrderPrice,FSalePrice,FIsSpecialTax,FISKFPeriod,FKFPeriod,FStockTime,FBatchManager,FBookPlan,FBeforeExpire,FCheckCycUnit,FOIHighLimit,FOILowLimit,FSOHighLimit,FSOLowLimit,FInHighLimit,FInLowLimit,FTrack,FPlanPrice,FPriceDecimal,FAcctID,FSaleAcctID,FCostAcctID,FAPAcctID,FAdminAcctID,FGoodSpec,FTaxRate,FCostProject,FIsSNManage,FNote,FPlanTrategy,FOrderTrategy,FFixLeadTime,FLeadTime,FTotalTQQ,FOrderInterVal,FQtyMin,FQtyMax,FBatchAppendQty,FOrderPoint,FBatFixEconomy,FBatChangeEconomy,FRequirePoint,FPlanPoint,FDefaultRoutingID,FDefaultWorkTypeID,FProductPrincipal,FPlanner,FPutInteger,FDailyConsume,FMRPCon,FMRPOrder,FChartNumber,FIsKeyItem,FGrossWeight,FNetWeight, FMaund,FLength, FWidth, FHeight,  FSize,FCubicMeasure,FStandardCost,FStandardManHour,FStdPayRate,FChgFeeRate,FStdFixFeeRate,FOutMachFee,FPieceRate,FInspectionLevel,FProChkMde,FWWChkMde,FSOChkMde,FWthDrwChkMde,FStkChkMde,FOtherChkMde,FStkChkPrd,FStkChkAlrm,FInspectionProject,FIdentifier,FVersion,FNameEn,FModelEn,FHSNumber,FFirstUnit,FSecondUnit,FImpostTaxRate,FConsumeTaxRate,FFirstUnitRate,FSecondUnitRate,FIsManage,FManageType,FLenDecimal,FCubageDecimal,FWeightDecimal,FIsCharSourceItem,@FShortNumber,@FNumber,@FName,@FParentID,@FItemID
	from t_icitem where fnumber like left(@FParentNumber,1)+'.%'

	exec cbAddCostObj @fitemid,0

	if not exists (select 1 from t_BaseProperty where FItemID=@fitemid)
	begin
		Insert Into t_BaseProperty(FTypeID, FItemID,  FCreateDate, FCreateUser, FLastModDate, FLastModUser, FDeleteDate, FDeleteUser)
				    Values(4,       @fitemid, getdate(),   @fusername,  Null,         Null,         Null,        Null)
	end
end

if not exists(select 1 from icbom where fitemid=@fitemid) and @fitemid<>0
begin
	exec GetICMaxNum 'icbom', @InterID output

	-- 10.4
	Update t_BillCodeRule Set FReChar = FReChar Where FBillTypeID =50

	SET @TmpID = (SELECT FID FROM t_BillCodeRule WITH(READUNCOMMITTED) WHERE fbilltypeid=50 and fprojectid=3)

	update t_billcoderule set fprojectval = fprojectval+1,flength=case when (flength-len(fprojectval)) >= 0 then flength else len(fprojectval) end where FID =  @TmpID 
	Update ICBillNo Set FCurNo = (select top 1 isnull(fprojectval,1) from t_billcoderule where fprojectid = 3 and fbilltypeid =50) where fbillid = 50
	   
	--长度和目前编码
	select @fprojectval=(fprojectval-1),@iLength=flength from t_BillCodeRule where fprojectid = 3 and fbilltypeid = 50

	-- 前缀
	select @BillNo=fprojectval+left('0000000000',@iLength-(len(@fprojectval)))+@fprojectval from t_BillCodeRule where fprojectid = 1 and fbilltypeid = 50  --@iLength

	INSERT INTO ICBomChild (FInterID,FEntryID,FBrNo,FItemID,       FMachinePos,FNote,FAuxQty,FScrap,FOffSetDay,FUnitID,FQty, FMaterielType,FMarshalType,FBeginDay,   FEndDay,     FPercent,FPositionNo,FItemSize,FItemSuite,FOperSN,FOperID,FBackFlush,FStockID,   FSPID,FAuxPropID,FPDMImportDate,FDetailID) 
	select                  @InterID,1,       '0',  @FSourceItemID,'',         '',   1,      0,     0,         FUnitID,1,    371,          385,         '1900-01-01','2100-01-01',100,     '',         '',       '',        '',     0,      1059,      fdefaultloc,0,    0,         null,          NEWID() 
	from t_icitem where fitemid=@FSourceItemID

	Update t1 set t1.FQty=cast(t1.FAuxQty as decimal(28,15)) * cast( isnull(t3.FCoefficient,1)  + cast(isnull(t3.FScale,0) as float) as decimal(28,15) )
	from ICBOMChild  t1,t_MeasureUnit t3
	Where t1.FInterID=@InterID and fentryid=1 and t3.FItemID = t1.FUnitID 

	select top 1 @fbomgroupid=t2.FParentID
	from t_icitem t1 
	inner join icbom t2 on t1.fitemid=t2.fitemid 
	where t1.fnumber like left(@FParentNumber,1)+'.%'
		
	INSERT INTO ICBom(fcheckerid,FInterID, FBomNumber,FItemID, FOperatorID,FEnterTime,FBrNo,FTranType,FCancellation,FStatus,FVersion,FUseStatus,FUnitID,FAuxPropID,FAuxQty,fqty,FYield,FNote,FCheckID,FCheckDate,FRoutingID,FBomType,FCustID,FParentID,   FAudDate,FImpMode,FPDMImportDate,FBOMSkip) 
	select            @fuserid,  @InterID, @BillNo,   @FItemID,@fuserid,   @fdate,    '0',  50,       0,            1,      '',      1072,      FUnitID,0,         1,      1,   100,   '',   @fuserid,@fdate,    0,         0,       0,      @fbomgroupid,@fdate,  0,       null,          1059
	from t_icitem where fitemid=@fitemid
end

set nocount off
