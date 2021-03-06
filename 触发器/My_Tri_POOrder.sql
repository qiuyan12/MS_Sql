set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go




ALTER TRIGGER [My_Tri_POOrder] ON [dbo].[POOrder]
FOR Insert,UPDATE

AS
BEGIN
	SET NOCOUNT ON
	declare @iMaxIndex int
	--采购订单内码
	declare @FInterID int  
	--@FMyInterID(我的内部ID变量在本触发器也没有用到？) 供应商
	declare @FMyInterID int ,@FSupplyID int
	--币别ID
	declare @fcurrencyid int
	--采购单号
	declare @fbillno varchar(30)
	--交易类型(这个变量没有用到？) 制单人 核准人
	declare @ftrantype int ,@FBillerID int,@FCheckerID int
	--订单状态
	declare @fstatus int,@s varchar(3000)

	--1.获取已输入的信息
	select top 1 @s='',@FSupplyID=FSupplyID,@fstatus=isnull(fstatus,0),@FBillerID=FBillerID,@FCheckerID=FCheckerID,
	@fcurrencyid=fcurrencyid,@fbillno=fbillno,@FInterID=FInterID from INSERTED 

	--2. 未关联数=订货数量-到货数量
	update m2 set FEntrySelfP0250=m2.fqty-m2.FCommitQty
	from poorderentry m2 
	inner join inserted m3 on m2.finterid=m3.finterid

	--FEntrySelfS0168 :采购余数 
	update t1 set FEntrySelfS0168=t1.fqty-isnull(t2.fqty,0)
	from seorderentry t1 --销售订单分录表
	inner join 
	(
		select t1.fsourceinterid,t1.fsourceentryid,t1.fitemid,sum(t1.fqty) fqty--源单内码 原分录号 采购数量
		from poorder t0 --
		inner join poorderEntry t1 on t0.finterid=t1.finterid  --
		inner join 
		(	  
			select distinct t1.fsourceinterid,t1.fsourceentryid 
			from poorderentry t1--
			inner join inserted t2 on t1.finterid=t2.finterid
			where t1.fsourcetrantype=81
		) t2 on t1.fsourceinterid=t2.fsourceinterid and t1.fsourceentryid=t2.fsourceentryid
		where t1.fsourcetrantype=81 --订单来源 71 采购申请 81 销售订单 0 采购申请
		group by t1.fsourceinterid,t1.fsourceentryid,t1.fitemid
	) t2 on t1.finterid=t2.fsourceinterid and t1.FEntryID=t2.fsourceentryid --and t1.fitemid=t2.fitemid
	inner join t_icitem t3 on t1.fitemid=t3.fitemid

	--修改销售订单 FOrderCommitQty 字段
	update t1 set FOrderCommitQty=isnull(t2.fqty,0)
	from seorderentry t1 --
	inner join 
	(
		select t1.fsourceinterid,t1.fsourceentryid,t1.fitemid,sum(t1.fqty) fqty
		from poorder t0 --
		inner join poorderEntry t1 on t0.finterid=t1.finterid  --
		inner join 
		(	  
			select distinct t1.fsourceinterid,t1.fsourceentryid 
			from poorderentry t1--
			inner join inserted t2 on t1.finterid=t2.finterid
			where t1.fsourcetrantype=81
		) t2 on t1.fsourceinterid=t2.fsourceinterid and t1.fsourceentryid=t2.fsourceentryid
		where t1.fsourcetrantype=81
		group by t1.fsourceinterid,t1.fsourceentryid,t1.fitemid
	) t2 on t1.finterid=t2.fsourceinterid and t1.FEntryID=t2.fsourceentryid --and t1.fitemid=t2.fitemid
	inner join t_icitem t3 on t1.fitemid=t3.fitemid
	where left(t3.fnumber,1) not in ('M') -- M开头的为成品
		
	update t2 set fmrpclosed=40019
	from t_BOSPlasticPoInStock t1
	inner join t_BOSPlasticPoInStockEntry t2 on t1.fid=t2.fid
	inner join t_icitem t3 on t2.fitemid=t3.fitemid
	inner join poorderentry t7 on t7.finterid=t2.fid_src and t7.fentryid=t2.fentryid_src 
	inner join inserted t4 on t4.finterid=t7.finterid
	where t7.FMrpClosed=1 

--	if exists(	select 1
--				from seorder t1
--				inner join seorderentry t2 on t1.finterid=t2.finterid
--				inner join t_icitem t3 on t2.fitemid=t3.fitemid
--				left join icmo t4 on t4.forderinterid=t2.finterid and t4.fsourceentryid=t2.fentryid
--				inner join poorderentry t5 on t5.fsourceinterid=t2.finterid and t5.fsourceentryid=t2.fentryid and t5.fsourcetrantype=81
--				inner join inserted t6 on t5.finterid=t6.finterid
--				where t4.finterid is null and isnull(t2.fentryselfs0175,0) in (40090,40091)
--				and isnull(t1.FHeadSelfS0147,0) not in (40032,40033) --40032	样品订单-收费 40033	样品订单-免费
--				) --select * from t_submessage where finterid in (40090,40091)
--	
--	begin
--		select @s=@s+','+m1.fshortnumber from
--		(
--			select t3.fshortnumber
--			from seorder t1
--			inner join seorderentry t2 on t1.finterid=t2.finterid
--			inner join t_icitem t3 on t2.fitemid=t3.fitemid
--			left join icmo t4 on t4.forderinterid=t2.finterid and t4.fsourceentryid=t2.fentryid
--			inner join poorderentry t5 on t5.fsourceinterid=t2.finterid and t5.fsourceentryid=t2.fentryid and t5.fsourcetrantype=81
--			inner join inserted t6 on t5.finterid=t6.finterid
--			where t4.finterid is null and isnull(t2.fentryselfs0175,0) in (40090,40091)
--			and isnull(t1.FHeadSelfS0147,0) not in (40032,40033) --40032	样品订单-收费 40033	样品订单-免费) --select * from t_submessage where finterid in (40090,40091)
--		) m1
--
--		set @s='以下外调品还未生成生产任务单['+@s+']'
--		RAISERROR(@s,18,18)
--	end

	------------------------------------------------------------------------------------------
    ---判断价格报价
	if exists(select 1  
				from poorderentry t1 
				inner join inserted t7 on t1.finterid=t7.finterid
				inner join t_icitem t2 on t1.fitemid=t2.fitemid 
				inner join t_supplyentry t4 on t4.fsupid=t7.fsupplyid and t4.fitemid=t2.fitemid
				where t1.ftaxprice>t4.ftaxprice and t1.ftaxprice>0 and t7.fdate>='2015-01-02') and @fstatus=0
	begin
		select @s=@s+','+m1.fnumber from
		(
			select distinct t2.fnumber
			from poorderentry t1 
			inner join inserted t7 on t1.finterid=t7.finterid
			inner join t_icitem t2 on t1.fitemid=t2.fitemid 
			inner join t_supplyentry t4 on t4.fsupid=t7.fsupplyid and t4.fitemid=t2.fitemid
			where t1.ftaxprice>t4.ftaxprice and t1.ftaxprice>0 and t7.fdate>='2015-01-02'
		) m1

		set @s='以下物料采购单价大于价格库单价['+@s+']'
		RAISERROR(@s,18,18)
	end

	--------------------------------------------------------------------------------------------
	if exists(select 1  
				from poorderentry t1 
				inner join inserted t7 on t1.finterid=t7.finterid
				inner join t_icitem t2 on t1.fitemid=t2.fitemid 
				left join t_supplyentry t4 on t4.fsupid=t7.fsupplyid and t4.fitemid=t2.fitemid
				where t4.fitemid is null and t7.fdate>='2015-01-02' and t1.fprice>0 and t2.fnumber not like 'v.e%')
	begin
		select @s=@s+','+m1.fnumber from
		(
			select distinct t2.fnumber
			from poorderentry t1 
			inner join inserted t7 on t1.finterid=t7.finterid
			inner join t_icitem t2 on t1.fitemid=t2.fitemid 
			left join t_supplyentry t4 on t4.fsupid=t7.fsupplyid and t4.fitemid=t2.fitemid
			where t4.fitemid is null and t7.fdate>='2015-01-02' and t1.fprice>0 
		) m1

		set @s='以下物料无采购单价['+@s+']'
		RAISERROR(@s,18,18)
	end

	------------------------------------------------------------------------------------------

	------------------------------------------------------------------------------------------
		
	if @fstatus=0
	begin
		set @FSupplyID=@FSupplyID
		/*
		update t13 set fentryselfp0247=t4.fsource  --更新主供应商信息
		from poorderentry t13 
		inner join INSERTED t16 on t16.finterid=t13.finterid 
		inner join t_icitem t4 on t4.fitemid=t13.fitemid
		where t16.fbillno=@fbillno and (isnull(t13.fentryselfp0247,0)=0) and (isnull(t4.fsource,0)<>0)
		*/

		--/*

		--最新供应商
		update t1 set fentryselfp0252=isnull(t3.fshortname,'')
		from poorderentry t1
		inner join 
		(	
			select t3.fsupplyid,t1.ftaxprice,t1.fitemid  --该物料的最新单据的供应商
			from poorderentry t1
			inner join 
			(
				select t2.fitemid,isnull(max(t1.finterid),0) finterid --该物料的最新单据
				from poorder t1
				inner join poorderentry t2 on t1.finterid=t2.finterid
				where t1.finterid<@finterid and t1.fstatus>0
				group by t2.fitemid
			) t2 on t1.finterid=t2.finterid and t1.fitemid=t2.fitemid
			inner join poorder t3 on t3.finterid=t1.finterid
		) t2 on t1.fitemid=t2.fitemid
		inner join t_supplier t3 on t3.fitemid=t2.fsupplyid
		where t1.finterid=@finterid 

		update t13 set --fentryselfp0249=isnull(t1.ftaxprice,0), --采购最小单价  --放在前台了
		fentryselfp0251=isnull(t2.fdate,null)  --最新报价日期
		from poorderentry t13 
		inner join INSERTED t16 on t16.finterid=t13.finterid 
		inner join t_icitem t4 on t4.fitemid=t13.fitemid
		--left join 
		--(
		--	select t4.fitemid,isnull(min(t4.ftaxprice),0) ftaxprice 
		--	FROM  t_SupplyEntry t4 
		--	inner  JOIN t_ICItem t7 ON t4.fitemid=t7.FItemID AND t7.FItemID<>0 
		--	inner  JOIN t_supplier t3 ON t3.fitemid=t4.fsupid AND t3.FItemID<>0 
		--	--where t4.FUsed=1 
		--	group by t4.fitemid
		--) t1 on t13.fitemid=t1.fitemid
		left join 
		(
			select t4.fitemid,max(t4.FQuoteTime) fdate
			FROM  t_SupplyEntry t4 
			inner  JOIN t_ICItem t7 ON t4.fitemid=t7.FItemID AND t7.FItemID<>0 
			inner  JOIN t_supplier t3 ON t3.fitemid=t4.fsupid AND t3.FItemID<>0 
			where t4.fsupid=@FSupplyID --and t4.FUsed=1 
			group by t4.fitemid
		) t2 on t13.fitemid=t2.fitemid --and t16.fsupplyid=
		--where t16.fbillno=@fbillno --and (isnull(t13.fentryselfp0247,0)=0) and (isnull(t4.fsource,0)<>0)
		--*/

		--主供应商变更原因
		/*
		if exists (select 1
		from poorderentry t3 
		inner join t_icitem t4 on t4.fitemid=t3.fitemid
		where t3.finterid=@FInterID and (isnull(t4.fsource,0)<>@FSupplyID) and (isnull(t4.fsource,0)<>0) and isnull(t3.fentryselfp0249,'')=''
		)
		begin
			select @s=@s+','+m1.fshortnumber from
			(
				select t4.fshortnumber
				from INSERTED t1
				inner join poorderentry t2 on t1.finterid=t2.finterid
				inner join t_icitem t4 on t4.fitemid=t2.fitemid
				where t2.finterid=@FInterID and (isnull(t4.fsource,0)<>@FSupplyID) and (isnull(t2.fentryselfp0249,'')='') and (isnull(t4.fsource,0)<>0)
			) m1

			set @s='以下物料所选供应商与主供应商不一致,请在[说明]栏中注明原因['+@s+']'
			RAISERROR(@s,18,18)
		end
		*/
	end
END




