--select * from t_Supplier
--select * from t_Supply  --truncate table t_Supply
--select * from t_SupplyEntry

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
select @fdate='2014-12-31',@fuserid=16394 

--if update(fcheckerid) and @fcheckerid>0  --select * from t_Supplier
--begin
DECLARE icbom_cursor CURSOR FOR	

select isnull(t1.ftaxprice,0) ftaxprice,(case when t2.ferpclsid=1 then 1 else 0 end) fptype,
--(case when isnull(t3.fcyid,0)=0 then 1 else t3.fcyid end) fcurrency,
t1.FCyID fcurrency,
t1.fprice,t1.FStartQty fstarqty,
t1.fendqty,t1.FRemark fnote,t1.FSupID fsupplyid,t3.fitemid,t3.funitid
from AIS20120820103535.dbo.t_SupplyEntry t1 
inner join AIS20120820103535.dbo.t_icitem t2 on t1.fitemid=t2.fitemid
--inner join t_supplier t3 on t3.fitemid=t1.fsupplyid
inner join t_icitem t3 on t2.fshortnumber=t3.fshortnumber
where left(t2.fnumber,1) in ('1','2','6')
order by t1.FSupID,t1.fitemid

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

	/*
	set @ftempprice=0
	
	select @ftempprice=t3.fprice  
	from (  
		select m1.fitemid,max(fentryid) fentryid  
		from t_SupplyEntry m1  
		inner join t_supplier m2 on m1.FSupID=m2.fitemid  
		where m1.fsupid=@FSupplyId and m1.fitemid=@FItemId  and m1.fptype=@FPType  and m1.fcyid=@fcurrencyid  and m1.fstartqty=@FStartQty  and m1.fendqty= @FEndQty
		group by m1.fitemid  
	) t1  
	inner join t_icitem t2 on t1.fitemid=t2.fitemid  
	inner join t_SupplyEntry t3 on t3.fentryid=t1.fentryid and t1.fitemid=t3.fitemid  
	left join t_supplier t4 on t4.fitemid=t2.fsource  
	LEFT JOIN t_ICItemBase t5 ON t2.FItemID=t5.FItemID  
	where t3.fsupid=@FSupplyId and t3.fitemid=@FItemId  and t3.fptype=@FPType  and t3.fcyid=@fcurrencyid  and t3.fstartqty=@FStartQty  and t3.fendqty=@FEndQty

	if @ftempprice=0 or @ftempprice<>@fprice
	*/

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
	--end