set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go


ALTER TRIGGER [My_Tri_ICStockBill_In]
            ON [dbo].[ICStockBill]
for insert,update

AS
BEGIN
	SET NOCOUNT ON
	--@iMaxIndex  @FInterID单据ID(关键字)  @FMyInterID @s输出提示 @fcurrencyid 币别 @FVchInterID 凭证ID
	declare @iMaxIndex int,@FInterID int, @FMyInterID int ,@s varchar(2000),@fcurrencyid int,@FVchInterID int
    --@fbillno入库单号  @ftrantype单据类型  @frob红蓝字 @fdate单据日期 @ftoday当前日期 @fstatus状态(0-未审核,1-已审核) @FHeadSelfB0433标识码
	declare @fbillno varchar(30),@ftrantype int  ,@frob int,@fdate datetime,@ftoday datetime,@fstatus int,@FHeadSelfB0433 int
	
	select top 1 @frob=frob,@ftrantype=ftrantype,@fcurrencyid=fcurrencyid,@s='',@fstatus=fstatus,@FVchInterID=isnull(FVchInterID,0),
	@fbillno=fbillno,@FInterID=FInterID,@fdate=fdate,@ftoday=replace(convert(varchar(10),getdate(),111),'/','-'),
	@FHeadSelfB0433=isnull(FHeadSelfB0433,0) from INSERTED 
--		
--	IF @ftrantype=1    
--	BEGIN
--		if exists (select 1 from icstockbillentry t1 inner join INSERTED t2 on t1.finterid=t2.finterid 
--				   inner join poorderentry t3 on t3.finterid=t1.forderinterid and t3.fentryid=t1.forderentryid 
--				   where t3.fauxprice=0 and t2.fdate>='2014-04-16')
--		begin
--			RAISERROR('采购单价为0的分录不能生成外购入库单!',18,18)
--		end
--	end

	----检查套件 拒绝出入库
	if exists(	select 1
				from icstockbill t1
				inner join icstockbillentry t2 on t1.finterid=t2.finterid
				inner join t_icitem t3 on t2.fitemid=t3.fitemid  --套件
				where t1.finterid=@FInterID and t3.fnumber like '1.02.%'  and t1.fdate>='2014-01-01'
				) 
				and exists (select * from t_SystemProfile where FCategory='IC' and fkey='FIsPlasticManage' and fvalue='1')
	begin
		RAISERROR('套件不允许出入库!',18,18)
	end
	----END检查套件 拒绝出入库

	--检查生产领料
	IF @ftrantype=24 and @FVchInterID=0 and not update(FVchInterID)    
	BEGIN
		if exists (select 1 from icstockbillentry t1 inner join INSERTED t2 on t1.finterid=t2.finterid 
		where isnull(t1.fsourcetrantype,0)=85 and isnull(t1.fsourcebillno,'')='' )
		begin
			update t1 set fsourcebillno=t4.fbillno,ficmobillno=t4.fbillno
			from icstockbillentry t1 
			inner join INSERTED t2 on t1.finterid=t2.finterid 
			inner join icmo t4 on t4.finterid=t1.fsourceinterid
			where isnull(t1.fsourcetrantype,0)=85 and isnull(t1.fsourcebillno,'')=''
		end

		if exists (select 1 from icstockbillentry t1 inner join INSERTED t2 on t1.finterid=t2.finterid 
		where isnull(t1.fsourceinterid,0)=0 and t2.fdate>'2016-09-01') --t1.fsourceinterid源单内码
		begin
			RAISERROR('生产领料必须关联单据生成!',18,18)
		end

		if exists (select 1 from icstockbillentry t1 inner join INSERTED t2 on t1.finterid=t2.finterid 
		where isnull(t1.ficmointerid,0)=0 and t2.fdate>='2016-09-07') --t1.cmointerid任务单内码
		begin
			RAISERROR('生产领料必须关联任务单生成!',18,18)
		end

		if exists (select 1 from icstockbillentry t1 inner join INSERTED t2 on t1.finterid=t2.finterid 
		where cast(t1.fqty as decimal(24,2))>cast(t1.fqtymust as decimal(24,2)) and t2.fdate>'2013-03-05' and t1.fqty>0)
		begin
			RAISERROR('实发数不能大于申请数!',18,18)
		end
		--End检查生产领料
		
		--if @fstatus=0 and @FHeadSelfB0433=0 --
		--begin
		--	if exists(
		--		select 1
		--		from
		--		(
		--			select t1.fitemid,t1.FSCStockID fstockid,t1.fbatchno,sum(t1.fqty) fqty
		--			from ICStockBill t0 --
		--			inner join ICStockBillEntry t1 on t0.finterid=t1.finterid  --
		--			inner join 
		--			(	  
		--				select distinct t1.fitemid
		--				from ICStockBillEntry t1--
		--				inner join inserted t2 on t1.finterid=t2.finterid
		--				where t1.fsourcetrantype in (85) --t1.finterid=@FInterID
		--			) t2 on t1.fitemid=t2.fitemid
		--			where t0.ftrantype=24 --and t1.fsourcetrantype in (85)  --,200000014
		--			and t0.fstatus=0 and t0.frob=1  --蓝字未审核的领料单
		--			group by t1.fitemid,t1.FSCStockID,t1.fbatchno
		--		) t1 left join icinventory t2 on t1.fitemid=t2.fitemid and t1.fstockid=t2.fstockid and t1.fbatchno=t2.fbatchno
		--		where t1.fqty>isnull(t2.fqty,0)
		--	)
		--	begin
		--		select @s=@s+','+m1.fnumber from
		--		(
		--			select '['+t3.fshortnumber+']'+'['+t4.fname+']'+'['+isnull(t1.fbatchno,'')+']'+'['+cast(t1.fqty as varchar(50))+']'+'库存['+cast(isnull(t2.fqty,0) as varchar(50))+']' fnumber
		--			from
		--			(
		--				select t1.fitemid,t1.FSCStockID fstockid,t1.fbatchno,cast(sum(t1.fqty) as decimal(24,2)) fqty
		--				from ICStockBill t0 --
		--				inner join ICStockBillEntry t1 on t0.finterid=t1.finterid  --
		--				inner join 
		--				(	  
		--					select distinct t1.fitemid
		--					from ICStockBillEntry t1--
		--					inner join inserted t2 on t1.finterid=t2.finterid
		--					where t1.fsourcetrantype in (85) -- t1.finterid=@FInterID
		--				) t2 on t1.fitemid=t2.fitemid
		--				where t0.ftrantype=24 --and t1.fsourcetrantype in (85)  --,200000014
		--				and t0.fstatus=0 and t0.frob=1
		--				group by t1.fitemid,t1.FSCStockID,t1.fbatchno
		--			) t1 left join icinventory t2 on t1.fitemid=t2.fitemid and t1.fstockid=t2.fstockid and t1.fbatchno=t2.fbatchno
		--			inner join t_icitem t3 on t3.fitemid=t1.fitemid
		--			inner join t_stock t4 on t4.fitemid=t1.fstockid
		--			where t1.fqty>isnull(t2.fqty,0)
		--		) m1

		--		set @s='以下物料库存不够['+@s+']'   --
		--		RAISERROR(@s,18,18)
		--	end
		--end

		--if exists(
		--	select 1
		--	from PPBOMEntry t1 --
		--	inner join 
		--	(
		--		select t1.ficmointerid,t1.fppbomentryid,t1.fitemid,sum(t1.fqty) fqty
		--		from ICStockBill t0 --
		--		inner join ICStockBillEntry t1 on t0.finterid=t1.finterid  --
		--		inner join 
		--		(	  
		--			select distinct t1.ficmointerid,t1.fitemid 
		--			from ICStockBillEntry t1--
		--			inner join inserted t2 on t1.finterid=t2.finterid
		--			where t1.fsourcetrantype in (85) --t1.finterid=@FInterID
		--		) t2 on t1.ficmointerid=t2.ficmointerid and t1.fitemid=t2.fitemid
		--		inner join icmo t3 on t3.finterid=t1.ficmointerid
		--		where t0.ftrantype=24 and t1.fsourcetrantype in (85)  --200000014
		--		group by t1.ficmointerid,t1.fppbomentryid,t1.fitemid
		--	) t2 on t1.ficmointerid=t2.ficmointerid and t1.FEntryID=t2.fppbomentryid and t1.fitemid=t2.fitemid
		--	where t1.fqtymust<t2.fqty
		--)
		--begin
		--	select @s=@s+','+m1.fnumber from
		--	(
		--		select '['+t3.fshortnumber+']'+'['+cast(t2.fqty as varchar(50))+']'+'应发['+cast(cast(t1.fqtymust as decimal(24,2)) as varchar(50))+']' fnumber
		--		from PPBOMEntry t1 --
		--		inner join 
		--		(
		--			select t1.ficmointerid,t1.fppbomentryid,t1.fitemid,cast(sum(t1.fqty) as decimal(24,2)) fqty
		--			from ICStockBill t0 --
		--			inner join ICStockBillEntry t1 on t0.finterid=t1.finterid  --
		--			inner join 
		--			(	  
		--				select distinct t1.ficmointerid,t1.fitemid  
		--				from ICStockBillEntry t1--
		--				inner join inserted t2 on t1.finterid=t2.finterid
		--				where t1.fsourcetrantype in (85) --t1.finterid=@FInterID
		--			) t2 on t1.ficmointerid=t2.ficmointerid and t1.fitemid=t2.fitemid
		--			inner join icmo t3 on t3.finterid=t1.ficmointerid
		--			where t0.ftrantype=24 and t1.fsourcetrantype in (85)  --200000014
		--			group by t1.ficmointerid,t1.fppbomentryid,t1.fitemid
		--		) t2 on t1.ficmointerid=t2.ficmointerid and t1.FEntryID=t2.fppbomentryid and t1.fitemid=t2.fitemid
		--		inner join t_icitem t3 on t3.fitemid=t1.fitemid
		--		where t1.fqtymust<t2.fqty
		--	) m1

		--	set @s='以下物料超过应发数['+@s+']'   --
		--	RAISERROR(@s,18,18)
		--end

		--更新投料单选单数量--虚仓的在虚仓触发器中考虑--不会出现一个物料又有虚仓又有实仓--有可能出现先调用了此触发器，K3又回写了，会造成double回写的错误
		update t1 set fqty=isnull(t2.fqty,0),fauxqty=isnull(t2.fqty,0)  --与My_P_GenerateOutStock24的写法不一样
		from PPBOMEntry t1 --
		inner join 
		(
			select t1.ficmointerid,t1.fppbomentryid,t1.fitemid,sum(t1.fqty) fqty
			from ICStockBill t0 --
			inner join ICStockBillEntry t1 on t0.finterid=t1.finterid  --
			inner join 
			(	  
				select distinct t1.ficmointerid 
				from ICStockBillEntry t1--
				inner join inserted t2 on t1.finterid=t2.finterid
				--where t1.finterid=@FInterID
			) t2 on t1.ficmointerid=t2.ficmointerid
			inner join icmo t3 on t3.finterid=t1.ficmointerid
			where t0.ftrantype=24 and t1.fsourcetrantype in (85,200000014)
			group by t1.ficmointerid,t1.fppbomentryid,t1.fitemid
		) t2 on t1.ficmointerid=t2.ficmointerid and t1.FEntryID=t2.fppbomentryid and t1.fitemid=t2.fitemid

--		--exec My_p_UpdateBillRelateData_24_26 24,@FInterID
--
--		--更新任务单的领料状态 
--		/*
--		update m2 set FHeadSelfJ0173=(case when fallcount=fallnocount then 40011 when (FPartCount>0 or fallcount>fallnocount) then 40012 when fallcount=FAllYesCount then 40013 end) 
--		from
--		(
--			select t1.ficmointerid,
--			(select count(finterid) from PPBomEntry where ficmointerid=t1.ficmointerid) FAllCount,
--			(select count(finterid) from PPBomEntry where ficmointerid=t1.ficmointerid and fqty=0) FAllNoCount,
--			(select count(finterid) from PPBomEntry where ficmointerid=t1.ficmointerid and FQtyMust>FQty and fqty>0) FPartCount,
--			(select count(finterid) from PPBomEntry where ficmointerid=t1.ficmointerid and FQtyMust<=FQty) FAllYesCount
--			from (select distinct t1.FICMOInterID from icstockbillentry t1
--				  inner join INSERTED t3 on t3.finterid=t1.finterid) t1
--		) m1 inner join icmo m2 on m1.ficmointerid=m2.finterid
--		*/
--
--		/*
--		update m2 set FHeadSelfJ0173=(case when m1.fqty=0 then 40011 when (m1.fqty>0 and m1.fqtymust>m1.fqty) then 40012 when m1.fqtymust<=m1.fqty then 40013 end) 
--		from
--		(
--			select t1.ficmointerid,isnull(sum(t1.fqtymust),0) fqtymust,isnull(sum(t2.fqty),0) fqty
--			from PPBomEntry t1
--			left join 
--			(
--				select t1.ficmointerid,t1.fppbomentryid,sum(t1.fqty) fqty
--				from icstockbill t0 
--				inner join icstockbillentry t1 on t0.finterid=t1.finterid
--				inner join 
--				(	  select distinct t1.FICMOInterID 
--					  from icstockbillentry t1
--					  inner join INSERTED t2 on t1.finterid=t2.finterid
--					  --where t1.finterid=@finterid 
--				) t2 on t1.ficmointerid=t2.ficmointerid
--				where t0.ftrantype=24 
--				group by t1.ficmointerid,t1.fppbomentryid
--			) t2 on t1.ficmointerid=t2.ficmointerid and t1.fentryid=t2.fppbomentryid
--			group by t1.ficmointerid
--		) m1 inner join icmo m2 on m1.ficmointerid=m2.finterid
--		*/
	end
--
--	/*
--	IF @ftrantype=41  --更新任务单的调拨状态   
--	BEGIN
--		update m2 set FHeadSelfJ0175=(case when m1.fqty=0 then 40011 when (m1.fqty>0 and m1.fqtymust>m1.fqty) then 40012 when m1.fqtymust<=m1.fqty then 40013 end) 
--		from
--		(
--			select t1.ficmointerid,sum(t1.fqtymust) fqtymust,sum(t2.fqty) fqty
--			from PPBomEntry t1
--			left join 
--			(
--				select t1.ficmointerid,t1.fppbomentryid,sum(t1.fqty) fqty
--				from icstockbill t0 
--				inner join icstockbillentry t1 on t0.finterid=t1.finterid
--				inner join 
--				(	  select distinct t1.FICMOInterID 
--					  from icstockbillentry t1
--					  inner join INSERTED t3 on t3.finterid=t1.finterid
--				) t2 on t1.ficmointerid=t2.ficmointerid
--				where t0.ftrantype=41 
--				group by t1.ficmointerid,t1.fppbomentryid
--			) t2 on t1.ficmointerid=t2.ficmointerid and t1.fentryid=t2.fppbomentryid
--			group by t1.ficmointerid
--		) m1 inner join icmo m2 on m1.ficmointerid=m2.finterid
--	end
--	*/
--
--	--/*

	IF @ftrantype=21  --销售出库   
	BEGIN
		--纯PCS数
		update x set x.FEntrySelfB0160=x.FQty*isnull(y.fqty,1)
		from icstockbillentry x left join 
				(
					select c.fitemid,isnull(sum(isnull(b.fqty,1)),1)  as fqty
					from icbom a inner join icbomchild b on a.finterid=b.finterid
									 inner join t_icitem c on a.fitemid=c.fitemid
									 inner join t_icitem d on b.fitemid=d.fitemid
				where left(d.fnumber,1) in ('3','4','5','7','8')
					group by c.fitemid
				) y on x.fitemid=y.fitemid
		inner join icstockbill t1 on t1.finterid=x.finterid
		where x.finterid=@finterid --and t1.fdate>='2016-05-03'

		update t8 set fentryselfb0161=t5.fentryselfs0176
		from seorderentry t5 
		inner join seorder t6 on t6.finterid=t5.finterid 
		inner join icstockbillentry t8 on t8.forderinterid=t5.finterid and t8.forderentryid=t5.fentryid and t8.fitemid=t5.fitemid 
		inner join inserted t9 on t9.finterid=t8.finterid
		where t9.ftrantype=21
	end

	IF @ftrantype=2  --产品入库   
	BEGIN
		if exists (select 1 from icstockbillentry t1 inner join INSERTED t2 on t1.finterid=t2.finterid 
		where isnull(t1.fsourceinterid,0)=0 and t2.fdate>'2013-03-01')
		begin
			RAISERROR('产品入库必须关联单据生成!',18,18)
		end

		if exists (select 1 from icstockbillentry t1 inner join INSERTED t2 on t1.finterid=t2.finterid 
		where t1.fqty>t1.fqtymust and t2.fdate>'2013-03-05' and t1.fqty>0)
		begin
			RAISERROR('实收数不能大于应收数!',18,18)
		end

		--纯PCS数
		update x set x.FEntrySelfA0238=x.FQty*isnull(y.fqty,1)
		from icstockbillentry x left join 
				(
					select c.fitemid,isnull(sum(isnull(b.fqty,1)),1)  as fqty
					from icbom a inner join icbomchild b on a.finterid=b.finterid
									 inner join t_icitem c on a.fitemid=c.fitemid
									 inner join t_icitem d on b.fitemid=d.fitemid
				where left(d.fnumber,1) in ('3','4','5','7','8')
					group by c.fitemid
				) y on x.fitemid=y.fitemid
		inner join icstockbill t1 on t1.finterid=x.finterid
		where x.finterid=@finterid --and t1.fdate>='2016-05-03'

		update x set x.FEntrySelfA0239=isnull(t2.fheadselfj0183,0)
		from icstockbillentry x 
		left join icmo t2 on x.ficmointerid=t2.finterid
		inner join icstockbill t1 on t1.finterid=x.finterid
		where x.finterid=@finterid and t1.fdate>='2017-03-01'

		update t2 set fnote=isnull(t2.fnote,'')+'//返工' --+(case when Charindex('返工',isnull(t2.fnote,''))<=0 then +'//返工' else '' end))
		from icstockbillentry t2 
		inner join inserted t3 on t2.finterid=t3.finterid
		inner join t_icitem t4 on t4.fitemid=t2.fitemid
		inner join icmo t1 on t1.finterid=t2.ficmointerid
		where t3.fdate>='2017-03-01' and t1.fworktypeid=56 and isnull(t2.fnote,'') not like '%//返工'

--and t3.ftrantype =cast(@fbilltype as int)
--and isnull(t3.FVchInterID,0)=0 

--
--		update src set src.fqtyfinish=isnull(dest.fqty,0),
--			 src.fauxqtyfinish=isnull(dest.fqty,0)/cast(t1.fcoefficient as float)
--		from icmo src left join 
--		(
--			select u1.fsourceinterid as fsourceinterid,u1.fitemid,sum(u1.FQtyFinish) as fqty
--			from
--			(
--				select t2.FSourceInterId
--				from inserted t1
--				inner join icstockbillentry t2 on t1.finterid=t2.finterid
--				group by t2.FSourceInterId
--			) t1 inner join ICMORptEntry u1 on t1.FSourceInterId=u1.fsourceinterid
--			group by u1.fsourceinterid,u1.fitemid
--		) dest on dest.fsourceinterid = src.finterid and dest.fitemid = src.fitemid
--		inner join t_measureunit t1 on src.funitid=t1.fitemid
	end
--	--*/
end


