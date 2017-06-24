---用户使用的功能表
SELECT
	topclass.FTopClassName,
	subsys.FTopClassID,
	subsys.FName,
	subfunc.FSubFuncID,
	subfunc.FFuncName,
	detailfunc.FDetailFuncID,
	detailfunc.FFuncName,
	'end'

--UPDATE  subfunc SET subfunc.FFuncName='MRP计算test' 
FROM
	t_UserTopClass topclass
INNER JOIN t_UserSubSystem subsys ON topclass.FTopClassID = subsys.FTopClassID
INNER JOIN t_UserSubFunc subfunc ON subsys.FSubSysID = subfunc.FSubSysID
INNER JOIN t_UserDetailFunc detailfunc ON subfunc.FSubFuncID = detailfunc.FSubFuncID

WHERE
	1 = 1
AND topclass.FVisible = 1
AND subsys.FVisible = 1  
--AND subfunc.FVisible = 1

AND subfunc.FSubFuncID=18001


--
--
-- SELECT
-- 	topclass.FTopClassName,
-- 	subsys.FName,
-- 	subfunc.FSubFuncID,
-- 	subfunc.FFuncName,
-- 	detailfunc.FDetailFuncID,
-- 	detailfunc.FFuncName
-- FROM
-- 	-- UPDATE  subfunc SET subfunc.FFuncName='MRP计算2' FROM
-- 	t_DataFlowTopClass topclass
-- LEFT JOIN t_DataFlowSubSystem subsys ON topclass.FTopClassID = subsys.FTopClassID
-- LEFT JOIN t_DataFlowSubFunc subfunc ON subsys.FSubSysID = subfunc.FSubSysID
-- LEFT JOIN t_DataFlowDetailFunc detailfunc ON subfunc.FSubFuncID = detailfunc.FSubFuncID --
-- WHERE
-- 	1 = 1
-- AND subfunc.FSubFuncID = 18001
-- AND detailfunc.FFuncName LIKE 'MRP计算' 

----系统标准表格
-- SELECT * FROM t_DataFlowTopClass  --主菜单
--
-- SELECT *  FROM t_DataFlowSubSystem --二级菜单
-- 
-- SELECT *  FROM t_DataFlowSubFunc --三级菜单
-- 
-- SELECT *  FROM t_DataFlowDetailFunc --明细菜单
-- 
-- SELECT*FROM t_DataFlowTimeStamp --删除表
