SELECT
	sub.FSubFuncID,
	detail.FDetailFuncID,
	detail.FClassName,
	detail.FFuncName,
	detail.FFuncName_CHT,
	detail.FFuncName_EN,
	detail.*
FROM
	t_DataFlowSubFunc sub
LEFT  JOIN t_DataFlowDetailFunc detail ON sub.FSubFuncID = detail.FSubFuncID
WHERE
	1 = 1 --AND sub.FSubFuncID = 19023 --自定义MRP
AND detail.FDetailFuncID IN ('99990102','99990126','99990150') --FFuncName='物料替代清单'
ORDER BY
	detail.FDetailFuncID DESC