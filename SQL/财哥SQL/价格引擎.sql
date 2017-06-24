select *
from t_itempropdesc where fitemclassid=4


-- �Ƿ�����	F_126
-- �۸�����	F_127
-- �������	F_129


set nocount on

--����Դ
select -1 ftype,fitemid,max(fbanitemid) fbanitemid,max(fxinitemid) fxinitemid,0 fisyinqing,0 fyinqingitemid,
0 FIsPriceError,0 FIsHaveSellPrice,
cast(0.00 as decimal(24,4)) fsellprice,cast(0.00 as decimal(24,4)) fmaterialcost into #data
from
(
	select t1.fitemid,
	case when left(t4.fnumber,1) in ('3','4','5','7','8') then t4.fitemid else 0 end fbanitemid,
	case when left(t4.fnumber,10) in ('1.01.0010.') then t4.fitemid else 0 end fxinitemid
	from t_icitem t1
	inner join t_item t13 on t13.fitemid=t1.fparentid 
	inner join icbom t2 on t1.fitemid=t2.fitemid
	inner join icbomchild t3 on t2.finterid=t3.finterid
	inner join t_icitem t4 on t3.fitemid=t4.fitemid
	where --left(t1.fnumber,4) in ('a.01','p.01','j.01','x.01','y.01') 
	left(t1.fnumber,1) in (select fitemtype from v_myitemtype where ftype=0)
	--and t1.fshortnumber='a02050'
	and left(t1.fnumber,1) not in ('q','r') and t1.fname not like '%����%' and t1.fdeleted=0
) t1 group by t1.fitemid

--��оƬ������
update t1 set ftype=0
from #data t1
inner join t_icitem t2 on t1.fitemid=t2.fitemid
where --left(t2.fnumber,4) in ('a.01','p.01','j.01','x.01','y.01') and 
t1.fxinitemid=0 and t2.fname like '%����%'

--��оƬ���Ǹ���
update t1 set ftype=1
from #data t1
inner join t_icitem t2 on t1.fitemid=t2.fitemid
where t1.fxinitemid=0 and t2.fname not like '%����%'

--��оƬ������
update t1 set ftype=2
from #data t1
inner join t_icitem t2 on t1.fitemid=t2.fitemid
where t1.fxinitemid>0 and t2.fname like '%����%'

--��оƬ���Ǹ���
update t1 set ftype=3
from #data t1
inner join t_icitem t2 on t1.fitemid=t2.fitemid
where t1.fxinitemid>0 and t2.fname not like '%����%'


--����������Ϊ����--��׼����ֻ�а���������Ϊ����
update t7 set fisyinqing=1,fyinqingitemid=t7.fitemid
from #data t7
inner join
(
	select t1.ftype,t1.fbanitemid,min(t2.fitemid) fitemid
	from #data t1
	inner join t_icitem t2 on t1.fitemid=t2.fitemid
	where left(t2.fnumber,4) in ('a.01','p.01','j.01','x.01','y.01')
	--and (t1.fxinitemid)=0
	group by t1.fbanitemid,t1.ftype
) t2 on t7.fitemid=t2.fitemid and t7.ftype=t2.ftype
inner join t_icitem t4 on t2.fitemid=t4.fitemid


--�������� ���+���Ʒ
update t7 set fyinqingitemid=t2.fitemid
from (select fitemid,fbanitemid,ftype from #data where fisyinqing=0) t1  
inner join (select fitemid,fbanitemid,ftype from #data where fisyinqing=1) t2 on t1.fbanitemid=t2.fbanitemid and t1.ftype=t2.ftype
inner join #data t7 on t7.fitemid=t1.fitemid

-- update t7 set fisyinqing=1,fyinqingitemid=t7.fitemid
-- from #data t7
-- inner join
-- (
-- 	select t1.fbanitemid,min(t2.fitemid) fitemid
-- 	from #data t1
-- 	inner join t_icitem t2 on t1.fitemid=t2.fitemid
-- 	where left(t2.fnumber,4) in ('a.01','p.01','j.01','x.01','y.01')
-- 	and (t1.fxinitemid)>0
-- 	group by t1.fbanitemid
-- ) t2 on t7.fitemid=t2.fitemid
-- inner join t_icitem t4 on t2.fitemid=t4.fitemid
-- 
-- update t7 set fyinqingitemid=t2.fitemid
-- from (select fitemid,fbanitemid from #data where fisyinqing=0 and fxinitemid>0) t1
-- inner join (select fitemid,fbanitemid from #data where fisyinqing=1 and fxinitemid>0) t2 on t1.fbanitemid=t2.fbanitemid
-- inner join t_icitem t3 on t1.fitemid=t3.fitemid
-- inner join t_icitem t4 on t2.fitemid=t4.fitemid
-- inner join #data t7 on t7.fitemid=t1.fitemid


--����оƬ
update t7 set fisyinqing=1,fyinqingitemid=t7.fitemid
from #data t7
inner join
(
	select t1.fitemid
	from #data t1
	inner join t_icitem t2 on t1.fitemid=t2.fitemid
	inner join t_icitem t8 on t1.fxinitemid=t8.fitemid
	where --left(t2.fnumber,4) in ('a.01','p.01','j.01','x.01','y.01') and
	t1.fxinitemid>0 and (t8.fname like '%/099%' or t8.fname like '%chn%')
) t2 on t7.fitemid=t2.fitemid
inner join t_icitem t4 on t2.fitemid=t4.fitemid

select * from t_submessage where ftypeid=10002 and fname ='��'
--�Ƿ�����	F_126
--�۸�����	F_127
--�������	F_129
select t3.fnumber ��Ʒ����,t3.fname ��Ʒ����,t3.fmodel ��Ʒ�ͺ�,t4.fnumber �������,t4.fname ��������,t4.fmodel �����ͺ�,
t7.fnumber ���Ʒ����,t7.fname ���Ʒ����,t7.fmodel ���Ʒ�ͺ�,t8.fnumber оƬ����,t8.fname оƬ����,t8.fmodel оƬ�ͺ�,
(case when t1.fisyinqing=1 then 'Y' end) �Ƿ�����,(case when t1.fisyinqing=1 then 40019 else 0 end) �Ƿ�����,
(case when t1.FIsPriceError=1 then 'Y' end) �۸�����,
(case when t1.FIsHaveSellPrice=1 then 'Y' end) �Ƿ��ѱ���,
t1.fsellprice ��׼�ۼ�,t1.fmaterialcost ���ϳɱ�
--update t5 set F_126=(case when t1.fisyinqing=1 then 40019 else 0 end),F_127=fyinqingitemid,F_129=t4.fnumber
from #data t1
inner join t_icitem t3 on t1.fitemid=t3.fitemid
left join t_icitem t4 on t1.fyinqingitemid=t4.fitemid
left join t_icitem t7 on t1.fbanitemid=t7.fitemid
left join t_icitem t8 on t1.fxinitemid=t8.fitemid
--left join IcPrcPlyEntry t9 on t9.fitemid=t1.fitemid
inner join t_ICItemCustom t5 on t1.fitemid=t5.fitemid
-- inner join t_ICItemCustom t6 on t2.fitemid=t6.fitemid --��Ʒ���� Y
where (left(t3.fnumber,4) in ('a.01','p.01','j.01','x.01','y.01') or left(t3.fnumber,1) in ('v'))
--and t3.fshortnumber in ('A00057','A00058')
and t1.fyinqingitemid>0
--and t1.fisyinqing='1'
order by t4.fnumber,t1.fisyinqing desc,t3.fnumber

--�Ҳ�������ĵ�����Ϊ����

select t3.fnumber ��Ʒ����,t3.fname ��Ʒ����,t3.fmodel ��Ʒ�ͺ�,isnull(t1.fbomnumber,'') BOM���
,isnull(t5.fnumber,'') ���Ʒ����,isnull(t5.fname,'') ���Ʒ����,isnull(t5.fmodel,'') ���Ʒ�ͺ�
,isnull(t8.fnumber,'') оƬ����,isnull(t8.fname,'') оƬ����,isnull(t8.fmodel,'') оƬ�ͺ�
from t_icitem t3 
left join icbom t1 on t1.fitemid=t3.fitemid
left join 
(
	select t1.finterid,t5.fitemid
	from icbom t1
	inner join icbomchild t2 on t1.finterid=t2.finterid
	inner join t_icitem t5 on t5.fitemid=t2.fitemid 
	where left(t5.fnumber,1) in ('3','4','5','7','8')
) t4 on t4.finterid=t1.finterid
left join t_icitem t5 on t5.fitemid=t4.fitemid
left join 
(
	select t1.finterid,t5.fitemid
	from icbom t1
	inner join icbomchild t2 on t1.finterid=t2.finterid
	inner join t_icitem t5 on t5.fitemid=t2.fitemid 
	where left(t5.fnumber,9) in ('1.01.0010')
) t7 on t7.finterid=t1.finterid
left join t_icitem t8 on t8.fitemid=t7.fitemid
--and t3.fshortnumber in ('A00057','A00058')
where (left(t3.fnumber,4) in ('a.01','p.01','j.01','x.01','y.01') or left(t3.fnumber,1) in ('v'))
and isnull(t3.F_126,0)<>40019 and isnull(t3.F_127,0)=0
and t3.fname not like '%����%' and isnull(t3.ftypeid,0)<>40127
order by t3.fnumber



drop table #data

set nocount off



----------------------------------------------------------------------------------------------------------------------


--����������
select t1.fnumber ����,t1.fname ����,t1.fmodel ����ͺ�,
isnull(t11.fnumber,'') �������,t11.fname ��������,t11.fmodel �������ͺ�
--select distinct t1.fitemid into #data
from t_icitem t1 
inner join t_ICItemCustom t3 on t1.fitemid=t3.fitemid
left join t_submessage t4 on t1.f_128=t4.finterid
inner join t_icitem t11 on t11.fitemid=t1.f_127  --����
left join t_submessage t12 on t12.finterid=t1.f_126
inner join icbom t13 on t13.fitemid=t1.fitemid
inner join icbom t14 on t14.fitemid=t11.fitemid
WHERE (left(t1.fnumber,1) in ('a','p','j','x','y') or t1.fnumber like 'v.b.%') 
and isnull(t1.f_126,0)<>40019 and t1.fname not like '%����%' and t11.fname like '%����%'
order by t1.fnumber,t11.fnumber

--��װ
select t1.fitemid into #data2
from
(
	select fitemid from
	(
		select t1.fitemid,t1.fnumber,t1.fname,t4.fitemid fbanitemid
		from t_icitem t1
		inner join icbom t2 on t1.fitemid=t2.fitemid
		inner join icbomchild t3 on t2.finterid=t3.finterid
		inner join t_icitem t4 on t3.fitemid=t4.fitemid
		where t1.fitemid in (select fitemid from #data) and t1.fname not like '%����%' and t1.fdeleted=0 
		and left(t1.fnumber,1) in ('v') and left(t4.fnumber,1) in ('3','4','5','7','8')
	) t1 group by t1.fitemid
	having count(1)>1
) t1 inner join t_ICItemCustom t12 on t1.fitemid=t12.fitemid
inner join t_icitem t3 on t3.fitemid=t1.fitemid

select t15.fnumber,t15.fname,t14.fnumber,t14.fname,t11.fnumber,t11.fname
--update t2 set flastmoddate='2016-04-13'
--update t12 set f_127=t1.fbaseitemid
from
(
	select t2.fitemid,min(t2.fbaseitemid) fbaseitemid
	from
	(
		select t1.fitemid,t2.fitemid fbaseitemid
		from
		(
			select fitemid,max(fbanitemid) fbanitemid,isnull(max(fxinitemid),0) fxinitemid from
			(
				select t1.fitemid,
				case when left(t4.fnumber,1) in ('3','4','5','7','8') then t4.fitemid else 0 end fbanitemid,
				case when left(t4.fnumber,10) in ('1.01.0010.') then t4.fitemid else 0 end fxinitemid
				from t_icitem t1
				inner join icbom t2 on t1.fitemid=t2.fitemid
				inner join icbomchild t3 on t2.finterid=t3.finterid
				inner join t_icitem t4 on t3.fitemid=t4.fitemid
				where t1.fitemid in (select fitemid from #data) 
				and t1.fitemid not in (select fitemid from #data2) 
				--and left(t1.fnumber,1) in (select fitemtype from v_myitemtype where ftype=0)
				--and t1.fname not like '%����%' and t1.fdeleted=0 
			) t1 group by t1.fitemid
		) t1 inner join
		(
			select fitemid,max(fbanitemid) fbanitemid,isnull(max(fxinitemid),0) fxinitemid from
			(
				select t1.fitemid,
				case when left(t4.fnumber,1) in ('3','4','5','7','8') then t4.fitemid else 0 end fbanitemid,
				case when left(t4.fnumber,10) in ('1.01.0010.') then t4.fitemid else 0 end fxinitemid
				from t_icitem t1
				inner join icbom t2 on t1.fitemid=t2.fitemid
				inner join icbomchild t3 on t2.finterid=t3.finterid
				inner join t_icitem t4 on t3.fitemid=t4.fitemid
				where t1.fname not like '%����%' and t1.fdeleted=0 and t1.fname not like '%ר��%'
				and left(t1.fnumber,4) in ('A.01','P.01','J.01','X.01','Y.01') 
			) t1 group by t1.fitemid
		) t2 on t1.fbanitemid=t2.fbanitemid and t1.fxinitemid=t2.fxinitemid
	) t2 group by t2.fitemid
) t1 inner join t_icitem t14 on t14.fitemid=t1.fitemid
inner join t_icitem t15 on t15.fitemid=t1.fbaseitemid
inner join t_ICItemCustom t12 on t1.fitemid=t12.fitemid
inner join t_icitem t11 on t11.fitemid=t14.f_127  --����
inner join t_baseproperty t2 on t1.fitemid=t2.fitemid