

--如果[收发汇总表]要与[总帐与存货对账表]数据对得上,则收发汇总表过滤条件应该: 1 不包含调拨 2 本期无发生额也显示 


SET NOCOUNT ON

--select * from 
declare @FYear int,@FPeriod int

select @FYear =2015,@FPeriod =9

Create Table #Happen(
        FItemID int Null,
        FStockID int Null,
        FStockPlaceID int Null, 
        FBatchNo Varchar(200),
        FAuxPropID INT NOT NULL DEFAULT(0),
        FBegQty decimal(28,10),
        FBegBal decimal(28,10),
        FInQty  decimal(28,10),
        FInPrice  decimal(28,10),
        FInAmount decimal(28,10),
        FOutQty decimal(28,10),
        FOutPrice  decimal(28,10),
        FOutAmount decimal(28,10),
FInSecQty Decimal(28,10) Default(0),
FOutSecQty Decimal(28,10) Default(0),
FBegSecQty Decimal(28,10) Default(0)) 

Insert Into #Happen
Select  v2.FItemID,v2.FStockID,Isnull(v2.FStockPlaceID,0),v2.FBatchNo,v2.FAuxPropID,
Sum (v2.FBegQty), case when t1.FTrack = 81 Then Sum(Round(v2.FBegBal,2) - Round(v2.FBegDiff,2)) Else Sum(Round(v2.FBegBal,2)) End ,0,0,0,0,0,0,
0,0,Sum(v2.FSecBegQty)
From ICInvbal v2 
Left Join t_ICItem t1  On v2.FItemID=t1.FItemID
Left Join t_Stock t2 On v2.FStockID=t2.FItemID
Left Join t_StockPlace t11 On v2.FStockPlaceID=t11.FSPID
Where v2.FYear=@FYear And v2.FPeriod=@FPeriod
--And t1.FShortNumber>='1082664' And t1. FShortNumber<='1082664'
Group By v2.FItemID,v2.FStockID,v2.FStockPlaceID,v2.FBatchNo,v2.FAuxPropID,t1.FTrack

Insert Into #Happen Select v2.FItemID,t2.FItemID,Isnull(v2.FDCSPID,0),v2.FBatchNo,v2.FAuxPropID,0,0,
Sum(IsNull(v2.FQty,0)),
Case When v1.FTranType In(1,2,5,10,40,100,101,102) And t1.FTrack<>81 Then Max(IsNull(v2.FPrice,0))
When v1.FTranType In(1,2,5,10,40,100,101,102,41) And t1.FTrack=81 Then Max(IsNull(v2.FPlanPrice,0)) 
When v1.FTranType = 41 Then Max(IsNull(v2.FPriceRef,0)) Else 0 End,
Case When v1.FTranType In(1,2,5,10,40,100,101,102) And t1.FTrack<>81 Then  Sum(IsNull(Round(v2.FAmount,2),0))
When v1.FTranType In(1,2,5,10,40,100,101,102,41) And t1.FTrack=81 Then Sum(IsNull(Round(v2.FPlanAmount,2),0))
When v1.FTranType =41 Then Sum(IsNull(Round(v2.FAmtRef,2),0)) Else 0 End ,
0,0,0,Sum(IsNull(v2.FSecQty,0)),0,0
From ICStockBill v1 
Inner Join ICStockBillEntry v2  On v1.FInterID=v2.FInterID
Left Join t_ICItem t1 On v2.FItemID=t1.FItemID
Left Join t_Stock t2 On v2.FDCStockID=t2.FItemID 
Left Join t_StockPlace t11 On v2.FDCSPID=t11.FSPID
Where (v1.FTranType In (1,2,5,10,100,101,102,41) Or (V1.FTranType=100 And V1.FBillTypeID=12542)) 
And year(v1.FDate )=@FYear
And month(v1.FDate )=@FPeriod
--And t1.FShortNumber>='1082664' And t1. FShortNumber<='1082664'
And v1.FCancelLation=0 
Group By v2.FItemID,t2.FItemID,v2.FDCSPID,v2.FBatchNo,v2.FAuxPropID,v1.FTranType,t1.FTrack

Insert Into #Happen Select v2.FItemID,t2.FItemID,Isnull(v2.FDCSPID,0),v2.FBatchNo,v2.FAuxPropID,0,0,
0,0,0,
Sum(IsNull(v2.FQty,0)),
Case When t1.FTrack<>81 Then  Max(IsNull(v2.FPrice,0))
When t1.FTrack=81 Then Max(IsNull(v2.FPlanPrice,0)) Else 0 End,
Case When t1.FTrack<>81 Then  Sum(IsNull(Round(v2.FAmount,2),0))
When t1.FTrack=81 Then Sum(IsNull(Round(v2.FPlanAmount,2),0)) Else 0 End,
0,Sum(IsNull(v2.FSecQty,0)),0
From ICStockBill v1 
Inner Join ICStockBillEntry v2  On v1.FInterID=v2.FInterID
Left Join t_ICItem t1 On v2.FItemID=t1.FItemID
Left Join t_Stock t2 On v2.FDCStockID=t2.FItemID 
Left Join t_StockPlace t11 On v2.FDCSPID=t11.FSPID
Where (v1.FTranType In (21,28,29,43) Or (V1.FTranType=100 And V1.FBillTypeID=12541)) 
And year(v1.FDate )=@FYear
And month(v1.FDate )=@FPeriod
--And t1.FShortNumber>='1082664' And t1. FShortNumber<='1082664'
And v1.FCancelLation=0 
Group By v2.FItemID,t2.FItemID,v2.FDCSPID,v2.FBatchNo,v2.FAuxPropID,v1.FTranType,t1.FTrack

Insert Into #Happen Select v2.FItemID,t2.FItemID,Case When v1.FTranType=41 Then v2.FSCSPID Else v2.FDCSPID End,v2.FBatchNo,v2.FAuxPropID,
0,0,0,0,0,
Sum(IsNull(v2.FQty,0)),
Case When t1.FTrack<>81 Then  Max(IsNull(v2.FPrice,0)) Else Max(IsNull(v2.FPlanPrice,0)) End,
Case When t1.FTrack<>81 Then  Sum(IsNull(Round(v2.FAmount,2),0)) Else Sum(IsNull(Round(v2.FPlanAmount,2),0)) End,
0,0,Sum(IsNull(v2.FSecQty,0))
From ICStockBill v1 
Inner Join ICStockBillEntry v2  On v1.FInterID=v2.FInterID
Left Join t_ICItem t1 On v2.FItemID=t1.FItemID
Left Join t_Stock t2 On v2.FSCStockID=t2.FItemID 
Left Join t_MeasureUnit t3  On t1.FStoreUnitID=t3.FMeasureUnitID
Left Join t_StockPlace t11 On (Case When v1.FTranType=41 Then v2.FSCSPID Else v2.FDCSPID End)=t11.FSPID
Where v1.FTranType In (24,41) 
And year(v1.FDate )=@FYear
And month(v1.FDate )=@FPeriod
--And t1.FShortNumber>='1082664' And t1. FShortNumber<='1082664'
And v1.FCancelLation=0 
Group By v2.FItemID,t2.FItemID,Case When v1.FTranType=41 Then v2.FSCSPID Else v2.FDCSPID End,v2.FBatchNo,v2.FAuxPropID,v1.FTranType,t1.FTrack

Select v1.FItemID,v1.FStockID,v1.FStockPlaceID,v1.FBatchNo,v1.FAuxPropID,
Sum(v1.FBegQty) As FBegQty,Sum(v1.FBegBal) As FBegBal,
Sum(v1.FInQty) As FInQty,Max(v1.FInPrice) As FInPrice,Sum(v1.FInAmount) As FInAmount,
Sum(v1.FOutQty) As FOutQty,Max(v1.FOutPrice) As FOutPrice,Sum(v1.FOutAmount) As FOutAmount,
Sum(v1.FInSecQty) As FInSecQty,Sum(v1.FOutSecQty) As FOutSecQty,Sum(v1.FBegSecQty) As FBegSecQty 
Into #Happen1 
From #Happen v1 
Where 1 = 1
Group By v1.FItemID,v1.FStockID,v1.FStockPlaceID,v1.FBatchNo,v1.FAuxPropID


Create Table #Data(
  FProp824 Varchar(355) null,
     FNumber  Varchar(355) null,
     FShortNumber  Varchar(355) null,
     FName  Varchar(355) null,
     FModel  Varchar(355) null,
     FUnitName  Varchar(355) null,
     FQtyDecimal smallint null, 
     FPriceDecimal smallint null, 
     FBegQty Decimal(28,10),
     FBegPrice Decimal(28,10),
     FBegBal Decimal(28,10),
     FInQty  Decimal(28,10),
     FInPrice  Decimal(28,10),
     FInAmount Decimal(28,10),
     FOutQty Decimal(28,10),
     FOutPrice Decimal(28,10),
     FOutAmount Decimal(28,10),
     FEndQty Decimal(28,10),
     FEndPrice Decimal(28,10),
     FEndAmount Decimal(28,10),
     FSumSort smallint not null Default(0),
     FID int IDENTITY,
FBegSecQty Decimal(28,10) Default(0),FInSecQty Decimal(28,10) Default(0),
FOutSecQty Decimal(28,10) Default(0),
FBalSecQty Decimal(28,10) Default(0))

Insert Into #Data 
Select Case When   Grouping(FNumber)=1 THEN '合计'
When   Grouping(FICItemNumber)=1 THEN  CONVERT(Varchar(355),FNumber)+'(小计)' 
Else CONVERT(Varchar(355),FNumber) END, 
FICItemNumber,'','','','',6,4,sum(FBegQty),case when sum(FBegQty) <> 0 then sum(FBegBal)/sum(FBegQty) else 0 end,sum(FBegBal),sum(FInQty),case when sum(FInQty) <> 0 
then sum(FInAmount)/ sum(FInQty) else 0 end,sum(FInAmount),sum(FOutQty)
,case when sum(FOutQty) <> 0 then sum(FOutAmount)/sum(FOutQty) Else 0 end,sum(FOutAmount),sum(FEndQty),case when sum(FEndQty)<>0 then sum(FEndAmount)/sum(FEndQty) 
else 0 end,sum(FEndAmount),
Case When Grouping(FNumber)=1 THEN 101
When  Grouping(FICItemNumber)=1 THEN 102 Else 0 END, 
Sum (FBegSecQty), Sum(FInSecQty), Sum(FOutSecQty), Sum(FBalSecQty) 
FROM 
( 
	Select tt2.FNumber,t1.FNumber FICItemNumber,
	'' as col1,'' as col2,'' as col3,'' as col4,6 as col5,4 as col6,
	SUM(ISNULL(v2.FBegQty,0)) as FBegQty,Case When SUM(ISNULL(v2.FBegQty,0))<>0 then SUM(ISNULL(FBegBal,0))/SUM(cast(ISNULL(FBegQty,0) as Decimal(28,10))) Else 0 End as 
	FBegPrice,
	SUM(ISNULL(v2.FBegBal,0)) as FBegBal,SUM(ISNULL(FInQty,0)) as FInQty,Case When SUM(ISNULL(FInQty,0))<>0 Then SUM(ISNULL(FInAmount,0))/SUM(cast(FInQty as 
	Decimal(28,10))) Else 0 End as FInPrice,
	SUM(ISNULL(FInAmount,0)) as FInAmount,SUM(ISNULL(FOutQty,0)) as FOutQty, Case When SUM(ISNULL(FOutQty,0))<>0 Then SUM(ISNULL(FOutAmount,0))/SUM(cast(ISNULL(FOutQty,0) 
	as Decimal(28,10))) Else 0 End as FOutPrice,
	SUM(ISNULL(FOutAmount,0)) as FOutAmount,SUM(ISNULL(FBegQty,0))+SUM(ISNULL(FInQty,0))-SUM(ISNULL(FOutQty,0)) as FEndQty,
	Case When SUM(ISNULL(FBegQty,0))+SUM(ISNULL(FInQty,0))-SUM(ISNULL(FOutQty,0))<>0 Then cast((SUM(ISNULL(FBegBal,0))+SUM(ISNULL(FInAmount,0))-SUM(ISNULL(FOutAmount,0))) 
	as Decimal(28,10))/cast((SUM(ISNULL(FBegQty,0))+SUM(ISNULL(FInQty,0))-SUM(ISNULL(FOutQty,0))) as Decimal(28,10)) Else 0 End as FEndPrice,
	Sum(ISNULL(FBegBal,0))+Sum(ISNULL(FInAmount,0))-Sum(ISNULL(FOutAmount,0)) as FEndAmount, 0 as FSumSort 
	,Sum(ISNULL(v2.FBegSecQty,0)) as FBegSecQty,Sum(ISNULL(v2.FInSecQty,0)) as FInSecQty,Sum(ISNULL(v2.FOutSecQty,0)) as 
	FOutSecQty,Sum(ISNULL(v2.FBegSecQty,0))+Sum(ISNULL(v2.FInSecQty,0))-Sum(ISNULL(v2.FOutSecQty,0)) as FBalSecQty
	From #Happen1 v2
	Inner Join t_ICItem t1 On v2.FItemID=t1.FItemID
	Left Join t_Stock t2 On v2.FStockID=t2.FItemID
	Left Join t_AuxItem ta On v2.FAuxPropID=ta.FItemID
	Left Join t_Account tt2 On t1.FAcctID=tt2.FAccountID
	Where 1=1  
	GROUP BY tt2.FNumber,t1.FNumber 
) t GROUP BY FNumber,FICItemNumber WITH ROLLUP  

Update t1 Set t1.FName=t2.FName,t1.FShortNumber=t2.FShortNumber,t1.FModel=t2.FModel,
t1.FUnitName=t3.FName,t1.FQtyDecimal=t2.FQtyDecimal,t1.FPriceDecimal=t2.FPriceDecimal
From #DATA t1 Left Join t_ICItem t2 On t1.FNumber = t2.FNumber 
Left Join t_MeasureUnit t3 On t2.FUnitID=t3.FMeasureUnitID 
Where t3.FStandard=1

update #data set FshortNumber = '合计' where fnumber = '合计'

Select t.fprop824 科目代码,t2.fname 科目名称,t.fshortnumber 物料编码,t.fname 物料名称,t.funitname 单位,
t.fbegqty 期初数量,t.fbegprice 期初单价,t.fbegbal 期初余额,
t.finqty 入库数量,t.finprice 入库单价,t.finamount 入库金额,
t.foutqty 出库数量,t.foutprice 出库单价,t.foutamount 出库金额,
t.fendqty 结存数量,t.fendprice 结存单价,t.fendamount 结存金额--,t.*,tm.FName As FSecUnitName 
From #Data t
Left Join t_ICItem ti On t.FNumber=ti.FNumber
Left Join t_MeasureUnit tm On ti.FSecUnitID=tm.FMeasureUnitID
inner join t_account t2 on t2.fnumber=t.fprop824
where Not (FBegQty=0 and  FBegBal=0 and FInQty=0 and  FInAmount=0 and FOutQty=0 and FOutAmount=0) 
Order by t.FID 

Drop Table #Data  

Drop Table #Happen
Drop Table #Happen1

SET NOCOUNT OFF