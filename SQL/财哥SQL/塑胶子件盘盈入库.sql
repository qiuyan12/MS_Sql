

SET NOCOUNT ON
declare @fplanprice decimal(18,4),@fitemid int,@funitid int,@entryid int,@fqty int
declare @InterID int,@BillNo varchar (20),@StockId int,@StockNumber varchar (20)

--exec CheckInventory  --效验即时库存

DECLARE stocks_cursor CURSOR FOR
--select distinct t3.fnumber --分仓盘盈入库
--from t_icitem t1
--inner join poinventory t2 on t1.fitemid=t2.fitemid
--inner join t_stock t3 on t3.fitemid=t2.fstockid
--where t2.fqty<>0 and t2.fstockid=20355 --t1.fnumber like '3.%' and -- select * from t_stock
--and t1.fdeleted=0

select '26' fnumber

OPEN stocks_cursor

FETCH NEXT FROM stocks_cursor 
INTO @StockNumber

WHILE @@FETCH_STATUS = 0
BEGIN
	exec GetICMaxNum 'ICStockBill', @InterID output
	update ICBillNo set FCurNo=FCurNo+1 where FBillID=40
	select @BillNo=FPreLetter+CAST(FCurNo as varchar(10)) from ICBillNo where FBillID= 40
    select @StockId=fitemid from t_stock where fnumber ='26'  --以目标帐套为准
	
	INSERT INTO ICStockBill (FBrNo,FUpStockWhenSave,FStatus,FInterID,FTranType,Fdate,       FDCStockID,      FBillNo,fcheckerid,FFManagerID,FBillerID,FMultiCheckLevel1,FMultiCheckLevel2,FMultiCheckLevel3,FMultiCheckLevel4,FMultiCheckLevel5,FMultiCheckLevel6) 
	                 VALUES ('0',  0,               0,      @InterID,40,       '2013-12-16',@StockId,        @BillNo,0,         17081 ,     16394,'','','','','','')
	
	set @entryid=1

	DECLARE authors_cursor CURSOR FOR	
	select t1.fitemid,sum(t1.fqty) fqty,t1.funitid
	from
	(
--		select t1.fitemid,t2.fqty,t1.funitid
--		from t_icitem t1  
--		inner join poinventory t2 on t1.fitemid=t2.fitemid
--		inner join t_stock t3 on t3.fitemid=t2.fstockid
--		where t1.fshortnumber like '6%' and t2.fstockid=20355 and t3.fnumber=@StockNumber and t2.fqty<>0 
--		union all
--		select t9.fitemid,t2.fqty*t8.fqty,t9.funitid
--		from t_icitem t1  
--		inner join poinventory t2 on t1.fitemid=t2.fitemid 
--		inner join t_stock t3 on t3.fitemid=t2.fstockid
--		inner join icbom t7 on t7.fitemid=t1.fitemid
--		inner join icbomchild t8 on t7.finterid=t8.finterid
--		inner join t_icitem t9 on t9.fitemid=t8.fitemid
--		where t2.fstockid=20355 and t1.fnumber like '1.02.%' and t3.fnumber=@StockNumber and t2.fqty<>0	
		select t2.fitemid,t2.funitid,cast(isnull(t1.数量,0) as decimal(24,4)) fqty 
		from sheet1$ t1 
		inner join t_icitem t2 on t1.代码=t2.fnumber 
		where t1.代码 like '6%' and 数量 not like '%卷%' and t2.fdeleted=0 and cast(isnull(t1.数量,0) as decimal(24,4))>0
	) t1
	group by t1.fitemid,t1.funitid

	OPEN authors_cursor
	
	FETCH NEXT FROM authors_cursor 
	INTO @fitemid ,@fqty,@funitid 
	
	WHILE @@FETCH_STATUS = 0
	BEGIN
        if @entryid=999 
        begin
			exec GetICMaxNum 'ICStockBill', @InterID output
			update ICBillNo set FCurNo=FCurNo+1 where FBillID=40  --select * from icstockbill where ftrantype=40 and fdate='2013-12-16'  select * from icstockbillentry where finterid=54707
			select @BillNo=FPreLetter+CAST(FCurNo as varchar(10)) from ICBillNo where FBillID= 40

			INSERT INTO ICStockBill (FBrNo,FUpStockWhenSave,FStatus,FInterID,FTranType,Fdate,       FDCStockID,      FBillNo,fcheckerid,FFManagerID,FBillerID,FMultiCheckLevel1,FMultiCheckLevel2,FMultiCheckLevel3,FMultiCheckLevel4,FMultiCheckLevel5,FMultiCheckLevel6) 
							 VALUES ('0',  0,               0,      @InterID,40,       '2013-12-16',@StockId,        @BillNo,0,         17081 ,     16394,'','','','','','')
	
			set @entryid=1
			UPDATE ICStockBill SET FUUID=NEWID() WHERE FInterID=@InterID-1
        end  
	        
		INSERT INTO ICStockBillEntry (fdcstockid,FBrNo,FInterID,FEntryID,FSourceEntryID,FItemID,FBatchNo,FQtyMust,FQtyActual,    FUnitID,  FAuxQtyMust,FauxqtyActual,FAuxPlanPrice,Fauxprice,FQty,    FAuxQty,Famount,Fnote,FKFDate,FKFPeriod) 
		VALUES                       (@StockId,  '0',  @InterID,@entryid,0,            @fitemid,'',      0,       @fqty,         @funitid, 0,          @fqty,        0            ,0,        @fqty,   @fqty,      0,      '',   '',     0    ) 

--        if EXISTS (select * from icinventory where fitemid=@fitemid and fstockid=@StockId)
--     	     update icinventory set fqty=fqty+@fqty where fitemid=@fitemid and fstockid=@StockId
--        else  
--            INSERT INTO ICInventory (FBrNo,FItemID,FBatchNo,FStockID,FStockPlaceID,FKFDate,FKFPeriod,FQty,FBal) VALUES ('0',@fitemid,'',@StockId,0,'',0,@fqty,0)

        set @entryid=@entryid+1

        FETCH NEXT FROM authors_cursor 
        INTO @fitemid ,@fqty,@funitid 
	END

	CLOSE authors_cursor
	DEALLOCATE authors_cursor

	FETCH NEXT FROM stocks_cursor 
	INTO @StockNumber
end

CLOSE stocks_cursor
DEALLOCATE stocks_cursor

set nocount off

go

--select * from icinventory where fstockid=39616  update t1 set FUpStockWhenSave=0 from icstockbill t1 where FUpStockWhenSave=1
--delete from icstockbill where finterid=54708 delete from icstockbillentry where finterid=54708
