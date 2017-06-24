

--库存状态表--*****
IF not EXISTS (select * from sysobjects where name='My_t_RepAlsStockStatus' and xtype='u')  --drop  Table My_t_RepAlsStockStatus
begin
	create table My_t_RepAlsStockStatus(frunid int,fitemid int,finvqty decimal(24,4) default 0,fwillinqty decimal(24,4) default 0,
	                                    fwilloutqty decimal(24,4) default 0,fendqty decimal(24,4) default 0,
	                                    fremainqty decimal(24,4) default 0)
end

go

--替换表--*****
IF not EXISTS (select * from sysobjects where name='My_t_RepAlsItemReplace' and xtype='u')  --drop  Table My_t_RepAlsItemReplace
begin
	create table My_t_RepAlsItemReplace(frunid int,fproductid int,fitemid int,frepitemid int,forder int) --1 外购  3 委外
end

go

        
--结果--*****
IF not EXISTS (select * from sysobjects where name='My_t_RepAlsRoughNeedSource' and xtype='u')  --drop  Table My_t_RepAlsRoughNeedSource
begin
	create table My_t_RepAlsRoughNeedSource(findex int identity(1,1),frunid int,ftrantype int,
	finterid int,fentryid int,fitemid int,fistop bit default 0,fproductid int,ficmointerid int,fcostobjid int,
	fqtymust decimal(24,2)/*应发数*/,fstockqty decimal(24,2)/*已领数*/,fisreplace bit default 0,
	fqty decimal(24,2)/*未发数*/,frepitemid int default 0/*替换物料*/,frepqty decimal(24,2) default 0/*替换数量*/,
	fwillinqty decimal(24,2) default 0,finvqty decimal(24,2) default 0,fcanuseqty decimal(24,2) default 0/*预计可用库存*/,
	fassignqty decimal(24,2) default 0/*分配数*/,fremainqty decimal(24,2) default 0/*剩余数*/,
	foweqty decimal(24,2) default 0/*欠数*/,fneeddate datetime)  --
end

go
     

--预计入库--*****
IF not EXISTS (select * from sysobjects where name='My_t_RepAlsWillInStock' and xtype='u')  --drop  Table My_t_RepAlsWillInStock
begin
	create table My_t_RepAlsWillInStock(fdate datetime,frunid int,ftrantype int,finterid int ,fentryid int,fitemid int,fqty decimal(24,2)) --1 外购  3 委外
end

go

--预计出库--*****
IF not EXISTS (select * from sysobjects where name='My_t_RepAlsWillOutStock' and xtype='u')  --drop  Table My_t_RepAlsWillOutStock
begin
	create table My_t_RepAlsWillOutStock(fdate datetime,frunid int,ftrantype int,finterid int ,fentryid int,
	fitemid int,fqtymust decimal(24,2),fstockqty decimal(24,2),fqty decimal(24,2)) --1 外购  3 委外
end

go

           
--库存--*****
IF not EXISTS (select * from sysobjects where name='My_t_RepAlsStock' and xtype='u')  --drop  Table My_t_RepAlsStock
begin
	create table My_t_RepAlsStock(frunid int,fstockid int,fitemid int,fqty decimal(24,2)) 
end

go


--计算信息--*****
IF not EXISTS (select * from sysobjects where name='My_t_RepAls' and xtype='u')  --drop  Table My_t_RepAls
begin
	create table My_t_RepAls(
	ftrantype int ,
	frunid int,
	fstatus int,
	fbilltime datetime,
	fbillno varchar(20),
	fuserid int,
	fcheckerid int,
	fcheckdate datetime,
	fchecktime datetime,
	fdate datetime,
	fempid int,
	fdeptid int,ftype int default 40043,--40043 常规物料 40044 包材物料
	)
end

go


IF EXISTS (select * from sysobjects where name='my_v_RepAlsReplace' and xtype='v')  drop  view my_v_RepAlsReplace

go

create view my_v_RepAlsReplace 
as

select t1.frunid 运算编号,t3.fnumber 产品编码,t3.fname 产品名称,t3.fmodel 产品规格型号, 
        t5.fnumber 物料编码,t5.fname 物料名称,t5.fmodel 物料规格型号,
        t23.fnumber 替换物料编码,t23.fname 替换物料名称,t23.fmodel 替换物料规格型号
        from My_t_RepAlsItemReplace t1 
        inner join t_icitem t3 on t1.fproductid=t3.fitemid  
        inner join t_icitem t5 on t5.fitemid=t1.fitemid  
        inner join t_icitem t23 on t23.fitemid=t1.frepitemid
        inner join t_measureunit t6 on t5.funitid=t6.fitemid  
        left join t_SubMessage t13 on t13.finterid=t5.F_114 and t13.ftypeid=10003  
        left join t_SubMessage t14 on t14.finterid=t5.ftypeid and t14.ftypeid=504  
        left join t_SubMessage t17 on t17.finterid=t5.F_115 and t17.ftypeid=10002 
go       


IF EXISTS (select * from sysobjects where name='my_v_RepAlsResult' and xtype='v')  drop  view my_v_RepAlsResult

go

create view my_v_RepAlsResult 
as

select t1.frunid 运算编号,t22.fbillno 任务单编号,t3.fnumber 产品编码,t3.fname 产品名称,t3.fmodel 产品规格型号, 
        t5.fnumber 物料编码,t5.fname 物料名称,t5.fmodel 物料规格型号,t6.fname 单位,
        t1.fqtymust 应发数,t1.fstockqty 已发数,t1.fqty 未发量,
        t1.fwillinqty 预计入库,t1.finvqty 库存,t1.fcanuseqty 预计可用库存,
        t1.fassignqty 分配数,t1.fremainqty 剩余数,t1.foweqty 欠数,
        t23.fnumber 替换物料编码,t23.fname 替换物料名称,t23.fmodel 替换物料规格型号,t1.frepqty 替换数量,
        t13.fname 仓管员,t14.fname 物料类别,t17.fname 倒冲,'' 备注  
        from My_t_RepAlsRoughNeedSource t1
        --inner join ppbomentry t20 on t20.finterid=t1.finterid and t20.fentryid=t1.fentryid
        --inner join ppbom t21 on t20.finterid=t21.finterid
        inner join icmo t22 on t1.ficmointerid=t22.finterid
        left join seorderentry t2 on t22.forderinterid=t2.finterid and t22.fsourceentryid=t2.fentryid  
        left join seorder t4 on t4.finterid=t2.finterid  
        inner join t_icitem t3 on t3.fitemid=t22.fitemid  
        inner join t_icitem t5 on t5.fitemid=t1.fitemid  
        inner join t_icitem t23 on t23.fitemid=t1.frepitemid
        inner join t_measureunit t6 on t5.funitid=t6.fitemid  
        left join t_SubMessage t13 on t13.finterid=t5.F_114 and t13.ftypeid=10003  
        left join t_SubMessage t14 on t14.finterid=t5.ftypeid and t14.ftypeid=504  
        left join t_SubMessage t17 on t17.finterid=t5.F_115 and t17.ftypeid=10002 

go            
       

--*****select * from my_v_RepAlsInfo
IF EXISTS (select * from sysobjects where name='my_v_RepAlsInfo' and xtype='v')  drop  view my_v_RepAlsInfo

go

create view my_v_RepAlsInfo 
as

select --fbillno 计算编号,--暂不使用,直接用内码作为计算编号
t1.frunid 计算编号,t1.fdate 计算日期,t1.fbilltime 计算时间,t2.fname 计算用户,
case when t1.ftrantype=0 then '成品' when t1.ftrantype=1 then '半成品' when t1.ftrantype=2 then '常规物料' 
     when t1.ftrantype=3 then '包材' end 计算类型,
(case when isnull(t1.fstatus,0)=0 then '' else 'Y' end) 审核,isnull(t3.fname,'') 审核人,isnull(t1.fcheckdate,Null) 审核日期
from My_t_RepAls t1 
inner join t_user t2 on t1.fuserid=t2.fuserid
left join t_user t3 on t1.fcheckerid=t3.fuserid and t3.fuserid<>0

go

IF EXISTS (select * from sysobjects where name='my_v_RepAlsWillOutStock' and xtype='v')  drop  view my_v_RepAlsWillOutStock

go

create view my_v_RepAlsWillOutStock 
as

select t1.frunid 运算编号,t22.fbillno 任务单编号,t3.fnumber 产品编码,t3.fname 产品名称,t3.fmodel 产品规格型号, 
        t5.fnumber 物料编码,t5.fname 物料名称,t5.fmodel 物料规格型号,t6.fname 单位,t1.fqtymust 应发数,
        t1.fstockqty 已发数,t1.fqty 数量,t13.fname 仓管员,t14.fname 物料类别,t17.fname 倒冲,'' 备注  
        from My_t_RepAlsWillOutStock t1
        inner join ppbomentry t20 on t20.finterid=t1.finterid and t20.fentryid=t1.fentryid
        inner join ppbom t21 on t20.finterid=t21.finterid
        inner join icmo t22 on t21.ficmointerid=t22.finterid
        left join seorderentry t2 on t22.forderinterid=t2.finterid and t22.fsourceentryid=t2.fentryid  
        left join seorder t4 on t4.finterid=t2.finterid  
        inner join t_icitem t3 on t3.fitemid=t22.fitemid  
        inner join t_icitem t5 on t5.fitemid=t20.fitemid  
        inner join t_measureunit t6 on t5.funitid=t6.fitemid  
        left join t_SubMessage t13 on t13.finterid=t5.F_114 and t13.ftypeid=10003  
        left join t_SubMessage t14 on t14.finterid=t5.ftypeid and t14.ftypeid=504  
        left join t_SubMessage t17 on t17.finterid=t5.F_115 and t17.ftypeid=10002 

go
            
--*****

IF EXISTS (select * from sysobjects where name='my_v_RepAlsWillInStock ' and xtype='v')  drop  view my_v_RepAlsWillInStock

go

create view my_v_RepAlsWillInStock 
as

select t1.frunid 运算编号,'收料通知单' 单据类型,t1.fdate 日期,t2.fbillno 单据编号,t5.fnumber 厂商编号,t5.FShortName 厂商名称,  
t4.fnumber 物料编码,t4.fname 名称,t4.fmodel 规格型号,t6.fname 单位,t1.fqty 数量,isnull(t13.fname,'') 仓管员,isnull(t14.fname,'') 物料类别,isnull(t17.fname,'') 倒冲  
from My_t_RepAlsWillInStock t1  
inner join poinstock t2 on t1.ftrantype=72 and t1.finterid=t2.finterid  
inner join t_supplier t5 on t5.fitemid=t2.fsupplyid  
inner join t_icitem t4 on t4.fitemid=t1.fitemid  
inner join t_measureunit t6 on t4.funitid=t6.fitemid  
left join t_SubMessage t13 on t13.finterid=t4.F_114 and t13.ftypeid=10003  
left join t_SubMessage t14 on t14.finterid=t4.ftypeid and t14.ftypeid=504  
left join t_SubMessage t17 on t17.finterid=t4.F_115 and t17.ftypeid=10002  
union all 
select t1.frunid 运算编号,'采购订单' 单据类型,t1.fdate 日期,t2.fbillno 单据编号,t5.fnumber 厂商编号,t5.FShortName 厂商名称,  
t4.fnumber 物料编码,t4.fname 名称,t4.fmodel 规格型号,t6.fname 单位,t1.fqty 数量,isnull(t13.fname,'') 仓管员,isnull(t14.fname,'') 物料类别,isnull(t17.fname,'') 倒冲
from My_t_RepAlsWillInStock t1  
inner join poorder t2 on t1.ftrantype=71 and t1.finterid=t2.finterid  
inner join t_supplier t5 on t5.fitemid=t2.fsupplyid  
inner join t_icitem t4 on t4.fitemid=t1.fitemid  
inner join t_measureunit t6 on t4.funitid=t6.fitemid  
left join t_SubMessage t13 on t13.finterid=t4.F_114 and t13.ftypeid=10003  
left join t_SubMessage t14 on t14.finterid=t4.ftypeid and t14.ftypeid=504  
left join t_SubMessage t17 on t17.finterid=t4.F_115 and t17.ftypeid=10002 
union all 
select t1.frunid 运算编号,'采购申请单' 单据类型,t1.fdate 日期,t2.fbillno 单据编号,'' 厂商编号,'' 厂商名称,  
t4.fnumber 物料编码,t4.fname 名称,t4.fmodel 规格型号,t6.fname 单位,t1.fqty 数量,isnull(t13.fname,'') 仓管员,isnull(t14.fname,'') 物料类别,isnull(t17.fname,'') 倒冲
from My_t_RepAlsWillInStock t1  
inner join porequest t2 on t1.ftrantype=70 and t1.finterid=t2.finterid  
inner join t_icitem t4 on t4.fitemid=t1.fitemid  
inner join t_measureunit t6 on t4.funitid=t6.fitemid  
left join t_SubMessage t13 on t13.finterid=t4.F_114 and t13.ftypeid=10003  
left join t_SubMessage t14 on t14.finterid=t4.ftypeid and t14.ftypeid=504  
left join t_SubMessage t17 on t17.finterid=t4.F_115 and t17.ftypeid=10002   
union all 
select t1.frunid 运算编号,'生产任务单' 单据类型,t1.fdate 日期,t2.fbillno 单据编号,t5.fnumber 厂商编号,t5.FName 厂商名称,  
t4.fnumber 物料编码,t4.fname 名称,t4.fmodel 规格型号,t6.fname 单位,t1.fqty 数量,isnull(t13.fname,'') 仓管员,isnull(t14.fname,'') 物料类别,isnull(t17.fname,'') 倒冲
from My_t_RepAlsWillInStock t1  
inner join icmo t2 on t1.ftrantype=85 and t1.finterid=t2.finterid  
inner join t_icitem t4 on t4.fitemid=t1.fitemid  
inner join t_department t5 on t5.fitemid=t2.fworkshop  
inner join t_measureunit t6 on t4.funitid=t6.fitemid  
left join t_SubMessage t13 on t13.finterid=t4.F_114 and t13.ftypeid=10003  
left join t_SubMessage t14 on t14.finterid=t4.ftypeid and t14.ftypeid=504  
left join t_SubMessage t17 on t17.finterid=t4.F_115 and t17.ftypeid=10002 
union all 
select t1.frunid 运算编号,'外购入库单' 单据类型,t1.fdate 日期,t2.fbillno 单据编号,t5.fnumber 厂商编号,t5.FShortName 厂商名称,  
t4.fnumber 物料编码,t4.fname 名称,t4.fmodel 规格型号,t6.fname 单位,t1.fqty 数量,isnull(t13.fname,'') 仓管员,isnull(t14.fname,'') 物料类别,isnull(t17.fname,'') 倒冲
from My_t_RepAlsWillInStock t1  
inner join icstockbill t2 on t1.ftrantype=1 and t1.finterid=t2.finterid  
inner join t_icitem t4 on t4.fitemid=t1.fitemid  
inner join t_supplier t5 on t5.fitemid=t2.fsupplyid  
inner join t_measureunit t6 on t4.funitid=t6.fitemid  
left join t_SubMessage t13 on t13.finterid=t4.F_114 and t13.ftypeid=10003  
left join t_SubMessage t14 on t14.finterid=t4.ftypeid and t14.ftypeid=504  
left join t_SubMessage t17 on t17.finterid=t4.F_115 and t17.ftypeid=10002   
union all 
select t1.frunid 运算编号,'塑胶子件收料申请单' 单据类型,t1.fdate 日期,t2.fbillno 单据编号,t5.fnumber 厂商编号,t5.FShortName 厂商名称,  
t4.fnumber 物料编码,t4.fname 名称,t4.fmodel 规格型号,t6.fname 单位,t1.fqty 数量,isnull(t13.fname,'') 仓管员,isnull(t14.fname,'') 物料类别,isnull(t17.fname,'') 倒冲
from My_t_RepAlsWillInStock t1  
inner join t_BosPlasticPoInStock t2 on t1.ftrantype=200000022 and t1.finterid=t2.fid  
inner join t_icitem t4 on t4.fitemid=t1.fitemid  
inner join t_supplier t5 on t5.fitemid=t2.fsupplyid  
inner join t_measureunit t6 on t4.funitid=t6.fitemid  
left join t_SubMessage t13 on t13.finterid=t4.F_114 and t13.ftypeid=10003  
left join t_SubMessage t14 on t14.finterid=t4.ftypeid and t14.ftypeid=504  
left join t_SubMessage t17 on t17.finterid=t4.F_115 and t17.ftypeid=10002 

go

--My_p_RepAls 16394,0,'',0

IF EXISTS (select * from sysobjects where name='My_p_RepAls' and xtype='p')  drop  procedure My_p_RepAls
go

--@fitemtype  100 全部 0 成品 1 半成品  2 常规物料 3 包材  @ftype 0 常规运算 1 按单运算
create procedure [dbo].My_p_RepAls (@fuserid int,@frunid int,@fbillno varchar(20),@fitemtype int)  --,@ftype int
 
as
set nocount on

--1 该物料有未发数
--2 该物料的可用库存不够发
--3 该物料有可代替其的物料
--4 可代替其的物料扣除掉自己所需库存外,还有剩余的库存	

--------------------------------------------------------------------------------------------------------------------------------------------------
--表一  物料替换表
--------------------------------------------------------------------------------------------------------------------------------------------------
--产品   物料   替换物料       替换物料库存
--------------------------------------------------------------------------------------------------------------------------------------------------
--A002   1001   1002           90
--------------------------------------------------------------------------------------------------------------------------------------------------
--A002   1001   1003           100
--------------------------------------------------------------------------------------------------------------------------------------------------

--表二  投料单
--------------------------------------------------------------------------------------------------------------------------------------------------
--行号 产品   物料   应发数 已发数 未发数   预计入库   库存  预计可用库存     备注
--------------------------------------------------------------------------------------------------------------------------------------------------
--1    A001   1001   100    20     80       100        60    160              --A001+1001虽然没有物料替换组合，但仍然要取出
--------------------------------------------------------------------------------------------------------------------------------------------------
--2    A002   1001   300    180    120                                        
--------------------------------------------------------------------------------------------------------------------------------------------------
--3    A002   1001   100    40     60                                         
--------------------------------------------------------------------------------------------------------------------------------------------------

--表三  投料单进行库存分配
--------------------------------------------------------------------------------------------------------------------------------------------------
--行号 产品   物料   应发数 已发数 未发数   预计入库   库存  预计可用库存     分配数     库存剩余   欠数     备注
--------------------------------------------------------------------------------------------------------------------------------------------------
--1    A001   1001   100    20     80       100        60    160              80         80         0        
--------------------------------------------------------------------------------------------------------------------------------------------------
--2    A002   1001   300    180    120                                        80         0          40     
--------------------------------------------------------------------------------------------------------------------------------------------------
--3    A002   1001   100    40     60                                         0          0          60     
--------------------------------------------------------------------------------------------------------------------------------------------------


--表四 按照欠数进行循环--有替换的则不再进行替换
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--行号 源行号 产品   物料   应发数 已发数 未发数   预计入库   库存  预计可用库存     分配数     剩余   欠数   替换物料   替换数量  是否执行替换   备注
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--1    1      A001   1001   100    20     80       100        60    160              80         80     0 
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------     
--2    2      A002   1001   300    180    120                                        80         0      40     1002       40        Y
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--3    3      A002   1001   100    40     60                                         0          0      60     1002       50        Y
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--4    3      A002   1001   10     0      10                                         0          0      10     1003       10        Y              应发数=未发数=欠数=上一行欠数-上一行替换数;其他=0
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------------------------------------------------------
--表五
--------------------------------------------------------------------------------------------------------------------------------------------------
--行号 源行号 产品   物料   应发数 已发数 未发数     原物料    备注
--------------------------------------------------------------------------------------------------------------------------------------------------
--1    1      A001   1001   100    20     80       
--------------------------------------------------------------------------------------------------------------------------------------------------            
--2    2      A002   1001   260    180    80                   已发数>0 & 欠数<=替换数;处理已发数;应发数=原应发数-替换数;已发数=原应发数;未发数=应发数-已发数       
--------------------------------------------------------------------------------------------------------------------------------------------------                     
--3    2      A002   1002   40     0      40         1001      已发数>0 & 欠数<=替换数;处理替换数;应发数=替换数;已发数=0;未发数=应发数-已发数                
--------------------------------------------------------------------------------------------------------------------------------------------------                                        
--4    3      A002   1001   40     40     0                    已发数>0 & 欠数>替换数;处理已发数;应发数=已发数;已发数=原已发数;未发数=应发数-已发数                                    
--------------------------------------------------------------------------------------------------------------------------------------------------
--5    3      A002   1002   50     0      50         1001      已发数>0 & 欠数>替换数;处理替换数;应发数=替换数;已发数=0;未发数=应发数-已发数   
--------------------------------------------------------------------------------------------------------------------------------------------------
--6    4      A002   1003   10     0      10         1001      已发数=0 & 欠数<=替换数
--------------------------------------------------------------------------------------------------------------------------------------------------

if @frunid=0
	exec My_p_GetBillNo 50000011,'My_t_RepAls',@frunid output, @fbillno output
	
declare @fdate datetime
select @fdate=replace(convert(varchar(10),getdate(),111),'/','-')  --制单日期

--保存运算信息
if not exists(select 1 from My_t_RepAls where frunid=@frunid)
begin
	insert into My_t_RepAls(ftrantype, fbillno, frunid, fuserid, fbilltime,fdate) 
	values(                 @fitemtype,@fbillno,@frunid,@fuserid,getdate(),@fdate)
end


--数据源--先满足1,3条件;后面再对此数据进行处理以满足2,4条件;-------------------
insert into My_t_RepAlsRoughNeedSource(fcostobjid,   ficmointerid,fproductid,fneeddate,         ftrantype,frunid, finterid,   fentryid,   fitemid,   fqtymust,   fstockqty,   fqty)
select                                 t5.fcostobjid,t5.finterid, t5.fitemid,t5.fplancommitdate,88,       @frunid,t3.finterid,t3.fentryid,t3.fitemid,t3.fqtymust,t3.fstockqty,(t3.fqtymust-t3.fstockqty)
from icmo t5 
inner join ppbom t2 on t5.finterid=t2.ficmointerid
inner join ppbomentry t3 on t2.finterid=t3.finterid
inner join t_icitem t4 on t3.fitemid=t4.fitemid --子项
inner join t_icitem t8 on t5.fitemid=t8.fitemid --父项
where t5.fstatus in (1,2,5) and (t3.fqtymust-t3.fstockqty)>0 --and isnull(t3.folditemid,0)=0  --还没有替换过
and exists(select 1 from t_BOSICItemReplaceEntry where fitemid=t3.fitemid)
--and exists(select 1 from t_BOSICItemReplaceEntry where fproductid=t5.fitemid and fitemid=t3.fitemid)
--and (t3.fitemid in (select fitemid from #replace) or t2.fitemid in (select FRepItemId from #replace))
order by t3.fitemid

--create table #replace(fproductid int,fitemid int,fstockqty decimal(24,4) default 0,fwillinqty decimal(24,4) default 0,fwilloutqty decimal(24,4) default 0,fendqty decimal(24,4) default 0,
--frepitemid int,frepstockqty decimal(24,4) default 0,frepwillinqty decimal(24,4) default 0,frepwilloutqty decimal(24,4) default 0,frependqty decimal(24,4) default 0,forder int)

--insert into #replace(fproductid,fitemid,FRepItemId,forder)
--select distinct t2.fproductid,t2.fitemid,t2.FRepItemId,t2.FOrder
--from My_t_RepAlsRoughNeedSource t1
--inner join t_BOSICItemReplaceEntry t2 on t1.fproductid=t2.fproductid and t1.fitemid=t2.fitemid

--数据源涉及到的替换关系表
insert into My_t_RepAlsItemReplace(frunid, fproductid,   fitemid,   FRepItemId,   forder)
select        distinct             @frunid,t2.fproductid,t2.fitemid,t2.FRepItemId,t2.FOrder
from My_t_RepAlsRoughNeedSource t1
inner join t_BOSICItemReplaceEntry t2 on t1.fproductid=t2.fproductid and t1.fitemid=t2.fitemid
where t1.frunid=@frunid

--物料和替换物料的库存状态
insert into My_t_RepAlsStockStatus(frunid,fitemid) 
select distinct @frunid,t1.fitemid
from
(
	select distinct fitemid from My_t_RepAlsItemReplace where frunid=@frunid
	union all
	select distinct FRepItemId from My_t_RepAlsItemReplace where frunid=@frunid
) t1


--预计出库
--create table #willout(fitemid int,fqty decimal(24,4))

--insert into #willout(fitemid,fqty)
--select t3.fitemid,(t3.fqtymust-t3.fstockqty) fqty

----预计出库--随单出货外购件
--insert into #willout(fitemid,fqty)
--select t4.fitemid,t4.fqty-isnull(t4.fstockqty,0)
--from seorderentry t4 
--inner join seorder t5  on t5.finterid=t4.finterid
--inner join t_icitem t8 on t8.fitemid=t4.fitemid
--where t8.ferpclsid=1 and t4.fmrpclosed<>1 and (t5.fstatus>0 or isnull(t5.FMultiCheckLevel1,0)>0) 
--and (t4.fitemid in (select fitemid from #replace) or t2.fitemid in (select FRepItemId from #replace))

--My_t_RepAlsRoughNeedSource和My_t_RepAlsWillOutStock的数据意义是不一样的，这里只是计算涉及到的物料和替换物料的所有未出库数
insert into My_t_RepAlsWillOutStock(fdate,             ftrantype,frunid, finterid,   fentryid,   fitemid,   fqtymust,   fstockqty,    fqty)
select                              t5.fplancommitdate,88,       @frunid,t3.finterid,t3.fentryid,t3.fitemid,t3.fqtymust,t3.fstockqty,(t3.fqtymust-t3.fstockqty)
from icmo t5 
inner join ppbom t2 on t5.finterid=t2.ficmointerid
inner join ppbomentry t3 on t2.finterid=t3.finterid
inner join t_icitem t4 on t3.fitemid=t4.fitemid --子项
inner join t_icitem t8 on t5.fitemid=t8.fitemid --父项
where t5.fstatus in (1,2,5) and (t3.fqtymust-t3.fstockqty)>0 --and isnull(t3.folditemid,0)=0  --还没有替换过
and t3.fitemid in (select fitemid from My_t_RepAlsStockStatus where frunid=@frunid)


--预计入库
--create table #willin(fitemid int,fqty decimal(24,4))

----预计入库--(采购申请单--未关闭--未关联数)--逻辑检查未关闭则中断MRP运算，因为采购申请单的到货日期是未确认的--此处开放为订单模拟时候用
--insert into #willin(fitemid,fqty)
--select t2.fitemid,t2.fqty-t2.fcommitqty

insert into My_t_RepAlsWillInStock(fdate,        frunid, ftrantype,finterid,   fentryid,   fitemid,   fqty)
select                             t2.FFetchTime,@frunid,70,       t2.finterid,t2.fentryid,t2.fitemid,t2.fqty-t2.fcommitqty
from porequest t1
inner join porequestentry t2 on t1.finterid=t2.finterid
inner join t_icitem t3 on t2.fitemid=t3.fitemid
inner join t_department t4 on t1.fdeptid=t4.fitemid
where --t1.fstatus>0 and 
t1.fstatus<>3 and isnull(t2.fmrpclosed,0)<>1
--and t4.fnumber not like '08.11.%'
and t3.ferpclsid in (1)
--and (t3.fnumber like 'H.%' or t3.fnumber like 'K.%' or t3.fnumber like 'M.%' or t3.fnumber like 'N.%')
and (t2.fqty-t2.fcommitqty)>0 
and t2.fitemid in (select fitemid from My_t_RepAlsStockStatus where frunid=@frunid)

--预计入库(未审核的外购入库单)
--insert into #willin(fitemid,fqty)
--select t2.fitemid,t2.fqty

insert into My_t_RepAlsWillInStock(fdate,   frunid, ftrantype,finterid,   fentryid,   fitemid,   fqty)
select                             t1.fdate,@frunid,1,        t2.finterid,t2.fentryid,t2.fitemid,t2.fqty
from icstockbill t1
inner join icstockbillentry t2 on t1.finterid=t2.finterid
inner join t_icitem t3 on t2.fitemid=t3.fitemid
inner join t_department t4 on t1.fdeptid=t4.fitemid
where t1.fstatus=0 and t2.FSourceTranType=72 
--and t4.fnumber not like '08.11.%'
and t2.fitemid in (select fitemid from My_t_RepAlsStockStatus where frunid=@frunid)

--预计入库(收料通知单--未关闭--未关联数)
--insert into #willin(fitemid,fqty)
--select t2.fitemid,t2.fqty-t2.fcommitqty-t2.fbackqty

insert into My_t_RepAlsWillInStock(fdate,   frunid,  ftrantype,  finterid,   fentryid,   fitemid,   fqty)
select                             t1.fdate,@frunid, 72,         t2.finterid,t2.fentryid,t2.fitemid,t2.fqty-t2.fcommitqty-t2.fbackqty
from poinstock t1
inner join poinstockentry t2 on t1.finterid=t2.finterid
inner join t_icitem t3 on t2.fitemid=t3.fitemid
inner join t_department t4 on t1.fdeptid=t4.fitemid
where t1.fstatus<>3 --已经审核的才纳入????
and t2.fqty>(t2.fcommitqty+t2.fbackqty)
--and t4.fnumber not like '08.11.%'
and t2.fitemid in (select fitemid from My_t_RepAlsStockStatus where frunid=@frunid)

--预计入库(塑胶子件收料申请单--未关闭--未关联数)
--insert into #willin(fitemid,fqty)
--select t2.fitemid,t2.fqty-t2.fcommitqty

insert into My_t_RepAlsWillInStock(fdate,   frunid,  ftrantype,  finterid,fentryid,   fitemid,   fqty)
select                             t1.fdate,@frunid, 200000022,  t2.fid,  t2.fentryid,t2.fitemid,t2.fqty-t2.fcommitqty
from t_BOSPlasticPoInStock t1 
inner join t_BOSPlasticPoInStockEntry t2 on t1.fid=t2.fid
inner join t_icitem t3 on t2.fitemid=t3.fitemid
--inner join t_department t4 on t1.fdeptid=t4.fitemid
where isnull(t2.fmrpclosed,0)<>40019 --and t1.fstatus>0 
and (t2.fqty-t2.fcommitqty)>0
and t2.fitemid in (select fitemid from My_t_RepAlsStockStatus where frunid=@frunid)

--预计入库--生产任务单
--insert into #willin(fitemid,fqty)
--select t2.fitemid, t2.fqty-isnull(t2.fstockqty,0)

insert into My_t_RepAlsWillInStock(fdate,             frunid, ftrantype,finterid,   fentryid,   fitemid,   fqty)
select                             t2.fplancommitdate,@frunid,85,       t2.finterid,0,          t2.fitemid,t2.fqty-isnull(t2.fstockqty,0)
from icmo t2 
inner join t_icitem t3 on t2.fitemid=t3.fitemid
inner join t_department t4 on t2.fworkshop=t4.fitemid
where t2.fstatus>0 and t2.fstatus<>3
and (t2.fqty-isnull(t2.fstockqty,0))>0
--and t4.fnumber not like '08.11.%'
and t2.fitemid in (select fitemid from My_t_RepAlsStockStatus where frunid=@frunid)

--库存
--create table #stock(fitemid int,fqty decimal(24,4))

--insert into #stock(fitemid,fqty)
--select t1.fitemid,t1.fqty

insert into My_t_RepAlsStock(frunid,fitemid,fstockid,fqty)
select @frunid,t1.fitemid,t1.fstockid,t1.fqty
from icinventory t1
inner join t_ICItem t2 on t1.FItemID=t2.FItemID
inner join t_stock t3 on t3.fitemid=t1.fstockid
where --t2.ferpclsid in (1) and 
t1.fqty>0 --and t3.fname not like '%计划%' 
and t3.fname not like '%不良%' and t3.fname not like '%报废%'
--and t3.fnumber not like '11.%' 
--and (t2.fnumber like 'H.%' or t2.fnumber like 'K.%' or t2.fnumber like 'M.%' or t2.fnumber like 'N.%')
and t2.fitemid in (select fitemid from My_t_RepAlsStockStatus where frunid=@frunid)

--insert into #stock(fitemid,fqty)
--select t1.fitemid,t1.fqty

insert into My_t_RepAlsStock(frunid,fitemid,fstockid,fqty)
select @frunid,t1.fitemid,t1.fstockid,t1.fqty
from poinventory t1
inner join t_ICItem t2 on t1.FItemID=t2.FItemID
inner join t_stock t3 on t3.fitemid=t1.fstockid
where --t2.ferpclsid in (1) and 
t1.fqty>0 --and t3.fname not like '%计划%' 
and t3.fname not like '%不良%' and t3.fname not like '%报废%' and t3.fitemid=16483  --代管仓
--and t3.fnumber not like '11.%' 
--and (t2.fnumber like 'H.%' or t2.fnumber like 'K.%' or t2.fnumber like 'M.%' or t2.fnumber like 'N.%')
and t2.fitemid in (select fitemid from My_t_RepAlsStockStatus where frunid=@frunid)

--预计出库
update t1 set fwilloutqty=t2.fqty
from My_t_RepAlsStockStatus t1
inner join (select fitemid,sum(fqty) fqty from My_t_RepAlsWillOutStock where frunid=@frunid group by fitemid) t2 on t1.fitemid=t2.fitemid
where t1.frunid=@frunid

--update t1 set frepwilloutqty=t2.fqty
--from #replace t1
--inner join (select fitemid,sum(fqty) fqty from My_t_RepAlsRoughNeedSource group by fitemid) t2 on t1.frepitemid=t2.fitemid

--预计入库
update t1 set fwillinqty=t2.fqty
from My_t_RepAlsStockStatus t1
inner join (select fitemid,sum(fqty) fqty from My_t_RepAlsWillInStock where frunid=@frunid group by fitemid) t2 on t1.fitemid=t2.fitemid
where t1.frunid=@frunid

--update t1 set frepwillinqty=t2.fqty
--from #replace t1
--inner join (select fitemid,sum(fqty) fqty from My_t_RepAlsWillInStock group by fitemid) t2 on t1.frepitemid=t2.fitemid

--库存
update t1 set finvqty=t2.fqty
from My_t_RepAlsStockStatus t1
inner join (select fitemid,sum(fqty) fqty from My_t_RepAlsStock where frunid=@frunid group by fitemid) t2 on t1.fitemid=t2.fitemid
where t1.frunid=@frunid

--update t1 set frepstockqty=t2.fqty
--from #replace t1
--inner join (select fitemid,sum(fqty) fqty from My_t_RepAlsStock group by fitemid) t2 on t1.frepitemid=t2.fitemid

--剩余预计可用库存
update t1 set fendqty=finvqty+fwillinqty-fwilloutqty from My_t_RepAlsStockStatus t1 where t1.frunid=@frunid
update t1 set fremainqty=fendqty from My_t_RepAlsStockStatus t1 where t1.frunid=@frunid

--update #replace set frepqty=frepstockqty+frepwillinqty-frepwilloutqty

--delete from #replace where fendqty>0 --剩余库存够用
--delete from #replace where frependqty<=0 --替换物料剩余库存不够用

delete t1
from My_t_RepAlsItemReplace t1
inner join My_t_RepAlsStockStatus t2 on t1.fitemid=t2.fitemid and t2.frunid=@frunid
where t1.frunid=@frunid and t2.fendqty>0 --该物料剩余库存够用则去除,即使该物料有未发数和可替换其的物料

delete t1
from My_t_RepAlsItemReplace t1
inner join My_t_RepAlsStockStatus t2 on t1.frepitemid=t2.fitemid and t2.frunid=@frunid
where t1.frunid=@frunid and t2.fendqty<=0 --替换物料剩余库存不够用则去除

--只关注替换关系成立的数据源
delete t1
from My_t_RepAlsRoughNeedSource t1
where t1.frunid=@frunid 
and not exists(select 1 from My_t_RepAlsItemReplace where frunid=@frunid and fitemid=t1.fitemid)
--and not exists(select 1 from My_t_RepAlsItemReplace where frunid=@frunid and fproductid=t1.fproductid and fitemid=t1.fitemid)

--select t1.fsourceinterid finterid,t1.fsourceentryid fentryid,t1.fproductid,t1.fitemid,t1.fqty
--into #sourcedata 
--from My_t_RepAlsRoughNeedSource t1

--形成表二
update t1 set fwillinqty=t2.fwillinqty,finvqty=t2.finvqty,fcanuseqty=t2.fwillinqty+t2.finvqty,fistop=1
from My_t_RepAlsRoughNeedSource t1
inner join (select min(findex) findex from My_t_RepAlsRoughNeedSource where frunid=@frunid group by fitemid) t3 on t1.findex=t3.findex
inner join My_t_RepAlsStockStatus t2 on t1.fitemid=t2.fitemid and t2.frunid=@frunid
where t1.frunid=@frunid

--形成表三
--set @fentryid=0

declare @fminid int,@fmaxid int,@fentryminid int,@fentrymaxid int,@fpreitemid int,@fcanuseqty decimal(24,2)
declare @fproductid int,@fistop int,@fqty decimal(24,2) ,@fentryid int,@fitemid int, @fnewindex int
declare @frependqty decimal(24,2), @frepitemid decimal(24,2), @frepremainqty decimal(24,2), @foweqty decimal(24,2)
declare @finterid int, @findex int, @fassignqty decimal(24,2),@fremainqty decimal(24,2)

create table #Cursor(FID int identity(1,1),finterid int,fentryid int,fitemid int,FQty decimal(24,2),
fproductid int,fistop int,findex int, foweqty decimal(24,2))

create table #CursorEntry(FID int identity(1,1),finterid int,fentryid int,fitemid int,FQty decimal(24,2),frepitemid int)

select @fpreitemid=0,@fcanuseqty=0

truncate table #Cursor
insert into #Cursor(fproductid,finterid,fentryid,fitemid,fqty,fistop,findex)
select fproductid,finterid,fentryid,fitemid,fqty,fistop,findex
from My_t_RepAlsRoughNeedSource t1 
where t1.frunid=@frunid
order by t1.findex

select @fminid=0,@fmaxid=0
select @fminid=isnull(min(fid),0),@fmaxid=isnull(max(fid),0) from #Cursor

WHILE @fmaxid>0 and @fminid<=@fmaxid --@@FETCH_STATUS = 0  --先把可用库存按物料先分配下去
BEGIN 
	select @fproductid=fproductid,@finterid=finterid,@fentryid=fentryid,@fistop=fistop,@fqty=fqty,@findex=findex 
	from #Cursor where fid=@fminid

	if @fistop=1
	begin
		select @fcanuseqty=fcanuseqty from My_t_RepAlsRoughNeedSource t1 where t1.frunid=@frunid and findex=@findex
	end
	
	if @fcanuseqty>0
	begin
		if @fcanuseqty>=@fqty --库存够分配
		begin
			select @fassignqty=@fqty,@fremainqty=@fcanuseqty-@fqty,@foweqty=0
		end
		else
		begin
			select @fassignqty=@fcanuseqty,@fremainqty=0,@foweqty=@fqty-@fcanuseqty
		end
	end
	else
	begin
		select @fassignqty=0,@fremainqty=0,@foweqty=@fqty	
	end
	
	update t1 set fassignqty=@fassignqty,fremainqty=@fremainqty,foweqty=@foweqty
	from My_t_RepAlsRoughNeedSource t1 where t1.frunid=@frunid and t1.findex=@findex
					
	set @fcanuseqty=@fcanuseqty-@fqty
	set @fminid=@fminid+1
END

--形成表四 --此时My_t_RepAlsRoughNeedSource表中,finterid+fentryid 是唯一的
truncate table #Cursor
insert into #Cursor(fproductid,finterid,fentryid,fitemid,fqty,fistop,findex,foweqty)
select t1.fproductid,t1.finterid,t1.fentryid,t1.fitemid,t1.fqty,t1.fistop,t1.findex,t1.foweqty
from My_t_RepAlsRoughNeedSource t1 
inner join ppbomentry t2 on t1.finterid=t2.finterid and t1.fentryid=t2.fentryid
where t1.frunid=@frunid and t1.foweqty>0 --不欠数的则不考虑
and isnull(t2.folditemid,0)=0 and t2.fqty=0 --已经有替换的或者已经有关联领料单的则不考虑
order by t1.findex

select @fminid=0,@fmaxid=0
select @fminid=isnull(min(fid),0),@fmaxid=isnull(max(fid),0) from #Cursor

WHILE @fmaxid>0 and @fminid<=@fmaxid --@@FETCH_STATUS = 0  --先把可用库存按物料先分配下去
BEGIN 
	select @fproductid=fproductid,@finterid=finterid,@fentryid=fentryid,@fistop=fistop,@fqty=fqty,@findex=findex,
	@foweqty=foweqty,@fitemid=fitemid
	from #Cursor where fid=@fminid

	set @frependqty=0
	select @frepitemid=t1.frepitemid from My_t_RepAlsItemReplace t1	
	where frunid=@frunid and t1.fproductid=@fproductid and t1.fitemid=@fitemid
	select @frepremainqty=fremainqty from My_t_RepAlsStockStatus where frunid=@frunid and fitemid=@frepitemid  
		
	if @frepremainqty>0
	begin
		if @frepremainqty>=@foweqty
		begin
			update t1 set frepitemid=@frepitemid,frepqty=@foweqty 
			from My_t_RepAlsRoughNeedSource t1 
			where frunid=@frunid and findex=@findex
			
			update t1 set fremainqty=fremainqty-@foweqty
			from My_t_RepAlsStockStatus t1 where frunid=@frunid and fitemid=@frepitemid  
		end
		else
		begin
			update t1 set frepitemid=@frepitemid,frepqty=@frepremainqty 
			from My_t_RepAlsRoughNeedSource t1 
			where frunid=@frunid and findex=@findex
			
			update t1 set fremainqty=0
			from My_t_RepAlsStockStatus t1 where frunid=@frunid and fitemid=@frepitemid 
			 	
			--此时My_t_RepAlsRoughNeedSource 表中,finterid+fentryid 可能是有多条记录的
			select @fnewindex=isnull(max(findex),0)+1 from My_t_RepAlsRoughNeedSource 
			
			insert into My_t_RepAlsRoughNeedSource(ficmointerid,fcostobjid,fproductid,fneeddate,         ftrantype,frunid, finterid,   fentryid,  fitemid, fqtymust,                 fstockqty,  fqty,                     foweqty)
			select                                 ficmointerid,fcostobjid,fproductid,fneeddate,         ftrantype,frunid, finterid,   fentryid,  fitemid, (@foweqty-@frepremainqty),0,          (@foweqty-@frepremainqty),(@foweqty-@frepremainqty)			
			from My_t_RepAlsRoughNeedSource where frunid=@frunid and findex=@findex
			
			insert into #Cursor(fproductid,finterid,fentryid,fitemid,fqty,fistop,findex,foweqty)
			select t1.fproductid,t1.finterid,t1.fentryid,t1.fitemid,t1.fqty,t1.fistop,t1.findex,t1.foweqty
			from My_t_RepAlsRoughNeedSource t1 
			where t1.frunid=@frunid and t1.findex=@fnewindex
			
			set @fmaxid=@fmaxid+1
		end
	end
	
	set @fminid=@fminid+1
END

go


IF EXISTS (select * from sysobjects where name='My_p_RepAlsExe' and xtype='p')  drop  procedure My_p_RepAlsExe
go

create procedure [dbo].My_p_RepAlsExe (@fuserid int,@frunid int)  
 
as
set nocount on

declare @fminid int,@fmaxid int,@fentryminid int,@fentrymaxid int,@fpreitemid int,@fcanuseqty decimal(24,2)
declare @fproductid int,@fistop int,@fqty decimal(24,2) ,@fentryid int,@fitemid int
declare @frependqty decimal(24,2), @frepitemid decimal(24,2), @frepremainqty decimal(24,2), @foweqty decimal(24,2)
declare @finterid int, @findex int, @fassignqty decimal(24,2),@fremainqty decimal(24,2)
declare @fcostobjid int,@ficmointerid int, @frepqty decimal(24,2),@fqtymust decimal(24,2)
declare @fnewentryid int,@fstockid int,@funitid int

truncate table #Cursor
insert into #Cursor(fcostobjid,ficmointerid,fproductid,finterid,fentryid,fitemid,fqty,fistop,findex,foweqty,fqtymust,frepqty,frepitemid)
select t1.fcostobjid,t1.ficmointerid,t1.fproductid,t1.finterid,t1.fentryid,t1.fitemid,t1.fqty,t1.fistop,t1.findex,t1.foweqty,t1.fqtymust,t1.frepqty,t1.frepitemid
from My_t_RepAlsRoughNeedSource t1 
where t1.frunid=@frunid and t1.frepitemid>0 and t1.fisreplace=1 and t1.frepqty>0
order by t1.findex

select @fminid=0,@fmaxid=0
select @fminid=isnull(min(fid),0),@fmaxid=isnull(max(fid),0) from #Cursor

WHILE @fmaxid>0 and @fminid<=@fmaxid --@@FETCH_STATUS = 0  --先把可用库存按物料先分配下去
BEGIN 
	select @fcostobjid=fcostobjid,@ficmointerid=ficmointerid,@fproductid=fproductid,
	@finterid=finterid,@fentryid=fentryid,@fistop=fistop,@fqty=fqty,@findex=findex,@foweqty=foweqty,@fitemid=fitemid
	from #Cursor where fid=@fminid

	if @fqtymust>@frepqty  ----应发数>替换数  则 更新:应发数=应发数-替换数;         新增:应发数=替换数  物料为替换物料
	begin
		update ppbomentry set fqtymust=fqtymust-@frepqty,fauxqtymust=fauxqtymust-@frepqty,fitemid=@frepitemid,folditemid=@fitemid,
		FAuxQtyPick=FAuxQtyPick-@frepqty,FBomInputAuxQty=FBomInputAuxQty-@frepqty
		where finterid=@finterid and fentryid=@fentryid
		
		select @fstockid=fdefaultloc,@funitid=funitid from t_icitem where fitemid=@frepitemid
		
		select @fnewentryid=isnull(max(fentryid),0)+1 from ppbomentry where finterid=@FInterID
		
		Insert Into PPBOMEntry (folditemid,fentryselfy0257,FICMOinterID,   FBrNo,FInterID,FEntryID,    FItemID,    FUnitID,  FAuxQtyMust,FAuxQty,FMachinePos,FBomInputAuxQty,FauxQtyLoss,FSequenceID,FStockID,  FNote,FSourceEntryID,FAuxQtyScrap,FScrap,  FSendItemDate,  FAuxQtyPick,  FSPID,FOperID,FOperSN,FMaterielType,FBackFlush,FMarshalType,FBOMInterID,FBatchNO )
		select                  @fitemid,  @fcostobjid,    @ficmointerid,  '0',  @FInterID,@fnewentryid,@frepitemid,@funitid, @frepqty,   0,      '',         @frepqty,       0,          '',         @fstockid, '',   0,             FQtyScrap,   fscrap,  FSendItemDate,  @frepqty,     0,    0,      0,      371,          1059,      385,         0,          ''
		from ppbomentry
		where finterid=@finterid and fentryid=@fentryid		
	end
	else  --应发数<=替换数 则 更新; 应发数=替换数,物料为替换物料
	begin
		update ppbomentry set fqtymust=@frepqty,fauxqtymust=@frepqty,fitemid=@frepitemid,folditemid=@fitemid,
		FAuxQtyPick=@frepqty,FBomInputAuxQty=@frepqty
		where finterid=@finterid and fentryid=@fentryid	
	end		
	set @fminid=@fminid+1
END

go



