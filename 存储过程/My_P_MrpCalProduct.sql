set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go


ALTER procedure [dbo].[My_P_MrpCalProduct](@fuserid int,@frunid int,@fbillno varchar(20),@fidentify int output)

as

--declare @fuserid int select @fuserid=16394

set nocount on 

declare @fplanprice decimal(18,4),@fitemid int,@fpitemid int,@funitid int,@entryid int,@fqty int
declare @InterID int,@BillNo varchar (20),@FStockId int,@StockNumber varchar (20)
DECLARE @TmpID INT ,@fsupplyid int,@fcurrencyid int,@FMyPoInStockInterId int
declare @fsupplyno varchar(20),@forderdate datetime,@FValueAddRate decimal(28, 2)
declare @iLength int,@FPrice decimal(28, 5),@FAmount decimal(20, 2),@FExchangeRate decimal(28, 10)
declare @FTaxPrice decimal(28, 5),@FTaxAmount decimal(20, 2),@SupplyId int
declare @fprojectval varchar(200),@fspid int,@fempid int,@fdeptid int,@fplanbegindate datetime
declare @FDateFormat varchar(200),@fdate datetime,@forginterid int,@fpacktype varchar(50)
declare @FSourcePOBillNo varchar(100),@FSourceSeBillNo varchar(100),@fcustid int
declare @fsourceNumber varchar(200),@fpSourceNumber varchar(200),@fpXxSourceNumber varchar(200)
declare @fXxOldSourceNumber varchar(200),@empid int,@fsourcetrantype int,@fbatchno varchar(50)
declare @FDCStockID int,@xx_FItemIDOld int,@fxxitemid int,@FOrgPPOInterID int
declare @FDCSPID int,@forderinterid int,@forderentryid int,@forderbillno varchar(30)
declare @fsourceInterid int,@fsourceEntryid int,@fsourceBillNo varchar (100)
declare @fyear int,@fperiod int,@FMangerID int,@s varchar(8000),@fdeliverid int
declare @fresultbillno varchar (800),@FBegBillNo varchar(20),@FEndBillNo varchar(20)
declare @ftempbillno varchar(50),@fcostobjid int,@fplancommitdate datetime,@fsourceid int
declare @fplanorderinterid int,@fbominterid int,@forgsaleinterid int,@forgentryid int
--AIS20041229163526   AIS20080129143619
--declare @fbout varchar(10),@fcommitdate datetime

declare @FProductProspectDays int,@FHalfProductProspectDays int,@FProductPrepareDays int,@FHalfProductPrepareDays int

select @FProductProspectDays=fvalue from t_SystemProfile where FCategory='IC' and fkey='FProductProspectDays' 
select @FHalfProductProspectDays=fvalue from t_SystemProfile where FCategory='IC' and fkey='FHalfProductProspectDays' 
select @FProductPrepareDays=fvalue from t_SystemProfile where FCategory='IC' and fkey='FProductPrepareDays' 
select @FHalfProductPrepareDays=fvalue from t_SystemProfile where FCategory='IC' and fkey='FHalfProductPrepareDays' 


select @fdate=replace(convert(varchar(10),getdate(),111),'/','-')  --制单日期
select @fresultbillno='',@BillNo='',@s=''

--保存运算信息
if not exists(select 1 from my_t_Mrp where frunid=@frunid)
begin
	insert into my_t_Mrp(ftrantype, fbillno, frunid, fuserid, fbilltime,fdate) 
	values(              0,         @fbillno,@frunid,@fuserid,getdate(),@fdate)
end

--set @fbout='204'


select @fidentify=isnull(max(fid),0)+1 from my_t_identify

insert into my_t_identify(fid,fuserid,fdate,FTrantypeID) values(@fidentify,@fuserid,getdate(),85)
select isnull(t1.FEntrySelfS0175,40089) fdeliverid,isnull(t7.fheadselfs0143,'') FSourcePoBillNo,isnull(t7.fheadselfs0144,'') FSourceSeBillNo,
--Dateadd(day,-@FProductPrepareDays,t1.fdate) fplancommitdate/*计划完工日期=订单出货日期-提前期*/,
t7.FHeadSelfS0154 fplanbegindate,t1.fdate /*t7.FHeadSelfS0148*/ fplancommitdate,
t7.fcustid,t14.fname fpacktype,
81 fsourcetrantype,isnull(t5.fitemid,0) fcostobjid,t1.fitemid,t4.finterid fbominterid,
t2.funitid,t1.fqty-isnull(t8.fqty,0) fqty,(case when left(t2.fnumber,4)='v.e.' then 175684 else 176 end) fdeptid,
isnull(t11.fid,0) fpacksubid,
isnull(t9.fitemid,0) fchilditemid,isnull(t10.fitemid,0) fchipitemid,isnull(t13.fitemid,0) fchipverid,
t1.finterid forderinterid,t1.fentryid forderentryid,t7.fbillno forderbillno,t2.ferpclsid,t2.fnumber
into #data
from seorderentry t1 
inner join seorder t7 on t1.finterid=t7.finterid
inner join t_icitem t2 on t1.fitemid=t2.fitemid 
inner join t_measureunit t3 on t3.fitemid=t2.funitid
inner join icbom t4 on t2.fitemid=t4.fitemid and t4.fusestatus=1072 --成品BOM
left join cbCostObj t5 on t5.FStdProductID=t2.fitemid  --成本对象 --t5.fnumber=t2.fnumber -- 
left join (select forderinterid,fsourceentryid,sum(fqty) fqty from icmo t1 group by forderinterid,fsourceentryid) t8 on t1.finterid=t8.forderinterid and t1.fentryid=t8.fsourceentryid
left join t_icitem t9 on t9.fitemid=t1.fentryselfs0164  --半成品
left join t_icitem t10 on t10.fitemid=t1.fentryselfs0161  --芯片
left join (select min(fid) fid,fproductid,fbrandid from t_BOSPackSub group by fproductid,fbrandid) t11 on t11.fproductid=t1.fitemid and t11.fbrandid=t1.fentryselfs0158  --成品的包装方式
left join t_item t13 on t13.fitemid=t1.fentryselfs0160 and t13.fitemclassid=3006 --芯片版本  --16465  无芯片
left join t_item t14 on t14.fitemclassid=3002 and t14.fitemid=t1.fentryselfs0158  --包装方式
where --datediff(day,getdate(),t1.fdate)<=@FProductProspectDays  --成品展望期30天 
t1.finterid in (select forderinterid from my_t_MrpSeOrder where frunid=@frunid and fselect=1) --去掉不参与运算的
and t1.fmrpclosed<>1 --行业务未关闭
and (t7.fstatus>0 or isnull(t7.FMultiCheckLevel1,0)>0) --一审或者已经审核
and (t1.fqty>isnull(t8.fqty,0)) --未完全生成生产任务单
order by t1.fdate,t1.fdeptid,t1.finterid,t1.fentryid


--放在前台检查
----自制件但没配置半成品
--if exists(select t1.forderbillno,t1.fnumber from #data t1 where ferpclsid=2 and fchilditemid=0)
--begin
--	select @s=@s+','+m1.fbillno from
--	(
--		select (t1.forderbillno+' | '+t1.fnumber) fbillno from #data t1 where ferpclsid=2 and fchilditemid=0
--	) m1
--
--	set @s='['+@s+']还未配置半成品!'  --
--	RAISERROR(@s,18,18)
--end 
--
----要芯片但没有配置芯片
--if exists(select t1.forderbillno,t1.fnumber from #data t1 where fchipverid<>16465 and fchipitemid=0)
--begin
--	select @s=@s+','+m1.fbillno from
--	(
--		select (t1.forderbillno+' | '+t1.fnumber) fbillno from #data t1 where fchipverid<>16465 and fchipitemid=0
--	) m1
--
--	set @s='['+@s+']还未配置芯片!'  --
--	RAISERROR(@s,18,18)
--end 

DECLARE authors_cursor CURSOR FOR	

select t1.fpacktype,t1.fcustid,t1.fdeliverid,t1.FSourcePoBillNo,t1.FSourceSeBillNo,t1.fsourcetrantype,t1.fcostobjid,t1.fitemid,t1.funitid,t1.fqty,
t1.fplanbegindate,(case when t1.fplancommitdate<@fdate then @fdate else t1.fplancommitdate end) fplancommitdate,
t1.fdeptid,t1.fbominterid,t1.forderinterid,t1.forderentryid,t1.forderbillno
from #data t1 

OPEN authors_cursor

FETCH NEXT FROM authors_cursor 
INTO @fpacktype,@fcustid,@fdeliverid,@FSourcePoBillNo,@FSourceSeBillNo,@fsourcetrantype,@fcostobjid,@fitemid,@funitid,@fqty,@fplanbegindate,@fplancommitdate,@fsourceid,@fbominterid,@forderinterid,@forderentryid,@forderbillno

WHILE @@FETCH_STATUS = 0
BEGIN 
	exec GetICMaxNum 'ICMO', @InterID output

	-- 10.4
	Update t_BillCodeRule Set FReChar = FReChar Where FBillTypeID =85

	SET @TmpID = (SELECT FID FROM t_BillCodeRule WITH(READUNCOMMITTED) WHERE fbilltypeid=85 and fprojectid=3) --生产任务单流水号 所在明细行的ID

	update t_billcoderule set fprojectval = fprojectval+1,flength=case when (flength-len(fprojectval)) >= 0 then flength else len(fprojectval) end where FID =  @TmpID  --流水号 加一
	Update ICBillNo Set FCurNo = (select top 1 isnull(fprojectval,1) from t_billcoderule where fprojectid = 3 and fbilltypeid =85) where fbillid = 85 --更新 ICBillNo 表存放的流水号信息
	   
	--长度和目前编码
	select @fprojectval=(fprojectval-1),@iLength=flength from t_BillCodeRule where fprojectid = 3 and fbilltypeid = 85
	  
	-- 前缀
	select @BillNo=fprojectval+left('0000000000',@iLength-(len(@fprojectval)))+@fprojectval from t_BillCodeRule where fprojectid = 1 and fbilltypeid = 85  --@iLength

	--40089	自产自包,40090	外调自包,40091	外调外包

	set @fsupplyid=0

	if @fdeliverid in (40090,40091)
	begin
		select top 1 @fsupplyid=t1.FSupplyID
		from poorder t1
		inner join poorderentry t2 on t1.finterid=t2.finterid
		where t2.fsourceinterid=@forderinterid and t2.fsourceentryid=@forderentryid and t2.fsourcetrantype=81
	end

	--if @fcustid=16707 --诚华
	--	set @fbatchno=@fpacktype
	--else 
		set @fbatchno=@forderbillno

	--icmo fstatus 5 确认 0 计划 1,2 下达 3 结案  
	--fbillerid 制单人 fcheckdate 制单日期 FConfirmerID 确认人 FConfirmDate 确认日期 FConveyerID 下达人 FCommitDate 下达日期 FCheckerID 结案人 FCloseDate 结案日期
	--fmrp 11061 mps产生 1052 手工录入 11077 mrp产生 --select forderinterid,fpporderinterid,fsourceentryid,* from icmo
	insert into icmo(FHeadSelfJ0182,FHeadSelfJ0180,       FHeadSelfJ0176 , FHeadSelfJ0177 , FHeadSelfJ0174,FHeadSelfJ0175,FInterID,FBillNo,FBrNo,FTranType,FCancellation,FCheckDate,Fstatus,FMRP, FWorktypeID,FCostObjID, FBomInterID, FRoutingID,FWorkShop, FSupplyID,FItemID, FUnitID, Fauxqty,FPlanCommitDate, FPlanFinishDate,Fnote,FCommitDate,FBillerID,FOrderInterID,  FParentInterID,FPPOrderInterID, FType,FSourceEntryID,FProcessPrice,FProcessFee,FPlanOrderInterID, FScheduleID,FCustID,FMultiCheckLevel1,FMultiCheckDate1,FMultiCheckLevel2,FMultiCheckDate2,FMultiCheckLevel3,FMultiCheckDate3,FMultiCheckLevel4,FMultiCheckDate4,FMultiCheckLevel5,FMultiCheckDate5,FMultiCheckLevel6,FMultiCheckDate6,FConfirmDate,FInHighLimit,FAuxInHighLimitQty,FInLowLimit,FAuxInLowLimitQty,FGMPBatchNo,   FMrpLockFlag,FChangeTimes,FCloseDate)
			  values(@fdeliverid ,  isnull(@fsupplyid,0), @FSourcePOBillNo,@FSourceSeBillNo,@fidentify,    @frunid,       @InterId,@BillNo,0,    85,       0,            @fdate    ,0,      11077,55,         @FCostObjID,@fbominterid,0         ,@fsourceid,0,        @FItemId,@funitid,@fqty,  @fplanbegindate, @FPlanCommitDate,'',  @fdate,     @fuserid, @FOrderInterID, 0,             0,               1054, @forderentryid,0,            0,          0,                 0,          0,      NULL,             NULL	,          NULL	,         NULL	,          NULL	,            NULL,            NULL,            	NULL,            NULL,             NULL	           ,NULL	,         NULL	      ,       @fdate,      0,	        @fqty,             0,          @fqty,            @fbatchno,     0,           0,           NULL	)

	insert into My_t_MrpRoughNeedSource(fneeddate,      ftrantype,frunid, fsourceinterid, fsourceentryid,  fitemid,  fqty)
	select                              @fplanbegindate,81,       @frunid,@FOrderInterID, @forderentryid,  @fitemid, @fqty

	exec My_P_AddOrEditPPBom @fuserid,@InterId,0

	--不能设置为确认状态,因为成品的BOM是虚拟的,下达时会提示BOM不存在
	--update icmo set Fstatus=1,FConfirmerID=@fuserid , FConfirmDate=@fdate , FConveyerID=@fuserid , FCommitDate=@fdate where finterid=@InterId
	update icmo set Fstatus=5,FConfirmerID=@fuserid , FConfirmDate=@fdate where finterid=@InterId

    --insert into my_t_scheduledetail (fbillerid, fsourcetrantype, ficmointerid,funitid, fitemid, fdeptid,   fdate,          fqty, fnote)
				--		      values(@fuserid,  85,              @InterId,    @funitid,@fitemid,@fsourceid,@fplanbegindate,@fqty,'')

	FETCH NEXT FROM authors_cursor 
	INTO @fpacktype,@fcustid,@fdeliverid,@FSourcePoBillNo,@FSourceSeBillNo,@fsourcetrantype,@fcostobjid,@fitemid,@funitid,@fqty,@fplanbegindate,@fplancommitdate,@fsourceid,@fbominterid,@forderinterid,@forderentryid,@forderbillno
END

CLOSE authors_cursor
DEALLOCATE authors_cursor



--单据编号自定义的

set @fendBillNo=@BillNo

drop table #data

set nocount off


