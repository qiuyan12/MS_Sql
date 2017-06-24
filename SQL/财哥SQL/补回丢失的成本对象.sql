由于语句分为：补回丢失的最明细成本对象 和 补回丢失成本对象组&物料组没丢失,成本对象全部丢失两部分,语句特别长。
1、补回丢失的最明细成本对象（语句如下）

SET NOCOUNT ON
DECLARE @ItemID INT

DECLARE AddCbCostObjCur SCROLL CURSOR FOR
SELECT a.FItemID FROM t_Item a,t_IcItem b
WHERE a.FItemID=b.FItemID 
and a.FItemClassID=4
and a.FDetail=1
and b.FTrack<>80
and b.FErpClsID=2
and a.FNumber not in
(SELECT FNumber FROM t_Item WHERE FItemClassID=2001 and FDetail=1)

OPEN AddCbCostObjCur
FETCH AddCbCostObjCur INTO @ItemID
WHILE @@FETCH_STATUS<>-1
BEGIN
	Execute cbAddCostObj @ItemID,0
	FETCH AddCbCostObjCur INTO @ItemID
END
CLOSE AddCbCostObjCur
DEALLOCATE AddCbCostObjCur


2、补回丢失成本对象组&物料组没丢失,成本对象全部丢失
--********************************************************************************************************
/* 物料组没丢失,成本对象全部丢失,补回丢失成本对象组
例如: a.01.001 是最明细物料, a、a.01、a.01.001在成本对象中全部丢失,此过程补回a和a.01 
(注意:此SQL不适用这种情况: a 与 a.01同时在物料中都丢失)
2002-08-27做成
*/
PRINT '********补回t_item中丢失的物料的成本对象组***********'
PRINT ' '
SET NOCOUNT ON
--当前物料
DECLARE @FNumber VARCHAR(80) 
DECLARE @FLevel SMALLINT
DECLARE @FName VARCHAR(80)
DECLARE @FFullNumber VARCHAR(80)
DECLARE @FShortNumber VARCHAR(80)
DECLARE @FFullName VARCHAR(80)
--丢失的成本对象组
DECLARE @LostFItemID INT
DECLARE @LostFParentID INT
DECLARE @LostUUID VARCHAR(80) 
DECLARE @ParentNumber VARCHAR(200) --“丢失的上级组”的“上级组”代码

DECLARE AddTeamCur SCROLL CURSOR FOR
SELECT FNumber,FLevel,FName,FNumber,FShortNumber,FFullName
FROM t_item 
where fitemclassid=4 and fdetail=0 and fnumber not in (select fnumber from t_item where fitemclassid=2001 and fdetail=0)
order by fnumber---在物料中存在而在成本组中不存在的物料
OPEN AddTeamCur
FETCH AddTeamCur INTO @FNumber,@FLevel,@FName,@FNumber,@FShortNumber,@FFullName


WHILE @@Fetch_Status<>-1
	
	
BEGIN --(1)
	PRINT @FNumber
	----添加丢失的物料组
	SELECT @LostFItemID= FNext FROM t_Identity WHERE FName='t_item'--寻找最大的FITEMID

	update t_identity set fnext=fnext+1 where fname='t_item'

	begin ----取当前成本组的父级ID
		if @FLevel=1
			select @LostFParentID=0
		else
		begin
			SELECT @ParentNumber=left( @FNumber,len(@FNumber)-CHARINDEX('.',REVERSE(@FNumber)))--取当前成本组的父级代码
			SELECT @LostFParentID=FItemID FROM t_item WHERE FNumber=@ParentNumber and FItemClassID=2001--取当前成本组的父级ID
		end
	end

	SELECT @LostUUID= NEWID() --取标识
	
	--补回丢失的成本对象组
	
	INSERT INTO t_item (FItemID,FItemClassID,FExternID,FNumber,FParentID,FLevel,FDetail,FName,FUnUsed,FBrNo,FFullNumber,
	FDiff,FDeleted,FShortNumber,FFullName,UUID,FGRCommonID) 
	VALUES
	(@LostFItemID,2001,-1,@FNumber,@LostFParentID,@FLevel,0,@FName,0,0,@FNumber,
	0,0,@FShortNumber,@FFullName,@LostUUID,-1) 
	
	FETCH AddTeamCur INTO @FNumber,@FLevel,@FName,@FNumber,@FShortNumber,@FFullName
END--(1)

CLOSE AddTeamCur
DEALLOCATE AddTeamCur 


select t2.fitemid,t1.fcostobjid,* 
--update t1 set fcostobjid=t2.fitemid
from icmo t1
inner join cbcostobj t2 on t1.fitemid=t2.fstdproductid
where isnull(t1.fcostobjid,0)=0