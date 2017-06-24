select * from sheet26$

select t3.*
--update t7 set F_144=t3.页产量
FROM         dbo.t_ICItemCore AS t0 
LEFT OUTER JOIN dbo.t_ICItemBase AS t1 ON t0.FItemID = t1.FItemID LEFT OUTER JOIN

dbo.t_ICItemCustom AS t7 ON t0.FItemID = t7.FItemID
inner join t_icitem t2 on t2.fitemid=t0.fitemid
inner join sheet26$ t3 on t3.代码=t2.fnumber


select * from t_itempropdesc where fitemclassid=4


set nocount on

if object_id('tempdb..#HPR_calc') is not null
 drop table #HPR_calc


select 日期,拉线,单据编号,源采购订单号,源销售订单号,产品编码,名称,规格型号,任务数,任务纯PCS数,
数量,系数,纯PCS数量,芯片标签数,页产量,体积,
case when 车间='包装' and 体积='大' and 芯片标签数<=5 and 纯PCS数量<=20 then 0.9 
	 when 车间='包装' and 体积='大' and 芯片标签数<=5 and 纯PCS数量 between 21 and 50 then 0.7 
	 when 车间='包装' and 体积='大' and 芯片标签数<=5 and 纯PCS数量 between 51 and 100 then 0.6 
	 when 车间='包装' and 体积='大' and 芯片标签数<=5 and 纯PCS数量>100 then 0.5 
     
	 when 车间='包装' and 体积='中' and 芯片标签数<=5 and 纯PCS数量<=20 then 0.85 
	 when 车间='包装' and 体积='中' and 芯片标签数<=5 and 纯PCS数量 between 21 and 50 then 0.65 
	 when 车间='包装' and 体积='中' and 芯片标签数<=5 and 纯PCS数量 between 51 and 100 then 0.55 
	 when 车间='包装' and 体积='中' and 芯片标签数<=5 and 纯PCS数量>100 then 0.45 

	 when 车间='包装' and 体积='小' and 芯片标签数<=5 and 纯PCS数量<=20 then 0.8 
	 when 车间='包装' and 体积='小' and 芯片标签数<=5 and 纯PCS数量 between 21 and 50 then 0.6 
	 when 车间='包装' and 体积='小' and 芯片标签数<=5 and 纯PCS数量 between 51 and 100 then 0.5 
	 when 车间='包装' and 体积='小' and 芯片标签数<=5 and 纯PCS数量>100 then 0.4 

	 when 车间='包装' and 体积='大' and 芯片标签数>5 and 纯PCS数量<=20 then 0.9 
	 when 车间='包装' and 体积='大' and 芯片标签数>5 and 纯PCS数量 between 21 and 50 then 0.7 
	 when 车间='包装' and 体积='大' and 芯片标签数>5 and 纯PCS数量 between 51 and 100 then 0.6 
	 when 车间='包装' and 体积='大' and 芯片标签数>5 and 纯PCS数量>100 then 0.5 
     
	 when 车间='包装' and 体积='中' and 芯片标签数>5 and 纯PCS数量<=20 then 0.85 
	 when 车间='包装' and 体积='中' and 芯片标签数>5 and 纯PCS数量 between 21 and 50 then 0.65 
	 when 车间='包装' and 体积='中' and 芯片标签数>5 and 纯PCS数量 between 51 and 100 then 0.55 
	 when 车间='包装' and 体积='中' and 芯片标签数>5 and 纯PCS数量>100 then 0.45 

	 when 车间='包装' and 体积='小' and 芯片标签数>5 and 纯PCS数量<=20 then 0.8 
	 when 车间='包装' and 体积='小' and 芯片标签数>5 and 纯PCS数量 between 21 and 50 then 0.6 
	 when 车间='包装' and 体积='小' and 芯片标签数>5 and 纯PCS数量 between 51 and 100 then 0.5 
	 when 车间='包装' and 体积='小' and 芯片标签数>5 and 纯PCS数量>100 then 0.4 

	 --when left(t4.fname,2)='装配' then t5.FPieceRate

	 --when left(t4.fname,2)='装配' then isnull(t5.F_139,0.00) 
	 end 单价,金额
into #HPR_calc
from
(
	select t3.fdate 日期,t4.fname 生产车间,t1.fname 拉线,isnull(t9.fbillno,t7.fbillno) 单据编号,
	isnull(t9.fheadselfs0143,'') 源采购订单号,isnull(t9.fheadselfs0144,'') 源销售订单号,
	t5.fnumber 产品编码,t5.fname 名称,t5.fmodel 规格型号,t7.fqty 任务数,
	isnull(y.fchildqty,1) 系数,t7.fqty*isnull(y.fchildqty,1) 任务纯PCS数,
	t2.fqty 数量,t2.fqty*isnull(y.fchildqty,1) 纯PCS数量,--isnull(1000*x.fqty,0) 单位灌粉量,
	(isnull(t6.fxinpianqty,0)+isnull(z.flabelqty,0))/isnull(y.fchildqty,1) 芯片标签数,
	cast(isnull(y.fpagecount,0)/isnull(y.fchildqty,1) as decimal(24,2)) 页产量,left(t4.fname,2) 车间,
	case when isnull(y.fpagecount,0)/isnull(y.fchildqty,1)<5 then '小' 
		 when isnull(y.fpagecount,0)/isnull(y.fchildqty,1)>=5 and isnull(y.fpagecount,0)/isnull(y.fchildqty,1)<10 then '中'
		 when isnull(y.fpagecount,0)/isnull(y.fchildqty,1)>=10 then '大' end 体积,

	--case when left(t4.fname,2)='装配' and (isnull(1000*x.fqty,0))<=150 and (isnull(1000*x.fqty,0))>0 then 0.09 
	--     when left(t4.fname,2)='装配' and (isnull(1000*x.fqty,0))>150 and (isnull(1000*x.fqty,0))<=550 then 0.18 
	--	 when left(t4.fname,2)='装配' and (isnull(1000*x.fqty,0))>550 then 0.36 
	--
	--	 --when left(t4.fname,2)='装配' then isnull(t5.F_139,0.00) 
	--	 end 灌粉单价,

	isnull(t2.famount,0.00) 金额

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
		select a.fitemid,sum(b.fqty) as fchildqty,sum(b.fqty*isnull(d.f_144,0)) fpagecount --半成品的总用量
		from icbom a --成品
		inner join icbomchild b on a.finterid=b.finterid  --半成品
		inner join t_icitem c on a.fitemid=c.fitemid --成品
		inner join t_icitem d on b.fitemid=d.fitemid --半成品
		where left(d.fnumber,1) in ('3','4','5','7','8')
		group by a.fitemid
	) y on t2.fitemid=y.fitemid
	left join 
	(
		select a.fitemid,sum(b.fqty) as fxinpianqty --芯片的总用量
		from icbom a --成品
		inner join icbomchild b on a.finterid=b.finterid  --芯片
		inner join t_icitem c on a.fitemid=c.fitemid --成品
		inner join t_icitem d on b.fitemid=d.fitemid --芯片
		where d.fnumber like '1.01.0010.%'
		group by a.fitemid
	) t6 on t2.fitemid=t6.fitemid
	--left join 
	--(
	--	select a.fitemid,sum(b.fqty) as fqty --芯片的总用量
	--	from icbom a --成品
	--	inner join icbomchild b on a.finterid=b.finterid  --芯片
	--	inner join t_icitem c on a.fitemid=c.fitemid --成品
	--	inner join t_icitem d on b.fitemid=d.fitemid --芯片
	--	where d.fnumber like '1.01.0009.%'
	--	group by a.fitemid
	--) x on t2.fitemid=x.fitemid
	left join 
	(
		select a.fitemid,sum(b.fqty) as flabelqty --标签的总用量
		from icbom a --成品
		inner join icbomchild b on a.finterid=b.finterid  --标签
		inner join t_icitem c on a.fitemid=c.fitemid --成品
		inner join t_icitem d on b.fitemid=d.fitemid --标签
		where left(d.fnumber,5) in ('2.05.','2.06.','2.07.')
		group by a.fitemid
	) z on t2.fitemid=z.fitemid
	--where t3.fdate>='20170401' and t3.fdate<='2017-04-30'
	where t3.fdate>='********' and t3.fdate<='########'
	and t3.ftrantype=2
	and left(t5.fnumber,1) not in ('r','q')
	and isnull(t7.fnote,'') not like '%返工%'
	and isnull(t7.fworktypeid,0)<>56
) t1 where 车间='包装' order by 日期,生产车间,拉线,产品编码

update #HPR_calc set 金额=isnull(纯PCS数量*单价,0)

select * from #HPR_calc

drop table #HPR_calc

set nocount off

