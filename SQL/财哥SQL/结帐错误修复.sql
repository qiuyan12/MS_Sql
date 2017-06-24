
--select * from POInvBal where fyear=2014 and fperiod in (11,12)
delete from POInvBal where fyear=2014 and fperiod in (11,12)

insert into POInvBal(FBrNo,FYear,FPeriod,FItemID,FStockID,FBatchNo,FAuxPropID,FBegQty,FSecBegQty,FSPID,FKFPeriod,FKFDate)
select FBrNo,2014,11,FItemID,FStockID,FBatchNo,FAuxPropID,FEndQty,FSecEndQty,FSPID,FKFPeriod,FKFDate
From POInvBal
Where FPeriod = 10
and FYear=2014


create table #POInvBal
(FItemID int not null ,
FStockID int not null ,
FBatchNo varchar(255) not null default '',
FAuxPropID varchar(255) not null default '',
FSPID int not null default(0),
FKFPeriod int not null default(0),
FKFDate varchar(20) not null,
FBegQty decimal(28,10) not null default(0),
FSecBegQty decimal(28,10) not null default(0),
FReceive decimal(28,10) not null default(0),
FSecReceive decimal(28,10) not null default(0),
FSend decimal(28,10) not null default(0),
FSecSend decimal(28,10) not null default(0))

insert into #POInvBal(FItemID,FStockID,FBatchNo,FAuxPropID,FBegQty,FSecBegQty,FSPID,FKFPeriod,FKFDate)
select FItemID,FStockID,FBatchNo,FAuxPropID,isnull(FBegQty,0),isnull(FSecBegQty,0),FSPID,FKFPeriod,FKFDate
From POInvBal
Where FPeriod = 11
and FYear=2014

insert into #POInvBal(FItemID,FStockID,FBatchNo,FAuxPropID,FReceive,FSecReceive,FSPID,FKFPeriod,FKFDate)
select t2.FItemID,t2.FStockID,t2.FBatchNo,t2.FAuxPropID,t2.FQty,t2.FSecQty,IsNull(t2.FDCSPID,0),t2.FKFPeriod,isnull(convert(varchar(10),t2.FKFDate,120),'')
from POInstock t1,POInstockEntry t2,t_Stock t3
where t1.FDate>='2014-11-01' and t1.FDate<'2014-12-01' and t1.FTranType=72
and t1.FCheckerID<>0 and t1.FInterID=t2.FInterID and t2.FStockID=t3.FItemID
and t3.FTypeID in(501,502,503)
And t1.FCancellation=0 and t1.FStatus>0

insert into #POInvBal(FItemID,FStockID,FBatchNo,FAuxPropID,FReceive,FSecReceive,FSPID,FKFPeriod,FKFDate)
select t2.FItemID,t2.FDCStockID,t2.FBatchNo,t2.FAuxPropID,t2.FQty,t2.FSecQty,IsNull(t2.FDCSPID,0),t2.FKFPeriod,isnull(convert(varchar(10),t2.FKFDate,120),'')
from ZPStockBill t1,ZPstockBillEntry t2,t_Stock t3
where t1.FDate>='2014-11-01' and t1.FDate<'2014-12-01' and t1.FTranType=6
and t1.FCheckerID<>0 and t1.FInterID=t2.FInterID and t2.FDCStockID=t3.FItemID
and t3.FTypeID in(501,502,503)
And t1.FCancellation=0 and t1.FStatus>0

insert into #POInvBal(FItemID,FStockID,FBatchNo,FAuxPropID,FSend,FSecSend,FSPID,FKFPeriod,FKFDate)
select t2.FItemID,t2.FDCStockID,t2.FBatchNo,t2.FAuxPropID,t2.FQty,t2.FSecQty,IsNull(t2.FDCSPID,0),t2.FKFPeriod,isnull(convert(varchar(10),t2.FKFDate,120),'')
from ZPStockBill t1,ZPstockBillEntry t2,t_Stock t3
where t1.FDate>='2014-11-01' and t1.FDate<'2014-12-01' and t1.FTranType=26
and t1.FCheckerID<>0 and t1.FInterID=t2.FInterID and t2.FDCStockID=t3.FItemID
and t3.FTypeID in(501,502,503)
And t1.FCancellation=0 and t1.FStatus>0

insert into #POInvBal(FItemID,FStockID,FBatchNo,FAuxPropID,FSend,FSecSend,FSPID,FKFPeriod,FKFDate)
select t2.FItemID,t5.FDCStockID ,t5.FBatchNo,t5.FAuxPropID,t2.FQty,t2.FSecQty,IsNull(t5.FDCSPID,0),t5.FKFPeriod,isnull(convert(varchar(10),t5.FKFDate,120),'')
from ICStockBill t1,ICStockBillEntry t2,ZPStockBill t3,ZPStockBillEntry t5,t_Stock t4
where t1.FDate>='2014-11-01' and t1.FDate<'2014-12-01'
and t1.FInterID=t2.FInterID and t2.FSourceInterID=t3.FInterID and t2.FSourceTranType = 6 
and t3.FInterID=t5.FInterID and t2.FSourceEntryID=t5.FEntryID
and t5.FDCStockID=t4.FItemID and t4.FTypeID in(501,502,503)
and t1.FTranType =10 
And t3.FCancellation=0 and t3.FStatus>0
And t1.FCancellation=0 

insert into #POInvBal(FItemID,FStockID,FBatchNo,FAuxPropID,FSend,FSecSend,FSPID,FKFPeriod,FKFDate)
select t2.FItemID,t5.FStockID ,t5.FBatchNo ,t5.FAuxPropID,t2.FQty,t2.FSecQty,IsNull(t5.FDCSPID,0),t5.FKFPeriod,isnull(convert(varchar(10),t5.FKFDate,120),'')
from ICStockBill t1,ICStockBillEntry t2,POInstock t3,POInstockEntry t5,t_Stock t4
where t1.FDate>='2014-11-01' and t1.FDate<'2014-12-01'
and t1.FInterID=t2.FInterID and t2.FSourceInterID=t3.FInterID and t2.FSourceTranType in (72,73,702) 
and t3.FInterID=t5.FInterID and t2.FSourceEntryID=t5.FEntryID
and t5.FStockID=t4.FItemID and t4.FTypeID in(501,502,503)
and t1.FTranType in(1,10)
And t3.FCancellation=0 and t3.FStatus>0
And t1.FCancellation=0 

insert into #POInvBal(FItemID,FStockID,FBatchNo,FAuxPropID,FSend,FSecSend,FSPID,FKFPeriod,FKFDate)
select t2.FItemID,t2.FSCStockID,t2.FBatchNo,t2.FAuxPropID,t2.FQty,t2.FSecQty,IsNull(t2.FSCSPID,0),t2.FKFPeriod,isnull(convert(varchar(10),t2.FKFDate,120),'')
from POStockBill t1,POStockBillEntry t2,t_Stock t4
where t1.FDate>='2014-11-01' and t1.FDate<'2014-12-01'
and t1.FInterID=t2.FInterID and t1.FTranType=74 
and t2.FSCStockID=t4.FItemID and t4.FTypeID in(501,502,503)
And t1.FCancellation=0 and t1.FStatus>0

insert into #POInvBal(FItemID,FStockID,FBatchNo,FAuxPropID,FReceive,FSecReceive,FSPID,FKFPeriod,FKFDate)
select t2.FItemID,t2.FDCStockID ,t2.FBatchNo ,t2.FAuxPropID,t2.FQty,t2.FSecQty,IsNull(t2.FDCSPID,0),t2.FKFPeriod,isnull(convert(varchar(10),t2.FKFDate,120),'')
from POStockBill t1,POStockBillEntry t2,t_Stock t4
where t1.FDate>='2014-11-01' and t1.FDate<'2014-12-01'
and t1.FInterID=t2.FInterID and t1.FTranType=74 
and t2.FDCStockID=t4.FItemID and t4.FTypeID in(501,502,503)
And t1.FCancellation=0 and t1.FStatus>0

insert into #POInvBal(FItemID,FStockID,FBatchNo,FAuxPropID,FSend,FSecSend,FSPID,FKFPeriod,FKFDate)
select t2.FItemID,t2.FStockID,t2.FBatchNo,t2.FAuxPropID,t2.FQty,t2.FSecQty,IsNull(t2.FDCSPID,0),t2.FKFPeriod,isnull(convert(varchar(10),t2.FKFDate,120),'')
from POInstock t1,POInstockEntry t2,t_Stock t3
where t1.FDate>='2014-11-01' and t1.FDate<'2014-12-01' and t1.FTranType=73
and t1.FCheckerID<>0 and t1.FInterID=t2.FInterID and t2.FStockID=t3.FItemID
and t3.FTypeID in(501,502,503)
And t1.FCancellation=0 and t1.FStatus>0

insert into #POInvBal(FItemID,FStockID,FBatchNo,FAuxPropID,FReceive,FSecReceive,FSPID,FKFPeriod,FKFDate)
select t2.FItemID,t2.FDCStockID,t2.FBatchNo,t2.FAuxPropID,t2.FQty,t2.FSecQty,IsNull(t2.FDCSPID,0),t2.FKFPeriod,isnull(convert(varchar(10),t2.FKFDate,120),'')
from ICSTJGBill t1,ICSTJGBillEntry t2,t_Stock t3
where t1.FDate>='2014-11-01' and t1.FDate<'2014-12-01' and t1.FTranType=92
and t1.FCheckerID<>0 and t1.FInterID=t2.FInterID and t2.FDCStockID=t3.FItemID
and t3.FTypeID in(501,502,503)
And t1.FCancellation=0 and t1.FStatus>0

insert into #POInvBal(FItemID,FStockID,FBatchNo,FAuxPropID,FReceive,FSecReceive,FSPID,FKFPeriod,FKFDate)
select t2.FItemID,t2.FStockID,t2.FBatchNo,t2.FAuxPropID,t2.FQty,t2.FSecQty,IsNull(t2.FDCSPID,0),t2.FKFPeriod,isnull(convert(varchar(10),t2.FKFDate,120),'')
from POInStock t1,POInStockEntry t2,t_Stock t3
where t1.FDate>='2014-11-01' and t1.FDate<'2014-12-01' and t1.FTranType=702
and t1.FCheckerID<>0 and t1.FInterID=t2.FInterID and t2.FStockID=t3.FItemID
and t3.FTypeID in(501,502,503)
And t1.FCancellation=0 and t1.FStatus>0

insert into #POInvBal(FItemID,FStockID,FBatchNo,FAuxPropID,FSend,FSecSend,FSPID,FKFPeriod,FKFDate)
select t2.FItemID,t2.FSCStockID,t2.FBatchNo,t2.FAuxPropID,t2.FQty,t2.FSecQty,IsNull(t2.FDCSPID,0),t2.FKFPeriod,isnull(convert(varchar(10),t2.FKFDate,120),'')
from ICSTJGBill t1,ICSTJGBillEntry t2,t_Stock t3
where t1.FDate>='2014-11-01' and t1.FDate<'2014-12-01' and t1.FTranType=137
and t1.FCheckerID<>0 and t1.FInterID=t2.FInterID and t2.FSCStockID=t3.FItemID
and t3.FTypeID in(501,502,503)
And t1.FCancellation=0 and t1.FStatus>0
delete t1 from POInvBal t1,t_ICItem t2
Where FPeriod = 11 And FYear = 2014
 AND t1.FItemID=t2.FItemID
 

insert into POInvBal(FBrNo,FYear,FPeriod,FItemID,FStockID,FBatchNo,FAuxPropID,FSPID,FKFPeriod,FKFDate,FBegQty,FSecBegQty,FReceive,FSecReceive,FSend,FSecSend)
select '0',2014,11,FItemID,FStockID,FBatchNo,FAuxPropID,FSPID,FKFPeriod,FKFDate,Sum (FBegQty),Sum (FSecBegQty), Sum(FReceive),Sum(FSecReceive), sum(FSend),sum(FSecSend)
from  #POInvBal
group by FStockID,FItemID,FBatchNo,FAuxPropID,FSPID,FKFPeriod,FKFDate


update POInvBal set FEndQty=FBegQty+FReceive-FSend,
FSecEndQty=FSecBegQty+FSecReceive-FSecSend
Where FPeriod = 11
and FYear=2014

insert into POInvBal(FBrNo,FYear,FPeriod,FItemID,FStockID,FBatchNo,FAuxPropID,FBegQty,FSecBegQty,FSPID,FKFPeriod,FKFDate)
select FBrNo,2014,12,FItemID,FStockID,FBatchNo,FAuxPropID,FEndQty,FSecEndQty,FSPID,FKFPeriod,FKFDate
From POInvBal
Where FPeriod = 11
and FYear=2014

drop  table #POInvBal




