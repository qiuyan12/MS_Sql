

--select * from vdbom$
--select distinct 编码 from vdbom$

--select fshortnumber from t_icitem where fnumber like 'v%' order by fshortnumber

--select * from t_icitem where fitemid not in (select fitemid from t_item where fitemclassid=4)
--select * from t_item where fitemclassid=4 and fdetail=1 and fitemid not in (select fitemid from t_icitem)

--分物料编码导入比较快—最多4级，如果有5级的，就开放5级的代码—！！！！！！————————————————————————————————————————————————

declare @fuserid int select @fuserid=16394
declare @iMaxIndex int,@fname varchar(2000),@fmodel varchar(2000),@fdescription varchar(2000)
declare @FCompatArea varchar(2000),@FCompatModel varchar(2000)
declare @FNetWeight decimal(24,2),@FGrossWeight decimal(24,2) --整箱净重、毛重
declare @FLength decimal(24,2),@FWidth decimal(24,2),@FHeight decimal(24,2),@FMainSupName varchar(30)
declare @FStdBoxSize varchar(300),@FStdColourSize varchar(300),@FStandardQty int
declare @fhgcpName varchar(50),@maxHgcpNb varchar(3),@fhgcpId int			--海关产品分类
declare @FStdNudeBoxSize varchar(300),@FStdNudeColourSize varchar(300),@FStandardNudeQty int,@FStdNudeNetWeight decimal(24,2)
declare @FInterID int ,@fcheckerid int,@fsource int,@fprintbrandid int
declare @FMyInterID int ,@FSupplyId int,@fusername varchar(30),@FLevel int,@ftempshortnumber varchar(20)
declare @fcurrencyid int,@FPType int,@fstartqty int,@fendqty int,@fnote varchar(500)
declare @fbillno varchar(30),@fitemid int,@fprice decimal(24,4),@ftempprice decimal(24,4)
declare @funitid int,@fnumber varchar(30),@FColourSizeTypeID int,@ftempnumber varchar(20),@ftempname varchar(2000)
declare @fstatus int,@fsubid int,@foldprice1 decimal(24,4),@foldprice2 decimal(24,4),@foldprice3 decimal(24,4)
declare @fdate datetime,@freasonid int,@FShortNumber varchar(20),@FParentNumber varchar(100),@FParentNamd varchar(2000)
declare @ftrantype varchar(50),@FParentID int,@ffullname varchar(3000)
declare @foldnumber varchar(50),@foldshortnumber varchar(50) ---
declare @fisengine int,@fengineid int,@ftypeid int,@fenginenumber varchar(50),@ftypename varchar(50)

select @fdate=replace(convert(varchar(10),getdate(),111),'/','-')  --制单日期

declare @findex int,@fprice1 decimal(24,4),@fprice2 decimal(24,4),@fprice3 decimal(24,4)
declare @fbegqty1 int,@fendqty1 int,@fbegqty2 int,@fendqty2 int,@fbegqty3 int,@fendqty3 int

select @fdate=replace(convert(varchar(10),getdate(),111),'/','-')  --制单日期

select @fusername=t1.fname from t_user t1 where t1.fuserid=@fuserid

--26301	中山鑫威打印耗材有限公司  --select * from t_supplier where fitemid=26301
--19782 诚杰
--13654	珠海诚威电子有限公司

--drop table #data  select * from #data  drop table #sellprice  select * from #sellprice --select * from t_supplier
--select * from my_t_icitem where fnumber='A.01.015.A00215'
DECLARE icbomEntry_cursor CURSOR FOR	
--select * from t_item where fitemclassid=3010
select ''FStdNudeBoxSize,0 FStdNudeNetWeight,0 FStandardNudeQty,''fhgcpName,
''FMainSupName,0 fsupid,
0 fitemid,t12.fshortnumber,t12.fnumber,t12.fname+'/',t12.fmodel,-----------------
'' fdescription,''FCompatArea,''FCompatModel,0 FNetWeight,0 FGrossWeight,0 FStandardQty,
0 FColourSizeTypeID,'' FStdColourSize,''FStdBoxSize,0 fprintbrandid,
t12.ffullname,isnull(t2.fitemid,0) fparentid,----------
0 fisengine,'' fenginenumber,'' ftypename
from t_icitem t12  
--left join t_icitem t7 on t12.fnumber=t7.fnumber 
--inner join t_supplier t1 on t1.fitemid=t12.fsupid  --
--left join t_submessage t4 on t4.finterid=t12.fprintbrandid and t4.ftypeid=10009
--left join t_item t5 on t5.fitemid=t12.FColourSizeTypeID and t5.fitemclassid=3010  --select * from t_item where fitemclassid=3010
left join t_item t2 on t2.fnumber=(REVERSE(right(REVERSE(t12.fnumber),len(t12.fnumber)-CHARINDEX('.',REVERSE(t12.fnumber))))) and t2.fdetail=0 and t2.fitemclassid=4
where t12.fnumber in (select 编码 from vdbom$) --and
--t12.fnumber not in (select fnumber from t_icitem )
and t12.fnumber like '%' --
order by t12.fnumber  --select * from my_t_icitem where fshortnumber='B30012'  --delete t1 from my_t_icitem t1 where fshortnumber<>'B30012'

OPEN icbomEntry_cursor

FETCH NEXT FROM icbomEntry_cursor 
INTO @FStdNudeBoxSize,@FStdNudeNetWeight,@FStandardNudeQty,@fhgcpName,@FMainSupName,@fsupplyid,@fitemid,@fshortnumber,@fnumber,@fname,@fmodel,@fdescription,@FCompatArea,@FCompatModel,@FNetWeight,@FGrossWeight,@FStandardQty,@FColourSizeTypeID,@FStdColourSize,@FStdBoxSize,@fprintbrandid,@ffullname,@fparentid,@fisengine,@fenginenumber,@ftypename

WHILE @@FETCH_STATUS = 0
BEGIN 
	--print @fnumber --select fname,* from t_supplier where fname like '%杰%'

	select @foldnumber=@fnumber,@foldshortnumber=@fshortnumber
	
	--是否引擎	F_128  引用引擎	F_129  --  40087 是 	40088 否	

	if not exists(select 1 from t_icitem where f_125=@foldnumber) --长代码已经存在,即修改资料 --select * from t_itempropdesc where fitemclassid=4
	begin
		select @ftempnumber=left(@FShortNumber,2)
		select @FShortNumber=@ftempnumber+isnull(left('00000',(len('00000')-len((max(cast(right(fshortnumber,5) as int))+1))))+CAST((max(cast(right(fshortnumber,5) as int))+1) as varchar(10)),'00000') from t_icitem where fshortnumber like @ftempnumber+'%' and fnumber not like '%取消%'
		--select @FShortNumber=REVERSE(left(REVERSE(@fnumber),CHARINDEX('.',REVERSE(@fnumber))-1))
		select @FParentNumber=REVERSE(right(REVERSE(@fnumber),len(@fnumber)-CHARINDEX('.',REVERSE(@fnumber))))
		select @FParentID=fitemid,@FLevel=FLevel+1 from t_item where fnumber=@FParentNumber and fdetail=0 and fitemclassid=4
		select @fnumber=@FParentNumber+'.'+@FShortNumber

		if not exists (select 1 from t_Item where fdetail=1 and fitemclassid=4 and (fnumber=@fnumber or fshortnumber=@FShortNumber))
		begin
			INSERT INTO t_Item (ffullnumber,FItemClassID,FParentID, FLevel, FName,  FNumber, FShortNumber,  FDetail,UUID,     FDeleted) 
			VALUES 			   (@fnumber,   4,           @FParentID,@FLevel,@fname, @fnumber,@FShortNumber, 1,      newid() , 0)
		end

		if not exists (select 1 from t_ICItem where (fnumber=@fnumber or fshortnumber=@FShortNumber))
		begin
			select @fitemid=FItemID,@ffullname=ffullname from t_Item where fdetail=1 and fitemclassid=4 and fnumber=@fnumber

			INSERT INTO t_ICItem ( F_102,F_103,F_104,F_105,F_106,F_107,F_108,F_109,F_110,F_111,F_112,F_113,F_114,F_115,F_116,F_117,F_118,F_119,F_120,F_121,F_122,F_123,F_125,      F_126,F_127,F_128,F_129,F_130,F_131,F_132,F_133,F_134,F_135,F_136,F_137,F_138,FHelpCode,FModel,   FAuxClassID,FErpClsID,FTypeID, FUnitGroupID,FUnitID,FOrderUnitID,FSaleUnitID,FProductUnitID,FStoreUnitID,FSecUnitID,FSecCoefficient,  FDefaultLoc,FSPID,FSource,         FQtyDecimal,FLowLimit,FHighLimit,FSecInv,FUseState,FIsEquipment,FEquipmentNum,FIsSparePart,FFullName,  FApproveNo,FAlias,FOrderRector,FPOHighPrice,FPOHghPrcMnyType,FWWHghPrc,FWWHghPrcMnyType,FSOLowPrc,FSOLowPrcMnyType,FIsSale,FProfitRate,FOrderPrice,FSalePrice,FIsSpecialTax,FISKFPeriod,FKFPeriod,FStockTime,FBatchManager,FBookPlan,FBeforeExpire,FCheckCycUnit,FOIHighLimit,FOILowLimit,FSOHighLimit,FSOLowLimit,FInHighLimit,FInLowLimit,FTrack,    FPlanPrice,FPriceDecimal,FAcctID,FSaleAcctID,FCostAcctID,FAPAcctID,FAdminAcctID,FGoodSpec,FTaxRate,FCostProject,FIsSNManage,FNote,FPlanTrategy,FOrderTrategy,FFixLeadTime,FLeadTime,FTotalTQQ,FOrderInterVal,FQtyMin,FQtyMax,FBatchAppendQty,FOrderPoint,FBatFixEconomy,FBatChangeEconomy,FRequirePoint,FPlanPoint,FDefaultRoutingID,FDefaultWorkTypeID,FProductPrincipal,FPlanner,FPutInteger,FDailyConsume,FMRPCon,FMRPOrder,FChartNumber,FIsKeyItem,FGrossWeight,FNetWeight, FMaund,FLength, FWidth, FHeight,  FSize,FCubicMeasure,FStandardCost,FStandardManHour,FStdPayRate,FChgFeeRate,FStdFixFeeRate,FOutMachFee,FPieceRate,FInspectionLevel,FProChkMde,FWWChkMde,FSOChkMde,FWthDrwChkMde,FStkChkMde,FOtherChkMde,FStkChkPrd,FStkChkAlrm,FInspectionProject,FIdentifier,FVersion,FNameEn,FModelEn,FHSNumber,FFirstUnit,FSecondUnit,FImpostTaxRate,FConsumeTaxRate,FFirstUnitRate,FSecondUnitRate,FIsManage,FManageType,FLenDecimal,FCubageDecimal,FWeightDecimal,FIsCharSourceItem,FShortNumber, FNumber, FName, FParentID, FItemID)   
			select                 F_102,F_103,F_104,F_105,F_106,F_107,F_108,F_109,F_110,F_111,F_112,F_113,F_114,F_115,F_116,F_117,F_118,F_119,F_120,F_121,F_122,F_123,@foldnumber,F_126,F_127,F_128,F_129,F_130,F_131,F_132,F_133,F_134,F_135,F_136,F_137,F_138,FHelpCode,FModel,   FAuxClassID,FErpClsID,FTypeID, FUnitGroupID,FUnitID,FOrderUnitID,FSaleUnitID,FProductUnitID,FStoreUnitID,FSecUnitID,FSecCoefficient,  FDefaultLoc,FSPID,FSource,         FQtyDecimal,FLowLimit,FHighLimit,FSecInv,FUseState,FIsEquipment,FEquipmentNum,FIsSparePart,FFullName,  FApproveNo,FAlias,FOrderRector,FPOHighPrice,FPOHghPrcMnyType,FWWHghPrc,FWWHghPrcMnyType,FSOLowPrc,FSOLowPrcMnyType,FIsSale,FProfitRate,FOrderPrice,FSalePrice,FIsSpecialTax,FISKFPeriod,FKFPeriod,FStockTime,FBatchManager,FBookPlan,FBeforeExpire,FCheckCycUnit,FOIHighLimit,FOILowLimit,FSOHighLimit,FSOLowLimit,FInHighLimit,FInLowLimit,FTrack,    FPlanPrice,FPriceDecimal,FAcctID,FSaleAcctID,FCostAcctID,FAPAcctID,FAdminAcctID,FGoodSpec,FTaxRate,FCostProject,FIsSNManage,FNote,FPlanTrategy,FOrderTrategy,FFixLeadTime,FLeadTime,FTotalTQQ,FOrderInterVal,FQtyMin,FQtyMax,FBatchAppendQty,FOrderPoint,FBatFixEconomy,FBatChangeEconomy,FRequirePoint,FPlanPoint,FDefaultRoutingID,FDefaultWorkTypeID,FProductPrincipal,FPlanner,FPutInteger,FDailyConsume,FMRPCon,FMRPOrder,FChartNumber,FIsKeyItem,FGrossWeight,FNetWeight, FMaund,FLength, FWidth, FHeight,  FSize,FCubicMeasure,FStandardCost,FStandardManHour,FStdPayRate,FChgFeeRate,FStdFixFeeRate,FOutMachFee,FPieceRate,FInspectionLevel,FProChkMde,FWWChkMde,FSOChkMde,FWthDrwChkMde,FStkChkMde,FOtherChkMde,FStkChkPrd,FStkChkAlrm,FInspectionProject,FIdentifier,FVersion,FNameEn,FModelEn,FHSNumber,FFirstUnit,FSecondUnit,FImpostTaxRate,FConsumeTaxRate,FFirstUnitRate,FSecondUnitRate,FIsManage,FManageType,FLenDecimal,FCubageDecimal,FWeightDecimal,FIsCharSourceItem,@FShortNumber,@FNumber,@FName,@FParentID,@FItemID
			from t_icitem where fnumber =@foldnumber
		end

		if not exists (select 1 from t_BaseProperty where FItemID=@fitemid)
		begin
			Insert Into t_BaseProperty(FTypeID, FItemID,  FCreateDate, FCreateUser, FLastModDate, FLastModUser, FDeleteDate, FDeleteUser)
								Values(4,       @fitemid, getdate(),   @fusername,  Null,         Null,         Null,        Null)
		end
	end
	print @fnumber
	FETCH NEXT FROM icbomEntry_cursor 
	INTO @FStdNudeBoxSize,@FStdNudeNetWeight,@FStandardNudeQty,@fhgcpName,@FMainSupName,@fsupplyid,@fitemid,@fshortnumber,@fnumber,@fname,@fmodel,@fdescription,@FCompatArea,@FCompatModel,@FNetWeight,@FGrossWeight,@FStandardQty,@FColourSizeTypeID,@FStdColourSize,@FStdBoxSize,@fprintbrandid,@ffullname,@fparentid,@fisengine,@fenginenumber,@ftypename
END

CLOSE icbomEntry_cursor
DEALLOCATE icbomEntry_cursor

----select * from t_itempropdesc where fitemclassid=4 --select * from t_item where fitemclassid=3011
 
set nocount off

GO






--V.B.B1414.01.VB09004

select t4.fdefaultloc,t14.FInterID fbomgroupid,t4.funitid,t4.fitemid,t3.fitemid fproductid,cast(t1.调整后用量 as decimal(24,5)) fqty
--select t23.fnumber,t3.fnumber
into #data123
--select 1
from vdbom$ t1
inner join t_icitem t23 on t23.fnumber=t1.编码
inner join t_icitem t3 on t23.fnumber=t3.f_125
inner join icbom t6 on t6.fitemid=t23.fitemid 
inner join icbomchild t7 on t7.finterid=t6.finterid and t7.finterid=t1.finterid and t7.fentryid=t1.fentryid
inner join t_icitem t4 on t4.fitemid=t7.fitemid
inner join t_item t13 on t3.FParentID=t13.fitemid
inner join ICBomGroup t14 on t14.fnumber=t13.fnumber
where --t23.fshortnumber='VB08983' and
not exists(select 1 from icbom where fitemid=t3.fitemid)
and t3.fdeleted=0 and t4.fdeleted=0
order by t3.fnumber,t4.fnumber

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
select            @fmaxnum+t1.fid,'BOM'+left('000000',6-len(@fmaxbill))+cast(@fmaxbill+t1.fid as varchar), t1.fproductid,16394,      @fdate,    '0',  50,       0,            0,      '',      1073,      t2.FUnitID,0,         1,      1,   100,   '',   16394,   @fdate,    0,         0,       0,      t1.fbomgroupid,null,    0,       null,          1059
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


-----------------------------------------------------------------------------------------
select 1
--update t6 set flastmoddate='2016-05-09'
from t_icitem t23 
inner join t_baseproperty t6 on t6.fitemid=t23.fitemid
where t23.fnumber in (select 编码 from vdbom$)


select t3.fnumber,t3.fname,t3.fmodel,t5.FLastModDate,t11.fname+'[计划禁用]'
--update t11 set fname=t11.fname+'[计划禁用]'
--update t0 set fname=t0.fname+'[计划禁用]'
--update t2 set fcheckdate='2016-05-09'
--update t5 set flastmoddate='2016-05-09'
--update t2 set FChkUserID=16394
from t_icitem t3
inner join t_ICItemCore t0 on t0.fitemid=t3.fitemid
inner join t_item t11 on t11.fitemid=t0.fitemid
inner join t_item t2 on t2.fitemid=t3.fitemid
left join t_baseproperty t5 on t5.fitemid=t3.fitemid
where t3.fnumber in (select 编码 from vdbom$)
and t3.fname not like '%禁用%' --and t3.fname like '%傲威中性粉盒%'


--批量审核和使用BOM
select t2.fnumber,t2.fname
--Update t1 Set FUseStatus=1072,FStatus = 1, FCheckerID = 16394, FAudDate = Convert(Varchar(10),Getdate(),120), FBeenChecked = 1
--update t3 set FUnitID=235, FUnitGroupID=220,FOrderUnitID=235, FSaleUnitID=235,FStoreUnitID=235, FProductUnitID=235
from ICBOM t1
inner join t_icitem t2 on t1.fitemid=t2.fitemid
inner join t_ICItemBase t3 on t3.fitemid=t2.fitemid
where t2.f_125 in (select 编码 from vdbom$)

select t3.fnumber,t3.fname,t3.fmodel,t5.FLastModDate,t11.fname+'[计划禁用]'
--update t2 set fcheckdate='2016-05-09'
--update t5 set flastmoddate='2016-05-09'
--update t2 set FChkUserID=16394
from t_icitem t3
inner join t_ICItemCore t0 on t0.fitemid=t3.fitemid
inner join t_item t11 on t11.fitemid=t0.fitemid
inner join t_item t2 on t2.fitemid=t3.fitemid
left join t_baseproperty t5 on t5.fitemid=t3.fitemid
where t3.f_125 in (select 编码 from vdbom$) and t3.fnumber like 'v.b.%'


select t3.fnumber,t3.fname,replace(t3.fname,'个包','个套装'),t3.fmodel,t5.FLastModDate
--update t11 set fname=replace(t11.fname,'个包','个套装')
--update t0 set fname=replace(t0.fname,'个包','个套装')
--update t5 set flastmoddate='2016-05-09'
from t_icitem t3
inner join t_ICItemCore t0 on t0.fitemid=t3.fitemid
inner join t_item t11 on t11.fitemid=t0.fitemid
inner join t_item t2 on t2.fitemid=t3.fitemid
left join t_baseproperty t5 on t5.fitemid=t3.fitemid
where t3.f_125 in ( select 编码 from vdbom$ ) --select 编码 from newbom$ union all select 编码 from bom$ union all
and t0.fname like '%个包%'

select t3.fnumber,t3.fname,replace(t3.fname,'个包','个套装'),t3.fmodel,t5.FLastModDate
--update t11 set fname=t11.fname +'/套装'
--update t0 set fname=t0.fname +'/套装'
--update t5 set flastmoddate='2016-05-09'
from t_icitem t3
inner join t_ICItemCore t0 on t0.fitemid=t3.fitemid
inner join t_item t11 on t11.fitemid=t0.fitemid
inner join t_item t2 on t2.fitemid=t3.fitemid
left join t_baseproperty t5 on t5.fitemid=t3.fitemid
where t3.f_125 in ( select 编码 from vdbom$ ) --select 编码 from newbom$ union all select 编码 from bom$ union all
and t0.fname not like '%套%'


select t3.fnumber,t3.fshortnumber,t3.fname,t4.fnumber,t4.fshortnumber,t4.fname
from t_icitem t3
inner join t_icitem t4 on t3.fnumber=t4.f_125
order by t3.fnumber





