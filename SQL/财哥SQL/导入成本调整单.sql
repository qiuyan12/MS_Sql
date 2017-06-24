


SET NOCOUNT ON
declare @fplanprice decimal(18,4),@fitemid int,@funitid int,@entryid int,@fqty int
declare @InterID int,@BillNo varchar (20),@StockId int,@StockNumber varchar (20)
DECLARE @TmpID INT 
declare @iLength int
declare @fprojectval  varchar(200)
declare @sDateFormat  varchar(200)
declare @FDCStockID int
declare @FDCSPID int
declare @famount decimal (18,2),@fyear int,@FPeriod int,@fdate datetime

select @fyear=2014,@FPeriod=2,@fdate='2014-02-28'

exec GetICMaxNum 'ICStockBill', @InterID output

-- 10.4
Update t_BillCodeRule Set FReChar = FReChar Where FBillTypeID =100

SET @TmpID = (SELECT FID FROM t_BillCodeRule WITH(READUNCOMMITTED) WHERE fbilltypeid=100 and fprojectid=3)

update t_billcoderule set fprojectval = fprojectval+1,flength=case when (flength-len(fprojectval)) >= 0 then flength else len(fprojectval) end where FID =  @TmpID 
Update ICBillNo Set FCurNo = (select top 1 isnull(fprojectval,1) from t_billcoderule where fprojectid = 3 and fbilltypeid =100) where fbillid = 100

--长度和目前编码
select @fprojectval=(fprojectval-1),@iLength=flength from t_BillCodeRule where fprojectid = 3 and fbilltypeid = 100
  
--日期
--select fprojectval,GetDate() AS DateNow from t_BillCodeRule where fprojectid = 2 and fbilltypeid = 100
  --  sDateFormat = tempRs.Fields("fprojectval")
  --  sDateFormat = Format(DateValue(tempRs.Fields("DateNow")), sDateFormat)

-- 前缀
select @BillNo=fprojectval+left('0000000000',@iLength-(len(@fprojectval)))+@fprojectval from t_BillCodeRule where fprojectid = 1 and fbilltypeid = 100  --@iLength

--update ICBillNo set FCurNo=FCurNo+1 where FBillID=100
--select @BillNo=FPreLetter+CAST(FCurNo as varchar(10)) from ICBillNo where FBillID= 100

INSERT INTO 
ICStockBill(FInterID,FBillNo,FBrNo,FTranType,FCancellation,FStatus,FHookStatus,Fdate,FBillerID,FCheckDate,FMultiCheckLevel1,FMultiCheckDate1,FMultiCheckLevel2,FMultiCheckDate2,FMultiCheckLevel3,FMultiCheckDate3,FMultiCheckLevel4,FMultiCheckDate4,FMultiCheckLevel5,FMultiCheckDate5,FMultiCheckLevel6,FMultiCheckDate6,FDeptID,FEmpID,FBillTypeID,FRefType) 
VALUES (@InterID,@BillNo,'0',100,0,0,0,@fdate,16394,Null,Null,Null,Null,Null,Null,Null,Null,Null,Null,Null,Null,Null,0,0,12542,0)

set @entryid=1

DECLARE authors_cursor CURSOR FOR	
Select t2.FItemID,cast(-t1.FAmount+t2.fplanprice*t1.FQty as decimal(24,2)) famount,t2.fdefaultloc,t2.fspid
from ICAbnormalBalance t1 
Inner join t_ICItem t2  On t1.FItemID = t2.FItemID  
Where t1.FYear=@FYear
And t1.FPeriod=@FPeriod
And NOT (t1.FPrice=0 AND Round(t1.FAmount,2)=0 AND t1.FQty=0) 
and t1.famount<0
Order by t2.FNumber,t2.FModel

OPEN authors_cursor

FETCH NEXT FROM authors_cursor 
INTO @fitemid,@famount,@FDCStockID,@FDCSPID

WHILE @@FETCH_STATUS = 0
BEGIN
        if @entryid=300 
        begin
	          exec GetICMaxNum 'ICStockBill', @InterID output

				-- 10.4
			  Update t_BillCodeRule Set FReChar = FReChar Where FBillTypeID =100

			  SET @TmpID = (SELECT FID FROM t_BillCodeRule WITH(READUNCOMMITTED) WHERE fbilltypeid=100 and fprojectid=3)

			  update t_billcoderule set fprojectval = fprojectval+1,flength=case when (flength-len(fprojectval)) >= 0 then flength else len(fprojectval) end where FID =  @TmpID 
			  Update ICBillNo Set FCurNo = (select top 1 isnull(fprojectval,1) from t_billcoderule where fprojectid = 3 and fbilltypeid =100) where fbillid = 100

				--长度和目前编码
			  select @fprojectval=(fprojectval-1),@iLength=flength from t_BillCodeRule where fprojectid = 3 and fbilltypeid = 100
				  
				--日期
				--select fprojectval,GetDate() AS DateNow from t_BillCodeRule where fprojectid = 2 and fbilltypeid = 100
				  --  sDateFormat = tempRs.Fields("fprojectval")
				  --  sDateFormat = Format(DateValue(tempRs.Fields("DateNow")), sDateFormat)

				-- 前缀
			  select @billno=fprojectval+left('0000000000',@iLength-(len(@fprojectval)))+@fprojectval from t_BillCodeRule where fprojectid = 1 and fbilltypeid = 100  --@iLength

	          --update ICBillNo set FCurNo=FCurNo+1 where FBillID=100
	          --select @BillNo=FPreLetter+CAST(FCurNo as varchar(10)) from ICBillNo where FBillID= 100

			  INSERT INTO 
			  ICStockBill(FInterID,FBillNo,FBrNo,FTranType,FCancellation,FStatus,FHookStatus,Fdate,FBillerID,FCheckDate,FMultiCheckLevel1,FMultiCheckDate1,FMultiCheckLevel2,FMultiCheckDate2,FMultiCheckLevel3,FMultiCheckDate3,FMultiCheckLevel4,FMultiCheckDate4,FMultiCheckLevel5,FMultiCheckDate5,FMultiCheckLevel6,FMultiCheckDate6,FDeptID,FEmpID,FBillTypeID,FRefType) 
			  VALUES (@InterID,@BillNo,'0',100,0,0,0,@fdate,16394,Null,Null,Null,Null,Null,Null,Null,Null,Null,Null,Null,Null,Null,0,0,12542,0)

	          set @entryid=1
	          UPDATE ICStockBill SET FUUID=NEWID() WHERE FInterID=@InterID-1
        end  
        
		INSERT INTO ICStockBillEntry (FInterID,FEntryID,FBrNo,FSourceEntryID,FItemID,FAuxPropID,FBatchNo,FAmount,FKFDate,FKFPeriod,FPeriodDate,FDCStockID,FDCSPID,FNote) 
		VALUES (@InterID,@entryid,'0',0,@fitemid,0,'',@famount,Null,0,Null,@FDCStockID,@FDCSPID,'') 

		set @entryid=@entryid+1

        FETCH NEXT FROM authors_cursor 
        INTO @fitemid,@famount,@FDCStockID,@FDCSPID
END
CLOSE authors_cursor
DEALLOCATE authors_cursor


go




