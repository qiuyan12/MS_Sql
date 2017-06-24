select top 1  t1.fitemid,t2.fitemid,t3.fshortnumber,t3.FItemID,t4.fshortnumber,t4.FItemID --@FBaseItemID=isnull(t2.fitemid,0),@fbannumber=isnull(t3.fshortnumber,''),@fxinnumber=isnull(t4.fshortnumber,'')
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
				where t1.fitemid=144874 and left(t1.fnumber,1) in (select fitemtype from v_myitemtype where ftype=0)
				--and t1.fname not like '%禁用%' and t1.fdeleted=0 
			) t1 group by t1.fitemid
		) t1 left join
		(
			select fitemid,max(fbanitemid) fbanitemid,isnull(max(fxinitemid),0) fxinitemid from
			(
				select t1.fitemid,
				case when left(t4.fnumber,1) in ('3','4','5','7','8') then t4.fitemid else 0 end fbanitemid, --半成品
				case when left(t4.fnumber,10) in ('1.01.0010.') then t4.fitemid else 0 end fxinitemid				--芯片
				from t_icitem t1
				inner join icbom t2 on t1.fitemid=t2.fitemid
				inner join icbomchild t3 on t2.finterid=t3.finterid
				inner join t_icitem t4 on t3.fitemid=t4.fitemid
				where 1=1
				and t1.fname not like '%禁用%' and t1.fdeleted=0 
				and left(t1.fnumber,4) in ('A.01','P.01','J.01','X.01','Y.01') 
			) t1 group by t1.fitemid
		) t2 on t1.fbanitemid=t2.fbanitemid and t1.fxinitemid=t2.fxinitemid
		left join t_icitem t3 on t3.fitemid=t1.fbanitemid
		left join t_icitem t4 on t4.fitemid=t1.fxinitemid