--�����ڳ���棬��������ι���ģ�����ֱ�ӽ�����������ɳɱ�������������Ӧ�ð���Щ����̯����������������������ȥ

--���� 1  
--ɾ��MRP������--Ȼ���Ż����ݿ⣬�ſ�ʼ����

Delete from My_t_MrpRoughNeedSource where frunid in (select frunid from my_t_Mrp where fdate<=Dateadd(day,-10,getdate()))
Delete from My_t_MrpWillInStock where frunid in (select frunid from my_t_Mrp where fdate<=Dateadd(day,-10,getdate()))
Delete from my_t_MrpResultDetail where frunid in (select frunid from my_t_Mrp where fdate<=Dateadd(day,-10,getdate()))
Delete from My_t_MrpStock where frunid in (select frunid from my_t_Mrp where fdate<=Dateadd(day,-10,getdate()))

--Delete from my_t_Mrp where fdate<=Dateadd(day,-20,getdate())  --Ҫ������Ļ���MRP������ĵ��ݻ���ʾû�м����

--���� 2 �ڳ��ִ��쳣����


select t6.fnumber,t6.fname,t6.fmodel,t1.fprice,t2.fnumber,t2.fname,t2.fmodel,t3.fprice,t7.fplanprice
--update t7 set fplanprice=t3.fprice
from icbomchild t4 
inner join icbom t5 on t5.finterid=t4.finterid
inner join t_icitem t6 on t6.fitemid=t5.fitemid --��
inner join t_icitem t2 on t4.fitemid=t2.fitemid --��
inner join t_SupplyEntry t1 on t1.fitemid=t6.fitemid  --��
inner join t_SupplyEntry t3 on t3.fitemid=t2.fitemid  --��
inner join t_ICItemMaterial t7 on t7.fitemid=t4.fitemid  --��
where t2.fnumber like '6.%' --and isnull(t1.fqty,0)=0
and t6.fnumber like '1.02.%' and isnull(t1.fprice,0)>0
--and isnull(t1.fprice,0)>0


--1.4 ���ĵ�������������

SELECT freftype,* 
--update t1 set freftype=12561
FROM ICSTOCKBILL t1 WHERE FTRANTYPE=41 
and isnull(FVchInterID,0)=0
and (isnull(freftype,0)<>12561)

SELECT freftype,* 
--update t2 set fpriceref=t2.fprice,fauxpriceref=t2.fauxprice,famtref=t2.famount
FROM ICSTOCKBILL t1 
inner join icstockbillentry t2 on t1.finterid=t2.finterid
WHERE t1.FTRANTYPE=41 
and isnull(t1.FVchInterID,0)=0
and t2.famtref<>t2.famount

--3.4 �������--����--�������������
select t13.fprice,t1.fname,t3.fcheckdate,t11.fnumber,t11.fname,t11.fmodel,t3.ftrantype,t3.fbillno,t3.fcheckerid,t2.fprice,t11.fplanprice,t2.fqty,t2.famount,t2.fnote
--update t2 set fprice=0.01,fauxprice=0.01,famount=cast(t2.fqty*0.01 as decimal(24,2))
--update t2 set fprice=t11.fplanprice,fauxprice=t11.fplanprice,famount=cast(t2.fqty*t11.fplanprice as decimal(24,2))
from icstockbillentry t2  
inner join icstockbill t3 on t2.finterid=t3.finterid  
inner join t_icitem t11 on t11.fitemid=t2.fitemid   
inner join t_item t1 on t1.fitemclassid=3010 and t1.fitemid=t3.fheadselfa9737
left join t_SupplyEntry t13 on t13.fitemid=t2.fitemid  --��
where year(t3.fdate)=2015 and month(t3.fdate)=1  and t3.ftrantype in (10)  --
and isnull(t3.FVchInterID,0)=0 and t3.FCancellation = 0 
--and t11.fname like '%оƬ%' 
--and t11.fnumber not like 'A.%' and t11.fnumber not like 'p.%'
--and t11.fnumber like '2.%'
--and t1.fname like '%����%'
and t2.fprice=0
and t11.fplanprice<>0 order by t11.fnumber

select fnumber,fname,fplanprice,* from t_icitem where fname like '%����%' and fnumber like '6.01.060%' order by fnumber

--�ܽ��Ӽ��ƻ����۸���
select t2.fnumber,t2.fname,t3.fplanprice,t1.fprice
--update t3 set fplanprice=t1.fprice
from t_supplyentry t1
inner join t_icitem t2 on t1.fitemid=t2.fitemid
inner join t_icitemmaterial t3 on t2.fitemid=t3.fitemid
where t2.fnumber like '6.%' and t3.fplanprice=0  


select * from t_itempropdesc where fitemclassid=4

select * from t_icitem where isnull(FAcctID,0) not in (select faccountid from t_account)

--1.4 �����⹺��ⵥ������Ŀ
SELECT fcussentacctid,* 
--update t1 set fcussentacctid=1107
FROM ICSTOCKBILL t1 WHERE FTRANTYPE=1 and fdate>='2013-9-01' 
and isnull(FVchInterID,0)=0
and (isnull(fcussentacctid,0)=0) and t1.fsupplyid not in (20163,20224)

--select fname from t_supplier where fitemid in (20163,20224)  --select * from t_account where faccountid in (1107,1340)

SELECT fcussentacctid,* 
--update t1 set fcussentacctid=1340
FROM ICSTOCKBILL t1 WHERE FTRANTYPE=1 and fdate>='2013-9-01' 
and isnull(FVchInterID,0)=0
and (isnull(fcussentacctid,0)=0) and t1.fsupplyid in (20163,20224)

select fname,* from t_supplier where fname like '%��%'
select * from t_account where fnumber like '2202%'

--drop table #t_supplyentry

set nocount on

---1 �ɹ�����

select t1.fitemid,max(t1.fprice) fprice
into #t_supplyentry
from t_supplyentry t1 
where t1.fprice<>0 and fcyid=1 
group by t1.fitemid

-----0 �����
--insert into #t_supplyentry
--select distinct t2.fitemid,max(t2.fprice) as fprice
--from icstockbill t1
--inner join icstockbillentry t2 on t1.finterid=t2.finterid
--inner join t_icitem t3 on t2.fitemid=t3.fitemid
--where t3.ferpclsid=1 and t1.ftrantype=24 and t2.fprice>0 
--and  year(t1.fdate)=(select fvalue from t_systemprofile where fcategory='ic' and fkey='currentyear') 
--and month(t1.fdate)=(select fvalue from t_systemprofile where fcategory='ic' and fkey='currentperiod') 
--and t3.fitemid not in (select fitemid from #t_supplyentry)
--group by t2.fitemid


---2 ���ڲɹ�����
insert into #t_supplyentry
select t2.fitemid,
max((case when fcurrencyid='1' then t2.fprice else  t2.fprice*cast(t1.fexchangerate as decimal(24,8)) end)) as fprice
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

--4 ��ǰ�ڼ��⹺��ⵥ����
insert into #t_supplyentry
select t2.fitemid,max(t2.fprice) from icstockbill t1
inner join icstockbillentry t2 on t1.finterid=t2.finterid
where t1.ftrantype=1 and t2.fitemid not in(select fitemid from #t_supplyentry)
group by t2.fitemid

--5 �ƻ�����
insert into #t_supplyentry
select t1.fitemid,t1.fplanprice 
from t_icitem t1
where t1.ferpclsid=1 and t1.fitemid not in(select fitemid from #t_supplyentry)
and t1.fplanprice>0

--����ԭ���ϼƻ�����
select m3.fnumber,m3.fname,m2.fplanprice,m1.fprice
--update m2 set fplanprice=m1.fprice
from #t_supplyentry m1	
inner join t_ICItemMaterial m2 on m1.fitemid=m2.fitemid  --����inner join ,������⹺���ǲ�����µ�
inner join t_icitem m3 on m3.fitemid=m2.fitemid
where m2.fplanprice<>m1.fprice and m2.fplanprice>200  

--�͹����ϼƻ����ۼ��
select t2.fnumber,t2.fname,t3.fplanprice
--update t3 set fplanprice=0.01
from t_icitem t2 
inner join t_icitemmaterial t3 on t2.fitemid=t3.fitemid
where t2.fnumber like '2.%' and t2.fname like '%�͹�%' and t3.fplanprice=0  

--�ʺмƻ����ۼ��
select t2.fnumber,t2.fname,t2.fmodel,t3.fplanprice,t4.fprice
--update t3 set fplanprice=3
from t_icitem t2 
inner join t_icitemmaterial t3 on t2.fitemid=t3.fitemid
left join t_supplyentry t4 on t4.fitemid=t2.fitemid
where left(t2.fnumber,5) in( '2.02.','2.03.','2.04.') --and t2.fname like '%�ʺ�%'
and t2.fplanprice>10

--�������->�޵��۵���ά��

select fplanprice,* from t_icitem where fname='�Ϸ۲����'

--�����º������޵��۵���ⵥ��--�⹺��
select t3.ftrantype,t3.fcheckerid,t2.fprice,t11.fplanprice,t3.fbillno,t11.fnumber,t11.fname,t11.fmodel,t2.fqty,t11.fplanprice*t2.fqty --,t21.fbegbal
--update t2 set fprice=0.01,fauxprice=0.01,famount=cast(t2.fqty*0.01 as decimal(24,2))
--update t2 set fprice=t11.fplanprice,fauxprice=t11.fplanprice,famount=cast(t2.fqty*t11.fplanprice as decimal(24,2))
--update t2 set fprice=cast(t21.fbegbal/t21.fbegqty as decimal(24,4)),fauxprice=cast(t21.fbegbal/t21.fbegqty as decimal(24,4)),famount=cast(t2.fqty*cast(t21.fbegbal/t21.fbegqty as decimal(24,4)) as decimal(24,2))
from icstockbillentry t2  
inner join icstockbill t3 on t2.finterid=t3.finterid  
inner join t_icitem t11 on t11.fitemid=t2.fitemid   
--inner join icinvbal t21 on t21.fitemid=t2.fitemid and t21.fyear=2015 and t21.fperiod=1
where year(t3.fdate)=2015 and month(t3.fdate)=1  and t11.ferpclsid=1  
and isnull(t3.FVchInterID,0)=0 and t3.FCancellation = 0 and t3.ftrantype in (1,2,3,5,10,40,41) --and t2.fprice<>t11.fplanprice
and (t2.fprice<=0 or t2.famount=0 ) --and t11.fnumber like '2.%'
order by t3.fbillno,t11.fnumber

--����г���⵫�Ӽ���û�е��۵��⹺��--��������е��۾Ϳ�����
select distinct t3.fplanprice,t4.fplanprice,t1.fitemid,t3.fnumber,t3.fname,t3.fmodel,t6.fentryid,t6.fitemid fchilditemid,
isnull(t4.fnumber,'') fchilditemnumber,isnull(t4.fname,'') fchilditemname,isnull(t4.fmodel,'') fchilditemmodel,
isnull(t5.fname,'') funit,cast(t6.fqty*(1+t6.fscrap/100 ) as decimal(24,4)) fqty
--select distinct t4.fnumber,t4.fname,t4.fmodel
--select distinct t3.fnumber,t3.fname,t3.fmodel,t3.fplanprice
--select distinct t3.fnumber,t3.fname,t3.fmodel,t3.fplanprice  --��ý��������ɲ�����һ��!!!!!�����ֱ������ƻ�����
--select distinct t1.fitemid into #childnoprice
from icbomchild t6 
inner join icbom t1 on t6.finterid=t1.finterid --���Ʒ
inner join t_icitem t3 on t3.fitemid=t1.fitemid --���Ʒ
inner join t_icitem t4 on t4.fitemid=t6.fitemid --����
inner join t_measureunit t5 on t5.fitemid=t4.funitid
left join #t_supplyentry t2 on t6.fitemid=t2.fitemid
inner join icstockbillentry t7 on t7.fitemid=t1.fitemid
inner join icstockbill t8 on t7.finterid=t8.finterid
left join #t_supplyentry t12 on t1.fitemid=t12.fitemid
where left(t3.fnumber,1) in ('3','4','r','q') and t1.fusestatus=1072 --and t3.fnumber like '4.01.026.400213'
and isnull(t2.fprice,0)<=0 and t4.fnumber not like '1.03.%' --����
and year(t8.fdate)=2015 and month(t8.fdate)=1 


select identity(int,1,1) as fid,t1.*,cast(isnull(t2.fprice,0) as decimal(24,4)) fprice,
cast(t1.fqty*isnull(t2.fprice,0) as decimal(24,2)) famount,cast(0 as decimal(24,2)) fallamount
into #temp
from
(
	--���Ʒ������
	select t1.fitemid,t3.fnumber,t3.fname,t3.fmodel,t6.fentryid,t6.fitemid fchilditemid,
	isnull(t4.fnumber,'') fchilditemnumber,isnull(t4.fname,'') fchilditemname,isnull(t4.fmodel,'') fchilditemmodel,
	isnull(t5.fname,'') funit,cast(t6.fqty*(1+t6.fscrap/100 ) as decimal(24,4)) fqty
	from icbomchild t6 
	inner join icbom t1 on t6.finterid=t1.finterid --���Ʒ
	inner join t_icitem t3 on t3.fitemid=t1.fitemid --���Ʒ
	inner join t_icitem t4 on t4.fitemid=t6.fitemid --����
	inner join t_measureunit t5 on t5.fitemid=t4.funitid
	where left(t3.fnumber,1) in ('3','4','r','q') and t1.fusestatus=1072 
	and t1.fitemid not in (select fitemid from #childnoprice)
--t3.fnumber like '3.%' AND t3.fnumber like '@@ItemNumber@@%'
) t1 left join #t_supplyentry t2 on t1.fchilditemid=t2.fitemid
order by fnumber,fentryid




--select * from #temp where fnumber='A.01.013.A00023'

--���Ʒ����
update t1 set fallamount=1*t2.fprice
from #temp t1
inner join 
(
	select fitemid,max(fid) fid,sum(famount)/*������Ļ��ܾ��Ǹ���ĵ���*/ fprice 
	from #temp 
	group by fitemid
) t2 on t1.fid=t2.fid

select fnumber ��Ʒ����,fname ��Ʒ����,fmodel ��Ʒ���,
fchilditemnumber ���ϱ���,fchilditemname ��������,fchilditemmodel ���Ϲ��,
funit ��λ,fqty ��λ����,fprice ����,famount ���,fallamount �ܽ��
into #data
FROM #temp where fallamount<>0

drop table #temp
drop table #t_supplyentry
--drop table #data

set nocount off


--select * from #data order by ��Ʒ����,���ϱ���


select t1.fdate,t1.fbillno,t3.fnumber,t3.fname,t3.fmodel,t2.fprice,t3.fplanprice,t4.�ܽ��,t2.* 
--update t2 set fprice=t4.�ܽ�� ,fauxprice=t4.�ܽ��,famount=t2.fqty*t4.�ܽ��
from icstockbill t1
inner join icstockbillentry t2 on t1.finterid=t2.finterid
inner join t_icitem t3 on t2.fitemid=t3.fitemid
inner join #data t4 on t3.fnumber=t4.��Ʒ����
where t1.ftrantype in(2,10,40) and month(t1.fdate)=1  and year(t1.fdate)=2015 
and left(t3.fnumber,1) in ('3','4','r','q') -- and t2.fprice=0
and isnull(t1.FVchInterID,0)=0
--and t3.fnumber not in(select ��Ʒ���� from #data)

--����Ƿ�û�е���
select t3.fplanprice,t1.fdate,t1.fbillno,t3.fnumber,t3.fname,t3.fmodel,t2.fprice,t4.�ܽ��
--update t2 set fprice=cast(t3.fplanprice as decimal(24,4)),fauxprice=cast(t3.fplanprice as decimal(24,4)),famount=cast(t2.fqty*cast(t3.fplanprice as decimal(24,4)) as decimal(24,2))
from icstockbill t1
inner join icstockbillentry t2 on t1.finterid=t2.finterid
inner join t_icitem t3 on t2.fitemid=t3.fitemid
left join #data t4 on t3.fnumber=t4.��Ʒ����
where t1.ftrantype in(2,10,40) and month(t1.fdate)=1  and year(t1.fdate)=2015 
and left(t3.fnumber,1) in ('3','4','r','q') and t2.fprice=0
and isnull(t1.FVchInterID,0)=0

--drop table #data



--3.2 �����º������޵��۵���ⵥ��
select t2.fqty,t3.ftrantype,t3.fbillno,t11.fnumber,t11.fname,t11.fmodel,t3.fcheckerid,t2.fprice,t11.fplanprice,t2.fqty,t11.fplanprice*t2.fqty
--update t2 set fprice=7.69,fauxprice=7.69,famount=cast(t2.fqty*7.69 as decimal(24,2))
--update t2 set fprice=0.01,fauxprice=0.01,famount=cast(t2.fqty*0.01 as decimal(24,2))
--update t2 set fprice=t11.fplanprice,fauxprice=t11.fplanprice,famount=cast(t2.fqty*t11.fplanprice as decimal(24,2))
--select distinct t11.fnumber,t11.fname,t11.fmodel
from icstockbillentry t2  
inner join icstockbill t3 on t2.finterid=t3.finterid  
inner join t_icitem t11 on t11.fitemid=t2.fitemid   
where year(t3.fdate)=2015 and month(t3.fdate)=1
and isnull(t3.FVchInterID,0)=0 and t3.FCancellation = 0 
and (t3.ftrantype in (1,2,3,5,10,40,41) or (t3.ftrantype in (24,29) and t3.frob=-1)) --and t2.fprice<>t11.fplanprice
and (t2.fprice<=0 or t2.famount=0 ) --and t11.fnumber like '1.06.001.001432%'
order by t3.fbillno



/*
--���ڲ�Ʒ�����--16872205.94
select sum(t2.famount)
from icstockbillentry t2  
inner join icstockbill t3 on t2.finterid=t3.finterid  
inner join t_icitem t11 on t11.fitemid=t2.fitemid   
where year(t3.fdate)=2015 and month(t3.fdate)=1 and t3.ftrantype in (2)
and isnull(t3.FVchInterID,0)=0 and t3.FCancellation = 0 --and t11.fnumber not like 'F%'

--�������Ͻ��--17176239.64
select sum(t2.famount)
from icstockbillentry t2  
inner join icstockbill t3 on t2.finterid=t3.finterid  
inner join t_icitem t11 on t11.fitemid=t2.fitemid  
inner join t_department t4 on t4.fitemid=t3.fdeptid 
where year(t3.fdate)=2015 and month(t3.fdate)=1 and t3.ftrantype in (24)
--and isnull(t3.FVchInterID,0)=0 
and t3.FCancellation = 0 
--and t4.fname not like '�Ͻ�%'

--  -��Ʒ���-�����������-������ӯ���+������������+�����̿����+��������  392567.75
select sum(case when t3.ftrantype in (40,10,2) then -t2.famount else t2.famount end)
from icstockbillentry t2  
inner join icstockbill t3 on t2.finterid=t3.finterid  
inner join t_icitem t11 on t11.fitemid=t2.fitemid  
inner join t_department t4 on t4.fitemid=t3.fdeptid 
where year(t3.fdate)=2015 and month(t3.fdate)=1
--and isnull(t3.FVchInterID,0)=0 
and t3.FCancellation = 0 
and t4.fname not like '�Ͻ�%' and t3.ftrantype in (2,24) and t11.fnumber not like 'F%' --(2,40,10,29,43,24)

select * from ictranstype

*/