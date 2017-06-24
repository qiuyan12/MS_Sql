
select * from sheet17$

--更新纸箱
SELECT t7.finterid,t8.fentryid,t3.fnumber 编码,t3.fname 名称,t3.fmodel 规格型号,
t4.fnumber 子件编码,t4.fname 子件名称,t4.fmodel 子件规格型号,t6.fname 单位,
t8.fqty 单位用量,0 调整后用量,t2.fnumber,t2.fname,t1.*
--select distinct t3.fitemid into #acai
--update t9 set flastmoddate=getdate()
--update t8 set fitemid=t2.fitemid,fqty=t1.新用量,fauxqty=t1.新用量
from t_icitem t3  --套件
inner join icbom t7 on t3.fitemid=t7.fitemid
inner join icbomchild t8 on t7.finterid=t8.finterid
inner join t_icitem t4 on t8.fitemid=t4.fitemid --子件
inner join t_measureunit t6 on t6.FMeasureUnitID=t4.funitid
inner join sheet17$ t1 on t1.产品代码=t3.fnumber and t1.纸箱代码=t4.fnumber
inner join t_icitem t2 on t2.fnumber=t1.新纸箱代码
inner join t_item t5 on t5.fitemid=t2.fitemid
inner join t_baseproperty t9 on t9.fitemid=t3.fitemid

update t1 set fcheckerid= & iK3UserID & ,fstatus=1  
                                    FROM icbomchild t0 inner join icbom t1 on t0.fitemid=t1.fitemid  
                                    where t0.fitemid= & vItemId &  and t1.fstatus=1 
		
--标准装箱数
update t7 set F_110=round(cast(cast(1 as decimal(24,4))/t3.fqty as decimal(24,4)),0)
from t_icitem t2
inner join icbom t1 on t1.fitemid=t2.fitemid
inner join icbomchild t3 on t1.finterid=t3.finterid
inner join t_icitem t4 on t3.fitemid=t4.fitemid
inner join t_measureunit t5 on t5.fitemid=t4.funitid
inner join t_ICItemCustom AS t7 ON t2.FItemID = t7.FItemID
where t4.fnumber like '2.01.%' and t2.fitemid in (select fitemid from #acai)
	
--单个净重=除掉彩盒、除掉纸箱的重量 
update t4 set FNetWeight=t1.FNetWeight
from  t_icitem t2
inner join
(
	select t2.fitemid,sum(t4.FNetWeight*t3.fqty) FNetWeight --单个
	from t_icitem t2
	inner join icbom t1 on t1.fitemid=t2.fitemid
	inner join icbomchild t3 on t1.finterid=t3.finterid
	inner join t_icitem t4 on t3.fitemid=t4.fitemid
	inner join t_measureunit t5 on t5.fitemid=t4.funitid
	where t2.fitemid in (select fitemid from #acai)
	and left(t4.fnumber,4) not in ('2.01','2.02','2.03','2.04') 
	--and t2.fshortnumber='A00001'
	and t4.FNetWeight<>0
	group by t2.fitemid
) t1 on t1.fitemid=t2.fitemid
inner join t_ICItemCustom AS t7 ON t2.FItemID = t7.FItemID
inner join t_ICItemDesign AS t4 ON t2.FItemID = t4.FItemID	
	
--整箱净重(KG)	 -- 整箱净重=单个净重×装箱数
update t7 set F_112=t2.FNetWeight*t2.F_110
from t_icitem t2
inner join t_ICItemCustom AS t7 ON t2.FItemID = t7.FItemID
inner join t_ICItemDesign AS t4 ON t2.FItemID = t4.FItemID		
inner join icbom t1 on t1.fitemid=t2.fitemid
where t2.fitemid in (select fitemid from #acai)
				
--单个毛重=除掉纸箱的重量
update t4 set FGrossWeight=t1.FNoBoxWeight
from  t_icitem t2
inner join
(
	select t2.fitemid,sum((case when left(t4.fnumber,4) not in ('2.01') then t4.FNetWeight else 0 end)*t3.fqty) FNoBoxWeight, --单个
				sum((case when left(t4.fnumber,4) in ('2.01') then t4.FNetWeight else 0 end)) FBoxWeight --一个纸箱的重量
	from t_icitem t2
	inner join icbom t1 on t1.fitemid=t2.fitemid
	inner join icbomchild t3 on t1.finterid=t3.finterid
	inner join t_icitem t4 on t3.fitemid=t4.fitemid
	inner join t_measureunit t5 on t5.fitemid=t4.funitid
	where t2.fitemid in (select fitemid from #acai)
	and t4.FNetWeight<>0 
	--and t2.fshortnumber='A00001'
	group by t2.fitemid
) t1 on t1.fitemid=t2.fitemid
inner join t_ICItemCustom AS t7 ON t2.FItemID = t7.FItemID
inner join t_ICItemDesign AS t4 ON t2.FItemID = t4.FItemID
	
--整箱毛重(KG)	     --整箱毛重=单个毛重*装箱数+单个纸箱重量
update t7 set F_119=t2.FGrossWeight*t2.F_110+t1.FBoxWeight
from  t_icitem t2
inner join
(
	select t2.fitemid,sum((case when left(t4.fnumber,4) not in ('2.01') then t4.FNetWeight else 0 end)*t3.fqty) FNoBoxWeight, --单个
				sum((case when left(t4.fnumber,4) in ('2.01') then t4.FNetWeight else 0 end)) FBoxWeight --一个纸箱的重量
	from t_icitem t2
	inner join icbom t1 on t1.fitemid=t2.fitemid
	inner join icbomchild t3 on t1.finterid=t3.finterid
	inner join t_icitem t4 on t3.fitemid=t4.fitemid
	inner join t_measureunit t5 on t5.fitemid=t4.funitid
	where t2.fitemid in (select fitemid from #acai)
	and t4.FNetWeight<>0 
	--and t2.fshortnumber='A00001'
	group by t2.fitemid
) t1 on t1.fitemid=t2.fitemid
inner join t_ICItemCustom AS t7 ON t2.FItemID = t7.FItemID
inner join t_ICItemDesign AS t4 ON t2.FItemID = t4.FItemID	

--标准外盒尺寸(MM)	     
update t7 set F_111=substring(t4.fmodel,1,dbo.My_F_Charindex(t4.fmodel,'mm',1)-1)  
from t_icitem t2
inner join icbom t1 on t1.fitemid=t2.fitemid
inner join icbomchild t3 on t1.finterid=t3.finterid
inner join t_icitem t4 on t3.fitemid=t4.fitemid
inner join t_measureunit t5 on t5.fitemid=t4.funitid
inner join t_ICItemCustom AS t7 ON t2.FItemID = t7.FItemID
where t2.fitemid in (select fitemid from #acai)
and left(t4.fnumber,4) in ('2.02','2.03','2.04') and t4.fmodel like '%*%*%mm%'
	
select t7.fnumber, --先计算盒子体积
cast(1*
cast(cast(left(t7.F_111,CHARINDEX('*',t7.F_111)-1) as decimal(24,4))/10 as decimal(24,4))*
cast(cast(substring(t7.F_111,CHARINDEX('*',t7.F_111)+1,charindex('*',t7.F_111,charindex('*',t7.F_111)+1)-CHARINDEX('*',t7.F_111)-1) as decimal(24,4))/10 as decimal(24,4))*
cast(cast(substring(t7.F_111,charindex('*',t7.F_111,charindex('*',t7.F_111)+1)+1,len(t7.F_111)-charindex('*',t7.F_111,charindex('*',t7.F_111)+1)) as decimal(24,4))/10 as decimal(24,4)) as decimal(24,4)) 体积
into #data
from t_icitem t7
inner join icbom t1 on t1.fitemid=t7.fitemid
where t7.fitemid in (select fitemid from #acai)
and t7.F_111 like '%*%*%' and t7.F_111 not like '%0*0*0%'

--外盒尺寸类别	  --按体积所属范围更新 大、中、小         
update t7 set F_103= (case when t1.体积<=8000 then 395 when t1.体积>8000 and t1.体积<=13000 then 394 when t1.体积>13000 then 393 end)           
from #data t1
inner join t_icitem t2 on t1.fnumber=t2.fnumber
inner join t_ICItemCustom AS t7 ON t2.FItemID = t7.FItemID
	
select t2.fnumber,t2.fname,t2.fmodel,
t4.fnumber fchildnumber,t4.fname fchildname,t4.fmodel fchildmodel,
substring(t4.fmodel,1,dbo.My_F_Charindex(t4.fmodel,'cm',1)-1) fsize,t3.fqty
into #bata
from t_icitem t2
inner join icbom t1 on t1.fitemid=t2.fitemid
inner join icbomchild t3 on t1.finterid=t3.finterid
inner join t_icitem t4 on t3.fitemid=t4.fitemid
inner join t_measureunit t5 on t5.fitemid=t4.funitid
where t2.fitemid in (select fitemid from #acai)
and t4.fnumber like '2.01.%' and t4.fmodel like '%*%*%cm%'
	
select t1.fnumber,cast(cast(cast(substring(t1.fsize,1,dbo.My_F_CharIndex(t1.fsize,'*',1)-1) as decimal(24,4))*10 as int) as varchar)+'*'+
cast(cast(cast(substring(t1.fsize,dbo.My_F_CharIndex(t1.fsize,'*',1)+1,(dbo.My_F_CharIndex(t1.fsize,'*',2)-dbo.My_F_CharIndex(t1.fsize,'*',1)-1)) as decimal(24,4))*10 as int) as varchar)+'*'+
cast(cast(cast(substring(t1.fsize,dbo.My_F_CharIndex(t1.fsize,'*',2)+1,len(t1.fsize)-(dbo.My_F_CharIndex(t1.fsize,'*',2)-1))  as decimal(24,4))*10 as int) as varchar) fsize ,
cast(cast(cast(substring(t1.fsize,1,dbo.My_F_CharIndex(t1.fsize,'*',1)-1) as decimal(24,4))*10 as int) as varchar) flength,
cast(cast(cast(substring(t1.fsize,dbo.My_F_CharIndex(t1.fsize,'*',1)+1,(dbo.My_F_CharIndex(t1.fsize,'*',2)-dbo.My_F_CharIndex(t1.fsize,'*',1)-1)) as decimal(24,4))*10 as int) as varchar) fwidth,
cast(cast(cast(substring(t1.fsize,dbo.My_F_CharIndex(t1.fsize,'*',2)+1,len(t1.fsize)-(dbo.My_F_CharIndex(t1.fsize,'*',2)-1))  as decimal(24,4))*10 as int) as varchar) fheight 
into #size
from #bata t1
inner join t_icitem t4 on t1.fnumber=t4.fnumber

--select * from #size

--标准外箱尺寸(MM)	     
update t7 set F_109=t1.fsize
from #size t1
inner join t_icitem t4 on t1.fnumber=t4.fnumber
inner join t_ICItemCustom AS t7 ON t4.FItemID = t7.FItemID
inner join t_ICItemDesign t2 on t2.fitemid=t4.fitemid

update t2 set FLength=t1.FLength, FWidth=t1.FWidth, FHeight=t1.FHeight
from #size t1
inner join t_icitem t4 on t1.fnumber=t4.fnumber
inner join t_ICItemCustom AS t7 ON t4.FItemID = t7.FItemID
inner join t_ICItemDesign t2 on t2.fitemid=t4.fitemid	
	
update t6 set flastmoddate=getdate()
from t_icitem t1 
inner join t_baseproperty t6 on t6.fitemid=t1.fitemid
where t1.fitemid in (select fitemid from #acai)

----主供应商
--update t7 set F_117=t4.F_117
--from t_icitem t2
--inner join icbom t1 on t1.fitemid=t2.fitemid
--inner join icbomchild t3 on t1.finterid=t3.finterid
--inner join t_icitem t4 on t3.fitemid=t4.fitemid
--inner join t_ICItemCustom AS t7 ON t4.FItemID = t7.FItemID
--where left(t4.fnumber,1) in ('7','8') 
--and left(t2.fnumber,1) in (select fitemtype from v_myitemtype where ftype=0)
		
drop table #data	
drop table #bata
drop table #size
