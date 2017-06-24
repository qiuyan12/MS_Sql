set nocount on

--drop table #t_supplyentry

---0 �����
select distinct t2.fitemid,max(t2.fprice) as fprice
into #t_supplyentry
from icstockbill t1
inner join icstockbillentry t2 on t1.finterid=t2.finterid
inner join t_icitem t3 on t2.fitemid=t3.fitemid
where left(t3.fnumber,1) in ('1','2','3','4') and t1.ftrantype=24 and t2.fprice>0 
and  year(t1.fdate)=(select fvalue from t_systemprofile where fcategory='ic' and fkey='currentyear') 
and month(t1.fdate)=(select fvalue from t_systemprofile where fcategory='ic' and fkey='currentperiod') 
group by t2.fitemid

---1 �ɹ�����
insert into #t_supplyentry
select t1.fitemid,max(t1.fprice) fprice
from t_supplyentry t1 
where t1.fprice<>0 and fcyid=1 
and t1.fitemid not in (select fitemid from #t_supplyentry)
group by t1.fitemid

---2 ���ڲɹ�����
insert into #t_supplyentry
select t2.fitemid,
max((case when fcurrencyid='1' then t2.fprice else t2.fprice*cast(t1.fexchangerate as decimal(24,8)) end)) as fprice
from poorder t1
inner join poorderentry t2 on t1.finterid=t2.finterid
where 
--year(t1.fdate)=(select fvalue from t_systemprofile where fcategory='ic' and fkey='currentyear') and month(t1.fdate)=(select fvalue from t_systemprofile where fcategory='ic' and fkey='currentperiod')and 
t2.fitemid not in(select fitemid from #t_supplyentry)
group by t2.fitemid

--3 �ڳ�����
insert into #t_supplyentry
select * from 
(select fitemid,sum(fbegbal)/sum(fbegqty) as fprice from icbal where fyear=(select fvalue from t_systemprofile where fcategory='ic' and fkey='currentyear') and fperiod=(select fvalue from t_systemprofile where fcategory='ic' and fkey='currentperiod') and fbegqty>0 group by fitemid ) a
where fitemid not in(select fitemid from #t_supplyentry)

----4 ��ǰ�ڼ��⹺��ⵥ����
--insert into #t_supplyentry
--select t2.fitemid,max(t2.fprice) from icstockbill t1
--inner join icstockbillentry t2 on t1.finterid=t2.finterid
--where t1.ftrantype=1 and t2.fitemid not in(select fitemid from #t_supplyentry)
--group by t2.fitemid
--
----5 ��ǰ�ڼ��������ϵ�����
--insert into #t_supplyentry
--select t2.fitemid,max(t2.fprice) from icstockbill t1
--inner join icstockbillentry t2 on t1.finterid=t2.finterid
--where t1.ftrantype=24 and t2.fitemid not in(select fitemid from #t_supplyentry)
--group by t2.fitemid

--6 �ƻ�����
insert into #t_supplyentry
select t1.fitemid,t1.fplanprice 
from t_icitem t1
where t1.fitemid not in(select fitemid from #t_supplyentry)
and t1.fplanprice>0

update t3 set fplanprice=t4.fprice
from t_icitem t2 
inner join t_ICItemMaterial t3 on t2.fitemid=t3.fitemid 
inner join #t_supplyentry t4 on t4.fitemid=t2.fitemid

 

--insert into #t_supplyentry
--select t2.fitemid,t1.�ܽ��
--from ssss t1
--inner join t_icitem t2 on t1.��Ʒ����=t2.fnumber
--where t2.fitemid not in(select fitemid from #t_supplyentry)

--drop table #data2

--��һ�ڵĳ����,�������±��ڵ�������ⵥ��--��Ʒ�ֹ�¼��
select t2.fitemid,max(t2.fprice) as fprice
into #temp
from icstockbill t1
inner join icstockbillentry t2 on t1.finterid=t2.finterid
inner join t_icitem t3 on t2.fitemid=t3.fitemid
where left(t3.fnumber,1) in ('a','p') and t1.ftrantype in (21,29) and t2.fprice>0 --and t3.fshortnumber='a00220'
and year(t1.fdate)=2014 and month(t1.fdate)=7
group by t2.fitemid

--drop table #temp

--3.2 ���±��ڵ�������ⵥ��
select t3.ftrantype,t3.fcheckerid,t2.fprice,t11.fplanprice,t2.fprice,t3.fbillno,t11.fnumber,t11.fname,t2.fqty,t11.fplanprice*t2.fqty
--update t2 set fprice=0.02,fauxprice=0.02,famount=cast(t2.fqty*0.02 as decimal(24,3))
--update t2 set fprice=t11.fplanprice,fauxprice=t11.fplanprice,famount=cast(t2.fqty*t11.fplanprice as decimal(24,3))
--update t2 set fprice=t4.fprice,fauxprice=t4.fprice,famount=cast(t2.fqty*t4.fprice as decimal(24,3))
from icstockbillentry t2  
inner join icstockbill t3 on t2.finterid=t3.finterid  
inner join t_icitem t11 on t11.fitemid=t2.fitemid 
--inner join #temp t4 on t4.fitemid=t2.fitemid
where left(t11.fnumber,1) in ('a','p') and year(t3.fdate)=2014 and month(t3.fdate)=12
and isnull(t3.FVchInterID,0)=0 and t3.FCancellation = 0 and t3.ftrantype in (10) --and t2.fprice<>t11.fplanprice
and (t2.fprice<=0 or t2.famount=0 ) --and t11.fshortnumber='190209'


select t1.finterid,t2.fentryid,t4.fqtymust/t3.fqty*t7.fprice fprice 
from icstockbill t1
inner join icstockbillentry t2 on t1.finterid=t2.finterid
inner join icmo t3 on t2.ficmointerid=t3.finterid
inner join ppbomentry t4 on t4.ficmointerid=t3.finterid
inner join t_icitem t5 on t3.fitemid=t5.fitemid
inner join t_icitem t6 on t6.fitemid=t4.fitemid
left join #t_supplyentry t7 on t7.fitemid=t4.fitemid
where t1.fdate>='2015-01-01' and t1.fdate<='2015-01-31' and t1.ftrantype=2
and left(t5.fnumber,1) in ('A','P') and t6.fdefaultloc <>16483 /*���ܲ�*/ and t4.fstockqty>0 /*������*/
and t5.fshortnumber='A00177'
and t4.fqtymust>0


--����ۼ��---------------------------------------------------
select t1.finterid,t2.fentryid,t5.fnumber,t5.fname,t5.fmodel,t6.fnumber,t6.fname,t6.fmodel,t4.fqtyscrap,t4.fqtymust/t3.fqty,t7.fprice,
t4.fqtymust/t3.fqty*t7.fprice fprice1,t4.fqtyscrap*t7.fprice fprice2,t4.fstockqty,t3.fbillno
from icstockbill t1
inner join icstockbillentry t2 on t1.finterid=t2.finterid
inner join icmo t3 on t2.ficmointerid=t3.finterid
inner join ppbomentry t4 on t4.ficmointerid=t3.finterid
inner join t_icitem t5 on t3.fitemid=t5.fitemid
inner join t_icitem t6 on t6.fitemid=t4.fitemid
left join #t_supplyentry t7 on t7.fitemid=t4.fitemid
where t1.fdate>='2015-01-01' and t1.fdate<='2015-01-31' and t1.ftrantype=2
and left(t5.fnumber,1) in ('A','P') and t6.fdefaultloc <>16483 and t4.fstockqty>0 --and left(t6.fnumber,1) in ('3','4') 
--and t5.fshortnumber='a00220'
and t4.fqtymust>0 and t7.fprice is null 



--��λ����
select t1.finterid,t2.fentryid,t4.fqtyscrap*t7.fprice fprice 
into #data
from icstockbill t1
inner join icstockbillentry t2 on t1.finterid=t2.finterid
inner join icmo t3 on t2.ficmointerid=t3.finterid
inner join ppbomentry t4 on t4.ficmointerid=t3.finterid
inner join t_icitem t5 on t3.fitemid=t5.fitemid
inner join t_icitem t6 on t6.fitemid=t4.fitemid
left join #t_supplyentry t7 on t7.fitemid=t4.fitemid
where t1.fdate>='2015-01-01' and t1.fdate<='2015-01-31' and t1.ftrantype=2
and left(t5.fnumber,1) in ('A','P') and t6.fdefaultloc <>16483 /*���ܲ�*/ and t4.fstockqty>0 /*������*/
and t4.fqtymust>0

--Ӧ����������������Ϊ��λ����
select t1.finterid,t2.fentryid,t4.fqtymust/t3.fqty*t7.fprice fprice 
into #data2
from icstockbill t1
inner join icstockbillentry t2 on t1.finterid=t2.finterid
inner join icmo t3 on t2.ficmointerid=t3.finterid
inner join ppbomentry t4 on t4.ficmointerid=t3.finterid
inner join t_icitem t5 on t3.fitemid=t5.fitemid
inner join t_icitem t6 on t6.fitemid=t4.fitemid
left join #t_supplyentry t7 on t7.fitemid=t4.fitemid
where t1.fdate>='2015-01-01' and t1.fdate<='2015-01-31' and t1.ftrantype=2
and left(t5.fnumber,1) in ('A','P') and t6.fdefaultloc <>16483 /*���ܲ�*/ and t4.fstockqty>0 /*������*/
and t4.fqtymust>0

--A00088 --WORK018122--2�ְ��Ʒ 3.01.040.300104 3.01.040.300391
select t3.fbillno,t2.fprice,t1.finterid,t2.fentryid,t4.fqtymust,t4.fstockqty,t3.fqty,t4.fqtymust/t3.fqty,t7.fprice,t4.fqtymust/t3.fqty*t7.fprice fprice ,
t6.fnumber,t6.fname,t6.fmodel
from icstockbill t1
inner join icstockbillentry t2 on t1.finterid=t2.finterid
inner join icmo t3 on t2.ficmointerid=t3.finterid
inner join ppbomentry t4 on t4.ficmointerid=t3.finterid
inner join t_icitem t5 on t3.fitemid=t5.fitemid
inner join t_icitem t6 on t6.fitemid=t4.fitemid
left join #t_supplyentry t7 on t7.fitemid=t4.fitemid
where t1.fdate>='2015-01-01' and t1.fdate<='2015-01-31' and t1.ftrantype=2
and left(t5.fnumber,1) in ('A','P') and t6.fdefaultloc <>16483 /*���ܲ�*/ and t4.fstockqty>0 /*������*/
--and t5.fnumber like '%p00106%'
and t4.fqtymust>0 order by t3.fbillno,t6.fnumber

select t1.finterid,t1.fentryid,t2.fprice,famount=cast(t2.fprice*t1.fqty as decimal(24,2)) into #temp1
from icstockbillentry t1
inner join 
(
	select t1.finterid,t1.fentryid,sum(fprice) fprice
	from #data t1
	group by t1.finterid,t1.fentryid
) t2 on t1.finterid=t2.finterid and t1.fentryid=t2.fentryid
inner join t_icitem t3 on t1.fitemid=t3.fitemid
inner join icstockbill t4 on t1.finterid=t4.finterid


select t1.finterid,t1.fentryid,t2.fprice,famount=cast(t2.fprice*t1.fqty as decimal(24,2)) into #temp2
from icstockbillentry t1
inner join 
(
	select t1.finterid,t1.fentryid,sum(fprice) fprice
	from #data2 t1
	group by t1.finterid,t1.fentryid
) t2 on t1.finterid=t2.finterid and t1.fentryid=t2.fentryid
inner join t_icitem t3 on t1.fitemid=t3.fitemid
inner join icstockbill t4 on t1.finterid=t4.finterid

--�Ƚϲ�����
select t7.fbillno,t6.fbillno,t4.fnumber,t4.fname,t4.fmodel,t3.fqty,t3.fprice,t1.fprice,t2.fprice
from #temp1 t1
inner join #temp2 t2 on t1.finterid=t2.finterid and t1.fentryid=t2.fentryid
inner join icstockbillentry t3 on t1.finterid=t3.finterid and t1.fentryid=t3.fentryid
inner join t_icitem t4 on t3.fitemid=t4.fitemid
inner join icstockbill t6 on t6.finterid=t3.finterid
left join icmo t7 on t7.finterid=t3.ficmointerid
where t1.fprice-t2.fprice>5 or t1.fprice-t2.fprice<-5

--�Դ�Ϊ׼
select t4.fdate,t4.fbillno,t3.fnumber,t3.fname,t3.fmodel,t1.fprice,t5.fname,t1.fqty,t2.fprice,famount=cast(t2.fprice*t1.fqty as decimal(24,2))
--update t1 set fprice=t2.fprice,fauxprice=t2.fprice,famount=cast(t2.fprice*t1.fqty as decimal(24,2))
from icstockbillentry t1
inner join 
(
	select t1.finterid,t1.fentryid,sum(fprice) fprice
	from #data2 t1
	group by t1.finterid,t1.fentryid
) t2 on t1.finterid=t2.finterid and t1.fentryid=t2.fentryid
inner join t_icitem t3 on t1.fitemid=t3.fitemid
inner join icstockbill t4 on t1.finterid=t4.finterid
inner join t_measureunit t5 on t5.fitemid=t3.funitid
and isnull(t4.FVchInterID,0)=0  
order by t3.fnumber

--3.2 ���±��ڵ�������ⵥ��
select t3.ftrantype,t3.fcheckerid,t2.fprice,t11.fplanprice,t2.fprice,t3.fbillno,t11.fnumber,t11.fname,t11.fmodel,t2.fqty,t11.fplanprice*t2.fqty
--update t2 set fprice=0.02,fauxprice=0.02,famount=cast(t2.fqty*0.02 as decimal(24,3))
--update t2 set fprice=t11.fplanprice,fauxprice=t11.fplanprice,famount=cast(t2.fqty*t11.fplanprice as decimal(24,3))
--update t2 set fprice=t4.fprice,fauxprice=t4.fprice,famount=cast(t2.fqty*t4.fprice as decimal(24,3))
from icstockbillentry t2  
inner join icstockbill t3 on t2.finterid=t3.finterid  
inner join t_icitem t11 on t11.fitemid=t2.fitemid 
where left(t11.fnumber,1) in ('a','p') and year(t3.fdate)=2014 and month(t3.fdate)=12
and isnull(t3.FVchInterID,0)=0 and t3.FCancellation = 0 and t3.ftrantype in (10) --and t2.fprice<>t11.fplanprice
and (t2.fprice<=0 or t2.famount=0 ) --and t11.fshortnumber='190209'


drop table #data
drop table #data2
drop table #temp1
drop table #temp2
drop table #t_supplyentry


--3.2 �����º������޵��۵���ⵥ��
select t3.ftrantype,t3.fcheckerid,t2.fprice,t11.fplanprice,t3.fbillno,t11.fnumber,t11.fname,t2.fqty,t11.fplanprice*t2.fqty
--update t2 set fprice=0.02,fauxprice=0.02,famount=cast(t2.fqty*0.02 as decimal(24,3))
--update t2 set fprice=t11.fplanprice,fauxprice=t11.fplanprice,famount=cast(t2.fqty*t11.fplanprice as decimal(24,3))
from icstockbillentry t2  
inner join icstockbill t3 on t2.finterid=t3.finterid  
inner join t_icitem t11 on t11.fitemid=t2.fitemid   
where year(t3.fdate)=2014 and month(t3.fdate)=12
and isnull(t3.FVchInterID,0)=0 and t3.FCancellation = 0 and t3.ftrantype in (1,2,3,5,10,40,41) --and t2.fprice<>t11.fplanprice
and (t2.fprice<=0 or t2.famount=0 ) --and t11.fshortnumber='190209'
order by t3.ftrantype,t11.fnumber



--drop table #temp

--7.1 �����������Ƴɱ�����

set nocount on

--����������
select t2.ficmointerid,t2.FPPBomEntryID,sum(t2.fqty) fqty
into #ppbom
from icstockbillentry t2  
inner join icstockbill t3 on t2.finterid=t3.finterid 
where t3.fdate>='2015-01-01' and t3.fdate<='2015-01-31'
and isnull(t2.ficmointerid,0)<>0 and t3.ftrantype=24  and t3.FCancellation = 0 
group by t2.ficmointerid,t2.FPPBomEntryID

--�������ϵ��漰��������
select t2.ficmointerid into #data from #ppbom t2 group by t2.ficmointerid

--δ��ȫ��������--��Щ���ȼƻ��٣����Ժ�Ҳ��������
select t1.finterid ficmointerid,t1.fqty,isnull(t2.fqty,0) fstockqty
into #temp
from icmo t1
left join 
(
	--���ڽ�ֹ����֮ǰ�������
	select t2.ficmointerid,sum(t2.fqty) fqty
	from icstockbillentry t2  
	inner join icstockbill t3 on t2.finterid=t3.finterid 
	inner join #data t1 on t1.ficmointerid=t2.ficmointerid
	where t3.fdate<='2015-01-31' --���ڽ�ֹ����
	and isnull(t2.ficmointerid,0)<>0 and t3.ftrantype=2  and t3.FCancellation = 0 
	group by t2.ficmointerid
) t2 on t1.finterid=t2.ficmointerid 
inner join #data t3 on t1.finterid=t3.ficmointerid
where t1.fqty>isnull(t2.fqty,0)

--select t2.fbillno,t3.fnumber,t3.fname,t1.* from #temp t1 inner join icmo t2 on t1.ficmointerid=t2.finterid inner join t_icitem t3 on t2.fitemid=t3.fitemid

--�������ƽ��--466979.47
--select * from my_t_Online where ���=2014 and �ڼ�=7
--delete from my_t_Online where ���=2014 and �ڼ�=7
--insert into my_t_Online 
select 2015 ���,1 �ڼ�,t9.fname ����,t5.fbillno ���񵥺�,t8.fnumber ��Ʒ����,t8.fname ��Ʒ����,t8.fmodel ��Ʒ����ͺ�,
t4.fnumber ���ϱ���,t4.fname ��������,t4.fmodel ���Ϲ���ͺ�,t1.fqty ����������,
t5.fqty ��Ʒ������,t6.fstockqty ���ڲ�Ʒ�����,t3.fauxqtyscrap ��λ����,cast(t3.fscrap/100 as decimal(24,4)) �����,
ceiling(t6.fstockqty*t3.fauxqtyscrap*(1+t3.fscrap/100)) �������������,
(t1.fqty-ceiling(t6.fstockqty*t3.fauxqtyscrap*(1+t3.fscrap/100))) ������,t4.fplanprice �ƻ�����,
(t1.fqty-ceiling(t6.fstockqty*t3.fauxqtyscrap*(1+t3.fscrap/100))) *t4.fplanprice �ƻ����
--select cast(sum((t1.fqty-ceiling(t6.fstockqty*t3.fauxqtyscrap*(1+t3.fscrap/100))) *t4.fplanprice) as decimal(24,2))
from icmo t5 
inner join #temp t6 on t5.finterid=t6.ficmointerid
inner join ppbom t2 on t5.finterid=t2.ficmointerid
inner join ppbomentry t3 on t2.finterid=t3.finterid
inner join #ppbom t1 on t1.ficmointerid=t5.finterid and t3.fentryid=t1.FPPBomEntryID
inner join t_icitem t4 on t3.fitemid=t4.fitemid
inner join t_icitem t8 on t5.fitemid=t8.fitemid
inner join t_department t9 on t9.fitemid=t5.fworkshop
inner join t_measureunit t10 on t10.fitemid=t4.funitid
where t1.fqty>ceiling(t6.fstockqty*t3.fauxqtyscrap*(1+t3.fscrap/100)) and t5.fcommitdate>='2015-01-10'
--and t8.fname like '%ר��%'
order by t4.fshortnumber

drop table #ppbom
drop table #temp
drop table #data

set nocount off

go

--select * from my_t_Online where ���=2014 and �ڼ�=10  order by ���,�ڼ�