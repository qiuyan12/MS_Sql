

Set NoCount On
Create Table #Data2( 
FItemID Int Null,
FCustID Int Null, 
FDeptID Int Null, 
FEmpID  Int Null, 
FQtySale Decimal(28,10) Default(0),
FIncomeSale Decimal(28,10) Default(0),
FQtySend Decimal(28,10) Default(0), 
FCostSale Decimal(28,10) Default(0)  )

Insert Into #Data2(FItemID,FCustID,FDeptID,FEmpID,FQtySend,FCostSale) 

Select v2.FItemID, v1.FSupplyID,v1.FDeptID, v1.FEmpID,v2.FQty,v2.FAmount
From ICStockBill v1
Inner Join ICStockBillEntry v2 On v1.FInterID = v2.FInterID
Inner Join t_ICItem t1 On v2.FItemID = t1.FItemID
Left Join t_Organization t2 On v1.FSupplyID=t2.FItemID
Left Join t_Department TD On v1.FDeptID = TD.FItemID
Left Join t_Emp TE On v1.FEmpID=TE.FItemID
Where  v1.FSaleStyle<>20296 And v1.FTranType=21
And v1.FCancelLation=0    And Convert(datetime,Convert(VarChar(30),v1.FDate,111)) >='2017-02-01'
And Convert(datetime,Convert(VarChar(30),v1.FDate,111)) <='2017-02-28'  



Insert Into #Data2(FItemID,FCustID,FDeptID,FEmpID,FQtySend,FCostSale) 

Select v2.FItemID, v1.FSupplyID,v1.FDeptID,v1.FEmpID, v2.FQty,Case FTranType When 76 Then (v2.FStdAmount-v2.FStdTaxAmount) Else v2.FStdAmount  End
From ICPurchase v1
Inner Join ICPurchaseEntry v2 On v1.FInterID = v2.FInterID
Inner Join t_ICItem t1 On v2.FItemID = t1.FItemID
Left Join t_Supplier t2 On v1.FSupplyID=t2.FItemID
Left Join t_Department TD On v1.FDeptID = TD.FItemID
Left Join t_Emp TE On v1.FEmpID=TE.FItemID
Where  v1.FPOStyle=20300 And v1.FSubSystemID In (-1,0)
And v1.FCancelLation=0    And Convert(datetime,Convert(VarChar(30),v1.FDate,111)) >='2017-02-01'
And Convert(datetime,Convert(VarChar(30),v1.FDate,111)) <='2017-02-28'  



Insert Into #Data2(FItemID,FCustID,FDeptID,FEmpID,FQtySale,FIncomeSale) 
Select v2.FItemID,v1.FCustID,v1.FDeptID,v1.FEmpID,v2.FQty,Round(Case v1.FTranType When 80 Then v2.FAmount * (IsNull(v1.FExchangeRate,1)+0.0000000001) Else (v2.FAmount - v2.FTaxAmount)* (IsNull(v1.FExchangeRate,1)+0.0000000001)  End,2)
From  ICSale v1
Inner Join ICSaleEntry v2 On v1.FInterID = v2.FInterID
Inner Join t_ICItem t1 On v2.FItemID = t1.FItemID
Left Join t_Organization t2 On v1.FCustID=t2.FItemID
Left Join t_Department TD On v1.FDeptID = TD.FItemID
Left Join t_Emp TE On v1.FEmpID=TE.FItemID
Where v1.FTranType in (80,86) 
And v1.FCancelLation=0    And Convert(datetime,Convert(VarChar(30),v1.FDate,111)) >='2017-02-01'
And Convert(datetime,Convert(VarChar(30),v1.FDate,111)) <='2017-02-28'  




CREATE TABLE #ItemLevel( 
FNumber1 Varchar(355),
FName1 Varchar(355),
FNumber2 Varchar(355),
FName2 Varchar(355),
FNumber3 Varchar(355),
FName3 Varchar(355),
FNumber4 Varchar(355),
FName4 Varchar(355),
FNumber5 Varchar(355),
FName5 Varchar(355),
FNumber6 Varchar(355),
FName6 Varchar(355),
FItemID int,
FNumber VARCHAR(355))

Insert Into #ItemLevel SELECT  
Case When CharIndex('.',FFullNumber)-1= -1 or FLevel<2 THEN NULL ELSE SUBSTRING(FNumber, 1,CharIndex('.',FFullNumber)-1)  END, 
'',
Case When CharIndex('.',FFullNumber,CharIndex('.',FFullNumber)+1)-1= -1 or FLevel<3 THEN NULL ELSE SUBSTRING(FNumber, 1,CharIndex('.',FFullNumber,CharIndex('.',FFullNumber)+1)-1)  END, 
'',
Case When CharIndex('.',FFullNumber,CharIndex('.',FFullNumber,CharIndex('.',FFullNumber)+1)+1)-1= -1 or FLevel<4 THEN NULL ELSE SUBSTRING(FNumber, 1,CharIndex('.',FFullNumber,CharIndex('.',FFullNumber,CharIndex('.',FFullNumber)+1)+1)-1)  END, 
'',
Case When CharIndex('.',FFullNumber,CharIndex('.',FFullNumber,CharIndex('.',FFullNumber,CharIndex('.',FFullNumber)+1)+1)+1)-1= -1 or FLevel<5 THEN NULL ELSE SUBSTRING(FNumber, 1,CharIndex('.',FFullNumber,CharIndex('.',FFullNumber,CharIndex('.',FFullNumber,CharIndex('.',FFullNumber)+1)+1)+1)-1)  END, 
'',
Case When CharIndex('.',FFullNumber,CharIndex('.',FFullNumber,CharIndex('.',FFullNumber,CharIndex('.',FFullNumber,CharIndex('.',FFullNumber)+1)+1)+1)+1)-1= -1 or FLevel<6 THEN NULL ELSE SUBSTRING(FNumber, 1,CharIndex('.',FFullNumber,CharIndex('.',FFullNumber,CharIndex('.',FFullNumber,CharIndex('.',FFullNumber,CharIndex('.',FFullNumber)+1)+1)+1)+1)-1)  END, 
'',
Case When CharIndex('.',FFullNumber,CharIndex('.',FFullNumber,CharIndex('.',FFullNumber,CharIndex('.',FFullNumber,CharIndex('.',FFullNumber,CharIndex('.',FFullNumber)+1)+1)+1)+1)+1)-1= -1 or FLevel<7 THEN NULL ELSE SUBSTRING(FNumber, 1,CharIndex('.',FFullNumber,CharIndex('.',FFullNumber,CharIndex('.',FFullNumber,CharIndex('.',FFullNumber,CharIndex('.',FFullNumber,CharIndex('.',FFullNumber)+1)+1)+1)+1)+1)-1)  END, 
'',
FItemID,FNumber From t_Item
Where FItemClassID=4
AND FDetail=1  And  FItemID In (Select Distinct  FItemID  From #Data2 )

Update t0 SET t0.FName1=t1.FName,t0.FName2=t2.FName,t0.FName3=t3.FName,t0.FName4=t4.FName,t0.FName5=t5.FName,t0.FName6=t6.FName
From #ItemLevel t0 left join t_Item t1 On t0.FNumber1=t1.FNumber  AND t1.FItemClassID=4 AND t1.FDetail=0 
left join t_Item t2 On t0.FNumber2=t2.FNumber  AND t2.FItemClassID=4 AND t2.FDetail=0 
left join t_Item t3 On t0.FNumber3=t3.FNumber  AND t3.FItemClassID=4 AND t3.FDetail=0 
left join t_Item t4 On t0.FNumber4=t4.FNumber  AND t4.FItemClassID=4 AND t4.FDetail=0 
left join t_Item t5 On t0.FNumber5=t5.FNumber  AND t5.FItemClassID=4 AND t5.FDetail=0 
left join t_Item t6 On t0.FNumber6=t6.FNumber  AND t6.FItemClassID=4 AND t6.FDetail=0 

Create Table #Data(
FCustName VarChar(355) Null,
FName1 VarChar(355) Null,
FName2 VarChar(355) Null,
FName3 VarChar(355) Null,
FName4 VarChar(355) Null,
FName5 VarChar(355) Null,
FName6 VarChar(355) Null,
FNumber  VarChar(355) Null,
FShortNumber  VarChar(355) Null,
FName  VarChar(355) Null,
FModel  VarChar(355) Null,
FUnitName  VarChar(355) Null,
FQtyDecimal SmallInt Null, 
FPriceDecimal SmallInt Null, 
FQtySale Decimal(28,10),
FIncomeSale Decimal(28,10),
FQtySend Decimal(28,10),
FCostSale Decimal(28,10),
FProfit Decimal(28, 10),
FCUUnitName  VarChar(355) Null,
FCUUnitQtySale Decimal(28,10),
FCUUnitQtySend Decimal(28,10),
FUnitCost Decimal(28,10),
FSumSort  SmallInt Not Null Default 0,
FID Int IDENTITY 
)

Insert Into #Data 
Select  t2.FName,tt1.FName1,tt1.FName2,tt1.FName3,tt1.FName4,tt1.FName5,tt1.FName6,t1.FNumber,'','','','',Max(t1.FQtyDecimal),
Max(t1.FPriceDecimal),Sum(IsNull(v1.FQtySale,0)),Sum(Round(v1.FIncomeSale,2)), Sum(IsNull(v1.FQtySend,0)),Sum(IsNull(v1.FCostSale,0)),
Sum(v1.FIncomeSale)-Sum(v1.FCostSale) , 
'', Sum(IsNull(v1.FQtySale,0)/(Case When IsNull(t3.FCoefficient,0)=0 Then 1 Else t3.FCoefficient End )) , 
Sum(IsNull(v1.FQtySend,0)/(Case When IsNull(t3.FCoefficient,0)=0 Then 1 Else t3.FCoefficient End )) , 
0, Case  When   Grouping(t2.FName)=1 Then 101   When   Grouping(tt1.FName1)=1 Then 106
When   Grouping(tt1.FName2)=1 Then 107
When   Grouping(tt1.FName3)=1 Then 108
When   Grouping(tt1.FName4)=1 Then 109
When   Grouping(tt1.FName5)=1 Then 110
When   Grouping(tt1.FName6)=1 Then 111
When   Grouping(t1.FNumber)=1 Then 112  Else   0 End 
From  #Data2 v1 Join  t_ICItem t1 On v1.FItemID=t1.FItemID
Left Join t_Organization t2 On v1.FCustID=t2.FItemID
Left Join t_MeasureUnit t3 On t1.FSaleUnitID = t3.FMeasureUnitID
Join #ItemLevel tt1 On t1.FItemID=tt1.FItemID
Where 1=1 
Group By  t2.FName,tt1.FName1,tt1.FName2,tt1.FName3,tt1.FName4,tt1.FName5,tt1.FName6,t1.FNumber With RollUp


Drop Table #Data2


Update t1 Set t1.FName=t2.FName,t1.FShortNumber=t2.FShortNumber,t1.FModel=t2.FModel, t1.FCUUnitName = t4.FName,  t1.FUnitName=t3.FName,t1.FQtyDecimal=t2.FQtyDecimal,t1.FPriceDecimal=t2.FPriceDecimal  From #Data t1,t_ICItem t2,t_MeasureUnit t3,t_MeasureUnit t4  Where t1.FNumber=t2.FNumber  And t2.FUnitGroupID=t3.FUnitGroupID  And t2.FSaleUnitID=t4.FMeasureUnitID  And t3.FStandard=1
Update #Data Set FUnitCost=(Case When FQtySend=0 Then Null Else FCostSale/FQtySend End) 


Update #Data Set  FName1=FName1+'(小计)'  Where FSumSort=107
Update #Data Set  FName2=FName2+'(小计)'  Where FSumSort=108
Update #Data Set  FName3=FName3+'(小计)'  Where FSumSort=109
Update #Data Set  FName4=FName4+'(小计)'  Where FSumSort=110
Update #Data Set  FName5=FName5+'(小计)'  Where FSumSort=111
Update #Data Set  FName6=FName6+'(小计)'  Where FSumSort=112
Update #Data Set FCustName=FCustName+'(小计)' Where FSumSort=106
Update #Data Set FCustName='合计' Where FSumSort=101

Select t3.fnumber 客户编码,fcustname 客户名称,t5.ffullname 客户全称,t1.fnumber 编码,t1.fname 名称,t4.ffullname 全称,t1.fmodel 规格型号,
isnull(y.fqty,1) 系数,
fqtysale 销售数量,fincomesale 销售收入,
fqtysend 发货数量,funitcost 单位成本,fcostsale 销售成本,fprofit 销售毛利润,
Case When FIncomeSale=0 Then '' Else LTrim(CAST(CAST(Round(CAST(FProfit AS FLOAT)/CAST(FIncomeSale AS FLOAT)*100,2) AS Decimal(28,2)) AS VarChar(50))) +'%' End As 销售毛利润率 
From #Data t1
inner join t_icitem t2 on t1.fnumber=t2.fnumber
inner join t_organization t3 on t3.fname=t1.fcustname
inner join t_item t4 on t2.fitemid=t4.fitemid
inner join t_item t5 on t3.fitemid=t5.fitemid
left join 
(
	select c.fitemid,isnull(sum(isnull(b.fqty,1)),1)  as fqty
	from icbom a inner join icbomchild b on a.finterid=b.finterid
							inner join t_icitem c on a.fitemid=c.fitemid
							inner join t_icitem d on b.fitemid=d.fitemid
	where left(d.fnumber,1) in ('3','4','5','7','8')
	group by c.fitemid
) y on t2.fitemid=y.fitemid
where t1.fnumber is not null  
Order By FID 

Drop Table #Data
Drop Table #ItemLevel

