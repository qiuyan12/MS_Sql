set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go


--my_p_BomBachChange 1035,16394,''

ALTER procedure [dbo].[my_p_BomBachChange](@finterid int,@UserId int,@errorinfo varchar(500) output)
as
SET NOCOUNT ON
declare @fplanprice decimal(18,4),@fitemid int,@fpitemid int,@funitid int,@entryid int,@fqty decimal(24,4)
declare @InterID int,@BillNo varchar (20),@StockId int,@StockNumber varchar (20)
DECLARE @TmpID INT ,@ftype varchar(500)
declare @iLength int,@fcheckerid int
declare @fprojectval  varchar(200)
declare @sDateFormat  varchar(200)
declare @fsourceNumber varchar(200),@fpSourceNumber varchar(200),@fpXxSourceNumber varchar(200)
declare @fXxOldSourceNumber varchar(200)
declare @FStockID int,@xx_FItemIDOld int,@fxxitemid int
declare @FDCSPID int,@fbominterid int,@folditemid int,@foldqty decimal(24,4),@foldpositionno varchar(20)
declare @fpositionno varchar(20),@fnewitemid int
declare @famount decimal (18,2),@foldentryid int
declare @fsourceInterid int,@fsourceEntryid int
declare @ftargetInterid int,@ftargetEntryid int
declare @fsourceitemid int,@ftargetitemid int
declare @fsourceshortnumber varchar(50),@ftargetshortnumber varchar(50)
declare @fsourcebillno varchar(50),@fiscanconfig int,@fbackflush int

select @fsourcebillno=fbillno from mybombachchange where finterid=@finterid

--AIS20041229163526   AIS20080129143619

set @errorinfo=''

DECLARE icbom_cursor CURSOR FOR	
select isnull(t5.fcheckerid,0) fcheckerid,t12.fbominterid,isnull(t2.fitemid,0) folditemid,
isnull(t3.fitemid,0) fnewitemid,isnull(t12.fpositionno,'') fpositionno,
isnull(round(t12.fqty,t3.fqtydecimal),0) fqty,--数量精度以新物料为准
t12.ftype,isnull(t12.funitid,0) funitid,t1.fbillno,t12.fstockid,
isnull(t12.fiscanconfig,1059) fiscanconfig,isnull(t12.fbackflush,1059) fbackflush
from mybombachchange t1
inner join mybombachchangeentry t12 on t1.finterid=t12.finterid
left join t_icitem t2 on t12.folditemid=t2.fitemid
left join t_icitem t3 on t12.fnewitemid=t3.fitemid
inner join t_icitem t4 on t12.fitemid=t4.fitemid
inner join icbom t5 on t5.finterid=t12.fbominterid
where t1.finterid=@finterid
and t12.ftype not like '%错误%'
order by t4.fnumber

OPEN icbom_cursor

FETCH NEXT FROM icbom_cursor 
INTO @fcheckerid,@fbominterid,@folditemid,@fnewitemid,@fpositionno,@fqty,@ftype,@funitid,@BillNo,@FStockID,@fiscanconfig,@fbackflush

WHILE @@FETCH_STATUS = 0
BEGIN 
	if (Charindex('替换',@ftype)<>0) or (Charindex('更改',@ftype)<>0)
	begin
		update icbomchild set fbackflush=@fbackflush,fitemid=@fnewitemid,fqty=@fqty,fauxqty=@fqty,fpositionno=@fpositionno, fentryselfz0141=@BillNo,fentryselfz0140=@fiscanconfig,fstockid=@FStockID,funitid=@funitid where finterid=@fbominterid and fitemid=@folditemid
	end 

	if Charindex('新增',@ftype)<>0
	begin
		select @entryid=max(fentryid)+1 from icbomchild where finterid=@fbominterid
	 
		INSERT INTO ICBomChild(FInterID,      FEntryID,FBrNo,fpositionno,    FItemID,    FMachinePos,FNote,FAuxQty, FScrap,FOffSetDay,FUnitID, FQty, FMaterielType, FMarshalType,FBeginDay,   FEndDay,     FPercent,FItemSize,FItemSuite,FOperSN,FOperID,FBackFlush,       FStockID, FSPID,FNote1,FNote2,FAuxPropID,FNote3, fentryselfz0141, fentryselfz0140) 
		select		           @fbominterid,  @entryid,'0',  @fpositionno,   @fnewitemid,'',         '' ,  @fqty,   0,     0,         @FUnitID,@fqty,371,           385,         '1900-01-01','2100-01-01',100,     '',       '',        0,      0,      @fbackflush,      @FStockID,0,    '',    '',    0,         '',     @BillNo,         @fiscanconfig
	end 

	if Charindex('删除',@ftype)<>0
	begin
		select top 1 @foldentryid=fentryid from icbomchild where finterid=@fbominterid and fitemid=@folditemid
		delete from icbomchild where finterid=@fbominterid and fitemid=@folditemid
		update icbomchild set fentryid=fentryid-1 where finterid=@fbominterid and fentryid>@foldentryid   --重新更新分录
	end 

	Update t1 set t1.FQty=cast(t1.FAuxQty as decimal(28,15)) * cast( isnull(t3.FCoefficient,1)  + cast(isnull(t3.FScale,0) as float) as decimal(28,15) )
	from ICBOMChild  t1,t_MeasureUnit t3
	Where t3.FItemID = t1.FUnitID and t1.FInterID=@fbominterid
	
	update icbom set FOperatorID=@UserId,FEnterTime=getdate() where finterid=@fbominterid 

	if @fcheckerid>0 --如果BOM已经审核，则触发BOM的触发器
	begin
	    update icbom set fstatus=0 where finterid=@fbominterid  
		update icbom set fstatus=1 where finterid=@fbominterid 
		update icbom set fcheckerid=0 where finterid=@fbominterid  
		update icbom set fcheckerid=@fcheckerid where finterid=@fbominterid  
	end

	INSERT INTO t_Log (FDate,FUserID,FFunctionID,FStatement,FDescription,FMachineName,FIPAddress) VALUES (getdate(),@UserId,'K010001',3,'编号为'+@BillNo+'的单据更新成功','KSW118','192.168.0.159')

	FETCH NEXT FROM icbom_cursor 
    	INTO @fcheckerid,@fbominterid,@folditemid,@fnewitemid,@fpositionno,@fqty,@ftype,@funitid,@BillNo,@FStockID,@fiscanconfig,@fbackflush
END

CLOSE icbom_cursor
DEALLOCATE icbom_cursor



