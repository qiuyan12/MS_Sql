
--���¹�˾����������


--declare @fyear int,@fperiod int select @fyear=2016,@fperiod=10 declare @ftype int set @ftype=4 --1��īˮ���Ʒ��8�� 2��ī�а���Ʒ��3�� 3��ī�а��Ʒ��4�� 4��ī�г�Ʒ��īˮ��Ʒ���������װ

-----0 �����
--select t2.fitemid,cast(max(t2.fprice) as decimal(24,6)) as fprice
--into #temp
--from icstockbill t1
--inner join icstockbillentry t2 on t1.finterid=t2.finterid
--inner join t_icitem t3 on t2.fitemid=t3.fitemid
--where year(t1.fdate)=@fyear --(select fvalue from t_systemprofile where fcategory='ic' and fkey='currentyear') 
--and month(t1.fdate)=@fperiod --(select fvalue from t_systemprofile where fcategory='ic' and fkey='currentperiod')
----left(t3.fnumber,1) in ('1','2','3','4') and 
--and t1.ftrantype in (24,29) and t1.frob=1 and t2.fprice>0 
--group by t2.fitemid

-----2 ���ڲɹ�����
--insert into #temp
--select t2.fitemid,
--max((case when fcurrencyid='1' then t2.fprice else cast(t2.fprice*t1.fexchangerate as decimal(24,6)) end)) as fprice
--from poorder t1
--inner join poorderentry t2 on t1.finterid=t2.finterid
--where t2.fitemid not in(select fitemid from #temp)
--and t1.fdate>='2016-09-01' 
----and year(t1.fdate)=(select fvalue from t_systemprofile where fcategory='ic' and fkey='currentyear') and month(t1.fdate)=(select fvalue from t_systemprofile where fcategory='ic' and fkey='currentperiod')and 
--and t2.fprice>0
--group by t2.fitemid

---1 �ɹ��۸��

--insert into #temp
select t4.fitemid,(case when t5.fcyid=1000 then t5.ftaxprice*t1.fexchangerate else t5.ftaxprice end) fprice into #temp
from (select fitemid,max(fentryid) fentryid from (select t1.fitemid,t1.fentryid from t_supplyentry t1 inner join (select fitemid,max(FQuoteTime) FQuoteTime from t_SupplyEntry group by fitemid) t2 on t1.fitemid=t2.fitemid and t1.FQuoteTime=t2.FQuoteTime) t1 group by fitemid) t4 
inner join t_supplyentry t5 on t4.fitemid=t5.fitemid and t4.fentryid=t5.fentryid
inner join t_currency t1 on t1.fcurrencyid=t5.fcyid
inner join t_icitem t2 on t2.fitemid=t4.fitemid
--where t2.ferpclsid=2  --��������д����Ϊ���׼��������

--3 �ڳ�����
insert into #temp
select fitemid,fprice
from 
(
	select t1.fitemid,sum(t1.fbegbal)/sum(t1.fbegqty) as fprice 
	from AIS20141008103333.dbo.icbal t1 
	inner join AIS20141008103333.dbo.t_icitem t2 on t1.fitemid=t2.fitemid
	where t1.fyear=2016 --(select fvalue from t_systemprofile where fcategory='ic' and fkey='currentyear') 
	and t1.fperiod=9 --(select fvalue from t_systemprofile where fcategory='ic' and fkey='currentperiod') 
	and t1.fbegqty>0 and t1.fbegbal>0 and t2.ferpclsid=1
	group by t1.fitemid 
) a where fitemid not in(select fitemid from #temp)

--���Ʒ
insert into #temp(fitemid,fprice)
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
	--and t1.fitemid in (select fitemid from #data)
	union all
	select t11.fitemid,(t12.fqty*t5.fprice) fprice
	from icbom t11   --���Ʒ
	inner join icbomchild t12 on t11.finterid=t12.finterid  --���Ʒ����
	inner join #temp t5 on t5.fitemid=t12.fitemid
	inner join t_icitem t6 on t6.fitemid=t11.fitemid --���Ʒ
	inner join t_icitem t8 on t8.fitemid=t12.fitemid --���Ʒ����
	where left(t6.fnumber,1) in ('5') and t8.fname not like '���ռ�%' --and t1.ferpclsid=2
	--and t11.fitemid in (select fitemid from #data)
	union all
	select t11.fitemid,(1*t5.fprice) fprice
	from icbom t11   --���Ʒ
	inner join (
-- 			select distinct t1.fitemid,(select top 1 fitemid from t_icitem where fparentid=t1.fparentid and fname like '%���%' ) fchiheitemid
-- 			from t_icitem t1
-- 			inner join icbomchild t2 on t1.fitemid=t2.fitemid
-- 			where t1.fnumber like '5.%' and t1.fname not like '%���%'
		select distinct t1.fitemid,
		(
			select top 1 m4.fitemid 
			from t_icitem m1 
			inner join icbomchild m2 on m1.fitemid=m2.fitemid
			inner join icbom m3 on m2.finterid=m3.finterid
			inner join t_icitem m4 on m3.fitemid=m4.fitemid
			where m4.fnumber like '5.%' and m4.fname like '%���%' and m1.fitemid=t5.fitemid 
		) fchiheitemid
		from t_icitem t1
		inner join icbomchild t2 on t1.fitemid=t2.fitemid
		inner join icbom t3 on t1.fitemid=t3.fitemid
		inner join icbomchild t4 on t4.finterid=t3.finterid
		inner join t_icitem t5 on t5.fitemid=t4.fitemid
		where t1.fnumber like '5.%' and t1.fname not like '%���%' and t5.fnumber like '1.02.%'
	) t12 on t11.fitemid=t12.fitemid --���Ʒͬ�����տ�
	inner join t_icitem t6 on t6.fitemid=t11.fitemid --���Ʒ
	inner join t_icitem t8 on t8.fitemid=t12.fchiheitemid --���Ʒͬ�����տ�
	inner join #temp t5 on t5.fitemid=t8.fitemid
	where left(t6.fnumber,1) in ('5') --and t1.ferpclsid=2
	--and t11.fitemid in (select fitemid from #data)
) t1 where t1.fitemid not in (select fitemid from #temp) 
group by t1.fitemid

--��Ʒ
insert into #temp(fitemid,fprice)
select t1.fitemid,sum(isnull(t6.fprice,0)*t2.fqty) fprice
from icbom t1
inner join icbomchild t2 on t1.finterid=t2.finterid
inner join t_icitem t3 on t1.fitemid=t3.fitemid
inner join t_icitem t4 on t2.fitemid=t4.fitemid
--inner join (select fitemid,max(finterid) finterid from icbom group by fitemid) t5 on t5.finterid=t1.finterid  --��ֹһ���ж��BOM
left join #temp t6 on t6.fitemid=t2.fitemid
--where not (left(t4.fnumber,5) in ('1.06.','2.20.','1.04.') and t4.funitid<>29056) --Ĥ ��λ��PCS --and t2.foperid not in (40013,40019,40020,40028,40026,40012,40014,40039,40023)
where left(t3.fnumber,1) not in ('3','4','5')
and t1.fitemid not in (select fitemid from #temp)
group by t1.fitemid

update t1 set fplanprice=0 from AIS20141008103333.dbo.t_ICItemMaterial t1

-- if exists (select * from sysobjects where name='t_temp' and xtype='u')  
-- begin
-- 	drop  Table t_temp
-- end
-- 
-- select * into t_temp from #temp

update t1 set fplanprice=t2.fprice
--select t2.fprice
from AIS20141008103333.dbo.t_ICItemMaterial t1 inner join #temp t2 on t1.fitemid=t2.fitemid
where t2.fprice>0

select distinct t2.fitemid,t1.fbatchno,cast(t2.fplanprice as decimal(24,6)) fprice,
cast(0 as decimal(24,6)) fsellprice,0 fbrandid,0 fcurrencyid,
cast('' as varchar(20)) fisbom into #data
from AIS20141008103333.dbo.icbal t1 
inner join AIS20141008103333.dbo.t_icitem t2 on t1.fitemid=t2.fitemid 
where t1.fyear=2016
and t1.fperiod=8
and t1.fendqty<>0 --and (t3.ftrantype in (2) or (t3.ftrantype in (10) and t2.ferpclsid=2))
and t2.ferpclsid=2

update t4 set fsellprice=t1.fprice,fcurrencyid=t7.fcurrencyid
from #data t4 
inner join AIS20141008103333.dbo.seorderentry t1 on t1.fitemid=t4.fitemid
inner join AIS20141008103333.dbo.seorder t7 on t1.finterid=t7.finterid and t4.fbatchno=t7.fbillno

--update t1 set fisbom='N'
--from #data t1
--inner join t_icitem t2 on t1.fitemid=t2.fitemid
--where --t2.fshortnumber='f04404' and 
--t1.fitemid not in (select fitemid from icbom)
--and t1.fitemid not in (select fproductid from t_bossuitbill)
--and t1.fitemid not in (select fproductid from t_BOSInkFmlt)

select t2.fitemid,t2.fnumber ����,t2.fname ����,t2.fmodel ����ͺ�,t1.fbatchno ����,
--t1.fbegbal �ڳ����,t1.fbegqty �ڳ�����,frecieve ��������,fsend ���ڷ���,
t1.fendqty ��ĩ����,
--fdebit,fcredit,
t1.fendbal ��ĩ���,
cast(t1.fendbal/t1.fendqty as decimal(24,4)) ƽ������,--cast(0 as decimal(24,4)) ���µ���
cast(t2.fplanprice as decimal(24,4)) ���µ���,cast(0 as int) �ұ�,cast(0 as decimal(24,4)) ���۵��� into #table
from AIS20141008103333.dbo.icbal t1 
inner join AIS20141008103333.dbo.t_icitem t2 on t1.fitemid=t2.fitemid 
where t1.fyear=2016 and t1.fperiod=8 --and t2.fnumber like '2%' 
and t1.fendqty<>0 --and t1.fbegbal/t1.fbegqty>20
order by t2.fnumber

update t1 set �ұ�=t2.fcurrencyid,���۵���=t2.fsellprice
from #table t1
inner join #data t2 on t1.fitemid=t2.fitemid and t1.����=t2.fbatchno

select * from #table order by ����

drop table #data
drop table #temp
drop table #table

set nocount off

go
