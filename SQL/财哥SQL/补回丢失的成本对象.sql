��������Ϊ�����ض�ʧ������ϸ�ɱ����� �� ���ض�ʧ�ɱ�������&������û��ʧ,�ɱ�����ȫ����ʧ������,����ر𳤡�
1�����ض�ʧ������ϸ�ɱ�����������£�

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


2�����ض�ʧ�ɱ�������&������û��ʧ,�ɱ�����ȫ����ʧ
--********************************************************************************************************
/* ������û��ʧ,�ɱ�����ȫ����ʧ,���ض�ʧ�ɱ�������
����: a.01.001 ������ϸ����, a��a.01��a.01.001�ڳɱ�������ȫ����ʧ,�˹��̲���a��a.01 
(ע��:��SQL�������������: a �� a.01ͬʱ�������ж���ʧ)
2002-08-27����
*/
PRINT '********����t_item�ж�ʧ�����ϵĳɱ�������***********'
PRINT ' '
SET NOCOUNT ON
--��ǰ����
DECLARE @FNumber VARCHAR(80) 
DECLARE @FLevel SMALLINT
DECLARE @FName VARCHAR(80)
DECLARE @FFullNumber VARCHAR(80)
DECLARE @FShortNumber VARCHAR(80)
DECLARE @FFullName VARCHAR(80)
--��ʧ�ĳɱ�������
DECLARE @LostFItemID INT
DECLARE @LostFParentID INT
DECLARE @LostUUID VARCHAR(80) 
DECLARE @ParentNumber VARCHAR(200) --����ʧ���ϼ��顱�ġ��ϼ��顱����

DECLARE AddTeamCur SCROLL CURSOR FOR
SELECT FNumber,FLevel,FName,FNumber,FShortNumber,FFullName
FROM t_item 
where fitemclassid=4 and fdetail=0 and fnumber not in (select fnumber from t_item where fitemclassid=2001 and fdetail=0)
order by fnumber---�������д��ڶ��ڳɱ����в����ڵ�����
OPEN AddTeamCur
FETCH AddTeamCur INTO @FNumber,@FLevel,@FName,@FNumber,@FShortNumber,@FFullName


WHILE @@Fetch_Status<>-1
	
	
BEGIN --(1)
	PRINT @FNumber
	----��Ӷ�ʧ��������
	SELECT @LostFItemID= FNext FROM t_Identity WHERE FName='t_item'--Ѱ������FITEMID

	update t_identity set fnext=fnext+1 where fname='t_item'

	begin ----ȡ��ǰ�ɱ���ĸ���ID
		if @FLevel=1
			select @LostFParentID=0
		else
		begin
			SELECT @ParentNumber=left( @FNumber,len(@FNumber)-CHARINDEX('.',REVERSE(@FNumber)))--ȡ��ǰ�ɱ���ĸ�������
			SELECT @LostFParentID=FItemID FROM t_item WHERE FNumber=@ParentNumber and FItemClassID=2001--ȡ��ǰ�ɱ���ĸ���ID
		end
	end

	SELECT @LostUUID= NEWID() --ȡ��ʶ
	
	--���ض�ʧ�ĳɱ�������
	
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