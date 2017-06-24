
--成本核算-------------------------------------------------------------------------------------

----步骤 3
----本期有出入库单据业务发生，但是禁用了--成本算完后要禁用回去！！！！！！！！！！！！！！！！
--
--
--create table t_icitemDelete(fyear int,fperiod int,fitemid int)
--
--insert into t_icitemDelete(fyear,fperiod,fitemid)
--select distinct 2013,2,t2.fitemid --t1.ftrantype,t3.fnumber
----update t4 set FDeleted=0
----update t5 set FDeleted=0
--from icstockbill t1
--inner join icstockbillentry t2 on t1.finterid=t2.finterid
--inner join t_icitem t3 on t2.fitemid=t3.fitemid
--inner join t_item t4 on t3.fitemid=t4.fitemid
--inner join t_ICItemCore t5 on t5.fitemid=t3.fitemid
--where year(t1.fdate)=2016 and month(t1.fdate)=8
--and t3.fdeleted=1 
--
--select distinct 2012,11,t2.fitemid --t1.ftrantype,t3.fnumber
----update t6 set FDeleted=0
----update t7 set FDeleted=0
--from icstockbill t1
--inner join icstockbillentry t2 on t1.finterid=t2.finterid
--inner join t_icitem t3 on t2.fitemid=t3.fitemid
--inner join t_item t4 on t3.fitemid=t4.fitemid
--inner join t_ICItemCore t5 on t5.fitemid=t3.fitemid
--inner join cbcostobj t6 on t6.FStdProductID=t3.fitemid
--inner join t_item t7 on t7.fitemid=t6.fitemid
--where year(t1.fdate)=8012 and month(t1.fdate)=8
--and t7.fdeleted=1 

select t2.fnumber,t2.fname,t2.fmodel,t1.*
from icbal t1
inner join t_icitem t2 on t1.fitemid=t2.fitemid
where t1.fyear=2015 and t1.fperiod=2 and t2.fshortnumber='000852'

--步骤 1  
--删除MRP计算结果--然后优化数据库，才开始计算

Delete from My_t_MrpRoughNeedSource where frunid in (select frunid from my_t_Mrp where fdate<=Dateadd(day,-10,getdate()))
Delete from My_t_MrpWillInStock where frunid in (select frunid from my_t_Mrp where fdate<=Dateadd(day,-10,getdate()))
Delete from my_t_MrpResultDetail where frunid in (select frunid from my_t_Mrp where fdate<=Dateadd(day,-10,getdate()))
Delete from My_t_MrpStock where frunid in (select frunid from my_t_Mrp where fdate<=Dateadd(day,-10,getdate()))
Delete from my_t_MrpResultSum where frunid in (select frunid from my_t_Mrp where fdate<=Dateadd(day,-10,getdate()))

--Delete from my_t_Mrp where fdate<=Dateadd(day,-20,getdate())  --要是清除的话，MRP计算过的单据会显示没有计算过

-- --半年之前的订单附件清除
-- select  200071,@FInterID,FDesc,FFileName,FFilesize,FUploader,FISPic,FFile
-- --update t1 set FFile=null
-- from t_accessory t1
-- where FTypeid=200081 and fitemid in 
-- (
-- 	select distinct t1.finterid
-- 	from seorder t1
-- 	inner join seorderentry t2 on t1.finterid=t2.finterid
-- 	where t1.fdate<=Dateadd(month,-3,getdate())
-- ) 

go

--4.1 用销售发票价更新销售出库的销售单价
SELECT t7.fname 客户,t6.fbillno 销售订单编号,t3.fnumber 产品编码,t3.fname 名称,t3.fmodel 规格型号,t2.fconsignprice ,t2.fconsignamount,t2.fprice,t2.famount,t2.fqty,
t4.fstdamount,cast(t4.fstdamount/t4.fqty as decimal(24,4)) fstdprice
--update t2 set fconsignprice=cast(t4.fstdamount/t4.fqty as decimal(24,4)) ,fconsignamount=cast(cast(t4.fstdamount/t4.fqty as decimal(24,4))*t2.fqty as decimal(24,2))
from icstockbill t1
inner join icstockbillentry t2 on t1.finterid=t2.finterid
inner join t_icitem t3 on t2.fitemid=t3.fitemid
inner join icsaleentry t4 on t4.fsourceinterid=t2.finterid and t4.fsourceentryid=t2.fentryid
inner join seorderentry t5 on t5.finterid=t2.forderinterid and t5.fentryid=t2.forderentryid
inner join seorder t6 on t5.finterid=t6.finterid
inner join t_organization t7 on t6.fcustid=t7.fitemid
where year(t1.fdate)=2016 and month(t1.fdate)=8 and t1.ftrantype=21
and isnull(t1.FVchInterID,0)=0 


--1.1 确定成本系统当前所处期间

--4.2 检查当期数量为0的错误出入库单据
select t3.frob,t3.ftrantype,t3.fbillno,t3.fcheckerid,t2.fprice,t11.fplanprice,t2.fqty,t2.fauxqty,t2.famount
--delete t2
from icstockbillentry t2  
inner join icstockbill t3 on t2.finterid=t3.finterid  
inner join t_icitem t11 on t11.fitemid=t2.fitemid   
where year(t3.fdate)=2016 and month(t3.fdate)=8
and isnull(t3.FVchInterID,0)=0 and t3.FCancellation = 0 and t3.ftrantype in (24,29,43,2,10,40,41)
and (t2.fqty=0) --and t1.famount=0

--1.4 更改调拨单调拨类型
SELECT freftype,* 
--update t2 set fpriceref=t2.fprice,fauxpriceref=t2.fauxprice,famtref=t2.famount
FROM ICSTOCKBILL t1 
inner join icstockbillentry t2 on t1.finterid=t2.finterid
WHERE t1.FTRANTYPE=41 and year(t1.fdate)=2016 and month(t1.fdate)=8
and isnull(t1.FVchInterID,0)=0
and t2.famtref<>t2.famount

SELECT freftype,* 
--update t1 set freftype=12561
FROM ICSTOCKBILL t1 WHERE FTRANTYPE=41 
and isnull(FVchInterID,0)=0 
and year(t1.fdate)=2016 and month(t1.fdate)=8
and (isnull(freftype,0)<>12561)

--1.1 无采购单价的外购件
select t2.fnumber,t2.fname,t2.fmodel,t3.fplanprice,t4.fprice,t5.fname,t2.fdeleted
--update t3 set fplanprice=0
from t_icitem t2 
inner join t_icitemmaterial t3 on t2.fitemid=t3.fitemid
left join t_supplyentry t4 on t4.fitemid=t2.fitemid
inner join t_stock t5 on t5.fitemid=t2.fdefaultloc
where isnull(t4.fprice,0)=0 and t3.fplanprice<>0 and t2.ferpclsid=1


--1.2 先用采购单价更新计划单价--客供的不会录入采购单价
--1.2 先用采购单价更新计划单价
select t3.fplanprice,t1.fnumber,t1.fname,t1.fmodel,t2.fprice
--update t3 set fplanprice=t2.fprice
from t_icitem t1
inner join 
(
-- 	select t1.fitemid,max(t1.fprice) fprice
-- 	from t_supplyentry t1 
-- 	where t1.fprice<>0 and fcyid=1 
-- 	group by t1.fitemid
	select t4.fitemid,(case when t5.fcyid=1000 then t5.ftaxprice*t1.fexchangerate else t5.ftaxprice end) fprice
	from (select fitemid,max(fentryid) fentryid from (select t1.fitemid,t1.fentryid from t_supplyentry t1 inner join (select fitemid,max(FQuoteTime) FQuoteTime from t_SupplyEntry group by fitemid) t2 on t1.fitemid=t2.fitemid and t1.FQuoteTime=t2.FQuoteTime) t1 group by fitemid) t4 
	inner join t_supplyentry t5 on t4.fitemid=t5.fitemid and t4.fentryid=t5.fentryid
	inner join t_currency t1 on t1.fcurrencyid=t5.fcyid
) t2 on t1.fitemid=t2.fitemid
inner join t_ICItemMaterial t3 on t1.fitemid=t3.fitemid
where t1.ferpclsid in (1,5)



--彩盒计划单价检查--大样，确实有这么贵
select t2.fnumber,t2.fname,t2.fmodel,t3.fplanprice,t4.fprice,t5.fname
--update t3 set fplanprice=3
from t_icitem t2 
inner join t_icitemmaterial t3 on t2.fitemid=t3.fitemid
left join t_supplyentry t4 on t4.fitemid=t2.fitemid
inner join t_stock t5 on t5.fitemid=t2.fdefaultloc
where left(t2.fnumber,5) in( '2.02.','2.03.','2.04.') --and t2.fname like '%彩盒%'
and t2.fplanprice>10 and t2.fdefaultloc<>16483


--执行三次即可--不再使用此功能
--update m2 set fplanprice=m1.fprice
--from
--(
--	select t1.fitemid,sum(t4.fplanprice*t2.fqty) fprice
--	from icbom t1
--	inner join icbomchild t2 on t1.finterid=t2.finterid
--	inner join t_icitem t3 on t1.fitemid=t3.fitemid
--	inner join t_icitem t4 on t2.fitemid=t4.fitemid
--	inner join (select fitemid,max(finterid) finterid from icbom group by fitemid) t5 on t5.finterid=t1.finterid  --防止一物有多个BOM
--	--inner join t_SubMessage t17 ON t2.FOperID=t17.FInterID and t17.ftypeid=61
--	--where t1.fitemid=@iPItemId --and t1.fusestatus=1072 
--	--and not (left(t4.fnumber,5) in ('1.06.','2.20.','1.04.') and t4.funitid<>29056) --膜 单位非PCS --and t2.foperid not in (40013,40019,40020,40028,40026,40012,40014,40039,40023)
--	group by t1.fitemid
--) m1	inner join t_ICItemMaterial m2 on m1.fitemid=m2.fitemid  --用了inner join ,如果是外购件是不会更新的

/*
select distinct t11.fitemid,t11.fnumber,t11.fname into #data  -- drop table #data drop table #data2 drop table #temp
from Sheet21$ t2    
inner join t_icitem t11 on t11.fnumber=t2.物料长代码   


select t2.物料短代码, t11.fitemid,t11.fnumber,t11.fname 
from Sheet10$ t2    
left join t_icitem t11 on t11.fshortnumber=t2.物料短代码   
where t11.fshortnumber is null


--是否引擎 F_126	  产品引擎 F_127	 	--是  40019	否  40020

--drop table #sale

select t2.fengineid fitemid,sum(t2.fqty) fqty,sum(t2.famount) famount into #sale
from
(
	select t1.fcurrencyid,t2.fitemid,(case when isnull(t3.F_126,0)=40019 then t3.fitemid when isnull(t3.F_126,0)<>40019 and isnull(t3.F_127,0)=0 then t3.fitemid else isnull(t3.F_127,0) end) fengineid,t2.fqty,t2.famount
	from icsale t1
	inner join icsaleentry t2 on t1.finterid=t2.finterid
	inner join t_icitem t3 on t3.fitemid=t2.fitemid
	where t1.fdate>='2015-01-01' and t1.fdate<='2015-09-30' and left(t3.fnumber,1) in ('A','P','J','X','Y','V')
	and t1.fcustid in (123,16708)
	and t1.fcurrencyid=1 and t2.fqty>0
) t2 group by t2.fengineid

--select * from t_item where fitemclassid=1   123  16708


--drop table #data

select t3.fitemid,t3.fnumber,t3.fname,t3.fmodel,isnull(t3.f_105,'') 描述,isnull(t3.F_106,'') 适用机型,--(case when t3.F_126=40019 then t3.fitemid else isnull(t3.F_127,0) end) fengineid
isnull(t11.fname,'') 结算类别,cast(isnull(t11.f_101,0) as decimal(24,2)) 系数,t13.fname 外盒尺寸,cast(t12.F_103 as decimal(24,2)) 标准彩盒费,
t4.fitemid fchilditemid,t4.fnumber fchildnumber,t4.fname fchildname,(case when isnull(t4.fmodel,'')='' then '///' else t4.fmodel end) fchildmodel,
isnull(t2.fqty,0) fqty,isnull(t2.famount,0) famount,
cast(0.0000 as decimal(24,4)) fmaterialcost,cast(0.0000 as decimal(24,4)) favgmaterialcost,cast('' as varchar(50)) fiscomplete
into #data
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
		where isnull(t1.f_126,0)=40019 and t1.fname not like '%禁用%' and t1.fdeleted=0 --left(t1.fnumber,4) in ('a.01','p.01','j.01','x.01','y.01')
	) t1 group by t1.fitemid
) t1 inner join t_ICItem t3 on t3.fitemid=t1.fitemid
inner join t_ICItem t4 on t4.fitemid=t1.fbanitemid
left join t_item t13 on t13.fitemid=t3.F_103 and t13.fitemclassid=3004  --外盒尺寸
left join t_item_3005 t11 on t11.fitemid=t3.F_104 --and t11.fitemclassid=3005  --结算类别
left join t_Item_3012 t12 on t3.F_103=t12.F_102 and t12.fname like '%彩盒%' --and 
left join #sale t2 on t2.fitemid=t1.fitemid
where isnull(t3.f_126,0)=40019 
order by t3.fnumber

--select * from #data

*/
--采购价格

--drop table #temp

select t4.fitemid,(case when t5.fcyid=1000 then t5.ftaxprice*t1.fexchangerate else t5.ftaxprice end) fprice
into #temp --
from (select fitemid,max(fentryid) fentryid from (select t1.fitemid,t1.fentryid from t_supplyentry t1 inner join (select fitemid,max(FQuoteTime) FQuoteTime from t_SupplyEntry group by fitemid) t2 on t1.fitemid=t2.fitemid and t1.FQuoteTime=t2.FQuoteTime) t1 group by fitemid) t4 
inner join t_supplyentry t5 on t4.fitemid=t5.fitemid and t4.fentryid=t5.fentryid
inner join t_currency t1 on t1.fcurrencyid=t5.fcyid

insert into #temp(fitemid,fprice)
select            fitemid,fprice
from
(
	select t1.fitemid,max(t1.fprice) fprice
	from icstockbillentry t1
	inner join 
	(
		select t2.fitemid,max(t1.finterid) finterid
		from icstockbill t1
		inner join icstockbillentry t2 on t1.finterid=t2.finterid
		inner join t_icitem t3 on t2.fitemid=t3.fitemid 
		where t1.ftrantype in (1,2,10,29) and t2.fprice>0 and left(t3.fnumber,1) not in (select fitemtype from v_myitemtype where ftype=0)
		and t3.fnumber not like '6.%'
		group by t2.fitemid
	) t2 on t1.finterid=t2.finterid
	group by t1.fitemid
) t1 where t1.fitemid not in (select fitemid from #temp)

select t1.fprice
--update t1 set fprice=cast(t1.fprice/1.170000 as decimal(24,6))
from #temp t1 where t1.fitemid not in (select t2.fitemid from temp111$ t1 inner join t_icitem t2 on t1.物料代码=t2.fnumber)

--自制
select distinct t11.fitemid,t11.fnumber,t11.fname into #data  -- drop table #data drop table #data2 drop table #temp
from icstockbillentry t2  
inner join icstockbill t3 on t2.finterid=t3.finterid  
inner join t_icitem t11 on t11.fitemid=t2.fitemid   
where year(t3.fdate)=2016 and month(t3.fdate)=8 and t11.ferpclsid=2


--外购
select distinct t11.fitemid,t11.fnumber,t11.fname into #data2
from icstockbillentry t2  
inner join icstockbill t3 on t2.finterid=t3.finterid  
inner join t_icitem t11 on t11.fitemid=t2.fitemid   
where year(t3.fdate)=2016 and month(t3.fdate)=8 and t11.ferpclsid=1

/*
--最近三个月平均成本

select t1.fitemid,cast(sum(fcredit)/sum(fsend) as decimal(24,4))fprice into #temp
from icbal t1
inner join t_icitem t2 on t1.fitemid=t2.fitemid
where fyear=2015 and fperiod=@fperiod and fsend>0 and fcredit>0 and t2.ferpclsid in (1,3)
group by t1.fitemid



--drop table #ttt

create table #ttt(findex int identity(1,1),fitemid int,fyearperiod int)

insert into #ttt(fitemid,fyearperiod)
select t1.fitemid,(t1.fyear*100+t1.fperiod) fyearperiod --identity(int,1,1) findex, into #ttt  
from icbal t1
inner join t_icitem t2 on t1.fitemid=t2.fitemid
where t1.fsend>0 and t1.fcredit>0 and t2.ferpclsid in (1,3)
group by t1.fitemid,(t1.fyear*100+t1.fperiod) --(t1.fyear*100+t1.fperiod)
order by t1.fitemid,(t1.fyear*100+t1.fperiod) desc

--select * from #ttt order by findex

drop table #temp

select t1.fitemid,cast(sum(t1.fcredit)/sum(t1.fsend) as decimal(24,4))fprice into #temp
from icbal t1
inner join 
(
	select t1.fitemid,t1.fyearperiod 
	from #ttt t1 
	inner join ( select fitemid,min(findex)+2 fminindex from #ttt group by fitemid ) t2 on t1.fitemid=t2.fitemid and t1.findex<=t2.fminindex
) t2 on t1.fitemid=t2.fitemid and (t1.fyear*100+t1.fperiod)=t2.fyearperiod
where t1.fsend>0 and t1.fcredit>0 
group by t1.fitemid
order by t1.fitemid

insert into #temp(fitemid,fprice)
select t4.fitemid,(case when t5.fcyid=1000 then t5.fprice*t1.fexchangerate else t5.fprice end) fprice
from (select fitemid,max(fentryid) fentryid from (select t1.fitemid,t1.fentryid from t_supplyentry t1 inner join (select fitemid,max(FQuoteTime) FQuoteTime from t_SupplyEntry group by fitemid) t2 on t1.fitemid=t2.fitemid and t1.FQuoteTime=t2.FQuoteTime) t1 group by fitemid) t4 
inner join t_supplyentry t5 on t4.fitemid=t5.fitemid and t4.fentryid=t5.fentryid
inner join t_currency t1 on t1.fcurrencyid=t5.fcyid
where t4.fitemid not in (select fitemid from #temp)

insert into #temp(fitemid,fprice)
select            fitemid,fprice
from
(
	select t1.fitemid,max(t1.fprice) fprice
	from icstockbillentry t1
	inner join 
	(
		select t2.fitemid,max(t1.finterid) finterid
		from icstockbill t1
		inner join icstockbillentry t2 on t1.finterid=t2.finterid
		inner join t_icitem t3 on t2.fitemid=t3.fitemid 
		where t1.ftrantype in (1,2,10,29) and t2.fprice>0 and left(t3.fnumber,1) not in (select fitemtype from v_myitemtype where ftype=0)
		and t3.fnumber not like '6.%'
		group by t2.fitemid
	) t2 on t1.finterid=t2.finterid
	group by t1.fitemid
) t1 where t1.fitemid not in (select fitemid from #temp)

select t1.fprice
--update t1 set fprice=cast(t1.fprice/1.170000 as decimal(24,6))
from #temp t1 where t1.fitemid not in (select t2.fitemid from temp111$ t1 inner join t_icitem t2 on t1.物料代码=t2.fnumber)

select distinct fnumber,fname,fmodel
from
(
	select distinct t3.fnumber,t3.fname,t3.fmodel
	from #data2 t1
	left join t_supplyentry t2 on t1.fitemid=t2.fitemid
	inner join t_icitem t3 on t3.fitemid=t1.fitemid
	where t2.fitemid is null
	and t3.fnumber not like '2.05%' and t3.fnumber not like '2.06%' and t3.fnumber not like '2.07%'
	union all
	select distinct t6.fnumber,t6.fname,t6.fmodel
	--select distinct t1.fnumber
	from #data t1
	inner join icbom t2 on t1.fitemid=t2.fitemid --and t2.fstatus>0
	inner join icbomchild t3 on t2.finterid=t3.finterid
	left join #temp t5 on t5.fitemid=t3.fitemid
	inner join t_icitem t6 on t6.fitemid=t3.fitemid
	inner join t_icitem t7 on t7.fitemid=t1.fitemid  --父项
	where t6.ferpclsid=1 
	and isnull(t5.fprice,0)=0 and t6.fnumber not like '2.05%' and t6.fnumber not like '2.06%' and t6.fnumber not like '2.07%'
	and t6.fname not like '%客户%彩盒%'
) t1 order by t1.fnumber

create table #NotComplete(ftype int,fitemid int)  --1 物料  2  成品 
*/

--无单价的外购件
select distinct t2.fnumber,t2.fname,isnull(t2.fmodel,'')
--select distinct t3.fnumber,t3.fname,t3.fmodel  --涉及到的成品
--insert into #NotComplete select distinct 1,t2.fitemid
--insert into #NotComplete select distinct 2,t3.fitemid
--select distinct t3.fnumber,t3.fname,t3.fmodel,t2.fnumber,t2.fname,isnull(t2.fmodel,'')
from
(
-- 	select t3.fitemid
-- 	--select distinct t3.fnumber
-- 	from #data2 t1
-- 	left join t_supplyentry t2 on t1.fitemid=t2.fitemid
-- 	inner join t_icitem t3 on t3.fitemid=t1.fitemid
-- 	where t2.fitemid is null
-- 	union all
	select t3.fitemid fchilditemid,t1.fitemid
	--select distinct t6.fnumber
	from #data t1
	inner join icbom t2 on t1.fitemid=t2.fitemid --and t2.fstatus>0
	inner join icbomchild t3 on t2.finterid=t3.finterid
	left join #temp t5 on t5.fitemid=t3.fitemid
	inner join t_icitem t6 on t6.fitemid=t3.fitemid
	inner join t_icitem t7 on t7.fitemid=t1.fitemid  --父项
	where t6.ferpclsid in (1,5)
	and isnull(t5.fprice,0)=0 
	union all
	select t6.fitemid fchilditemid,t1.fitemid
	--select distinct t6.fnumber
	from t_icitem t1
	inner join icbom t2 on t1.fitemid=t2.fitemid --and t2.fstatus>0
	inner join icbomchild t3 on t2.finterid=t3.finterid
	left join #temp t5 on t5.fitemid=t3.fitemid
	inner join t_icitem t6 on t6.fitemid=t3.fitemid
	where left(t6.fnumber,1) not in ('3','4','5') 
	and t1.fitemid in (select fitemid from #data) and t6.ferpclsid in (1,5) and t5.fitemid is null
	union all
	select t8.fitemid fchilditemid,t1.fitemid
	--select distinct t8.fnumber
	from t_icitem t1
	inner join icbom t2 on t1.fitemid=t2.fitemid --and t2.fstatus>0 --成品
	inner join icbomchild t3 on t2.finterid=t3.finterid  --半成品
	inner join icbom t11 on t11.fitemid=t3.fitemid  --半成品
	inner join icbomchild t12 on t11.finterid=t12.finterid  --半成品子项
	left join #temp t5 on t5.fitemid=t12.fitemid
	inner join t_icitem t6 on t6.fitemid=t3.fitemid --半成品
	inner join t_icitem t7 on t7.fitemid=t2.fitemid --成品
	inner join t_icitem t8 on t8.fitemid=t12.fitemid --半成品子项
	where left(t6.fnumber,1) in ('3','4') 
	and t1.fitemid in (select fitemid from #data) and t8.ferpclsid in (1,5) and t5.fitemid is null
	union all
	select t8.fitemid fchilditemid,t1.fitemid
	--select distinct t8.fnumber
	from t_icitem t1
	inner join icbom t2 on t1.fitemid=t2.fitemid --and t2.fstatus>0 --成品
	inner join icbomchild t3 on t2.finterid=t3.finterid  --半成品
	inner join icbom t11 on t11.fitemid=t3.fitemid  --半成品
	inner join icbomchild t12 on t11.finterid=t12.finterid  --半成品子项
	left join #temp t5 on t5.fitemid=t12.fitemid
	inner join t_icitem t6 on t6.fitemid=t3.fitemid --半成品
	inner join t_icitem t7 on t7.fitemid=t2.fitemid --成品
	inner join t_icitem t8 on t8.fitemid=t12.fitemid --半成品子项
	where left(t6.fnumber,1) in ('5') and t8.fname not like '回收件%' --and t1.ferpclsid=2
	and t1.fitemid in (select fitemid from #data) and t8.ferpclsid in (1,5) and t5.fitemid is null
	union all
	select t8.fitemid fchilditemid,t1.fitemid
	--select distinct t8.fnumber
	from t_icitem t1
	inner join icbom t2 on t1.fitemid=t2.fitemid --and t2.fstatus>0 --成品
	inner join icbomchild t3 on t2.finterid=t3.finterid  --半成品
	inner join icbom t11 on t11.fitemid=t3.fitemid  --半成品
	inner join (
	-- 			select distinct t1.fitemid,(select top 1 fitemid from t_icitem where fparentid=t1.fparentid and fname like '%拆盒%' ) fchiheitemid
	-- 			from t_icitem t1
	-- 			inner join icbomchild t2 on t1.fitemid=t2.fitemid
	-- 			where t1.fnumber like '5.%' and t1.fname not like '%拆盒%'
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
	) t12 on t11.fitemid=t12.fitemid --半成品同级回收壳
	inner join t_icitem t6 on t6.fitemid=t3.fitemid --半成品
	inner join t_icitem t7 on t7.fitemid=t2.fitemid --成品
	inner join t_icitem t8 on t8.fitemid=t12.fchiheitemid --半成品同级回收壳
	left join #temp t5 on t5.fitemid=t8.fitemid
	where left(t6.fnumber,1) in ('5') --and t1.ferpclsid=2
	and t1.fitemid in (select fitemid from #data) and t8.ferpclsid in (1,5) and t5.fitemid is null
) t1 inner join t_icitem t2 on t1.fchilditemid=t2.fitemid
inner join t_icitem t3 on t1.fitemid=t3.fitemid
where t2.fnumber not like '2.05%' and t2.fnumber not like '2.06%' and t2.fnumber not like '2.07%'
and t2.fname not like '%客户%彩盒%' and t2.fdefaultloc<>16483  --
order by t2.fnumber


--成本明细-成品
select t1.fnumber 产品编码,t1.fname 产品名称,t1.fmodel 产品规格型号,t6.fnumber 子项编码,t6.fname 子项名称,t6.fmodel 子项规格型号,t3.fqty 单位用量,t5.fprice 采购单价,(t3.fqty*t5.fprice) 单位成本
from t_icitem t1
inner join icbom t2 on t1.fitemid=t2.fitemid --and t2.fstatus>0
inner join icbomchild t3 on t2.finterid=t3.finterid
inner join #temp t5 on t5.fitemid=t3.fitemid
inner join t_icitem t6 on t6.fitemid=t3.fitemid
where left(t6.fnumber,1) not in ('3','4','5') --and t1.ferpclsid=2 
and t1.fitemid in (select fitemid from #data) and left(t1.fnumber,1) in ('A', 'J', 'P', 'Q', 'R', 'V', 'X', 'Y')
union all
select t1.fnumber,t1.fname,t1.fmodel,t8.fnumber,t8.fname,t8.fmodel,t3.fqty*t12.fqty,t5.fprice,(t3.fqty*t12.fqty*t5.fprice) fprice
from t_icitem t1
inner join icbom t2 on t1.fitemid=t2.fitemid --and t2.fstatus>0 --成品
inner join icbomchild t3 on t2.finterid=t3.finterid  --半成品
inner join icbom t11 on t11.fitemid=t3.fitemid  --半成品
inner join icbomchild t12 on t11.finterid=t12.finterid  --半成品子项
inner join #temp t5 on t5.fitemid=t12.fitemid
inner join t_icitem t6 on t6.fitemid=t3.fitemid --半成品
inner join t_icitem t7 on t7.fitemid=t2.fitemid --成品
inner join t_icitem t8 on t8.fitemid=t12.fitemid --半成品子项
where left(t6.fnumber,1) in ('3','4') --and t1.ferpclsid=2
and t1.fitemid in (select fitemid from #data) and left(t1.fnumber,1) in ('A', 'J', 'P', 'Q', 'R', 'V', 'X', 'Y')
union all
select t1.fnumber,t1.fname,t1.fmodel,t8.fnumber,t8.fname,t8.fmodel,t3.fqty*t12.fqty,t5.fprice,(t3.fqty*t12.fqty*t5.fprice) fprice
from t_icitem t1
inner join icbom t2 on t1.fitemid=t2.fitemid --and t2.fstatus>0 --成品
inner join icbomchild t3 on t2.finterid=t3.finterid  --半成品
inner join icbom t11 on t11.fitemid=t3.fitemid  --半成品
inner join icbomchild t12 on t11.finterid=t12.finterid  --半成品子项
inner join #temp t5 on t5.fitemid=t12.fitemid
inner join t_icitem t6 on t6.fitemid=t3.fitemid --半成品
inner join t_icitem t7 on t7.fitemid=t2.fitemid --成品
inner join t_icitem t8 on t8.fitemid=t12.fitemid --半成品子项
where left(t6.fnumber,1) in ('5') and t8.fname not like '回收件%' --and t1.ferpclsid=2
and t1.fitemid in (select fitemid from #data) and left(t1.fnumber,1) in ('A', 'J', 'P', 'Q', 'R', 'V', 'X', 'Y')
union all
select t1.fnumber,t1.fname,t1.fmodel,t8.fnumber,t8.fname,t8.fmodel,t3.fqty,t5.fprice,(t3.fqty*t5.fprice) fprice
from t_icitem t1
inner join icbom t2 on t1.fitemid=t2.fitemid --and t2.fstatus>0 --成品
inner join icbomchild t3 on t2.finterid=t3.finterid  --半成品
inner join icbom t11 on t11.fitemid=t3.fitemid  --半成品
inner join (
-- 			select distinct t1.fitemid,(select top 1 fitemid from t_icitem where fparentid=t1.fparentid and fname like '%拆盒%' ) fchiheitemid
-- 			from t_icitem t1
-- 			inner join icbomchild t2 on t1.fitemid=t2.fitemid
-- 			where t1.fnumber like '5.%' and t1.fname not like '%拆盒%'
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
) t12 on t11.fitemid=t12.fitemid --半成品同级回收壳
inner join t_icitem t6 on t6.fitemid=t3.fitemid --半成品
inner join t_icitem t7 on t7.fitemid=t2.fitemid --成品
inner join t_icitem t8 on t8.fitemid=t12.fchiheitemid --半成品同级回收壳
inner join #temp t5 on t5.fitemid=t8.fitemid
where left(t6.fnumber,1) in ('5') --and t1.ferpclsid=2
and t1.fitemid in (select fitemid from #data) and left(t1.fnumber,1) in ('A', 'J', 'P', 'Q', 'R', 'V', 'X', 'Y')
order by 产品编码,子项编码



--成本明细-半成品
select t1.fnumber 产品编码,t1.fname 产品名称,t1.fmodel 产品规格型号,t6.fnumber 子项编码,t6.fname 子项名称,t6.fmodel 子项规格型号,t3.fqty 单位用量,t5.fprice 采购单价,(t3.fqty*t5.fprice) 单位成本
from t_icitem t1
inner join icbom t2 on t1.fitemid=t2.fitemid --and t2.fstatus>0
inner join icbomchild t3 on t2.finterid=t3.finterid
inner join #temp t5 on t5.fitemid=t3.fitemid
inner join t_icitem t6 on t6.fitemid=t3.fitemid
where left(t1.fnumber,1) in ('3','4') --and t1.ferpclsid=2 
and t1.fitemid in (select fitemid from #data)
union all
select t6.fnumber 产品编码,t6.fname 产品名称,t6.fmodel 产品规格型号,t8.fnumber 子项编码,t8.fname 子项名称,t8.fmodel 子项规格型号,t12.fqty 单位用量,t5.fprice 采购单价,(t12.fqty*t5.fprice) 单位成本
from icbom t11   --半成品
inner join icbomchild t12 on t11.finterid=t12.finterid  --半成品子项
inner join #temp t5 on t5.fitemid=t12.fitemid
inner join t_icitem t6 on t6.fitemid=t11.fitemid --半成品
inner join t_icitem t8 on t8.fitemid=t12.fitemid --半成品子项
where left(t6.fnumber,1) in ('5') and t8.fname not like '回收件%' --and t1.ferpclsid=2
and t11.fitemid in (select fitemid from #data)
union all
select t6.fnumber 产品编码,t6.fname 产品名称,t6.fmodel 产品规格型号,t8.fnumber 子项编码,t8.fname 子项名称,t8.fmodel 子项规格型号,1 单位用量,t5.fprice 采购单价,(1*t5.fprice) 单位成本
from icbom t11   --半成品
inner join (
-- 			select distinct t1.fitemid,(select top 1 fitemid from t_icitem where fparentid=t1.fparentid and fname like '%拆盒%' ) fchiheitemid
-- 			from t_icitem t1
-- 			inner join icbomchild t2 on t1.fitemid=t2.fitemid
-- 			where t1.fnumber like '5.%' and t1.fname not like '%拆盒%'
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
) t12 on t11.fitemid=t12.fitemid --半成品同级回收壳
inner join t_icitem t6 on t6.fitemid=t11.fitemid --半成品
inner join t_icitem t8 on t8.fitemid=t12.fchiheitemid --半成品同级回收壳
inner join #temp t5 on t5.fitemid=t8.fitemid
where left(t6.fnumber,1) in ('5') --and t1.ferpclsid=2
and t11.fitemid in (select fitemid from #data)
order by 产品编码,子项编码


--半成品
update t1 set fplanprice=t2.fprice
from t_ICItemMaterial t1
inner join 
(
	select t1.fitemid,sum(fprice) fprice
	from
	(
		select t2.fitemid,(t3.fqty*t5.fprice) fprice
		from t_icitem t1
		inner join icbom t2 on t1.fitemid=t2.fitemid --and t2.fstatus>0
		inner join icbomchild t3 on t2.finterid=t3.finterid
		inner join #temp t5 on t5.fitemid=t3.fitemid
		inner join t_icitem t6 on t6.fitemid=t3.fitemid
		where left(t1.fnumber,1) in ('3','4') --and t1.ferpclsid=2 
		and t1.fitemid in (select fitemid from #data)
		union all
		select t11.fitemid,(t12.fqty*t5.fprice) fprice
		from icbom t11   --半成品
		inner join icbomchild t12 on t11.finterid=t12.finterid  --半成品子项
		inner join #temp t5 on t5.fitemid=t12.fitemid
		inner join t_icitem t6 on t6.fitemid=t11.fitemid --半成品
		inner join t_icitem t8 on t8.fitemid=t12.fitemid --半成品子项
		where left(t6.fnumber,1) in ('5') and t8.fname not like '回收件%' --and t1.ferpclsid=2
		and t11.fitemid in (select fitemid from #data)
		union all
		select t11.fitemid,(1*t5.fprice) fprice
		from icbom t11   --半成品
		inner join (
-- 			select distinct t1.fitemid,(select top 1 fitemid from t_icitem where fparentid=t1.fparentid and fname like '%拆盒%' ) fchiheitemid
-- 			from t_icitem t1
-- 			inner join icbomchild t2 on t1.fitemid=t2.fitemid
-- 			where t1.fnumber like '5.%' and t1.fname not like '%拆盒%'
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
		) t12 on t11.fitemid=t12.fitemid --半成品同级回收壳
		inner join t_icitem t6 on t6.fitemid=t11.fitemid --半成品
		inner join t_icitem t8 on t8.fitemid=t12.fchiheitemid --半成品同级回收壳
		inner join #temp t5 on t5.fitemid=t8.fitemid
		where left(t6.fnumber,1) in ('5') --and t1.ferpclsid=2
		and t11.fitemid in (select fitemid from #data)
	) t1 group by t1.fitemid
) t2 on t1.fitemid=t2.fitemid



--成品
update t1 set fplanprice=t2.fprice
--select t3.fnumber 产品编码,t3.fname 产品名称,t3.fmodel 产品规格型号,t2.fprice 单位成本
from t_ICItemMaterial t1
inner join 
(
	select t1.fitemid,sum(fprice) fprice
	from
	(
		select t2.fitemid,(t3.fqty*t5.fprice) fprice
		from t_icitem t1
		inner join icbom t2 on t1.fitemid=t2.fitemid --and t2.fstatus>0
		inner join icbomchild t3 on t2.finterid=t3.finterid
		inner join #temp t5 on t5.fitemid=t3.fitemid
		inner join t_icitem t6 on t6.fitemid=t3.fitemid
		where left(t6.fnumber,1) not in ('3','4','5') --and t1.ferpclsid=2 
		and t1.fitemid in (select fitemid from #data) and left(t1.fnumber,1) in ('A', 'J', 'P', 'Q', 'R', 'V', 'X', 'Y')
		and t6.fdefaultloc<>16483  --
		union all
		select t2.fitemid,(t3.fqty*t12.fqty*t5.fprice) fprice
		from t_icitem t1
		inner join icbom t2 on t1.fitemid=t2.fitemid --and t2.fstatus>0 --成品
		inner join icbomchild t3 on t2.finterid=t3.finterid  --半成品
		inner join icbom t11 on t11.fitemid=t3.fitemid  --半成品
		inner join icbomchild t12 on t11.finterid=t12.finterid  --半成品子项
		inner join #temp t5 on t5.fitemid=t12.fitemid
		inner join t_icitem t6 on t6.fitemid=t3.fitemid --半成品
		inner join t_icitem t7 on t7.fitemid=t2.fitemid --成品
		inner join t_icitem t8 on t8.fitemid=t12.fitemid --半成品子项
		where left(t6.fnumber,1) in ('3','4') --and t1.ferpclsid=2
		and t1.fitemid in (select fitemid from #data) and left(t1.fnumber,1) in ('A', 'J', 'P', 'Q', 'R', 'V', 'X', 'Y')
		union all
		select t2.fitemid,(t3.fqty*t12.fqty*t5.fprice) fprice
		from t_icitem t1
		inner join icbom t2 on t1.fitemid=t2.fitemid --and t2.fstatus>0 --成品
		inner join icbomchild t3 on t2.finterid=t3.finterid  --半成品
		inner join icbom t11 on t11.fitemid=t3.fitemid  --半成品
		inner join icbomchild t12 on t11.finterid=t12.finterid  --半成品子项
		inner join #temp t5 on t5.fitemid=t12.fitemid
		inner join t_icitem t6 on t6.fitemid=t3.fitemid --半成品
		inner join t_icitem t7 on t7.fitemid=t2.fitemid --成品
		inner join t_icitem t8 on t8.fitemid=t12.fitemid --半成品子项
		where left(t6.fnumber,1) in ('5') and t8.fname not like '回收件%' --and t1.ferpclsid=2
		and t1.fitemid in (select fitemid from #data) and left(t1.fnumber,1) in ('A', 'J', 'P', 'Q', 'R', 'V', 'X', 'Y')
		union all
		select t2.fitemid,(t3.fqty*t5.fprice) fprice
		from t_icitem t1
		inner join icbom t2 on t1.fitemid=t2.fitemid --and t2.fstatus>0 --成品
		inner join icbomchild t3 on t2.finterid=t3.finterid  --半成品
		inner join icbom t11 on t11.fitemid=t3.fitemid  --半成品
		inner join (
-- 			select distinct t1.fitemid,(select top 1 fitemid from t_icitem where fparentid=t1.fparentid and fname like '%拆盒%' ) fchiheitemid
-- 			from t_icitem t1
-- 			inner join icbomchild t2 on t1.fitemid=t2.fitemid
-- 			where t1.fnumber like '5.%' and t1.fname not like '%拆盒%'
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
		) t12 on t11.fitemid=t12.fitemid --半成品同级回收壳
		inner join t_icitem t6 on t6.fitemid=t3.fitemid --半成品
		inner join t_icitem t7 on t7.fitemid=t2.fitemid --成品
		inner join t_icitem t8 on t8.fitemid=t12.fchiheitemid --半成品同级回收壳
		inner join #temp t5 on t5.fitemid=t8.fitemid
		where left(t6.fnumber,1) in ('5') --and t1.ferpclsid=2
		and t1.fitemid in (select fitemid from #data) and left(t1.fnumber,1) in ('A', 'J', 'P', 'Q', 'R', 'V', 'X', 'Y')
	) t1 group by t1.fitemid
) t2 on t1.fitemid=t2.fitemid
inner join t_icitem t3 on t3.fitemid=t1.fitemid
--left join #data t4 on t4.fitemid=t1.fitemid
order by t3.fnumber

--更新自制件入库单单价
select t3.ftrantype,t3.fbillno,t3.fcheckerid,t2.fprice,t11.fplanprice,t11.fnumber,t11.fname,t11.fplanprice
--update t2 set fprice=t11.fplanprice,fauxprice=t11.fplanprice,famount=cast(t2.fqty*t11.fplanprice as decimal(24,2))
from icstockbillentry t2  
inner join icstockbill t3 on t2.finterid=t3.finterid  
inner join t_icitem t11 on t11.fitemid=t2.fitemid   
where year(t3.fdate)=2016 and month(t3.fdate)=8
and isnull(t3.FVchInterID,0)=0 and t3.FCancellation = 0 and t3.ftrantype in (2,10,40)
and t11.ferpclsid=2 --and t11.fplanprice=0
--and t11.fnumber not like 'F%' --and t11.fnumber like '%400830'  


SELECT T2.FNUMBER,T2.FNAME,T1.* 
--DELETE T1
FROM t_supplyentry T1 INNER JOIN T_ICITEM T2 ON T1.FITEMID=T2.FITEMID WHERE T2.FNUMBER LIKE 'A%'

--1.2 检查当期出入库自制件是否没有BOM--
select distinct t1.fname,t11.fnumber,t11.fname,t11.fplanprice,t11.ferpclsid,t4.fprice--,t5.fbegbal,t5.fendbal
from icstockbillentry t2  
inner join icstockbill t3 on t2.finterid=t3.finterid  
inner join t_icitem t11 on t11.fitemid=t2.fitemid   
left join icbom t9 on t9.fitemid=t2.fitemid 
left join t_supplier t1 on t1.fitemid= t11.F_117
left join t_supplyentry t4 on t4.fitemid=t2.fitemid
--left join icbal t5 on t5.fitemid=t11.fitemid
where year(t3.fdate)=2016 and month(t3.fdate)=8 --and t3.ftrantype=2
and isnull(t9.fitemid,0)=0 /*没有BOM*/ and t11.ferpclsid=2  
and t3.FCancellation = 0 --and left(t11.fnumber,1) not in ('2','5','1')

 
-- --自制件出入库的子件没有采购单价
-- select distinct t1.fname,t11.fnumber,t11.fname,t12.fnumber,t12.fname,t12.fplanprice,t12.ferpclsid
-- --select distinct t12.fnumber,t12.fname,t12.fplanprice,t12.ferpclsid
-- from icstockbillentry t2  
-- inner join icstockbill t3 on t2.finterid=t3.finterid  
-- inner join t_icitem t11 on t11.fitemid=t2.fitemid   
-- inner join icbom t9 on t9.fitemid=t2.fitemid 
-- inner join icbomchild t10 on t10.finterid=t9.finterid
-- inner join t_icitem t12 on t12.fitemid=t10.fitemid  --子项
-- left join t_supplier t1 on t1.fitemid= t11.F_117 --父项主供应商
-- left join t_supplyentry t4 on t4.fitemid=t10.fitemid
-- --left join icbal t5 on t5.fitemid=t11.fitemid
-- where year(t3.fdate)=2016 and month(t3.fdate)=8--and t3.ftrantype=2
-- and isnull(t4.fprice,0)=0 /*没采购价*/ and t12.ferpclsid=1  
-- and t3.FCancellation = 0 --and left(t11.fnumber,1) not in ('2','5','1')
-- and t12.fname not like '%标签%' --and t11.fplanprice=0


select m1.fnumber,m1.fname,m1.fplanprice
--update m2 set fplanprice=41.51
from t_icitem m1	
inner join t_ICItemMaterial m2 on m1.fitemid=m2.fitemid
and m1.fnumber>='8.01.10.800624' and m1.fnumber<='8.01.10.800624' and m2.fplanprice=0

-- --1.2 检查当期产品入库套装件是否没有套装清单
-- select distinct t1.fname,t11.fnumber,t11.fname,t11.fmodel
-- from icstockbillentry t2  
-- inner join icstockbill t3 on t2.finterid=t3.finterid  
-- inner join t_icitem t11 on t11.fitemid=t2.fitemid   
-- left join t_bossuitbill t9 on t9.fproductid=t2.fitemid 
-- left join t_supplier t1 on t1.fitemid= t11.F_117
-- where year(t3.fdate)=2016 and month(t3.fdate)=8 and t3.ftrantype=2
-- and isnull(t9.fid,0)=0 and t11.ferpclsid=2  and t3.FCancellation = 0
-- and t11.fname like '%套装%' and t11.fnumber not like 'F%' and t11.fnumber not like 'R%'
-- --and t11.F_117=25952 

--1.3 检查当期是否有未审核的出入库单据
select distinct t3.ftrantype,t3.fbillno,t3.fcheckerid
from icstockbillentry t2  
inner join icstockbill t3 on t2.finterid=t3.finterid  
inner join t_icitem t11 on t11.fitemid=t2.fitemid   
where year(t3.fdate)=2016 and month(t3.fdate)=8--and t3.ftrantype=2
and t3.fstatus=0 and t3.FCancellation = 0

--1.3 检查当期是否有作废的出入库单据
select distinct t3.finterid,t3.fbillno,t1.fname,t3.ftrantype --into #cancel  --drop table #cancel
from icstockbillentry t2  
inner join icstockbill t3 on t2.finterid=t3.finterid  
inner join t_icitem t11 on t11.fitemid=t2.fitemid   
inner join t_user t1 on t1.fuserid=t3.fbillerid
where year(t3.fdate)=2016 and month(t3.fdate)=8 and t3.FCancellation = 1

-- select distinct t3.ftrantype,t3.fbillno,t3.fcheckerid
-- --update t3 set FCancellation=0
-- --delete t3
-- from icstockbillentry t2  
-- inner join icstockbill t3 on t2.finterid=t3.finterid  
-- inner join t_icitem t11 on t11.fitemid=t2.fitemid   
-- where t3.finterid in (select finterid from #cancel)

select t2.fname,t1.* from t_log t1 inner join t_user t2 on t1.fuserid=t2.fuserid where t1.fdescription like '%SOUT022732%'

--1.4 更改外购入库单往来科目--
select ffullname,* from t_account where fname like '%外部%'--1107	1231.03.07	外部供应商  1209  ---    2202.07	外部暂估	

-- SELECT fcussentacctid,* 
-- --update t1 set fcussentacctid=1107
-- FROM ICSTOCKBILL t1 WHERE FTRANTYPE=1 and fdate>='2013-9-01' 
-- and isnull(FVchInterID,0)=0
-- and (isnull(fcussentacctid,0)=0) and t1.fsupplyid not in (20163,20224)
-- 
-- --select fname from t_supplier where fitemid in (20163,20224)  --select * from t_account where faccountid in (1107,1340,)
-- 
-- SELECT fcussentacctid,* 
-- --update t1 set fcussentacctid=1340
-- FROM ICSTOCKBILL t1 WHERE FTRANTYPE=1 and fdate>='2013-9-01' 
-- and isnull(FVchInterID,0)=0
-- and (isnull(fcussentacctid,0)=0) and t1.fsupplyid in (20163,20224)

SELECT fcussentacctid,* 
--update t1 set fcussentacctid=1746
FROM ICSTOCKBILL t1 WHERE FTRANTYPE=1 and fdate>='2013-9-01' 
and isnull(FVchInterID,0)=0
and (isnull(fcussentacctid,0)=0)

SELECT fcussentacctid,t1.fdate 
--update t1 set fcussentacctid=1209
FROM ICSTOCKBILL t1
inner join icstockbillentry t2 on t1.finterid=t2.finterid
left join icpurchaseentry t3 on t3.fsourceinterid=t2.finterid and t3.fsourceentryid=t2.fentryid
WHERE t1.FTRANTYPE=1 and t1.fdate>='2013-9-01' 
and isnull(t1.FVchInterID,0)=0
and (isnull(t3.finterid,0)=0) and t1.fcussentacctid<>1209


--select * from t_account where fname like '%暂估%' 

--3.4 其他入库存在返点单价--具体视情况而定


select t2.fqty,t13.fprice,t1.fname,t3.fcheckdate,t11.fnumber,t11.fname,t11.fmodel,t3.ftrantype,t3.fbillno,t3.fcheckerid,t2.fprice,t11.fplanprice,t2.fqty,t2.famount,t2.fnote
--update t2 set fprice=0.01,fauxprice=0.01,famount=cast(t2.fqty*0.01 as decimal(24,2))
--update t2 set fprice=t11.fplanprice,fauxprice=t11.fplanprice,famount=cast(t2.fqty*t11.fplanprice as decimal(24,2))
from icstockbillentry t2  
inner join icstockbill t3 on t2.finterid=t3.finterid  
inner join t_icitem t11 on t11.fitemid=t2.fitemid   
inner join t_item t1 on t1.fitemclassid=3010 and t1.fitemid=t3.fheadselfa9737
left join t_SupplyEntry t13 on t13.fitemid=t2.fitemid  --子
where year(t3.fdate)=2016 and month(t3.fdate)=8  and t3.ftrantype in (10)  --
and isnull(t3.FVchInterID,0)=0 and t3.FCancellation = 0 
--and t11.fname like '%芯片%' 
--and t11.fnumber not like 'A.%' and t11.fnumber not like 'p.%'
--and t11.fnumber like '2.%'
--and (t11.fnumber like '2.05%' or t11.fnumber like '2.06%' or t11.fnumber like '2.07%')
--and t1.fname like '%赠送%'
and t2.fprice=0
and t11.fplanprice<>0 order by t11.fnumber

--2.0 原材料先做材料出库核算
 

--2.1 更新计划单价  --my_p_CalZZMatilPrice

IF EXISTS (select * from sysobjects where name='my_p_CalZZMatilPrice' and xtype='p')  drop  procedure my_p_CalZZMatilPrice
go

create procedure [dbo].[my_p_CalZZMatilPrice] --
with encryption
as
set nocount on 

declare @sqls varchar (8000),@fprice decimal(24,5)

set @sqls=''

/*
select m1.fnumber,m1.fname,m1.fplanprice
--update m2 set fplanprice=0
from t_icitem m1	
inner join t_ICItemMaterial m2 on m1.fitemid=m2.fitemid
and m1.ferpclsid<>1 and m2.fplanprice=0
*/

exec GenerateLowestBomCode 1,1,0,''  --取得低位码  要从最低级算起

create table #MyNewPrice(fitemid int,fprice decimal(24,4))

insert into #MyNewPrice(fitemid,   fprice)
select distinct t4.fitemid,(case when t5.fcyid=1000 then t5.fprice*t1.fexchangerate else t5.fprice end) fprice
from (select fitemid,max(fentryid) fentryid from t_supplyentry group by fitemid) t4 
inner join t_supplyentry t5 on t4.fitemid=t5.fitemid and t4.fentryid=t5.fentryid
inner join t_currency t1 on t1.fcurrencyid=t5.fcyid

---0 当期出库价
insert into #MyNewPrice(fitemid,   fprice)
select distinct         t2.fitemid,max(t2.fprice) as fprice
from icstockbill t1
inner join icstockbillentry t2 on t1.finterid=t2.finterid
inner join t_icitem t3 on t2.fitemid=t3.fitemid
where t3.ferpclsid=1 and t1.ftrantype=24 and t2.fprice>0 
and  year(t1.fdate)=(select fvalue from t_systemprofile where fcategory='ic' and fkey='currentyear') 
and month(t1.fdate)=(select fvalue from t_systemprofile where fcategory='ic' and fkey='currentperiod') 
and t3.fitemid not in(select fitemid from #MyNewPrice)
group by t2.fitemid


---2 当期采购订单
insert into #MyNewPrice
select t2.fitemid,
max((case when fcurrencyid='1' then t2.fprice else  t2.fprice*cast(t1.fexchangerate as decimal(24,8)) end)) as fprice
from poorder t1
inner join poorderentry t2 on t1.finterid=t2.finterid
where year(t1.fdate)=(select fvalue from t_systemprofile where fcategory='ic' and fkey='currentyear') 
and month(t1.fdate)=(select fvalue from t_systemprofile where fcategory='ic' and fkey='currentperiod')
and t2.fitemid not in(select fitemid from #MyNewPrice)
group by t2.fitemid

--3 以前期间外购入库单单价
insert into #MyNewPrice
select t2.fitemid,max(t2.fprice) from icstockbill t1
inner join icstockbillentry t2 on t1.finterid=t2.finterid
where t1.ftrantype=1 and t2.fitemid not in(select fitemid from #MyNewPrice)
group by t2.fitemid

--1 期初单价
insert into #MyNewPrice
select * from 
(select fitemid,sum(fbegbal)/sum(fbegqty) as fprice from icbal where fyear=(select fvalue from t_systemprofile where fcategory='ic' and fkey='currentyear') and fperiod=(select fvalue from t_systemprofile where fcategory='ic' and fkey='currentperiod') and fbegqty>0 group by fitemid ) a
where fitemid not in(select fitemid from #MyNewPrice)

--先更新原材料单价
update t3 set fplanprice=t1.fprice
--select t2.fnumber,t2.fname,t4.fname,t2.fplanprice
from #MyNewPrice t1
inner join t_icitem t2 on t1.fitemid=t2.fitemid
inner join t_ICItemMaterial t3 on t2.fitemid=t3.fitemid
left join t_supplier t4 on t4.fitemid= t2.F_117
--where isnull(t3.fplanprice,0)=0 --and 
--t2.ferpclsid=1 --and t1.fptype=1


--select * from #MyNewPrice

--select * from t_LowestBomCode  --select * from t_icitem  select max(flowestbomcode) from t_LowestBomCode

--IF EXISTS (select * from sysobjects where name='#MyMultiParent' and xtype='u')  drop  Table #MyMultiParent

create table #MyMultiParent
(
finterid int IDENTITY (1, 1) NOT NULL ,
fbillno varchar(30),
fitemid int,
--fnumber varchar (20),
fqty decimal(14, 6),
FLowestBOMCode int,
fprice decimal(24,5),
)

create table #MultiBom
(
finterid int IDENTITY (1, 1) NOT NULL ,
fbillno varchar(30),
fpItemId int,
fitemid int,
fnumber varchar (20),
fqty decimal(14, 6),
fprice decimal(14, 6),
famount decimal(14, 6),
flevel int,
fcalflag int  --0 表示已经计算过，1表示还没计算过
)

insert into #MyMultiParent (fbillno,fitemid,fqty,FLowestBOMCode,fprice)
select '',t1.fitemid,1 fqty,t2.FLowestBOMCode,0
from t_icitem t1 
inner join t_LowestBomCode t2 on t1.fitemid=t2.fitemid
inner join icbom t3 on t1.fitemid=t3.fitemid  --用了Inner join
--where t1.ferpclsid in (2,3) and isnull(t1.fplanprice,0)=0   --只要做了BOM的就拿来算
order by t2.FLowestBOMCode desc

--先更新委外加工费,委外件计划价=原材料价+加工费
update t3 set fprice=t1.fprice
from #MyNewPrice t1
inner join t_icitem t2 on t1.fitemid=t2.fitemid
inner join #MyMultiParent t3 on t2.fitemid=t3.fitemid 
where --isnull(t3.fplanprice,0)=0 and 
t2.ferpclsid=3 --and t1.fptype=1

/*
--select t2.fnumber,t1.* from #MyMultiParent t1 inner join t_icitem t2 on t1.fitemid=t2.fitemid order by t1.FLowestBOMCode desc
*/

declare @iCurrentRecord int
declare @iMaxRecord int,@iMaxLevel int
declare @iPItemId int
declare @iLevel int
declare @fqty decimal(14, 6)
declare @ipCurrentRecord int
declare @ipMaxRecord int
declare @pfqty decimal(14, 6)
declare @fbillno varchar(30)

set @iCurrentRecord=1
set @ipCurrentRecord=1
set @iLevel=0
set @iMaxLevel=6  --6级够啦  --注意,第一级是最终产成品

while @iMaxLevel>=0
begin
	select @ipMaxRecord=max(finterid) from #MyMultiParent where flowestbomcode=@iMaxLevel

	while @ipCurrentRecord<=@ipMaxRecord
	begin
		select @iPItemId=fitemid,@pfqty=fqty,@fbillno=fbillno,@fprice=fprice from #MyMultiParent where finterid=@ipCurrentRecord

        --从最后一级开始算起就不再全部展开啦
		--select @fbillno,@iPItemId,t2.fitemid,t4.fnumber,@pfqty*(1+t2.fscrap/100)*t2.fqty,t4.fplanprice,t4.fplanprice*@pfqty*(1+t2.fscrap/100)*t2.fqty
		--select @fbillno,@iPItemId,t2.fitemid,t4.fnumber,@pfqty*t2.fqty,t4.fplanprice,t4.fplanprice*@pfqty*t2.fqty,0

		update m2 set fplanprice=m1.famount+@fprice
		from
		(
				select t1.fitemid,sum(t4.fplanprice*@pfqty*t2.fqty) famount
				from icbom t1
				inner join icbomchild t2 on t1.finterid=t2.finterid
				inner join t_icitem t3 on t1.fitemid=t3.fitemid
				inner join t_icitem t4 on t2.fitemid=t4.fitemid
				inner join (select fitemid,max(finterid) finterid from icbom group by fitemid) t5 on t5.finterid=t1.finterid
				--inner join t_SubMessage t17 ON t2.FOperID=t17.FInterID and t17.ftypeid=61
				where t1.fitemid=@iPItemId --and t1.fusestatus=1072 
				--and not (left(t4.fnumber,5) in ('1.06.','2.20.','1.04.') and t4.funitid<>29056) --膜 单位非PCS --and t2.foperid not in (40013,40019,40020,40028,40026,40012,40014,40039,40023)
				group by t1.fitemid
		) m1	inner join t_ICItemMaterial m2 on m1.fitemid=m2.fitemid  --用了inner join ,如果是外购件是不会更新的
		
      	set @ipCurrentRecord=@ipCurrentRecord+1
	end

	set @iMaxLevel=@iMaxLevel-1
end

--select * from t_measureunit where fitemid=29056

/*
update t3 set fplanprice=0.01
from t_icitem t2 
inner join t_ICItemMaterial t3 on t2.fitemid=t3.fitemid 
where isnull(t3.fplanprice,0)=0 and 
t2.ferpclsid=1 --and t1.fptype=1
*/

drop table #MyMultiParent
drop table #MultiBom
drop table #MyNewPrice

set nocount off

GO


--特殊估价
update t3 set fplanprice=3.5750000000
--select t2.fnumber,t2.fname,t4.fname,t2.fplanprice
from t_icitem t2 
inner join t_ICItemMaterial t3 on t2.fitemid=t3.fitemid
left join t_supplier t4 on t4.fitemid= t2.F_117
where --t2.fname like '%HP%cf350%粉仓%' and 
t2.fnumber like '6.01.060605.608879%' and isnull(t3.fplanprice,0)=0  


select ferpclsid from t_icitem where fnumber like '1.02.%'

--本期出入库自制件子项计划单价检查
-- select distinct t1.ferpclsid,t5.fname,t1.fnumber,t1.fname,t1.fmodel,t1.fplanprice,t4.fprice--,t2.fqty
-- from icstockbillentry t2  
-- inner join icstockbill t3 on t2.finterid=t3.finterid  
-- inner join t_icitem t11 on t11.fitemid=t2.fitemid    --父项
-- inner join icbom t18 on t18.fitemid=t2.fitemid 
-- inner join icbomchild t19 on t18.finterid=t19.finterid
-- left join t_supplyentry t4 on t4.fitemid=t19.fitemid
-- --left join t_supplier t1 on t1.fitemid= t11.F_117
-- inner join t_icitem t1 on t1.fitemid=t19.fitemid --子项
-- inner join t_stock t5 on t5.fitemid=t1.fdefaultloc
-- where year(t3.fdate)=2016 and month(t3.fdate)=8--and t3.ftrantype=2
-- and isnull(t1.fplanprice,0)=0 --and t11.ferpclsid=2  
-- and t3.FCancellation = 0 and t1.fname not like '%标签%'
-- --and not (left(t1.fnumber,5) in ('1.06.','2.20.','1.04.') and t1.funitid<>29056)
-- order by t1.fnumber

--本期出入库自制件父项计划单价检查
select distinct t21.fname,t11.fnumber,t11.fname,t11.fmodel,t11.fplanprice
from icstockbillentry t2  
inner join icstockbill t3 on t2.finterid=t3.finterid  
inner join t_icitem t11 on t11.fitemid=t2.fitemid    --父项
inner join icbom t18 on t18.fitemid=t2.fitemid 
left join t_supplier t21 on t21.fitemid= t11.F_117
where year(t3.fdate)=2016 and month(t3.fdate)=8 --and t3.ftrantype=2
and isnull(t11.fplanprice,0)=0 --and t11.ferpclsid=2  
and t3.FCancellation = 0


-- --套装子项计划单价检查
-- select t5.fbomnumber,t4.fname,t2.fnumber,t2.fname,t2.fmodel,t2.fplanprice,t1.fnumber,t1.fname,t1.fmodel
-- from t_BOSSuitBill t18 
-- inner join t_BOSSuitBillEntry t19 on t18.fid=t19.fid
-- inner join t_icitem t2 on t18.fproductid=t2.fitemid --父项
-- inner join t_ICItemMaterial t3 on t2.fitemid=t3.fitemid
-- inner join t_icitem t1 on t1.fitemid=t19.fitemid --子项
-- left join t_supplier t4 on t4.fitemid= t1.F_117
-- left join icbom t5 on t5.fitemid=t19.fitemid
-- where isnull(t1.fplanprice,0)=0 
-- order by t2.fnumber
-- 
-- 
-- --更新套装计划单价
-- select t3.fnumber,t3.fname,t3.fmodel,t2.fprice,t1.fplanprice
-- --update t1 set fplanprice=t2.fprice
-- from t_ICItemMaterial t1
-- inner join 
-- (
-- 	select t2.fitemid,sum(t19.fqty*t1.fplanprice) fprice
-- 	from t_BOSSuitBill t18 
-- 	inner join t_BOSSuitBillEntry t19 on t18.fid=t19.fid
-- 	inner join t_icitem t2 on t18.fproductid=t2.fitemid --父项
-- 	inner join t_icitem t1 on t1.fitemid=t19.fitemid --子项
-- 	left join t_supplier t4 on t4.fitemid= t1.F_117
-- 	left join icbom t5 on t5.fitemid=t19.fitemid
-- 	group by t2.fitemid
-- ) t2 on t1.fitemid=t2.fitemid
-- inner join t_icitem t3 on t1.fitemid=t3.fitemid
-- where t3.fplanprice<>t2.fprice 
-- --and t3.fshortnumber='b49879'


-- --投料单子项单价检查
-- select distinct t6.fplanprice,t6.fnumber,t6.fname,t6.fmodel
-- --select t3.fbillno 任务单号,t1.fbillno 单据编号,t5.fnumber 产品编码,t5.fname 产品名称,t5.fmodel 产品规格型号,t6.fnumber 物料编码,t6.fname 物料名称,t6.fmodel 物料规格型号,t6.fplanprice 单价,t4.fqtyscrap 单位用量,cast(t6.fplanprice*t4.fqtyscrap as decimal(24,2)) 单位成本
-- from icstockbill t1
-- inner join icstockbillentry t2 on t1.finterid=t2.finterid
-- inner join icmo t3 on t2.ficmointerid=t3.finterid
-- inner join ppbomentry t4 on t4.ficmointerid=t3.finterid
-- inner join t_icitem t5 on t3.fitemid=t5.fitemid --父项
-- inner join t_icitem t6 on t6.fitemid=t4.fitemid  --子项
-- inner join t_stock t7 on t7.fitemid=t6.fdefaultloc
-- where t1.fdate>='2016-02-01' and t1.fdate<='2016-02-29' and t1.ftrantype=2
-- --and isnull(t6.fplanprice,0)=0 and not (left(t6.fnumber,5) in ('1.06.','2.20.','1.04.') and t4.funitid<>29056) 
-- --and t6.fnumber not like '2.01.%'  
-- and t6.fmodel not like '%客供%' and t6.fmodel not like '%标签%'
-- and t7.fname not like '%代管%' 
-- --and t5.fnumber not like 'F%'
-- order by t6.fnumber

----按实际领料
--select t4.fbillno,t1.fprice,t3.fplanprice,t2.fprice,t3.fnumber,t3.fname,t2.fprice*t1.fqty famount
----update t1 set fprice=t2.fprice,fauxprice=t2.fprice,famount=cast(t1.fqty*t2.fprice as decimal(24,2))
--from icstockbillentry t1
--inner join 
--(
--	select t2.ficmointerid,sum(t2.famount/t3.fqty) fprice
--	from icstockbill t1
--	inner join icstockbillentry t2 on t1.finterid=t2.finterid
--	inner join icmo t3 on t2.ficmointerid=t3.finterid
--	inner join t_icitem t5 on t3.fitemid=t5.fitemid --父项
--	where t1.fdate>='2016-02-01' and t1.fdate<='2016-02-29' and t1.ftrantype=24
--	group by t2.ficmointerid
--) t2 on t1.ficmointerid=t2.ficmointerid 
--inner join t_icitem t3 on t1.fitemid=t3.fitemid
--inner join icstockbill t4 on t4.finterid=t1.finterid
--where t4.fdate>='2016-02-01' and t4.fdate<='2016-02-29' and t4.ftrantype=2
--and isnull(t4.FVchInterID,0)=0 and t4.FCancellation = 0 
-- 
-- select t1.fbillno,t2.finterid,t2.fentryid,t6.fnumber,t6.fname,t3.fqty,t6.fplanprice,t4.fqtymust,(t4.fqtymust/t3.fqty*t6.fplanprice) fprice
-- from icstockbill t1
-- inner join icstockbillentry t2 on t1.finterid=t2.finterid
-- inner join icmo t3 on t2.ficmointerid=t3.finterid
-- inner join ppbomentry t4 on t4.ficmointerid=t3.finterid
-- inner join t_icitem t5 on t3.fitemid=t5.fitemid --父项
-- inner join t_icitem t6 on t6.fitemid=t4.fitemid  --子项
-- where t1.fdate>='2016-02-01' and t1.fdate<='2016-02-29' and t1.ftrantype=2
-- and not (left(t6.fnumber,5) in ('1.06.','2.20.','1.04.') and t4.funitid<>29056) and t6.fnumber not like '2.01.%' 
-- and t5.fnumber like '%B.01.004.B45058'
-- order by t1.fbillno




-- 
-- --更新产品入库单单价--含包材
-- select t4.fbillno,t1.finterid,t1.fentryid,t1.fprice,t3.fplanprice,t2.fprice,t3.fnumber,t3.fname
-- --update t1 set fprice=t2.fprice,fauxprice=t2.fprice,famount=cast(t1.fqty*t2.fprice as decimal(24,2))
-- from icstockbillentry t1
-- inner join 
-- (
-- 	select t2.finterid,t2.fentryid,sum(t4.fqtymust/t3.fqty*t6.fplanprice) fprice
-- 	from icstockbill t1
-- 	inner join icstockbillentry t2 on t1.finterid=t2.finterid
-- 	inner join icmo t3 on t2.ficmointerid=t3.finterid
-- 	inner join ppbomentry t4 on t4.ficmointerid=t3.finterid
-- 	inner join t_icitem t5 on t3.fitemid=t5.fitemid --父项
-- 	inner join t_icitem t6 on t6.fitemid=t4.fitemid  --子项
-- 	where t1.fdate>='2016-02-01' and t1.fdate<='2016-02-29' and t1.ftrantype=2
-- 	and not (left(t6.fnumber,5) in ('1.06.','2.20.','1.04.') and t4.funitid<>29056) and t6.fnumber not like '2.01.%' 
-- 	group by t2.finterid,t2.fentryid
-- ) t2 on t1.finterid=t2.finterid and t1.fentryid=t2.fentryid
-- inner join t_icitem t3 on t1.fitemid=t3.fitemid
-- inner join icstockbill t4 on t4.finterid=t1.finterid
-- where t3.fbatchmanager=1 --and t2.fprice>t1.fprice
-- and isnull(t4.FVchInterID,0)=0 and t4.FCancellation = 0 
-- and t3.fnumber not like 'F%' --and t3.fnumber like '%400830' 

--3.1 检查计划单价是否有错误
select fplanprice,* from t_icitem where fnumber not like '5.%' and fplanprice>20
select fplanprice,* from t_icitem where fnumber like '4.%' and fplanprice>500

select fplanprice,* from t_icitem where fnumber like '1.01.0002.002%'



--3.1 供应链->存货核算->无单价单据维护->更新无单价单据  (用计划价更新)  --检查没有单价的入库单

--3.2 检查更新后当期仍无单价的入库单据
select t2.fqty,t3.ftrantype,t3.fbillno,t11.fnumber,t11.fname,t11.fmodel,t3.fcheckerid,t2.fprice,t11.fplanprice,t2.fqty,t11.fplanprice*t2.fqty
--update t2 set fprice=7.69,fauxprice=7.69,famount=cast(t2.fqty*7.69 as decimal(24,2))
--update t2 set fprice=0.01,fauxprice=0.01,famount=cast(t2.fqty*0.01 as decimal(24,2))
--update t2 set fprice=t11.fplanprice,fauxprice=t11.fplanprice,famount=cast(t2.fqty*t11.fplanprice as decimal(24,2))
--update t2 set famount=0.01,fprice=cast(0.01/t2.fqty as decimal(24,5)),fauxprice=cast(0.01/t2.fqty as decimal(24,5))
from icstockbillentry t2  
inner join icstockbill t3 on t2.finterid=t3.finterid  
inner join t_icitem t11 on t11.fitemid=t2.fitemid   
where year(t3.fdate)=2016 and month(t3.fdate)=8 --and t11.fshortnumber='210644' 
and isnull(t3.FVchInterID,0)=0 and t3.FCancellation = 0 
and (t3.ftrantype in (1,2,3,5,10,40,41) or (t3.ftrantype in (24,29) and t3.frob=-1)) --and t2.fprice<>t11.fplanprice
and (t2.fprice<=0 or t2.famount=0 ) --and t11.fnumber like '1.06.001.001432%'
--and t11.fnumber not like 'F%'  
--and (t11.fnumber like '2.05%' or t11.fnumber like '2.06%' or t11.fnumber like '2.07%')
--and (t11.fnumber like '2.99%')
order by t3.fbillno

-- select t2.fprice
-- from poorder t1
-- inner join poorderentry t2 on t1.finterid=t2.finterid
-- inner join t_icitem t3 on t2.fitemid=t3.fitemid
-- where t3.fnumber='G.01.016.G16002'

--3.3 外购入库生成凭证--有发票和暂估


select t2.fdcstockid,t2.fscstockid,t3.fcheckdate,t11.fnumber,t11.fname,t3.ftrantype,t3.fbillno,t3.fcheckerid,t2.fprice,t11.fplanprice,t2.fqty,t2.famount,t2.fnote
--update t3 set ftrantype=29
--update t2 set fdcstockid=t2.fscstockid
--update t2 set fprice=0.01,fauxprice=0.01,famount=cast(t2.fqty*0.01 as decimal(24,2))
from icstockbillentry t2  
inner join icstockbill t3 on t2.finterid=t3.finterid  
inner join t_icitem t11 on t11.fitemid=t2.fitemid   
where year(t3.fdate)=2016 and month(t3.fdate)=8 
and isnull(t3.FVchInterID,0)=0 and t3.FCancellation = 0 
and t3.fbillno in ('sout037760','sout037761','sout037762')

--无期初无入库但出库
select t2.fitemid into #ttt
from icstockbillentry t2  
inner join icstockbill t3 on t2.finterid=t3.finterid  
inner join t_icitem t11 on t11.fitemid=t2.fitemid   
where year(t3.fdate)=2016 and month(t3.fdate)=8 
and t2.fitemid not in (select fitemid from icbal where fyear=2015 and fperiod=4 and fbegqty>0)  --无期初
and t2.fitemid not in 
(
	select m2.fitemid 
	from icstockbill m1 
	inner join icstockbillentry m2 on m1.finterid=m2.finterid 
	where m1.ftrantype in (1,2,3,5,10,40,41) and year(m1.fdate)=2016 and month(m1.fdate)=8 and m1.frob=1
)
and isnull(t3.FVchInterID,0)=0 and t3.FCancellation = 0 
and t3.ftrantype=21 and t3.frob=1

select t3.fdate,t2.fdcstockid,t2.fscstockid,t3.fcheckdate,t11.fnumber,t11.fname,t3.ftrantype,t3.fbillno,t3.fcheckerid,t2.fprice,t11.fplanprice,t2.fqty,t2.famount,t2.fnote
--update t3 set fdate='2016-02-29'
from icstockbillentry t2  
inner join icstockbill t3 on t2.finterid=t3.finterid  
inner join t_icitem t11 on t11.fitemid=t2.fitemid   
where year(t3.fdate)=2016 and month(t3.fdate)=8 
and isnull(t3.FVchInterID,0)=0 and t3.FCancellation = 0 
and t3.ftrantype=2 and t3.frob=1
and t2.fitemid in (select fitemid from #ttt)


--4.1 材料出库核算：计算外购件的出库成本  

--4.1.1 检查调拨单的问题
SELECT freftype,* 
--update t2 set fpriceref=t2.fprice,fauxpriceref=t2.fauxprice,famtref=t2.famount
FROM ICSTOCKBILL t1 
inner join icstockbillentry t2 on t1.finterid=t2.finterid
WHERE t1.FTRANTYPE=41 and year(t1.fdate)=2016 and month(t1.fdate)=8 
and isnull(t1.FVchInterID,0)=0
and t2.famtref<>t2.famount


--出库异常调整
Select --CAST((t1.FYear+t1.FPeriod*0.01) AS VARCHAR) AS FPeriodName,t2.FItemID,
t2.FNumber,t2.FName,
--t2.FModel,t2.FPriceDecimal,t2.FQtyDecimal,
t1.FBatchNO,t1.FAmount,t1.FQty,t1.FPrice,t1.FStockID,--t2.FErpClsID,t2.FAuxClassID  ,
t2.fplanprice,-t1.FAmount+t2.fplanprice*t1.fqty
from ICAbnormalBalance t1 
Inner join t_ICItem t2  On t1.FItemID = t2.FItemID  
Where t1.FYear=2014
And t1.FPeriod=1
And NOT (t1.FPrice=0 AND Round(t1.FAmount,2)=0 AND t1.FQty=0) 
Order by t2.FNumber,t2.FModel



-- ----4.3 产品入库单价不靠谱的数据
-- select t11.fnumber,t11.fname,t11.fmodel,t2.fprice,t11.fplanprice,t2.fqty,t3.ftrantype,t3.fbillno,t3.fcheckerid
-- --update t2 set fprice=t11.fplanprice,fauxprice=t11.fplanprice,famount=cast(t2.fqty*t11.fplanprice as decimal(24,2))
-- from icstockbillentry t2  
-- inner join icstockbill t3 on t2.finterid=t3.finterid  
-- inner join t_icitem t11 on t11.fitemid=t2.fitemid   
-- where year(t3.fdate)=2016 and month(t3.fdate)=8 and t3.ftrantype in (2)  --
-- and isnull(t3.FVchInterID,0)=0 and t3.FCancellation = 0 
-- and t2.fprice>20 --t11.fplanprice
-- and t11.fname not like '%套装%'
-- 
-- select t3.fdate,t11.fnumber,t3.ftrantype,t3.fbillno,t3.fcheckerid,t2.fprice,t11.fplanprice,t2.fqty
-- --update t3 set fdate='2016-02-01'
-- from icstockbillentry t2  
-- inner join icstockbill t3 on t2.finterid=t3.finterid  
-- inner join t_icitem t11 on t11.fitemid=t2.fitemid   
-- where year(t3.fdate)=2016 and month(t3.fdate)=8 --and t3.ftrantype in (2)  --
-- and isnull(t3.FVchInterID,0)=0 and t3.FCancellation = 0 
-- and t3.fbillno='SOUT053385'



----4.4 产品出库核算：计算自制件的出库成本  

--5.1 检查当期无单价的出库单据--无单价
select t11.fnumber,t11.fname,t3.frob,t3.ftrantype,t3.fbillno,t3.fcheckerid,t2.fprice,t11.fplanprice,t2.fqty,t2.famount
--update t2 set fprice=t11.fplanprice,fauxprice=t11.fplanprice,famount=cast(t2.fqty*t11.fplanprice as decimal(24,2))
--update t2 set fprice=0.02,fauxprice=0.02,famount=cast(t2.fqty*0.02 as decimal(24,2))
--update t2 set fprice=cast(0.01/t2.fqty as decimal(24,4)),fauxprice=cast(0.01/t2.fqty as decimal(24,4)),famount=0.01
--delete t2
from icstockbillentry t2  
inner join icstockbill t3 on t2.finterid=t3.finterid  
inner join t_icitem t11 on t11.fitemid=t2.fitemid   
where year(t3.fdate)=2016 and month(t3.fdate)=8
and isnull(t3.FVchInterID,0)=0  and t3.FCancellation = 0 and t3.ftrantype in (24,29,43,21)
and (t2.fprice<=0 or t2.famount=0 ) --and t11.ferpclsid=1
--and t3.fbillno like 'SOUT029720'
order by t3.ftrantype


--select t2.fpriceref,t2.fauxpriceref,t2.famtref,t3.frob,t3.ftrantype,t3.fbillno,t3.fcheckerid,t2.fprice,t11.fplanprice*t2.fqty fplanamount,t11.fplanprice,t2.fqty,t2.famount,t11.fnumber,t11.fname,t11.fmodel
----update t2 set fprice=t11.fplanprice,fauxprice=t11.fplanprice,famount=cast(t2.fqty*t11.fplanprice as decimal(24,2)),fpriceref=t11.fplanprice,fauxpriceref=t11.fplanprice,famtref=cast(t2.fqty*t11.fplanprice as decimal(24,2))
----update t2 set fprice=0.02,fauxprice=0.02,famount=cast(t2.fqty*0.02 as decimal(24,2))
--from icstockbillentry t2  
--inner join icstockbill t3 on t2.finterid=t3.finterid  
--inner join t_icitem t11 on t11.fitemid=t2.fitemid   
--where year(t3.fdate)=2016 and month(t3.fdate)=8
----and isnull(t3.FVchInterID,0)=0  and t3.FCancellation = 0 
--and t3.ftrantype in (41)  
--and (t2.fprice<=0 or t2.famount=0 ) 
--order by t3.ftrantype

--6.1 将需要纳入共耗的生产成本生成凭证(盘盈、盘亏、其它入库、其它出库)  --暂定盘盈、盘亏、办公用品其它出库不拿来共耗
--6.2 领料单生成凭证--生成凭证之前检查一下是否有负单价

--7.1 本期理论在制成本计算

set nocount on

--本期领料数
select t2.ficmointerid,t2.FPPBomEntryID,sum(t2.fqty) fqty
into #ppbom
from icstockbillentry t2  
inner join icstockbill t3 on t2.finterid=t3.finterid 
where t3.fdate>='2016-02-01' and t3.fdate<='2016-02-29'
and isnull(t2.ficmointerid,0)<>0 and t3.ftrantype=24  and t3.FCancellation = 0 
group by t2.ficmointerid,t2.FPPBomEntryID

--本期领料单涉及到的任务单
select t2.ficmointerid into #data from #ppbom t2 group by t2.ficmointerid

--未完全入库的任务单--有些入库比计划少，且以后也不再入了
select t1.finterid ficmointerid,t1.fqty,isnull(t2.fqty,0) fstockqty
into #temp
from icmo t1
left join 
(
	--本期截止日期之前入库数量
	select t2.ficmointerid,sum(t2.fqty) fqty
	from icstockbillentry t2  
	inner join icstockbill t3 on t2.finterid=t3.finterid 
	inner join #data t1 on t1.ficmointerid=t2.ficmointerid
	where t3.fdate<='2016-02-29' --本期截止日期
	and isnull(t2.ficmointerid,0)<>0 and t3.ftrantype=2  and t3.FCancellation = 0 
	group by t2.ficmointerid
) t2 on t1.finterid=t2.ficmointerid 
inner join #data t3 on t1.finterid=t3.ficmointerid
where t1.fqty>isnull(t2.fqty,0)

--select t2.fbillno,t3.fnumber,t3.fname,t1.* from #temp t1 inner join icmo t2 on t1.ficmointerid=t2.finterid inner join t_icitem t3 on t2.fitemid=t3.fitemid

--理论在制金额--634158.67
--select * from my_t_Online where 年度=2015 and 期间=2
--delete from my_t_Online where 年度=2015 and 期间=2
--insert into my_t_Online 
select 2015 年度,5 期间,t9.fname 车间,t5.fbillno 任务单号,t8.fnumber 产品编码,t8.fname 产品名称,t8.fmodel 产品规格型号,
t4.fnumber 物料编码,t4.fname 物料名称,t4.fmodel 物料规格型号,t1.fqty 本期领料数,
t5.fqty 产品任务数,t6.fstockqty 本期产品入库数,t3.fauxqtyscrap 单位用量,cast(t3.fscrap/100 as decimal(24,4)) 损耗率,
ceiling(t6.fstockqty*t3.fauxqtyscrap*(1+t3.fscrap/100)) 本期入库消耗数,
(t1.fqty-ceiling(t6.fstockqty*t3.fauxqtyscrap*(1+t3.fscrap/100))) 在制数,t4.fplanprice 计划单价,
(t1.fqty-ceiling(t6.fstockqty*t3.fauxqtyscrap*(1+t3.fscrap/100))) *t4.fplanprice 计划金额 --,t5.fcommitdate
--select cast(sum((t1.fqty-ceiling(t6.fstockqty*isnull(t3.fauxqtyscrap,0)*(1+isnull(t3.fscrap,0)/100))) *isnull(t4.fplanprice,0)) as decimal(24,2))
from icmo t5 
inner join #temp t6 on t5.finterid=t6.ficmointerid
inner join ppbom t2 on t5.finterid=t2.ficmointerid
inner join ppbomentry t3 on t2.finterid=t3.finterid
inner join #ppbom t1 on t1.ficmointerid=t5.finterid and t3.fentryid=t1.FPPBomEntryID
inner join t_icitem t4 on t3.fitemid=t4.fitemid
inner join t_icitem t8 on t5.fitemid=t8.fitemid
inner join t_department t9 on t9.fitemid=t5.fworkshop
inner join t_measureunit t10 on t10.fitemid=t4.funitid
where t1.fqty>ceiling(t6.fstockqty*t3.fauxqtyscrap*(1+t3.fscrap/100)) and 
t5.fcommitdate>='2015-12-10'
--and t8.fname like '%专利%'
order by t4.fshortnumber

drop table #ppbom
drop table #temp
drop table #data

set nocount off

go



/*
--本期产品入库金额--22236577.05  22643213.34 22500221.69
select sum(t2.famount)
from icstockbillentry t2  
inner join icstockbill t3 on t2.finterid=t3.finterid  
inner join t_icitem t11 on t11.fitemid=t2.fitemid   
where year(t3.fdate)=2016 and month(t3.fdate)=8 and t3.ftrantype in (2,10,40)
and isnull(t3.FVchInterID,0)=0 and t3.FCancellation = 0 --and t11.fnumber not like 'F%'

--本期领料金额--21095502.00  21682529.15
select sum(t2.famount)
from icstockbillentry t2  
inner join icstockbill t3 on t2.finterid=t3.finterid  
inner join t_icitem t11 on t11.fitemid=t2.fitemid  
inner join t_department t4 on t4.fitemid=t3.fdeptid 
where year(t3.fdate)=2016 and month(t3.fdate)=8 and t3.ftrantype in (24,29,43)
--and isnull(t3.FVchInterID,0)=0 
and t3.FCancellation = 0 
--and t4.fname not like '诚杰%'

--  -产品入库-本期其它入库-本期盘盈入库+本期其他出库+本期盘亏损毁+生产领料  392567.75
select sum(case when t3.ftrantype in (40,10,2) then -t2.famount else t2.famount end)
from icstockbillentry t2  
inner join icstockbill t3 on t2.finterid=t3.finterid  
inner join t_icitem t11 on t11.fitemid=t2.fitemid  
inner join t_department t4 on t4.fitemid=t3.fdeptid 
where year(t3.fdate)=2016 and month(t3.fdate)=8
--and isnull(t3.FVchInterID,0)=0 
and t3.FCancellation = 0 
and t4.fname not like '诚杰%' and t3.ftrantype in (2,24) and t11.fnumber not like 'F%' --(2,40,10,29,43,24)

select * from ictranstype

*/

--8.0 检查总帐所属期间
--8.1 待分摊金额--在科目<5001.01.01>余额表中查询的余额，也可以在共耗费用中引入后加上期初得到--12145707.89
--=期初余额+本期其他出库+本期盘亏损毁+本期领料金额-(本期产品入库金额+本期其它入库+本期盘盈入库)-本期在制金额
--select 1249967.61+493003.50-2147782.64=-404811.53  --期初也要去掉

--将科目<5001.01>余额表引出至EXCEL,非诚杰的期末借方余额之和(明细)-非诚杰的期末贷方余额之和-本期产品入库金额-本期在制金额
--select 13012565.77-11920700.22-1934106.43=-842240.88
--将期末贷方余额以负数形式剪切到期末借方余额


--9 分摊

--9.1 部门间分配系数--

IF not EXISTS (select * from sysobjects where name='My_t_CBStandardCoefficient' and xtype='u')  --drop  Table My_t_CBStandardCoefficient
begin
	create table My_t_CBStandardCoefficient(FYear int,FPeriod int,FDeptID int,finterid int,fentryid int,fitemid int,FQty decimal(24,8),FStandardID int)  --6 部门间 7 部门内
end

go

set nocount on 

declare @iCurrentYear as int,@iCurrentPeriod int  

Select @iCurrentYear=FValue From t_SystemProfile Where FCategory ='CB' And FKey ='CurrentYear'  
Select @iCurrentPeriod=FValue From t_SystemProfile Where FCategory ='CB' And FKey ='CurrentPeriod'  

delete from My_t_CBStandardCoefficient where FYear=@iCurrentYear and FPeriod=@iCurrentPeriod and FStandardID=6  

select t3.fdeptid,cast(sum(t2.famount) as decimal(28,8)) fqty  
into #CostMatilAmount  
from icstockbillentry t2  
inner join icstockbill t3 on t2.finterid=t3.finterid  
inner join t_icitem t11 on t11.fitemid=t2.fitemid  
inner join cbCostobj t4 on t4.FStdProductID=t11.fitemid  
inner join icbom t9 on t9.fitemid=t2.fitemid  
where year(t3.fdate)=@iCurrentYear and month(t3.fdate)=@iCurrentPeriod  
and t3.ftrantype=2 and t11.fbatchmanager=1 and t3.FCancellation = 0 
and t3.frob=1 and left(t11.fnumber,1) in ('a','p','x','y','j','v')
group by t3.fdeptid  
Having Sum(t2.fqty) <> 0 

INSERT INTO My_t_CBStandardCoefficient (FYear,        FPeriod,        FStandardID,FDeptID,   FQty)  
select                                  @iCurrentYear,@iCurrentPeriod,6,          t1.fdeptid,t1.fqty/t2.fqty fqty  
from #CostMatilAmount t1  
Inner Join  
(  
    select cast(sum(fqty) as decimal(28,8)) fqty  
    from #CostMatilAmount  
    Having Sum(fqty) > 0  
) t2 on 1=1   

delete from My_t_CBStandardCoefficient where FYear=@iCurrentYear and FPeriod=@iCurrentPeriod and fqty<0.00000001 and FStandardID=6 

declare @fyuqty decimal(24,8),@fdeptid int

select @fyuqty=(1-sum(fqty)) from My_t_CBStandardCoefficient where FYear=@iCurrentYear and FPeriod=@iCurrentPeriod and fqty>0 and FStandardID=6 

--分给最大的
select top 1 @fdeptid=fdeptid from My_t_CBStandardCoefficient where FYear=@iCurrentYear and FPeriod=@iCurrentPeriod and fqty>0 and FStandardID=6 order by fqty desc

update t1 set fqty=t1.fqty+@fyuqty from My_t_CBStandardCoefficient t1 where FYear=@iCurrentYear and FPeriod=@iCurrentPeriod and fqty>0 and fdeptid=@fdeptid and FStandardID=6 


drop table #CostMatilAmount 

--select * from My_t_CBStandardCoefficient where fyear=2014 and fperiod=11 and FStandardID=6

go


--9.2 部门内费用分配系数

set nocount on 

declare @iCurrentYear as int,@iCurrentPeriod int ,@finterid int,@fentryid int
 
Select @iCurrentYear=FValue From t_SystemProfile Where FCategory ='CB' And FKey ='CurrentYear'  
Select @iCurrentPeriod=FValue From t_SystemProfile Where FCategory ='CB' And FKey ='CurrentPeriod' 
 
delete from My_t_CBStandardCoefficient where FYear=@iCurrentYear and FPeriod=@iCurrentPeriod and FStandardID=7  

select t3.fdeptid,t11.fitemid,cast(sum(t2.famount) as decimal(28,8)) fqty,t2.finterid,t2.fentryid 
into #CostMatilAmount  
from icstockbillentry t2  
inner join icstockbill t3 on t2.finterid=t3.finterid  
inner join t_icitem t11 on t11.fitemid=t2.fitemid  
inner join cbCostobj t4 on t4.FStdProductID=t11.fitemid  
inner join icbom t9 on t9.fitemid=t2.fitemid  
where year(t3.fdate)=@iCurrentYear and month(t3.fdate)=@iCurrentPeriod  
and t3.ftrantype=2 and t11.fbatchmanager=1 and t3.FCancellation = 0 
and t3.frob=1 and left(t11.fnumber,1) in ('a','p','x','y','j','v')
group by t3.fdeptid,t11.fitemid,t2.finterid,t2.fentryid 
Having Sum(t2.famount) <> 0 

INSERT INTO My_t_CBStandardCoefficient (FYear,        FPeriod,        FStandardID,FDeptID,   finterid,   fentryid,   fitemid,   FQty)  
select                                 @iCurrentYear,@iCurrentPeriod,7,          t2.fdeptid,t1.finterid,t1.fentryid,t1.fitemid,t1.FQty/t2.FQty fqty  
from #CostMatilAmount t1  
Inner Join  
(  
    select fdeptid,  
    cast(sum(FQty) as decimal(28,8)) FQty  
    from #CostMatilAmount  
    group by fdeptid having sum(FQty)>0  
) t2 on t1.fdeptid=t2.fdeptid 

delete from My_t_CBStandardCoefficient where FYear=@iCurrentYear and FPeriod=@iCurrentPeriod and fqty<0.00000001 and FStandardID=7 

declare @fyuqty decimal(24,8),@fdeptid int

DECLARE icbom_cursor CURSOR FOR	
select distinct fdeptid
from My_t_CBStandardCoefficient 
where FYear=@iCurrentYear and FPeriod=@iCurrentPeriod and fqty>0 and FStandardID=7 

OPEN icbom_cursor

FETCH NEXT FROM icbom_cursor 
INTO @fdeptid --@fdeptid,@fsourcetrantype,@fsourceinterid,@fisbackflush,

WHILE @@FETCH_STATUS = 0
BEGIN 
	select @fyuqty=(1-sum(fqty)) 
	from My_t_CBStandardCoefficient 
	where FYear=@iCurrentYear and FPeriod=@iCurrentPeriod and fqty>0 and FStandardID=7 and fdeptid=@fdeptid 

	select top 1 @fdeptid=fdeptid,@finterid=finterid,@fentryid=fentryid 
	from My_t_CBStandardCoefficient 
	where FYear=@iCurrentYear and FPeriod=@iCurrentPeriod and fdeptid=@fdeptid and fqty>0 and FStandardID=7 
	order by fqty desc

	update t1 set fqty=t1.fqty+@fyuqty 
	from My_t_CBStandardCoefficient t1 
	where FYear=@iCurrentYear and FPeriod=@iCurrentPeriod and fqty>0 and fdeptid=@fdeptid 
	and finterid=@finterid and fentryid=@fentryid and FStandardID=7 

	FETCH NEXT FROM icbom_cursor 
    INTO @fdeptid --@fdeptid,@fsourcetrantype,@fsourceinterid,@fisbackflush,
END

CLOSE icbom_cursor
DEALLOCATE icbom_cursor

drop table #CostMatilAmount

--select * from My_t_CBStandardCoefficient where fyear=2014 and fperiod=11 and FStandardID=7 order by fdeptid

go

--10.1 分摊

declare @fsumamount decimal(24,2)
declare @iCurrentYear as int,@iCurrentPeriod int ,@finterid int,@fentryid int
 
Select @iCurrentYear=FValue From t_SystemProfile Where FCategory ='CB' And FKey ='CurrentYear'  
Select @iCurrentPeriod=FValue From t_SystemProfile Where FCategory ='CB' And FKey ='CurrentPeriod' 

set @fsumamount=170000

--select t3.fdeptid,t11.fitemid,t4.fqty,t1.fqty,cast((@fsumamount*t4.fqty*t1.fqty+t2.famount) as decimal(24,2)) famount,t2.famount,cast((@fsumamount*t4.fqty*t1.fqty+t2.famount)/t2.fqty as decimal(24,4)) fprice,t2.fprice
--update t2 set fprice=cast((@fsumamount*t4.fqty*t1.fqty+t2.famount)/t2.fqty as decimal(24,4))
update t2 set fauxprice=t2.fprice,famount=cast(t2.fprice*t2.fqty as decimal(24,2)) --先执行完上一行再执行此行
from icstockbillentry t2  
inner join icstockbill t3 on t2.finterid=t3.finterid  
inner join t_icitem t11 on t11.fitemid=t2.fitemid  
inner join My_t_CBStandardCoefficient t1 on t1.finterid=t2.finterid and t1.fentryid=t2.fentryid and t1.fyear=@iCurrentYear and t1.fperiod=@iCurrentPeriod and t1.FStandardID=7
inner join My_t_CBStandardCoefficient t4 on t4.fdeptid=t3.fdeptid and t4.fyear=@iCurrentYear and t4.fperiod=@iCurrentPeriod and t4.FStandardID=6
where year(t3.fdate)=2016 and month(t3.fdate)=8
and t3.ftrantype=2 and left(t11.fnumber,1) in ('a','p','x','y','j','v')
and t3.frob=1  and t3.FCancellation = 0 

go

--10.2 检查更新后单价小于0的产品入库单据
select t3.ftrantype,t3.fbillno,t3.fcheckerid,t2.fprice,t11.fplanprice,t2.fqty
--update t2 set fprice=t11.fplanprice,fauxprice=t11.fplanprice,famount=cast(t2.fqty*t11.fplanprice as decimal(24,2))
from icstockbillentry t2  
inner join icstockbill t3 on t2.finterid=t3.finterid  
inner join t_icitem t11 on t11.fitemid=t2.fitemid   
where year(t3.fdate)=2016 and month(t3.fdate)=8
and isnull(t3.FVchInterID,0)=0 and t3.FCancellation = 0 and t3.ftrantype in (2)
and (t2.fprice<=0 or t2.famount=0 ) 

--11.1 产品入库单生成凭证

--11.2 产成品出库核算：计算自制件的出库成本  --

--11.3 更新销售出库的计划单价和计划金额
select t3.ftrantype,t3.fbillno,t3.fcheckerid,t2.fprice,t11.fplanprice,t2.fqty,t2.fplanprice,t2.fauxplanprice,t2.fplanamount
--update t2 set fplanprice=t11.fplanprice,fauxplanprice=t11.fplanprice,fplanamount=cast(t2.fqty*t11.fplanprice as decimal(24,2))
from icstockbillentry t2  
inner join icstockbill t3 on t2.finterid=t3.finterid  
inner join t_icitem t11 on t11.fitemid=t2.fitemid   
where year(t3.fdate)=2016 and month(t3.fdate)=8
--and isnull(t3.FVchInterID,0)=0 
and t3.FCancellation = 0 and t2.fprice<=0
and t3.ftrantype in (21,24) --and t11.fnumber not like 'F%'



select t11.fnumber,t11.fname,t3.ftrantype,t3.fbillno,t3.fcheckerid,t11.fplanprice,t2.fqty,
t2.fauxplanprice,t2.fplanamount,t11.fplanprice,t2.fprice,t2.fconsignprice,t2.fconsignamount,t2.famount
--update t2 set fprice=t11.fplanprice,fauxprice=t11.fplanprice,famount=cast(t2.fqty*t11.fplanprice as decimal(24,2))
--update t2 set fprice=t2.fconsignprice-10,fauxprice=t2.fconsignprice-10,famount=cast(t2.fqty*(t2.fconsignprice-10) as decimal(24,2))
--update t2 set fprice=0.98,fauxprice=0.98,famount=cast(t2.fqty*0.98 as decimal(24,2))
from icstockbillentry t2  
inner join icstockbill t3 on t2.finterid=t3.finterid  
inner join t_icitem t11 on t11.fitemid=t2.fitemid   
where year(t3.fdate)=2016 and month(t3.fdate)=8
and isnull(t3.FVchInterID,0)=0 and t3.FCancellation = 0 and t3.ftrantype in (21)
--and t3.fbillno like 'xout001022' 
--and abs(t2.fconsignamount-t2.famount)>1000
and (t2.famount-t2.fconsignamount)>=1000  --亏1000
--and abs(t2.fconsignprice-t2.fprice)>15 and t2.fprice<=50


--用销售发票价更新销售出库的销售单价
SELECT t7.fname 客户,t6.fbillno 销售订单编号,t3.fnumber 产品编码,t3.fname 名称,t3.fmodel 规格型号,t2.fconsignprice ,t2.fconsignamount,t2.fprice,t2.famount,t2.fqty,
t4.fstdamount,cast(t4.fstdamount/t4.fqty as decimal(24,4)) fstdprice
--update t2 set fconsignprice=cast(t4.fstdamount/t4.fqty as decimal(24,4)) ,fconsignamount=cast(cast(t4.fstdamount/t4.fqty as decimal(24,4))*t2.fqty as decimal(24,2))
from icstockbill t1
inner join icstockbillentry t2 on t1.finterid=t2.finterid
inner join t_icitem t3 on t2.fitemid=t3.fitemid
inner join icsaleentry t4 on t4.fsourceinterid=t2.finterid and t4.fsourceentryid=t2.fentryid
inner join seorderentry t5 on t5.finterid=t2.forderinterid and t5.fentryid=t2.forderentryid
inner join seorder t6 on t5.finterid=t6.finterid
inner join t_organization t7 on t6.fcustid=t7.fitemid
where t1.fdate>='2016-02-01' and t1.fdate<='2016-02-29' and t1.ftrantype=21

--亏本明细
SELECT t7.fname 客户,t6.fbillno 生产单编号,t6.FHeadSelfS0144 源销售订单号,--t6.FHeadSelfS0143 源采购订单号,
t3.fnumber 产品编码,t3.fname 名称,t3.fmodel 规格型号,t9.fname 包装方式,t2.fqty 数量,t2.fconsignprice 销售单价,t2.fconsignamount 销售金额,t2.fprice 单位成本,t2.famount 成本,
t8.fname 源币别,t5.fentryselfs0173 源销售单价
from icstockbill t1
inner join icstockbillentry t2 on t1.finterid=t2.finterid
inner join t_icitem t3 on t2.fitemid=t3.fitemid
left join seorderentry t5 on t5.finterid=t2.forderinterid and t5.fentryid=t2.forderentryid
left join seorder t6 on t5.finterid=t6.finterid
left join t_organization t7 on t6.fcustid=t7.fitemid
left join t_item t9 on t9.fitemclassid=3002 and t9.fitemid=t5.fentryselfs0158
left join t_currency t8 on t8.fcurrencyid=t6.fheadselfs0153
where t1.fdate>='2016-02-01' and t1.fdate<='2016-02-29' and t1.ftrantype=21
and (t2.famount-t2.fconsignamount)>=500  --亏1000
and t2.fqty>0

--成本明细
select t5.fnumber 产品编码,t5.fname 产品名称,t5.fmodel 规格型号,
t6.fnumber 物料编码,t6.fname 物料名称,t6.fmodel 物料规格型号,t9.fname 单位,t6.fplanprice 单价,t4.fqty 单位用量,(t4.fqty*t6.fplanprice) 金额
from
(
	select distinct t3.finterid,t2.fitemid
	from icstockbill t1
	inner join icstockbillentry t2 on t1.finterid=t2.finterid
	inner join icbom t3 on t2.fitemid=t3.fitemid
	where t1.fdate>='2016-02-01' and t1.fdate<='2016-02-29' and t1.ftrantype=2
) t1 inner join icbomchild t4 on t1.finterid=t4.finterid
inner join t_icitem t5 on t1.fitemid=t5.fitemid --父项
inner join t_icitem t6 on t6.fitemid=t4.fitemid  --子项
--inner join seorderentry t7 on t7.finterid=t3.forderinterid and t7.fentryid=t3.fsourceentryid
--inner join seorder t8 on t8.finterid=t7.finterid
inner join t_measureunit t9 on t9.fitemid=t6.funitid
--and not (left(t6.fnumber,5) in ('1.06.','2.20.','1.04.') and t4.funitid<>29056) and t6.fnumber not like '2.01.%' 
--and t5.fnumber='B.01.004.B40161'
--and t1.fbillno='cin004628'
order by t5.fnumber,t6.fnumber

select t2.fitemid,T1.FNUMBER,T1.FNAME,t19.fqty,t1.fplanprice fprice
from t_BOSSuitBill t18 
inner join t_BOSSuitBillEntry t19 on t18.fid=t19.fid
inner join t_icitem t2 on t18.fproductid=t2.fitemid --父项
inner join t_icitem t1 on t1.fitemid=t19.fitemid --子项
left join t_supplier t4 on t4.fitemid= t1.F_117
left join icbom t5 on t5.fitemid=t19.fitemid
WHERE T2.FNUMBER LIKE '%B.02.001.B19882'


select t1.fnumber,t1.fname,t1.fplanprice
from t_icitem t11   --父项
inner join icbom t18 on t18.fitemid=t11.fitemid 
inner join icbomchild t19 on t18.finterid=t19.finterid
inner join t_icitem t1 on t1.fitemid=t19.fitemid --子项
where t11.FNUMBER LIKE '%B.01.004.B40108'

--11.4 引出在制数

----步骤n --把禁用的再禁用回去--成本计算完成后再使用--结转完后再使用？
--select t1.fyear,t1.fperiod,t2.fnumber,t2.fname,t2.fmodel--,* 
----update t4 set FDeleted=1
----update t5 set FDeleted=1
--from t_icitemDelete t1
--inner join t_icitem t2 on t1.fitemid=t2.fitemid
--inner join t_item t4 on t2.fitemid=t4.fitemid
--inner join t_ICItemCore t5 on t5.fitemid=t2.fitemid
--where t2.fdeleted=0
--
--delete from t_icitemDelete

go




declare @fperiod int set @fperiod=5

--自制
select distinct t11.fitemid,t11.fnumber,t11.fname into #data  -- drop table #data drop table #data2 drop table #temp
from icstockbillentry t2  
inner join icstockbill t3 on t2.finterid=t3.finterid  
inner join t_icitem t11 on t11.fitemid=t2.fitemid   
where year(t3.fdate)=2016 and month(t3.fdate)=@fperiod and t11.ferpclsid=2 and t3.ftrantype=2 


select t1.fitemid,cast(sum(fcredit)/sum(fsend) as decimal(24,4))fprice into #temp
from icbal t1
inner join t_icitem t2 on t1.fitemid=t2.fitemid
where fyear=2015 and fperiod=@fperiod and fsend>0 and fcredit>0 and t2.ferpclsid in (1,3)
group by t1.fitemid


insert into #temp(fitemid,fprice)
select t4.fitemid,(case when t5.fcyid=1000 then t5.fprice*t1.fexchangerate else t5.fprice end) fprice
from (select fitemid,max(fentryid) fentryid from t_supplyentry group by fitemid) t4 
inner join t_supplyentry t5 on t4.fitemid=t5.fitemid and t4.fentryid=t5.fentryid
inner join t_currency t1 on t1.fcurrencyid=t5.fcyid
where t4.fitemid not in(select fitemid from #temp)



--半成品
select t3.fnumber,t3.fname,isnull(t3.fmodel,'') fmodel,t2.fprice
from t_ICItemMaterial t1
inner join 
(
	select t1.fitemid,sum(fprice) fprice
	from
	(
		select t2.fitemid,(t3.fqty*t5.fprice) fprice
		from t_icitem t1
		inner join icbom t2 on t1.fitemid=t2.fitemid --and t2.fstatus>0
		inner join icbomchild t3 on t2.finterid=t3.finterid
		inner join #temp t5 on t5.fitemid=t3.fitemid
		inner join t_icitem t6 on t6.fitemid=t3.fitemid
		where left(t1.fnumber,1) in ('3','4') --and t1.ferpclsid=2 
		and t1.fitemid in (select fitemid from #data)
		union all
		select t11.fitemid,(t12.fqty*t5.fprice) fprice
		from icbom t11   --半成品
		inner join icbomchild t12 on t11.finterid=t12.finterid  --半成品子项
		inner join #temp t5 on t5.fitemid=t12.fitemid
		inner join t_icitem t6 on t6.fitemid=t11.fitemid --半成品
		inner join t_icitem t8 on t8.fitemid=t12.fitemid --半成品子项
		where left(t6.fnumber,1) in ('5') and t8.fname not like '回收件%' --and t1.ferpclsid=2
		and t11.fitemid in (select fitemid from #data)
		union all
		select t11.fitemid,(1*t5.fprice) fprice
		from icbom t11   --半成品
		inner join (
-- 			select distinct t1.fitemid,(select top 1 fitemid from t_icitem where fparentid=t1.fparentid and fname like '%拆盒%' ) fchiheitemid
-- 			from t_icitem t1
-- 			inner join icbomchild t2 on t1.fitemid=t2.fitemid
-- 			where t1.fnumber like '5.%' and t1.fname not like '%拆盒%'
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
		) t12 on t11.fitemid=t12.fitemid --半成品同级回收壳
		inner join t_icitem t6 on t6.fitemid=t11.fitemid --半成品
		inner join t_icitem t8 on t8.fitemid=t12.fchiheitemid --半成品同级回收壳
		inner join #temp t5 on t5.fitemid=t8.fitemid
		where left(t6.fnumber,1) in ('5') --and t1.ferpclsid=2
		and t11.fitemid in (select fitemid from #data)
	) t1 group by t1.fitemid
) t2 on t1.fitemid=t2.fitemid
inner join t_icitem t3 on t2.fitemid=t3.fitemid
--order by t3.fnumber

union all  --成品

select t3.fnumber,t3.fname,t3.fmodel,t2.fprice
from t_ICItemMaterial t1
inner join 
(
	select t1.fitemid,sum(fprice) fprice
	from
	(
		select t2.fitemid,(t3.fqty*t5.fprice) fprice
		from t_icitem t1
		inner join icbom t2 on t1.fitemid=t2.fitemid --and t2.fstatus>0
		inner join icbomchild t3 on t2.finterid=t3.finterid
		inner join #temp t5 on t5.fitemid=t3.fitemid
		inner join t_icitem t6 on t6.fitemid=t3.fitemid
		where left(t6.fnumber,1) not in ('3','4','5') --and t1.ferpclsid=2 
		and t1.fitemid in (select fitemid from #data) and left(t1.fnumber,1) in ('A', 'J', 'P', 'Q', 'R', 'V', 'X', 'Y')
		union all
		select t2.fitemid,(t12.fqty*t5.fprice) fprice
		from t_icitem t1
		inner join icbom t2 on t1.fitemid=t2.fitemid --and t2.fstatus>0 --成品
		inner join icbomchild t3 on t2.finterid=t3.finterid  --半成品
		inner join icbom t11 on t11.fitemid=t3.fitemid  --半成品
		inner join icbomchild t12 on t11.finterid=t12.finterid  --半成品子项
		inner join #temp t5 on t5.fitemid=t12.fitemid
		inner join t_icitem t6 on t6.fitemid=t3.fitemid --半成品
		inner join t_icitem t7 on t7.fitemid=t2.fitemid --成品
		inner join t_icitem t8 on t8.fitemid=t12.fitemid --半成品子项
		where left(t6.fnumber,1) in ('3','4') --and t1.ferpclsid=2
		and t1.fitemid in (select fitemid from #data) and left(t1.fnumber,1) in ('A', 'J', 'P', 'Q', 'R', 'V', 'X', 'Y')
		union all
		select t2.fitemid,(t12.fqty*t5.fprice) fprice
		from t_icitem t1
		inner join icbom t2 on t1.fitemid=t2.fitemid --and t2.fstatus>0 --成品
		inner join icbomchild t3 on t2.finterid=t3.finterid  --半成品
		inner join icbom t11 on t11.fitemid=t3.fitemid  --半成品
		inner join icbomchild t12 on t11.finterid=t12.finterid  --半成品子项
		inner join #temp t5 on t5.fitemid=t12.fitemid
		inner join t_icitem t6 on t6.fitemid=t3.fitemid --半成品
		inner join t_icitem t7 on t7.fitemid=t2.fitemid --成品
		inner join t_icitem t8 on t8.fitemid=t12.fitemid --半成品子项
		where left(t6.fnumber,1) in ('5') and t8.fname not like '回收件%' --and t1.ferpclsid=2
		and t1.fitemid in (select fitemid from #data) and left(t1.fnumber,1) in ('A', 'J', 'P', 'Q', 'R', 'V', 'X', 'Y')
		union all
		select t2.fitemid,(t3.fqty*t5.fprice) fprice
		from t_icitem t1
		inner join icbom t2 on t1.fitemid=t2.fitemid --and t2.fstatus>0 --成品
		inner join icbomchild t3 on t2.finterid=t3.finterid  --半成品
		inner join icbom t11 on t11.fitemid=t3.fitemid  --半成品
		inner join (
-- 			select distinct t1.fitemid,(select top 1 fitemid from t_icitem where fparentid=t1.fparentid and fname like '%拆盒%' ) fchiheitemid
-- 			from t_icitem t1
-- 			inner join icbomchild t2 on t1.fitemid=t2.fitemid
-- 			where t1.fnumber like '5.%' and t1.fname not like '%拆盒%'
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
		) t12 on t11.fitemid=t12.fitemid --半成品同级回收壳
		inner join t_icitem t6 on t6.fitemid=t3.fitemid --半成品
		inner join t_icitem t7 on t7.fitemid=t2.fitemid --成品
		inner join t_icitem t8 on t8.fitemid=t12.fchiheitemid --半成品同级回收壳
		inner join #temp t5 on t5.fitemid=t8.fitemid
		where left(t6.fnumber,1) in ('5') --and t1.ferpclsid=2
		and t1.fitemid in (select fitemid from #data) and left(t1.fnumber,1) in ('A', 'J', 'P', 'Q', 'R', 'V', 'X', 'Y')
	) t1 group by t1.fitemid
) t2 on t1.fitemid=t2.fitemid
inner join t_icitem t3 on t2.fitemid=t3.fitemid
order by fnumber



drop table #data drop table #temp