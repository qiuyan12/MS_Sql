select * from sheet26$

select t3.*
--update t7 set F_144=t3.ҳ����
FROM         dbo.t_ICItemCore AS t0 
LEFT OUTER JOIN dbo.t_ICItemBase AS t1 ON t0.FItemID = t1.FItemID LEFT OUTER JOIN

dbo.t_ICItemCustom AS t7 ON t0.FItemID = t7.FItemID
inner join t_icitem t2 on t2.fitemid=t0.fitemid
inner join sheet26$ t3 on t3.����=t2.fnumber


select * from t_itempropdesc where fitemclassid=4


set nocount on

if object_id('tempdb..#HPR_calc') is not null
 drop table #HPR_calc


select ����,����,���ݱ��,Դ�ɹ�������,Դ���۶�����,��Ʒ����,����,����ͺ�,������,����PCS��,
����,ϵ��,��PCS����,оƬ��ǩ��,ҳ����,���,
case when ����='��װ' and ���='��' and оƬ��ǩ��<=5 and ��PCS����<=20 then 0.9 
	 when ����='��װ' and ���='��' and оƬ��ǩ��<=5 and ��PCS���� between 21 and 50 then 0.7 
	 when ����='��װ' and ���='��' and оƬ��ǩ��<=5 and ��PCS���� between 51 and 100 then 0.6 
	 when ����='��װ' and ���='��' and оƬ��ǩ��<=5 and ��PCS����>100 then 0.5 
     
	 when ����='��װ' and ���='��' and оƬ��ǩ��<=5 and ��PCS����<=20 then 0.85 
	 when ����='��װ' and ���='��' and оƬ��ǩ��<=5 and ��PCS���� between 21 and 50 then 0.65 
	 when ����='��װ' and ���='��' and оƬ��ǩ��<=5 and ��PCS���� between 51 and 100 then 0.55 
	 when ����='��װ' and ���='��' and оƬ��ǩ��<=5 and ��PCS����>100 then 0.45 

	 when ����='��װ' and ���='С' and оƬ��ǩ��<=5 and ��PCS����<=20 then 0.8 
	 when ����='��װ' and ���='С' and оƬ��ǩ��<=5 and ��PCS���� between 21 and 50 then 0.6 
	 when ����='��װ' and ���='С' and оƬ��ǩ��<=5 and ��PCS���� between 51 and 100 then 0.5 
	 when ����='��װ' and ���='С' and оƬ��ǩ��<=5 and ��PCS����>100 then 0.4 

	 when ����='��װ' and ���='��' and оƬ��ǩ��>5 and ��PCS����<=20 then 0.9 
	 when ����='��װ' and ���='��' and оƬ��ǩ��>5 and ��PCS���� between 21 and 50 then 0.7 
	 when ����='��װ' and ���='��' and оƬ��ǩ��>5 and ��PCS���� between 51 and 100 then 0.6 
	 when ����='��װ' and ���='��' and оƬ��ǩ��>5 and ��PCS����>100 then 0.5 
     
	 when ����='��װ' and ���='��' and оƬ��ǩ��>5 and ��PCS����<=20 then 0.85 
	 when ����='��װ' and ���='��' and оƬ��ǩ��>5 and ��PCS���� between 21 and 50 then 0.65 
	 when ����='��װ' and ���='��' and оƬ��ǩ��>5 and ��PCS���� between 51 and 100 then 0.55 
	 when ����='��װ' and ���='��' and оƬ��ǩ��>5 and ��PCS����>100 then 0.45 

	 when ����='��װ' and ���='С' and оƬ��ǩ��>5 and ��PCS����<=20 then 0.8 
	 when ����='��װ' and ���='С' and оƬ��ǩ��>5 and ��PCS���� between 21 and 50 then 0.6 
	 when ����='��װ' and ���='С' and оƬ��ǩ��>5 and ��PCS���� between 51 and 100 then 0.5 
	 when ����='��װ' and ���='С' and оƬ��ǩ��>5 and ��PCS����>100 then 0.4 

	 --when left(t4.fname,2)='װ��' then t5.FPieceRate

	 --when left(t4.fname,2)='װ��' then isnull(t5.F_139,0.00) 
	 end ����,���
into #HPR_calc
from
(
	select t3.fdate ����,t4.fname ��������,t1.fname ����,isnull(t9.fbillno,t7.fbillno) ���ݱ��,
	isnull(t9.fheadselfs0143,'') Դ�ɹ�������,isnull(t9.fheadselfs0144,'') Դ���۶�����,
	t5.fnumber ��Ʒ����,t5.fname ����,t5.fmodel ����ͺ�,t7.fqty ������,
	isnull(y.fchildqty,1) ϵ��,t7.fqty*isnull(y.fchildqty,1) ����PCS��,
	t2.fqty ����,t2.fqty*isnull(y.fchildqty,1) ��PCS����,--isnull(1000*x.fqty,0) ��λ�����,
	(isnull(t6.fxinpianqty,0)+isnull(z.flabelqty,0))/isnull(y.fchildqty,1) оƬ��ǩ��,
	cast(isnull(y.fpagecount,0)/isnull(y.fchildqty,1) as decimal(24,2)) ҳ����,left(t4.fname,2) ����,
	case when isnull(y.fpagecount,0)/isnull(y.fchildqty,1)<5 then 'С' 
		 when isnull(y.fpagecount,0)/isnull(y.fchildqty,1)>=5 and isnull(y.fpagecount,0)/isnull(y.fchildqty,1)<10 then '��'
		 when isnull(y.fpagecount,0)/isnull(y.fchildqty,1)>=10 then '��' end ���,

	--case when left(t4.fname,2)='װ��' and (isnull(1000*x.fqty,0))<=150 and (isnull(1000*x.fqty,0))>0 then 0.09 
	--     when left(t4.fname,2)='װ��' and (isnull(1000*x.fqty,0))>150 and (isnull(1000*x.fqty,0))<=550 then 0.18 
	--	 when left(t4.fname,2)='װ��' and (isnull(1000*x.fqty,0))>550 then 0.36 
	--
	--	 --when left(t4.fname,2)='װ��' then isnull(t5.F_139,0.00) 
	--	 end ��۵���,

	isnull(t2.famount,0.00) ���

	from icstockbill t3	
	inner join t_Item_3008 t1 on t1.fitemid=t3.fheadselfa0229 
	inner join icstockbillentry t2 on t2.finterid=t3.finterid
	inner join t_icitem t5 on t5.fitemid=t2.fitemid
	inner join t_department t4 on t4.fitemid=t3.fdeptid
	left join icmo t7 on t7.finterid=t2.ficmointerid
	left join seorderentry t8 on t8.finterid=t7.forderinterid and t8.fentryid=t7.fsourceentryid
	left join seorder t9 on t8.finterid=t9.finterid
	left join 
	(
		select a.fitemid,sum(b.fqty) as fchildqty,sum(b.fqty*isnull(d.f_144,0)) fpagecount --���Ʒ��������
		from icbom a --��Ʒ
		inner join icbomchild b on a.finterid=b.finterid  --���Ʒ
		inner join t_icitem c on a.fitemid=c.fitemid --��Ʒ
		inner join t_icitem d on b.fitemid=d.fitemid --���Ʒ
		where left(d.fnumber,1) in ('3','4','5','7','8')
		group by a.fitemid
	) y on t2.fitemid=y.fitemid
	left join 
	(
		select a.fitemid,sum(b.fqty) as fxinpianqty --оƬ��������
		from icbom a --��Ʒ
		inner join icbomchild b on a.finterid=b.finterid  --оƬ
		inner join t_icitem c on a.fitemid=c.fitemid --��Ʒ
		inner join t_icitem d on b.fitemid=d.fitemid --оƬ
		where d.fnumber like '1.01.0010.%'
		group by a.fitemid
	) t6 on t2.fitemid=t6.fitemid
	--left join 
	--(
	--	select a.fitemid,sum(b.fqty) as fqty --оƬ��������
	--	from icbom a --��Ʒ
	--	inner join icbomchild b on a.finterid=b.finterid  --оƬ
	--	inner join t_icitem c on a.fitemid=c.fitemid --��Ʒ
	--	inner join t_icitem d on b.fitemid=d.fitemid --оƬ
	--	where d.fnumber like '1.01.0009.%'
	--	group by a.fitemid
	--) x on t2.fitemid=x.fitemid
	left join 
	(
		select a.fitemid,sum(b.fqty) as flabelqty --��ǩ��������
		from icbom a --��Ʒ
		inner join icbomchild b on a.finterid=b.finterid  --��ǩ
		inner join t_icitem c on a.fitemid=c.fitemid --��Ʒ
		inner join t_icitem d on b.fitemid=d.fitemid --��ǩ
		where left(d.fnumber,5) in ('2.05.','2.06.','2.07.')
		group by a.fitemid
	) z on t2.fitemid=z.fitemid
	--where t3.fdate>='20170401' and t3.fdate<='2017-04-30'
	where t3.fdate>='********' and t3.fdate<='########'
	and t3.ftrantype=2
	and left(t5.fnumber,1) not in ('r','q')
	and isnull(t7.fnote,'') not like '%����%'
	and isnull(t7.fworktypeid,0)<>56
) t1 where ����='��װ' order by ����,��������,����,��Ʒ����

update #HPR_calc set ���=isnull(��PCS����*����,0)

select * from #HPR_calc

drop table #HPR_calc

set nocount off

