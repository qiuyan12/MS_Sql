

/**Begin 新单据模板数据脚本，名称 调拨申请单    Script Date: 2014-01-09 **/


/****** Object:Data   单据描述：ICClassType    Script Date: 2014-01-09 ******/

Delete ICClassType WHERE FID=200000024  --select * from ICClassType where FID>200000024 
GO
INSERT INTO ICClassType(FID,FName_CHS,FName_CHT,FName_EN,FShowIndex,FTableName,FShowType,FTemplateID,FImgID,FModel,FLogic,FBillWidth,FBillHeight,FMenuControl,FFunctionID,FFilter,FBillTypeID,FIsManageBillNo,FBillNoKey,FEntryCount,FLayerCount,FLayerNames,FPrimaryKey,FEPrimaryKey,FClassTypeKey,FIndexKey,FObjectType,FObjectID,FGroupIDView,FGroupIDManage,FComponentExt,FBillNoManageType,FAccessoryTypeID,FControl,FTimeStamp,FExtBaseDataAccess) 
VALUES (200000024,'调拨申请单','單據200000024','Doc200000024',0,'t_BOSChangeStockRequest',0,200000024,'',2,3,9540,5490,'',23,'',3,0,'',0,1,'CHS=;CHT=;EN=','FID','FEntryID','FClassTypeID','FIndex',4100,200000024,2101,2102,'',1,80000029,2483,NULL,'') 
GO

/****** Object:Data   单据分录描述：ICClassTypeEntry    Script Date: 2014-01-09 ******/

Delete ICClassTypeEntry WHERE FParentID=200000024
GO
INSERT INTO ICClassTypeEntry(FIndex,FParentID,FTableName,FLeft,FTop,FWidth,FHeight,FLayer,FEntryType,FTabIndex,FMustInput,FKeyField,FDescription_CHS,FDescription_CHT,FDescription_EN,FFilter,FUserDefine,FContainer) 
VALUES (1,200000024,'t_BOSChangeStockRequest',0,2190,4000,4740,0,0,0,1,'','','','','',1,'') 
GO

INSERT INTO ICClassTypeEntry(FIndex,FParentID,FTableName,FLeft,FTop,FWidth,FHeight,FLayer,FEntryType,FTabIndex,FMustInput,FKeyField,FDescription_CHS,FDescription_CHT,FDescription_EN,FFilter,FUserDefine,FContainer) 
VALUES (2,200000024,'t_BOSChangeStockRequestEntry',225,1585,9095,3250,0,1,10,0,'','','','','',1,'') 
GO

/****** Object:Data   单据模板字段描述：ICClassTableInfo    Script Date: 2014-01-09 ******/

Delete ICClassTableInfo WHERE FClassTypeID=200000024
GO
INSERT INTO ICClassTableInfo(FClassTypeID,FPage,FCaption_CHS,FCaption_CHT,FCaption_EN,FKey,FFieldName,FTableName,FTableNameAs,FListIndex,FListClassName,FVisible,FEnable,FNeedSave,FMustInput,FCtlType,FProperty,FLookUpType,FLookUpClassID,FLookUpList,FSRCFieldName,FSRCTableName,FSRCTableNameAs,FDSPFieldName,FFNDFieldName,FValueLocation,FFilter,FFilterGroup,FValueType,FDspColType,FEditlen,FValuePrecision,FSaveRule,FDefValue,FAction,FUserDefine,FNote,FKeyWord,FLeft,FTop,FHeight,FWidth,FCondition,FTabIndex,FLock,FSum,FPrec,FScale,FLayer,FLoadAction,FUnControl,FFont,FSourceType,FSubKey,FParentKey,FConditionExt,FFrameBorder,FFrameBorderColor,FLabelWidth,FLabelColor,FTextColor,FIsF7,FContainer,FStyle) 
VALUES (200000024,1,'单据编号','單據編號','Doc No.','FBillNo','FBillNo','t_BOSChangeStockRequest','',0,2,-1,0,1,1,1,'',0,0,'','','','','','',1,'','',167,500,30,30,'','','',1,'','BILLNO',7200,765,375,2130,'0',0,0,0,0,0,0,'',1,'',3,'','',0,2,0,0,0,0,0,'',0) 
GO

INSERT INTO ICClassTableInfo(FClassTypeID,FPage,FCaption_CHS,FCaption_CHT,FCaption_EN,FKey,FFieldName,FTableName,FTableNameAs,FListIndex,FListClassName,FVisible,FEnable,FNeedSave,FMustInput,FCtlType,FProperty,FLookUpType,FLookUpClassID,FLookUpList,FSRCFieldName,FSRCTableName,FSRCTableNameAs,FDSPFieldName,FFNDFieldName,FValueLocation,FFilter,FFilterGroup,FValueType,FDspColType,FEditlen,FValuePrecision,FSaveRule,FDefValue,FAction,FUserDefine,FNote,FKeyWord,FLeft,FTop,FHeight,FWidth,FCondition,FTabIndex,FLock,FSum,FPrec,FScale,FLayer,FLoadAction,FUnControl,FFont,FSourceType,FSubKey,FParentKey,FConditionExt,FFrameBorder,FFrameBorderColor,FLabelWidth,FLabelColor,FTextColor,FIsF7,FContainer,FStyle) 
VALUES (200000024,1,'内码','內碼','ISN','FID','FID','t_BOSChangeStockRequest','',5,2,0,1,1,0,3,'',0,0,'','','','','','',1,'','',56,500,255,4,'','','',1,'','PRIMARY',240,120,405,2535,'-1',4,0,0,0,0,0,'',1,'',0,'','',0,0,0,0,0,0,0,'',0) 
GO

INSERT INTO ICClassTableInfo(FClassTypeID,FPage,FCaption_CHS,FCaption_CHT,FCaption_EN,FKey,FFieldName,FTableName,FTableNameAs,FListIndex,FListClassName,FVisible,FEnable,FNeedSave,FMustInput,FCtlType,FProperty,FLookUpType,FLookUpClassID,FLookUpList,FSRCFieldName,FSRCTableName,FSRCTableNameAs,FDSPFieldName,FFNDFieldName,FValueLocation,FFilter,FFilterGroup,FValueType,FDspColType,FEditlen,FValuePrecision,FSaveRule,FDefValue,FAction,FUserDefine,FNote,FKeyWord,FLeft,FTop,FHeight,FWidth,FCondition,FTabIndex,FLock,FSum,FPrec,FScale,FLayer,FLoadAction,FUnControl,FFont,FSourceType,FSubKey,FParentKey,FConditionExt,FFrameBorder,FFrameBorderColor,FLabelWidth,FLabelColor,FTextColor,FIsF7,FContainer,FStyle) 
VALUES (200000024,1,'计划开工日期','日期','Date','FDate','FDate','t_BOSChangeStockRequest','',3,2,-1,0,1,1,0,'',0,0,'','','','','','',1,'','',61,0,8,8,'','','',1,'','',3420,735,375,2850,'2,13',5,0,0,3,23,0,'',1,'',0,'','',0,2,0,0,0,0,0,'',0) 
GO

INSERT INTO ICClassTableInfo(FClassTypeID,FPage,FCaption_CHS,FCaption_CHT,FCaption_EN,FKey,FFieldName,FTableName,FTableNameAs,FListIndex,FListClassName,FVisible,FEnable,FNeedSave,FMustInput,FCtlType,FProperty,FLookUpType,FLookUpClassID,FLookUpList,FSRCFieldName,FSRCTableName,FSRCTableNameAs,FDSPFieldName,FFNDFieldName,FValueLocation,FFilter,FFilterGroup,FValueType,FDspColType,FEditlen,FValuePrecision,FSaveRule,FDefValue,FAction,FUserDefine,FNote,FKeyWord,FLeft,FTop,FHeight,FWidth,FCondition,FTabIndex,FLock,FSum,FPrec,FScale,FLayer,FLoadAction,FUnControl,FFont,FSourceType,FSubKey,FParentKey,FConditionExt,FFrameBorder,FFrameBorderColor,FLabelWidth,FLabelColor,FTextColor,FIsF7,FContainer,FStyle) 
VALUES (200000024,1,'备注','備註','Remarks','FNOTE','FNOTE','t_BOSChangeStockRequest','',7,2,-1,0,1,0,999,'',0,0,'','','','','','',0,'','',231,500,50,50,'','','',1,'','',165,1185,300,9180,'0,13',6,0,0,0,0,0,'',55,'',0,'','',0,2,0,0,0,0,0,'',0) 
GO

INSERT INTO ICClassTableInfo(FClassTypeID,FPage,FCaption_CHS,FCaption_CHT,FCaption_EN,FKey,FFieldName,FTableName,FTableNameAs,FListIndex,FListClassName,FVisible,FEnable,FNeedSave,FMustInput,FCtlType,FProperty,FLookUpType,FLookUpClassID,FLookUpList,FSRCFieldName,FSRCTableName,FSRCTableNameAs,FDSPFieldName,FFNDFieldName,FValueLocation,FFilter,FFilterGroup,FValueType,FDspColType,FEditlen,FValuePrecision,FSaveRule,FDefValue,FAction,FUserDefine,FNote,FKeyWord,FLeft,FTop,FHeight,FWidth,FCondition,FTabIndex,FLock,FSum,FPrec,FScale,FLayer,FLoadAction,FUnControl,FFont,FSourceType,FSubKey,FParentKey,FConditionExt,FFrameBorder,FFrameBorderColor,FLabelWidth,FLabelColor,FTextColor,FIsF7,FContainer,FStyle) 
VALUES (200000024,1,'审核','用戶','User','FChecker','FChecker','t_BOSChangeStockRequest','',4,2,-1,1,1,0,1,'',7,9,'','FUserID','t_User','','FName','FName',1,'','',56,500,255,4,'','0','',1,'','',4935,4950,345,1785,'0',7,-1,0,0,6,0,'',1,'',4,'','',1000000,2,0,0,0,0,0,'',0) 
GO

INSERT INTO ICClassTableInfo(FClassTypeID,FPage,FCaption_CHS,FCaption_CHT,FCaption_EN,FKey,FFieldName,FTableName,FTableNameAs,FListIndex,FListClassName,FVisible,FEnable,FNeedSave,FMustInput,FCtlType,FProperty,FLookUpType,FLookUpClassID,FLookUpList,FSRCFieldName,FSRCTableName,FSRCTableNameAs,FDSPFieldName,FFNDFieldName,FValueLocation,FFilter,FFilterGroup,FValueType,FDspColType,FEditlen,FValuePrecision,FSaveRule,FDefValue,FAction,FUserDefine,FNote,FKeyWord,FLeft,FTop,FHeight,FWidth,FCondition,FTabIndex,FLock,FSum,FPrec,FScale,FLayer,FLoadAction,FUnControl,FFont,FSourceType,FSubKey,FParentKey,FConditionExt,FFrameBorder,FFrameBorderColor,FLabelWidth,FLabelColor,FTextColor,FIsF7,FContainer,FStyle) 
VALUES (200000024,1,'制单人','制單人','Prep. by','FBiller','FBiller','t_BOSChangeStockRequest','',2,2,-1,-1,1,0,1,'',7,9,'','FUserID','t_User','t_User1','FName','FName',1,'','',56,500,255,4,'','','',1,'','USER',255,4950,345,1770,'0,9',8,-1,0,0,6,0,'',1,'',8,'','',0,2,0,0,0,0,0,'',0) 
GO

INSERT INTO ICClassTableInfo(FClassTypeID,FPage,FCaption_CHS,FCaption_CHT,FCaption_EN,FKey,FFieldName,FTableName,FTableNameAs,FListIndex,FListClassName,FVisible,FEnable,FNeedSave,FMustInput,FCtlType,FProperty,FLookUpType,FLookUpClassID,FLookUpList,FSRCFieldName,FSRCTableName,FSRCTableNameAs,FDSPFieldName,FFNDFieldName,FValueLocation,FFilter,FFilterGroup,FValueType,FDspColType,FEditlen,FValuePrecision,FSaveRule,FDefValue,FAction,FUserDefine,FNote,FKeyWord,FLeft,FTop,FHeight,FWidth,FCondition,FTabIndex,FLock,FSum,FPrec,FScale,FLayer,FLoadAction,FUnControl,FFont,FSourceType,FSubKey,FParentKey,FConditionExt,FFrameBorder,FFrameBorderColor,FLabelWidth,FLabelColor,FTextColor,FIsF7,FContainer,FStyle) 
VALUES (200000024,1,'审核日期','日期1','Date1','FCheckDate','FCheckDate','t_BOSChangeStockRequest','',6,2,-1,0,1,0,0,'',0,0,'','','','','','',1,'','',61,0,8,8,'','','',1,'','',7200,4950,315,2070,'2,13',9,-1,0,3,23,0,'',1,'',0,'','',0,2,0,0,0,0,0,'',0) 
GO

INSERT INTO ICClassTableInfo(FClassTypeID,FPage,FCaption_CHS,FCaption_CHT,FCaption_EN,FKey,FFieldName,FTableName,FTableNameAs,FListIndex,FListClassName,FVisible,FEnable,FNeedSave,FMustInput,FCtlType,FProperty,FLookUpType,FLookUpClassID,FLookUpList,FSRCFieldName,FSRCTableName,FSRCTableNameAs,FDSPFieldName,FFNDFieldName,FValueLocation,FFilter,FFilterGroup,FValueType,FDspColType,FEditlen,FValuePrecision,FSaveRule,FDefValue,FAction,FUserDefine,FNote,FKeyWord,FLeft,FTop,FHeight,FWidth,FCondition,FTabIndex,FLock,FSum,FPrec,FScale,FLayer,FLoadAction,FUnControl,FFont,FSourceType,FSubKey,FParentKey,FConditionExt,FFrameBorder,FFrameBorderColor,FLabelWidth,FLabelColor,FTextColor,FIsF7,FContainer,FStyle) 
VALUES (200000024,1,'事务类型','事務類型','Transaction Type','FClassTypeID','FClassTypeID','t_BOSChangeStockRequest','',8,2,0,1,1,0,1,'',0,0,'','FID','ICClassType','','FName','FName',1,'','',56,500,255,4,'','','',1,'','CLASSTYPEID',240,120,405,2535,'-1',10,0,0,0,0,0,'',1,'',0,'','',0,0,0,0,0,0,0,'',0) 
GO

INSERT INTO ICClassTableInfo(FClassTypeID,FPage,FCaption_CHS,FCaption_CHT,FCaption_EN,FKey,FFieldName,FTableName,FTableNameAs,FListIndex,FListClassName,FVisible,FEnable,FNeedSave,FMustInput,FCtlType,FProperty,FLookUpType,FLookUpClassID,FLookUpList,FSRCFieldName,FSRCTableName,FSRCTableNameAs,FDSPFieldName,FFNDFieldName,FValueLocation,FFilter,FFilterGroup,FValueType,FDspColType,FEditlen,FValuePrecision,FSaveRule,FDefValue,FAction,FUserDefine,FNote,FKeyWord,FLeft,FTop,FHeight,FWidth,FCondition,FTabIndex,FLock,FSum,FPrec,FScale,FLayer,FLoadAction,FUnControl,FFont,FSourceType,FSubKey,FParentKey,FConditionExt,FFrameBorder,FFrameBorderColor,FLabelWidth,FLabelColor,FTextColor,FIsF7,FContainer,FStyle) 
VALUES (200000024,1,'销售订单','文本1','Text1','FSeBillNo','FSeBillNo','t_BOSChangeStockRequest','',1,2,-1,0,1,0,1,'',0,0,'','','','','FName','',1,'','',167,500,50,50,'','','',1,'','',2235,4965,300,2595,'0,13',27,-1,0,0,0,0,'',19,'',0,'','',0,2,0,0,0,0,0,'',0) 
GO

INSERT INTO ICClassTableInfo(FClassTypeID,FPage,FCaption_CHS,FCaption_CHT,FCaption_EN,FKey,FFieldName,FTableName,FTableNameAs,FListIndex,FListClassName,FVisible,FEnable,FNeedSave,FMustInput,FCtlType,FProperty,FLookUpType,FLookUpClassID,FLookUpList,FSRCFieldName,FSRCTableName,FSRCTableNameAs,FDSPFieldName,FFNDFieldName,FValueLocation,FFilter,FFilterGroup,FValueType,FDspColType,FEditlen,FValuePrecision,FSaveRule,FDefValue,FAction,FUserDefine,FNote,FKeyWord,FLeft,FTop,FHeight,FWidth,FCondition,FTabIndex,FLock,FSum,FPrec,FScale,FLayer,FLoadAction,FUnControl,FFont,FSourceType,FSubKey,FParentKey,FConditionExt,FFrameBorder,FFrameBorderColor,FLabelWidth,FLabelColor,FTextColor,FIsF7,FContainer,FStyle) 
VALUES (200000024,1,'运算编号','文本2','Text2','FRunID','FRunID','t_BOSChangeStockRequest','',0,2,-1,0,1,0,1,'',0,0,'','','','','FName','',1,'','',167,500,50,50,'','','',1,'','',210,750,315,1890,'0,13',28,-1,0,0,0,0,'',19,'',0,'','',0,2,0,0,0,0,0,'',0) 
GO

INSERT INTO ICClassTableInfo(FClassTypeID,FPage,FCaption_CHS,FCaption_CHT,FCaption_EN,FKey,FFieldName,FTableName,FTableNameAs,FListIndex,FListClassName,FVisible,FEnable,FNeedSave,FMustInput,FCtlType,FProperty,FLookUpType,FLookUpClassID,FLookUpList,FSRCFieldName,FSRCTableName,FSRCTableNameAs,FDSPFieldName,FFNDFieldName,FValueLocation,FFilter,FFilterGroup,FValueType,FDspColType,FEditlen,FValuePrecision,FSaveRule,FDefValue,FAction,FUserDefine,FNote,FKeyWord,FLeft,FTop,FHeight,FWidth,FCondition,FTabIndex,FLock,FSum,FPrec,FScale,FLayer,FLoadAction,FUnControl,FFont,FSourceType,FSubKey,FParentKey,FConditionExt,FFrameBorder,FFrameBorderColor,FLabelWidth,FLabelColor,FTextColor,FIsF7,FContainer,FStyle) 
VALUES (200000024,2,'分录内码','分錄內碼','Entry ISN','FEntryID2','FEntryID','t_BOSChangeStockRequestEntry','',9,0,0,1,0,0,3,'',0,0,'','','','','','',1,'','',56,500,255,4,'','','',1,'','ENTRYKEY',240,120,350,1800,'-1',-1,0,0,0,0,0,'',1,'',0,'','',0,0,0,0,0,0,0,'',0) 
GO

INSERT INTO ICClassTableInfo(FClassTypeID,FPage,FCaption_CHS,FCaption_CHT,FCaption_EN,FKey,FFieldName,FTableName,FTableNameAs,FListIndex,FListClassName,FVisible,FEnable,FNeedSave,FMustInput,FCtlType,FProperty,FLookUpType,FLookUpClassID,FLookUpList,FSRCFieldName,FSRCTableName,FSRCTableNameAs,FDSPFieldName,FFNDFieldName,FValueLocation,FFilter,FFilterGroup,FValueType,FDspColType,FEditlen,FValuePrecision,FSaveRule,FDefValue,FAction,FUserDefine,FNote,FKeyWord,FLeft,FTop,FHeight,FWidth,FCondition,FTabIndex,FLock,FSum,FPrec,FScale,FLayer,FLoadAction,FUnControl,FFont,FSourceType,FSubKey,FParentKey,FConditionExt,FFrameBorder,FFrameBorderColor,FLabelWidth,FLabelColor,FTextColor,FIsF7,FContainer,FStyle) 
VALUES (200000024,2,'单据内码','單據內碼','Doc ISN','FID2','FID','t_BOSChangeStockRequestEntry','',29,0,0,1,1,1,3,'',0,0,'','','','','','',1,'','',56,500,255,4,'','','',1,'','PARENTID',240,120,350,1800,'-1',-1,0,0,0,0,0,'',1,'',0,'','',0,0,0,0,0,0,0,'',0) 
GO

INSERT INTO ICClassTableInfo(FClassTypeID,FPage,FCaption_CHS,FCaption_CHT,FCaption_EN,FKey,FFieldName,FTableName,FTableNameAs,FListIndex,FListClassName,FVisible,FEnable,FNeedSave,FMustInput,FCtlType,FProperty,FLookUpType,FLookUpClassID,FLookUpList,FSRCFieldName,FSRCTableName,FSRCTableNameAs,FDSPFieldName,FFNDFieldName,FValueLocation,FFilter,FFilterGroup,FValueType,FDspColType,FEditlen,FValuePrecision,FSaveRule,FDefValue,FAction,FUserDefine,FNote,FKeyWord,FLeft,FTop,FHeight,FWidth,FCondition,FTabIndex,FLock,FSum,FPrec,FScale,FLayer,FLoadAction,FUnControl,FFont,FSourceType,FSubKey,FParentKey,FConditionExt,FFrameBorder,FFrameBorderColor,FLabelWidth,FLabelColor,FTextColor,FIsF7,FContainer,FStyle) 
VALUES (200000024,2,'行号','行號','Row No.','FIndex2','FIndex','t_BOSChangeStockRequestEntry','',30,0,0,1,1,0,3,'',0,0,'','','','','','',1,'','',56,500,255,4,'','','',1,'','INDEX',240,120,350,1800,'-1',-1,-1,0,0,0,0,'',1,'',0,'','',0,0,0,0,0,0,0,'',0) 
GO

INSERT INTO ICClassTableInfo(FClassTypeID,FPage,FCaption_CHS,FCaption_CHT,FCaption_EN,FKey,FFieldName,FTableName,FTableNameAs,FListIndex,FListClassName,FVisible,FEnable,FNeedSave,FMustInput,FCtlType,FProperty,FLookUpType,FLookUpClassID,FLookUpList,FSRCFieldName,FSRCTableName,FSRCTableNameAs,FDSPFieldName,FFNDFieldName,FValueLocation,FFilter,FFilterGroup,FValueType,FDspColType,FEditlen,FValuePrecision,FSaveRule,FDefValue,FAction,FUserDefine,FNote,FKeyWord,FLeft,FTop,FHeight,FWidth,FCondition,FTabIndex,FLock,FSum,FPrec,FScale,FLayer,FLoadAction,FUnControl,FFont,FSourceType,FSubKey,FParentKey,FConditionExt,FFrameBorder,FFrameBorderColor,FLabelWidth,FLabelColor,FTextColor,FIsF7,FContainer,FStyle) 
VALUES (200000024,2,'物料','物料','Mtrl','FItemId','FItemId','t_BOSChangeStockRequestEntry','',10,0,-1,0,1,1,1,'',1,4,'','FItemID','t_ICItem','','FNumber','FNumber',1,'','',56,500,255,4,'','','TakeBaseData{FBaseProperty,FUnitId=FUnitID}',1,'','',5158,7738,346,1860,'0',0,0,0,0,10,0,'',21,'',1,'','',0,2,0,0,0,0,0,'',0) 
GO

INSERT INTO ICClassTableInfo(FClassTypeID,FPage,FCaption_CHS,FCaption_CHT,FCaption_EN,FKey,FFieldName,FTableName,FTableNameAs,FListIndex,FListClassName,FVisible,FEnable,FNeedSave,FMustInput,FCtlType,FProperty,FLookUpType,FLookUpClassID,FLookUpList,FSRCFieldName,FSRCTableName,FSRCTableNameAs,FDSPFieldName,FFNDFieldName,FValueLocation,FFilter,FFilterGroup,FValueType,FDspColType,FEditlen,FValuePrecision,FSaveRule,FDefValue,FAction,FUserDefine,FNote,FKeyWord,FLeft,FTop,FHeight,FWidth,FCondition,FTabIndex,FLock,FSum,FPrec,FScale,FLayer,FLoadAction,FUnControl,FFont,FSourceType,FSubKey,FParentKey,FConditionExt,FFrameBorder,FFrameBorderColor,FLabelWidth,FLabelColor,FTextColor,FIsF7,FContainer,FStyle) 
VALUES (200000024,2,'名称','基礎資料屬性','Master Data Property','FBaseProperty','FItemId','t_BOSChangeStockRequestEntry','',11,0,-1,0,0,0,1,'',0,4,'','FItemID','t_ICItem','','FName','',3,'','',167,500,255,0,'','','',1,'','',0,0,0,2500,'0',1,-1,0,0,0,0,'',55,'',2,'','',0,2,0,0,0,0,0,'',0) 
GO

INSERT INTO ICClassTableInfo(FClassTypeID,FPage,FCaption_CHS,FCaption_CHT,FCaption_EN,FKey,FFieldName,FTableName,FTableNameAs,FListIndex,FListClassName,FVisible,FEnable,FNeedSave,FMustInput,FCtlType,FProperty,FLookUpType,FLookUpClassID,FLookUpList,FSRCFieldName,FSRCTableName,FSRCTableNameAs,FDSPFieldName,FFNDFieldName,FValueLocation,FFilter,FFilterGroup,FValueType,FDspColType,FEditlen,FValuePrecision,FSaveRule,FDefValue,FAction,FUserDefine,FNote,FKeyWord,FLeft,FTop,FHeight,FWidth,FCondition,FTabIndex,FLock,FSum,FPrec,FScale,FLayer,FLoadAction,FUnControl,FFont,FSourceType,FSubKey,FParentKey,FConditionExt,FFrameBorder,FFrameBorderColor,FLabelWidth,FLabelColor,FTextColor,FIsF7,FContainer,FStyle) 
VALUES (200000024,2,'规格型号','基礎資料屬性2','Master Data Property2','FBaseProperty2','FItemId','t_BOSChangeStockRequestEntry','',18,0,-1,0,0,0,1,'',0,4,'','FItemID','t_ICItem','','FModel','',3,'','',167,500,255,0,'','','',1,'','',0,0,0,2500,'0',2,-1,0,0,0,0,'',55,'',2,'','',0,2,0,0,0,0,0,'',0) 
GO

INSERT INTO ICClassTableInfo(FClassTypeID,FPage,FCaption_CHS,FCaption_CHT,FCaption_EN,FKey,FFieldName,FTableName,FTableNameAs,FListIndex,FListClassName,FVisible,FEnable,FNeedSave,FMustInput,FCtlType,FProperty,FLookUpType,FLookUpClassID,FLookUpList,FSRCFieldName,FSRCTableName,FSRCTableNameAs,FDSPFieldName,FFNDFieldName,FValueLocation,FFilter,FFilterGroup,FValueType,FDspColType,FEditlen,FValuePrecision,FSaveRule,FDefValue,FAction,FUserDefine,FNote,FKeyWord,FLeft,FTop,FHeight,FWidth,FCondition,FTabIndex,FLock,FSum,FPrec,FScale,FLayer,FLoadAction,FUnControl,FFont,FSourceType,FSubKey,FParentKey,FConditionExt,FFrameBorder,FFrameBorderColor,FLabelWidth,FLabelColor,FTextColor,FIsF7,FContainer,FStyle) 
VALUES (200000024,2,'计量单位','計量單位','Unit of Measure (UoM)','FUnitId','FUnitId','t_BOSChangeStockRequestEntry','',20,0,-1,0,1,1,1,'FItemId.FUnitGroupID',6,7,'','FItemID','t_Measureunit','','FName','FNumber',1,'','',56,500,255,4,'','','',1,'','',5158,7738,346,1290,'0',3,0,0,0,10,0,'',17,'',1,'','',0,2,0,0,0,0,0,'',0) 
GO

INSERT INTO ICClassTableInfo(FClassTypeID,FPage,FCaption_CHS,FCaption_CHT,FCaption_EN,FKey,FFieldName,FTableName,FTableNameAs,FListIndex,FListClassName,FVisible,FEnable,FNeedSave,FMustInput,FCtlType,FProperty,FLookUpType,FLookUpClassID,FLookUpList,FSRCFieldName,FSRCTableName,FSRCTableNameAs,FDSPFieldName,FFNDFieldName,FValueLocation,FFilter,FFilterGroup,FValueType,FDspColType,FEditlen,FValuePrecision,FSaveRule,FDefValue,FAction,FUserDefine,FNote,FKeyWord,FLeft,FTop,FHeight,FWidth,FCondition,FTabIndex,FLock,FSum,FPrec,FScale,FLayer,FLoadAction,FUnControl,FFont,FSourceType,FSubKey,FParentKey,FConditionExt,FFrameBorder,FFrameBorderColor,FLabelWidth,FLabelColor,FTextColor,FIsF7,FContainer,FStyle) 
VALUES (200000024,2,'数量','數量','Quantity','FQty','FQty','t_BOSChangeStockRequestEntry','',27,0,-1,0,1,0,2,'FBase2',0,0,'','','','','','',1,'','',106,2,28,13,'','','',1,'','QTY',0,0,350,1320,'1,13',4,0,1,28,10,0,'',17,'',0,'','',0,2,0,0,0,0,0,'',0) 
GO

INSERT INTO ICClassTableInfo(FClassTypeID,FPage,FCaption_CHS,FCaption_CHT,FCaption_EN,FKey,FFieldName,FTableName,FTableNameAs,FListIndex,FListClassName,FVisible,FEnable,FNeedSave,FMustInput,FCtlType,FProperty,FLookUpType,FLookUpClassID,FLookUpList,FSRCFieldName,FSRCTableName,FSRCTableNameAs,FDSPFieldName,FFNDFieldName,FValueLocation,FFilter,FFilterGroup,FValueType,FDspColType,FEditlen,FValuePrecision,FSaveRule,FDefValue,FAction,FUserDefine,FNote,FKeyWord,FLeft,FTop,FHeight,FWidth,FCondition,FTabIndex,FLock,FSum,FPrec,FScale,FLayer,FLoadAction,FUnControl,FFont,FSourceType,FSubKey,FParentKey,FConditionExt,FFrameBorder,FFrameBorderColor,FLabelWidth,FLabelColor,FTextColor,FIsF7,FContainer,FStyle) 
VALUES (200000024,2,'调出仓库','倉庫1','Warehouse1','FSCStockID','FSCStockID','t_BOSChangeStockRequestEntry','',9,0,-1,0,1,1,1,'',1,5,'','FItemID','t_Stock','t_Stock1','FName','FNumber',1,'','',56,500,255,4,'','','',1,'','',5158,7738,346,2500,'0',5,0,0,0,10,0,'',17,'',1,'','',0,2,0,0,0,0,0,'',0) 
GO

INSERT INTO ICClassTableInfo(FClassTypeID,FPage,FCaption_CHS,FCaption_CHT,FCaption_EN,FKey,FFieldName,FTableName,FTableNameAs,FListIndex,FListClassName,FVisible,FEnable,FNeedSave,FMustInput,FCtlType,FProperty,FLookUpType,FLookUpClassID,FLookUpList,FSRCFieldName,FSRCTableName,FSRCTableNameAs,FDSPFieldName,FFNDFieldName,FValueLocation,FFilter,FFilterGroup,FValueType,FDspColType,FEditlen,FValuePrecision,FSaveRule,FDefValue,FAction,FUserDefine,FNote,FKeyWord,FLeft,FTop,FHeight,FWidth,FCondition,FTabIndex,FLock,FSum,FPrec,FScale,FLayer,FLoadAction,FUnControl,FFont,FSourceType,FSubKey,FParentKey,FConditionExt,FFrameBorder,FFrameBorderColor,FLabelWidth,FLabelColor,FTextColor,FIsF7,FContainer,FStyle) 
VALUES (200000024,2,'调入仓库','倉庫','Warehouse','FDCStockID','FDCStockID','t_BOSChangeStockRequestEntry','',12,0,-1,0,1,1,1,'',1,5,'','FItemID','t_Stock','','FName','FNumber',1,'','',56,500,255,4,'','','',1,'','',5158,7738,346,2500,'0',6,0,0,0,10,0,'',17,'',1,'','',0,2,0,0,0,0,0,'',0) 
GO

INSERT INTO ICClassTableInfo(FClassTypeID,FPage,FCaption_CHS,FCaption_CHT,FCaption_EN,FKey,FFieldName,FTableName,FTableNameAs,FListIndex,FListClassName,FVisible,FEnable,FNeedSave,FMustInput,FCtlType,FProperty,FLookUpType,FLookUpClassID,FLookUpList,FSRCFieldName,FSRCTableName,FSRCTableNameAs,FDSPFieldName,FFNDFieldName,FValueLocation,FFilter,FFilterGroup,FValueType,FDspColType,FEditlen,FValuePrecision,FSaveRule,FDefValue,FAction,FUserDefine,FNote,FKeyWord,FLeft,FTop,FHeight,FWidth,FCondition,FTabIndex,FLock,FSum,FPrec,FScale,FLayer,FLoadAction,FUnControl,FFont,FSourceType,FSubKey,FParentKey,FConditionExt,FFrameBorder,FFrameBorderColor,FLabelWidth,FLabelColor,FTextColor,FIsF7,FContainer,FStyle) 
VALUES (200000024,2,'备注','文本','Text','FRemark','FRemark','t_BOSChangeStockRequestEntry','',34,0,-1,0,1,0,1,'',0,0,'','','','','FName','',1,'','',167,500,50,50,'','','',1,'','',0,0,350,2500,'0,13',7,0,0,0,0,0,'',19,'',0,'','',0,2,0,0,0,0,0,'',0) 
GO

INSERT INTO ICClassTableInfo(FClassTypeID,FPage,FCaption_CHS,FCaption_CHT,FCaption_EN,FKey,FFieldName,FTableName,FTableNameAs,FListIndex,FListClassName,FVisible,FEnable,FNeedSave,FMustInput,FCtlType,FProperty,FLookUpType,FLookUpClassID,FLookUpList,FSRCFieldName,FSRCTableName,FSRCTableNameAs,FDSPFieldName,FFNDFieldName,FValueLocation,FFilter,FFilterGroup,FValueType,FDspColType,FEditlen,FValuePrecision,FSaveRule,FDefValue,FAction,FUserDefine,FNote,FKeyWord,FLeft,FTop,FHeight,FWidth,FCondition,FTabIndex,FLock,FSum,FPrec,FScale,FLayer,FLoadAction,FUnControl,FFont,FSourceType,FSubKey,FParentKey,FConditionExt,FFrameBorder,FFrameBorderColor,FLabelWidth,FLabelColor,FTextColor,FIsF7,FContainer,FStyle) 
VALUES (200000024,2,'产品','物料1','Mtrl1','FProductID','FProductID','t_BOSChangeStockRequestEntry','',17,0,-1,0,1,0,1,'',1,4,'','FItemID','t_ICItem','t_ICItem1','FNumber','FNumber',1,'','',56,500,255,4,'','','',1,'','',5158,7738,346,2500,'0',8,-1,0,0,10,0,'',17,'',1,'','',0,2,0,0,0,0,0,'',0) 
GO

INSERT INTO ICClassTableInfo(FClassTypeID,FPage,FCaption_CHS,FCaption_CHT,FCaption_EN,FKey,FFieldName,FTableName,FTableNameAs,FListIndex,FListClassName,FVisible,FEnable,FNeedSave,FMustInput,FCtlType,FProperty,FLookUpType,FLookUpClassID,FLookUpList,FSRCFieldName,FSRCTableName,FSRCTableNameAs,FDSPFieldName,FFNDFieldName,FValueLocation,FFilter,FFilterGroup,FValueType,FDspColType,FEditlen,FValuePrecision,FSaveRule,FDefValue,FAction,FUserDefine,FNote,FKeyWord,FLeft,FTop,FHeight,FWidth,FCondition,FTabIndex,FLock,FSum,FPrec,FScale,FLayer,FLoadAction,FUnControl,FFont,FSourceType,FSubKey,FParentKey,FConditionExt,FFrameBorder,FFrameBorderColor,FLabelWidth,FLabelColor,FTextColor,FIsF7,FContainer,FStyle) 
VALUES (200000024,2,'产品名称','基礎資料屬性1','Master Data Property1','FBaseProperty1','FProductID','t_BOSChangeStockRequestEntry','',19,0,-1,0,0,0,1,'',0,4,'','FItemID','t_ICItem','t_ICItem1','FName','',3,'','',167,500,255,0,'','','',1,'','',0,0,0,2500,'0',9,-1,0,0,0,0,'',55,'',2,'','',0,2,0,0,0,0,0,'',0) 
GO

INSERT INTO ICClassTableInfo(FClassTypeID,FPage,FCaption_CHS,FCaption_CHT,FCaption_EN,FKey,FFieldName,FTableName,FTableNameAs,FListIndex,FListClassName,FVisible,FEnable,FNeedSave,FMustInput,FCtlType,FProperty,FLookUpType,FLookUpClassID,FLookUpList,FSRCFieldName,FSRCTableName,FSRCTableNameAs,FDSPFieldName,FFNDFieldName,FValueLocation,FFilter,FFilterGroup,FValueType,FDspColType,FEditlen,FValuePrecision,FSaveRule,FDefValue,FAction,FUserDefine,FNote,FKeyWord,FLeft,FTop,FHeight,FWidth,FCondition,FTabIndex,FLock,FSum,FPrec,FScale,FLayer,FLoadAction,FUnControl,FFont,FSourceType,FSubKey,FParentKey,FConditionExt,FFrameBorder,FFrameBorderColor,FLabelWidth,FLabelColor,FTextColor,FIsF7,FContainer,FStyle) 
VALUES (200000024,2,'关联数','數量1','Quantity1','FCommitQty','FCommitQty','t_BOSChangeStockRequestEntry','',28,0,12,0,1,0,2,'FUnitId',0,0,'','','','','','',1,'','',106,2,28,13,'','','',1,'','QTY',0,0,350,2500,'1,13',10,-1,1,28,10,0,'',17,'',0,'','',0,2,0,0,0,0,0,'',0) 
GO

INSERT INTO ICClassTableInfo(FClassTypeID,FPage,FCaption_CHS,FCaption_CHT,FCaption_EN,FKey,FFieldName,FTableName,FTableNameAs,FListIndex,FListClassName,FVisible,FEnable,FNeedSave,FMustInput,FCtlType,FProperty,FLookUpType,FLookUpClassID,FLookUpList,FSRCFieldName,FSRCTableName,FSRCTableNameAs,FDSPFieldName,FFNDFieldName,FValueLocation,FFilter,FFilterGroup,FValueType,FDspColType,FEditlen,FValuePrecision,FSaveRule,FDefValue,FAction,FUserDefine,FNote,FKeyWord,FLeft,FTop,FHeight,FWidth,FCondition,FTabIndex,FLock,FSum,FPrec,FScale,FLayer,FLoadAction,FUnControl,FFont,FSourceType,FSubKey,FParentKey,FConditionExt,FFrameBorder,FFrameBorderColor,FLabelWidth,FLabelColor,FTextColor,FIsF7,FContainer,FStyle) 
VALUES (200000024,2,'备损率(%)','小數','Decimal Fraction','FPrepScrap','FPrepScrap','t_BOSChangeStockRequestEntry','',23,0,12,0,1,0,2,'',0,0,'','','','','','',1,'','',106,9,20,13,'','','',1,'','',0,0,350,0,'1,13',11,-1,0,28,2,0,'',17,'',0,'','',0,2,0,0,0,0,0,'',0) 
GO

INSERT INTO ICClassTableInfo(FClassTypeID,FPage,FCaption_CHS,FCaption_CHT,FCaption_EN,FKey,FFieldName,FTableName,FTableNameAs,FListIndex,FListClassName,FVisible,FEnable,FNeedSave,FMustInput,FCtlType,FProperty,FLookUpType,FLookUpClassID,FLookUpList,FSRCFieldName,FSRCTableName,FSRCTableNameAs,FDSPFieldName,FFNDFieldName,FValueLocation,FFilter,FFilterGroup,FValueType,FDspColType,FEditlen,FValuePrecision,FSaveRule,FDefValue,FAction,FUserDefine,FNote,FKeyWord,FLeft,FTop,FHeight,FWidth,FCondition,FTabIndex,FLock,FSum,FPrec,FScale,FLayer,FLoadAction,FUnControl,FFont,FSourceType,FSubKey,FParentKey,FConditionExt,FFrameBorder,FFrameBorderColor,FLabelWidth,FLabelColor,FTextColor,FIsF7,FContainer,FStyle) 
VALUES (200000024,2,'备损数','數量2','Quantity2','FPrepScrapQty','FPrepScrapQty','t_BOSChangeStockRequestEntry','',24,0,12,0,1,0,2,'FUnitId',0,0,'','','','','','',1,'','',106,9,28,13,'','','',1,'','QTY',0,0,350,0,'1,13',12,-1,1,28,10,0,'',17,'',0,'','',0,2,0,0,0,0,0,'',0) 
GO

INSERT INTO ICClassTableInfo(FClassTypeID,FPage,FCaption_CHS,FCaption_CHT,FCaption_EN,FKey,FFieldName,FTableName,FTableNameAs,FListIndex,FListClassName,FVisible,FEnable,FNeedSave,FMustInput,FCtlType,FProperty,FLookUpType,FLookUpClassID,FLookUpList,FSRCFieldName,FSRCTableName,FSRCTableNameAs,FDSPFieldName,FFNDFieldName,FValueLocation,FFilter,FFilterGroup,FValueType,FDspColType,FEditlen,FValuePrecision,FSaveRule,FDefValue,FAction,FUserDefine,FNote,FKeyWord,FLeft,FTop,FHeight,FWidth,FCondition,FTabIndex,FLock,FSum,FPrec,FScale,FLayer,FLoadAction,FUnControl,FFont,FSourceType,FSubKey,FParentKey,FConditionExt,FFrameBorder,FFrameBorderColor,FLabelWidth,FLabelColor,FTextColor,FIsF7,FContainer,FStyle) 
VALUES (200000024,2,'损耗率(%)','小數1','Decimal Fraction1','FScrap','FScrap','t_BOSChangeStockRequestEntry','',25,0,12,0,1,0,2,'',0,0,'','','','','','',1,'','',106,9,20,13,'','','',1,'','',0,0,350,0,'1,13',13,-1,0,28,2,0,'',17,'',0,'','',0,2,0,0,0,0,0,'',0) 
GO

INSERT INTO ICClassTableInfo(FClassTypeID,FPage,FCaption_CHS,FCaption_CHT,FCaption_EN,FKey,FFieldName,FTableName,FTableNameAs,FListIndex,FListClassName,FVisible,FEnable,FNeedSave,FMustInput,FCtlType,FProperty,FLookUpType,FLookUpClassID,FLookUpList,FSRCFieldName,FSRCTableName,FSRCTableNameAs,FDSPFieldName,FFNDFieldName,FValueLocation,FFilter,FFilterGroup,FValueType,FDspColType,FEditlen,FValuePrecision,FSaveRule,FDefValue,FAction,FUserDefine,FNote,FKeyWord,FLeft,FTop,FHeight,FWidth,FCondition,FTabIndex,FLock,FSum,FPrec,FScale,FLayer,FLoadAction,FUnControl,FFont,FSourceType,FSubKey,FParentKey,FConditionExt,FFrameBorder,FFrameBorderColor,FLabelWidth,FLabelColor,FTextColor,FIsF7,FContainer,FStyle) 
VALUES (200000024,2,'损耗数','數量3','Quantity3','FScrapQty','FScrapQty','t_BOSChangeStockRequestEntry','',26,0,12,0,1,0,2,'FUnitId',0,0,'','','','','','',1,'','',106,2,28,13,'','','',1,'','QTY',0,0,350,0,'1,13',14,-1,1,28,10,0,'',17,'',0,'','',0,2,0,0,0,0,0,'',0) 
GO

INSERT INTO ICClassTableInfo(FClassTypeID,FPage,FCaption_CHS,FCaption_CHT,FCaption_EN,FKey,FFieldName,FTableName,FTableNameAs,FListIndex,FListClassName,FVisible,FEnable,FNeedSave,FMustInput,FCtlType,FProperty,FLookUpType,FLookUpClassID,FLookUpList,FSRCFieldName,FSRCTableName,FSRCTableNameAs,FDSPFieldName,FFNDFieldName,FValueLocation,FFilter,FFilterGroup,FValueType,FDspColType,FEditlen,FValuePrecision,FSaveRule,FDefValue,FAction,FUserDefine,FNote,FKeyWord,FLeft,FTop,FHeight,FWidth,FCondition,FTabIndex,FLock,FSum,FPrec,FScale,FLayer,FLoadAction,FUnControl,FFont,FSourceType,FSubKey,FParentKey,FConditionExt,FFrameBorder,FFrameBorderColor,FLabelWidth,FLabelColor,FTextColor,FIsF7,FContainer,FStyle) 
VALUES (200000024,2,'系数','數量4','Quantity4','FPerQty','FPerQty','t_BOSChangeStockRequestEntry','',22,0,12,0,1,0,2,'FUnitId',0,0,'','','','','','',1,'','',106,2,28,13,'','','',1,'','QTY',0,0,350,0,'1,13',15,-1,0,28,10,0,'',17,'',0,'','',0,2,0,0,0,0,0,'',0) 
GO

INSERT INTO ICClassTableInfo(FClassTypeID,FPage,FCaption_CHS,FCaption_CHT,FCaption_EN,FKey,FFieldName,FTableName,FTableNameAs,FListIndex,FListClassName,FVisible,FEnable,FNeedSave,FMustInput,FCtlType,FProperty,FLookUpType,FLookUpClassID,FLookUpList,FSRCFieldName,FSRCTableName,FSRCTableNameAs,FDSPFieldName,FFNDFieldName,FValueLocation,FFilter,FFilterGroup,FValueType,FDspColType,FEditlen,FValuePrecision,FSaveRule,FDefValue,FAction,FUserDefine,FNote,FKeyWord,FLeft,FTop,FHeight,FWidth,FCondition,FTabIndex,FLock,FSum,FPrec,FScale,FLayer,FLoadAction,FUnControl,FFont,FSourceType,FSubKey,FParentKey,FConditionExt,FFrameBorder,FFrameBorderColor,FLabelWidth,FLabelColor,FTextColor,FIsF7,FContainer,FStyle) 
VALUES (200000024,2,'用量','數量5','Quantity5','FBomQty','FBomQty','t_BOSChangeStockRequestEntry','',21,0,12,0,1,0,2,'FUnitId',0,0,'','','','','','',1,'','',106,2,28,13,'','','',1,'','QTY',0,0,350,0,'1,13',16,-1,1,28,10,0,'',17,'',0,'','',0,2,0,0,0,0,0,'',0) 
GO

INSERT INTO ICClassTableInfo(FClassTypeID,FPage,FCaption_CHS,FCaption_CHT,FCaption_EN,FKey,FFieldName,FTableName,FTableNameAs,FListIndex,FListClassName,FVisible,FEnable,FNeedSave,FMustInput,FCtlType,FProperty,FLookUpType,FLookUpClassID,FLookUpList,FSRCFieldName,FSRCTableName,FSRCTableNameAs,FDSPFieldName,FFNDFieldName,FValueLocation,FFilter,FFilterGroup,FValueType,FDspColType,FEditlen,FValuePrecision,FSaveRule,FDefValue,FAction,FUserDefine,FNote,FKeyWord,FLeft,FTop,FHeight,FWidth,FCondition,FTabIndex,FLock,FSum,FPrec,FScale,FLayer,FLoadAction,FUnControl,FFont,FSourceType,FSubKey,FParentKey,FConditionExt,FFrameBorder,FFrameBorderColor,FLabelWidth,FLabelColor,FTextColor,FIsF7,FContainer,FStyle) 
VALUES (200000024,2,'关联调拨数','數量6','Quantity6','FCGStockQty','FCGStockQty','t_BOSChangeStockRequestEntry','',31,0,-1,0,1,0,2,'FUnitId',0,0,'','','','','','',1,'','',106,2,28,13,'','','',1,'','QTY',0,0,350,2500,'1,13',17,-1,1,28,10,0,'',17,'',0,'','',0,2,0,0,0,0,0,'',0) 
GO

INSERT INTO ICClassTableInfo(FClassTypeID,FPage,FCaption_CHS,FCaption_CHT,FCaption_EN,FKey,FFieldName,FTableName,FTableNameAs,FListIndex,FListClassName,FVisible,FEnable,FNeedSave,FMustInput,FCtlType,FProperty,FLookUpType,FLookUpClassID,FLookUpList,FSRCFieldName,FSRCTableName,FSRCTableNameAs,FDSPFieldName,FFNDFieldName,FValueLocation,FFilter,FFilterGroup,FValueType,FDspColType,FEditlen,FValuePrecision,FSaveRule,FDefValue,FAction,FUserDefine,FNote,FKeyWord,FLeft,FTop,FHeight,FWidth,FCondition,FTabIndex,FLock,FSum,FPrec,FScale,FLayer,FLoadAction,FUnControl,FFont,FSourceType,FSubKey,FParentKey,FConditionExt,FFrameBorder,FFrameBorderColor,FLabelWidth,FLabelColor,FTextColor,FIsF7,FContainer,FStyle) 
VALUES (200000024,2,'供应商','供應商','Vendor','FSupplyID','FSupplyID','t_BOSChangeStockRequestEntry','',33,0,-1,0,1,0,1,'',1,8,'','FItemID','t_Supplier','','FName','FNumber',1,'','',56,500,255,4,'','','',1,'','',5158,7738,346,2500,'0',18,0,0,0,10,0,'',17,'',1,'','',0,2,0,0,0,0,0,'',0) 
GO

INSERT INTO ICClassTableInfo(FClassTypeID,FPage,FCaption_CHS,FCaption_CHT,FCaption_EN,FKey,FFieldName,FTableName,FTableNameAs,FListIndex,FListClassName,FVisible,FEnable,FNeedSave,FMustInput,FCtlType,FProperty,FLookUpType,FLookUpClassID,FLookUpList,FSRCFieldName,FSRCTableName,FSRCTableNameAs,FDSPFieldName,FFNDFieldName,FValueLocation,FFilter,FFilterGroup,FValueType,FDspColType,FEditlen,FValuePrecision,FSaveRule,FDefValue,FAction,FUserDefine,FNote,FKeyWord,FLeft,FTop,FHeight,FWidth,FCondition,FTabIndex,FLock,FSum,FPrec,FScale,FLayer,FLoadAction,FUnControl,FFont,FSourceType,FSubKey,FParentKey,FConditionExt,FFrameBorder,FFrameBorderColor,FLabelWidth,FLabelColor,FTextColor,FIsF7,FContainer,FStyle) 
VALUES (200000024,2,'未调拨数','數量7','Quantity7','FNoOutStockQty','FNoOutStockQty','t_BOSChangeStockRequestEntry','',32,0,-1,0,1,0,2,'FUnitId',0,0,'','','','','','',1,'','',106,9,28,13,'','','',1,'','QTY',0,0,350,2500,'1,13',19,-1,1,28,10,0,'',17,'',0,'','',0,2,0,0,0,0,0,'',0) 
GO

INSERT INTO ICClassTableInfo(FClassTypeID,FPage,FCaption_CHS,FCaption_CHT,FCaption_EN,FKey,FFieldName,FTableName,FTableNameAs,FListIndex,FListClassName,FVisible,FEnable,FNeedSave,FMustInput,FCtlType,FProperty,FLookUpType,FLookUpClassID,FLookUpList,FSRCFieldName,FSRCTableName,FSRCTableNameAs,FDSPFieldName,FFNDFieldName,FValueLocation,FFilter,FFilterGroup,FValueType,FDspColType,FEditlen,FValuePrecision,FSaveRule,FDefValue,FAction,FUserDefine,FNote,FKeyWord,FLeft,FTop,FHeight,FWidth,FCondition,FTabIndex,FLock,FSum,FPrec,FScale,FLayer,FLoadAction,FUnControl,FFont,FSourceType,FSubKey,FParentKey,FConditionExt,FFrameBorder,FFrameBorderColor,FLabelWidth,FLabelColor,FTextColor,FIsF7,FContainer,FStyle) 
VALUES (200000024,2,'是否倒冲','基礎資料屬性3','Master Data Property3','FBaseProperty3','FItemId','t_BOSChangeStockRequestEntry','',9,0,-1,0,0,0,1,'',0,4,'','FItemID','t_ICItem','','F_105','',3,'','',167,500,255,0,'','','',1,'','',0,0,0,2500,'0',20,-1,0,0,0,0,'',55,'',2,'','',0,2,0,0,0,0,0,'',0) 
GO

INSERT INTO ICClassTableInfo(FClassTypeID,FPage,FCaption_CHS,FCaption_CHT,FCaption_EN,FKey,FFieldName,FTableName,FTableNameAs,FListIndex,FListClassName,FVisible,FEnable,FNeedSave,FMustInput,FCtlType,FProperty,FLookUpType,FLookUpClassID,FLookUpList,FSRCFieldName,FSRCTableName,FSRCTableNameAs,FDSPFieldName,FFNDFieldName,FValueLocation,FFilter,FFilterGroup,FValueType,FDspColType,FEditlen,FValuePrecision,FSaveRule,FDefValue,FAction,FUserDefine,FNote,FKeyWord,FLeft,FTop,FHeight,FWidth,FCondition,FTabIndex,FLock,FSum,FPrec,FScale,FLayer,FLoadAction,FUnControl,FFont,FSourceType,FSubKey,FParentKey,FConditionExt,FFrameBorder,FFrameBorderColor,FLabelWidth,FLabelColor,FTextColor,FIsF7,FContainer,FStyle) 
VALUES (200000024,2,'物料属性','基礎資料屬性4','Master Data Property4','FBaseProperty4','FItemId','t_BOSChangeStockRequestEntry','',9,0,-1,0,0,0,1,'',0,4,'','FItemID','t_ICItem','','FErpClsID','',3,'','',167,500,255,0,'','','',1,'','',0,0,0,2500,'0',21,-1,0,0,0,0,'',55,'',2,'','',0,2,0,0,0,0,0,'',0) 
GO

INSERT INTO ICClassTableInfo(FClassTypeID,FPage,FCaption_CHS,FCaption_CHT,FCaption_EN,FKey,FFieldName,FTableName,FTableNameAs,FListIndex,FListClassName,FVisible,FEnable,FNeedSave,FMustInput,FCtlType,FProperty,FLookUpType,FLookUpClassID,FLookUpList,FSRCFieldName,FSRCTableName,FSRCTableNameAs,FDSPFieldName,FFNDFieldName,FValueLocation,FFilter,FFilterGroup,FValueType,FDspColType,FEditlen,FValuePrecision,FSaveRule,FDefValue,FAction,FUserDefine,FNote,FKeyWord,FLeft,FTop,FHeight,FWidth,FCondition,FTabIndex,FLock,FSum,FPrec,FScale,FLayer,FLoadAction,FUnControl,FFont,FSourceType,FSubKey,FParentKey,FConditionExt,FFrameBorder,FFrameBorderColor,FLabelWidth,FLabelColor,FTextColor,FIsF7,FContainer,FStyle) 
VALUES (200000024,2,'仓管员','基礎資料屬性5','Master Data Property5','FBaseProperty5','FItemId','t_BOSChangeStockRequestEntry','',9,0,-1,0,0,0,1,'',0,4,'','FItemID','t_ICItem','','F_106','',3,'','',167,500,255,0,'','','',1,'','',0,0,0,2500,'0',26,-1,0,0,0,0,'',55,'',2,'','',0,2,0,0,0,0,0,'',0) 
GO

INSERT INTO ICClassTableInfo(FClassTypeID,FPage,FCaption_CHS,FCaption_CHT,FCaption_EN,FKey,FFieldName,FTableName,FTableNameAs,FListIndex,FListClassName,FVisible,FEnable,FNeedSave,FMustInput,FCtlType,FProperty,FLookUpType,FLookUpClassID,FLookUpList,FSRCFieldName,FSRCTableName,FSRCTableNameAs,FDSPFieldName,FFNDFieldName,FValueLocation,FFilter,FFilterGroup,FValueType,FDspColType,FEditlen,FValuePrecision,FSaveRule,FDefValue,FAction,FUserDefine,FNote,FKeyWord,FLeft,FTop,FHeight,FWidth,FCondition,FTabIndex,FLock,FSum,FPrec,FScale,FLayer,FLoadAction,FUnControl,FFont,FSourceType,FSubKey,FParentKey,FConditionExt,FFrameBorder,FFrameBorderColor,FLabelWidth,FLabelColor,FTextColor,FIsF7,FContainer,FStyle) 
VALUES (200000024,2,'库存数','小數2','Decimal Fraction2','FInvQty','FInvQty','t_BOSChangeStockRequestEntry','',9,0,-1,0,1,0,2,'',0,0,'','','','','','',1,'','',106,9,20,13,'','','',1,'','',0,0,350,2500,'1,13',27,-1,0,28,2,0,'',17,'',0,'','',0,2,0,0,0,0,0,'',0) 
GO

/****** Object:Data   单据模板通用控件描述：ICClassCtl    Script Date: 2014-01-09 ******/

Delete ICClassCtl WHERE FClassTypeID=200000024
GO
/****** Object:Data   单据编号：ICBillNo    Script Date: 2014-01-09 ******/

 IF NOT EXISTS (SELECT * FROM  ICBillNo WHERE FBillID=200000024) 
 BEGIN 
  INSERT INTO ICBillNo(FBillID,FBillName,FPreLetter,FSufLetter,FCurNo,FBillName_CHT,FBillName_EN,FFormat,FPos,FCanAlterBillNo,FCheckAfterSave,FUseBillCodeRule,FDesc) 
  VALUES (200000024,'调拨申请单_BOS','','',774,'單據200000024_BOS','Doc200000024_BOS','00000000',200000024,0,0,1,'BF+000762') 
end 

GO

/****** Object:Data   单据编号：t_BillCodeRule    Script Date: 2014-01-09 ******/

 IF NOT EXISTS (SELECT * FROM  t_BillCodeRule WHERE FBillTypeID=200000024) 
 BEGIN 
INSERT INTO t_BillCodeRule(FBillTypeID,FClassIndex,FProjectID,FProjectVal,FFormatIndex,FLength,FAddChar,FReChar,FBillType,FIsBy) 
VALUES ('200000024',1,1,'BF',0,2,'','','',0) 

INSERT INTO t_BillCodeRule(FBillTypeID,FClassIndex,FProjectID,FProjectVal,FFormatIndex,FLength,FAddChar,FReChar,FBillType,FIsBy) 
VALUES ('200000024',2,3,'774',0,6,'','','',0) 

 END 

/****** Object:Data   单据权限类弄表：t_ObjectAccessType    Script Date: 2014-01-09 ******/

Delete t_ObjectAccessType WHERE FObjectType=4100 And FObjectID =200000024
GO
INSERT INTO t_ObjectAccessType(FObjectType,FObjectID,FIndex,FAccessMask,FAccessUse,FName,FDescription,FName_cht,FName_en,FDescription_cht,FDescription_en) 
VALUES (4100,200000024,1,2097152,1048576,'查看','查看','查看','View','查看','View') 
GO

INSERT INTO t_ObjectAccessType(FObjectType,FObjectID,FIndex,FAccessMask,FAccessUse,FName,FDescription,FName_cht,FName_en,FDescription_cht,FDescription_en) 
VALUES (4100,200000024,2,1024,0,'查看凭证','查看凭证','查看凭证','查看凭证','查看凭证','查看凭证') 
GO

INSERT INTO t_ObjectAccessType(FObjectType,FObjectID,FIndex,FAccessMask,FAccessUse,FName,FDescription,FName_cht,FName_en,FDescription_cht,FDescription_en) 
VALUES (4100,200000024,3,131072,3145728,'新增','新增','新增','New','新增','New') 
GO

INSERT INTO t_ObjectAccessType(FObjectType,FObjectID,FIndex,FAccessMask,FAccessUse,FName,FDescription,FName_cht,FName_en,FDescription_cht,FDescription_en) 
VALUES (4100,200000024,4,65536,3145728,'删除','删除','刪除','Delete','刪除','Delete') 
GO

INSERT INTO t_ObjectAccessType(FObjectType,FObjectID,FIndex,FAccessMask,FAccessUse,FName,FDescription,FName_cht,FName_en,FDescription_cht,FDescription_en) 
VALUES (4100,200000024,5,4194304,3145728,'修改','修改','修改','Edit','修改','Edit') 
GO

INSERT INTO t_ObjectAccessType(FObjectType,FObjectID,FIndex,FAccessMask,FAccessUse,FName,FDescription,FName_cht,FName_en,FDescription_cht,FDescription_en) 
VALUES (4100,200000024,6,16,3145728,'引出内部数据','引出内部数据','引出內部資料','Export','引出內部資料','Export') 
GO

INSERT INTO t_ObjectAccessType(FObjectType,FObjectID,FIndex,FAccessMask,FAccessUse,FName,FDescription,FName_cht,FName_en,FDescription_cht,FDescription_en) 
VALUES (4100,200000024,7,32768,3145728,'打印','打印','列印','Print','列印','Print') 
GO

INSERT INTO t_ObjectAccessType(FObjectType,FObjectID,FIndex,FAccessMask,FAccessUse,FName,FDescription,FName_cht,FName_en,FDescription_cht,FDescription_en) 
VALUES (4100,200000024,8,128,0,'按单生成凭证','按单生成凭证','按单生成凭证','按单生成凭证','按单生成凭证','按单生成凭证') 
GO

INSERT INTO t_ObjectAccessType(FObjectType,FObjectID,FIndex,FAccessMask,FAccessUse,FName,FDescription,FName_cht,FName_en,FDescription_cht,FDescription_en) 
VALUES (4100,200000024,9,512,0,'合并生成凭证','合并生成凭证','合并生成凭证','合并生成凭证','合并生成凭证','合并生成凭证') 
GO

/****** Object:Data   单据权限对象表：t_ObjectType    Script Date: 2014-01-09 ******/

Delete t_ObjectType WHERE FObjectType=4100 And FObjectID =200000024
GO
INSERT INTO t_ObjectType(FObjectType,FObjectID,FName,FDescription,FName_cht,FName_en,FDescription_cht,FDescription_en) 
VALUES (4100,200000024,'调拨申请单','','單據200000024','Doc200000024',NULL,NULL) 
GO

/****** Object:Data   单据权限表：t_ObjectAccess    Script Date: 2014-01-09 ******/

Delete t_ObjectAccess WHERE FObjectType=4100 And FObjectID =200000024
GO
INSERT INTO t_ObjectAccess(FGroupID,FObjectType,FObjectID,FIndex) 
VALUES (2101,4100,200000024,0) 
GO

INSERT INTO t_ObjectAccess(FGroupID,FObjectType,FObjectID,FIndex) 
VALUES (2101,4100,200000024,1) 
GO

INSERT INTO t_ObjectAccess(FGroupID,FObjectType,FObjectID,FIndex) 
VALUES (2102,4100,200000024,0) 
GO

INSERT INTO t_ObjectAccess(FGroupID,FObjectType,FObjectID,FIndex) 
VALUES (2102,4100,200000024,1) 
GO

INSERT INTO t_ObjectAccess(FGroupID,FObjectType,FObjectID,FIndex) 
VALUES (2102,4100,200000024,2) 
GO

INSERT INTO t_ObjectAccess(FGroupID,FObjectType,FObjectID,FIndex) 
VALUES (2102,4100,200000024,3) 
GO

INSERT INTO t_ObjectAccess(FGroupID,FObjectType,FObjectID,FIndex) 
VALUES (2102,4100,200000024,4) 
GO

INSERT INTO t_ObjectAccess(FGroupID,FObjectType,FObjectID,FIndex) 
VALUES (2102,4100,200000024,5) 
GO

INSERT INTO t_ObjectAccess(FGroupID,FObjectType,FObjectID,FIndex) 
VALUES (2102,4100,200000024,6) 
GO

INSERT INTO t_ObjectAccess(FGroupID,FObjectType,FObjectID,FIndex) 
VALUES (2102,4100,200000024,7) 
GO

INSERT INTO t_ObjectAccess(FGroupID,FObjectType,FObjectID,FIndex) 
VALUES (2102,4100,200000024,8) 
GO

INSERT INTO t_ObjectAccess(FGroupID,FObjectType,FObjectID,FIndex) 
VALUES (2102,4100,200000024,9) 
GO

/****** Object:Data   选单关联：ICClassLink    Script Date: 2014-01-09 ******/

Delete ICClassLink WHERE FDestClassTypeID = 200000024 OR FSourClassTypeID =  200000024
GO
INSERT INTO ICClassLink(FSourClassTypeID,FDestClassTypeID,FSourBillShowIndex,FAllowCopy,FAllowCheck,FAllowForceCheck,FFlowControl,FDeCondition,FCondition,FDeHCondition,FDeBCondition,FSourBillFID,FSourBillFEntryID,FSourBillFBillNo,FObjectName,FObjectType,FObjectID,FIsUsed,FUsePage,FDefaultPage,FSRCIDKey,FSRCEntryIDKey,FSRCBillNoKey,FSRCClassIDKey,FISUserDefine,FDestTranTypeID,FSourTranTypeID,FSelectListID,FMustSelected,FSystemReserved,FROB,FFieldName,FRemark,FUseSpec,FSrcDestPage,FSrcPage,FToRed,FSourTypeID,FDestTypeID,FLookUpConditionUp,FLookUpConditionDown,FDefault) 
VALUES (200000024,-41,0,0,1,0,0,'','isnull(t_BOSChangeStockRequest.FChecker,0)>0','','','FID','FEntryID2','FBillNo','',0,0,0,',1,2,',',1,2,','FSourceInterID','FSourceEntryID','FSourceBillNo','FSourceTranType',1,41,200000024,200000024,0,0,0,'200000024','<FAction=,CanMultiSelBill;/>',-1,0,0,0,0,0,'','',0) 
GO

/****** Object:Data   选单关联明细：ICClassLinkEntry    Script Date: 2014-01-09 ******/

Delete ICClassLinkEntry WHERE FDestClassTypeID=200000024 OR FSourClassTypeID =  200000024
GO
INSERT INTO ICClassLinkEntry(FSourClassTypeID,FDestClassTypeID,FSourPage,FSourFKey,FDestPage,FDestFKey,FIsCheck,FIsGroup,FIsFilter,FDoAction,FAllowModified,FCheckStatCol,FHaveCheckCol,FISUserDefine,FControl,FRedNeg,FBeforeFormula,FAfterFormula,FSourTypeID,FDestTypeID) 
VALUES (200000024,-41,2,'FBaseProperty',2,'FItemName',0,0,0,0,0,'','',1,0,0,'','',0,0) 
GO

INSERT INTO ICClassLinkEntry(FSourClassTypeID,FDestClassTypeID,FSourPage,FSourFKey,FDestPage,FDestFKey,FIsCheck,FIsGroup,FIsFilter,FDoAction,FAllowModified,FCheckStatCol,FHaveCheckCol,FISUserDefine,FControl,FRedNeg,FBeforeFormula,FAfterFormula,FSourTypeID,FDestTypeID) 
VALUES (200000024,-41,2,'FBaseProperty2',2,'FItemModel',0,0,0,0,0,'','',1,0,0,'','',0,0) 
GO

INSERT INTO ICClassLinkEntry(FSourClassTypeID,FDestClassTypeID,FSourPage,FSourFKey,FDestPage,FDestFKey,FIsCheck,FIsGroup,FIsFilter,FDoAction,FAllowModified,FCheckStatCol,FHaveCheckCol,FISUserDefine,FControl,FRedNeg,FBeforeFormula,FAfterFormula,FSourTypeID,FDestTypeID) 
VALUES (200000024,-41,1,'FBillNo',1,'FSelBillNo',0,0,0,0,0,'','',1,0,0,'','',0,0) 
GO

INSERT INTO ICClassLinkEntry(FSourClassTypeID,FDestClassTypeID,FSourPage,FSourFKey,FDestPage,FDestFKey,FIsCheck,FIsGroup,FIsFilter,FDoAction,FAllowModified,FCheckStatCol,FHaveCheckCol,FISUserDefine,FControl,FRedNeg,FBeforeFormula,FAfterFormula,FSourTypeID,FDestTypeID) 
VALUES (200000024,-41,1,'FBillNo',2,'FSourceBillNo',0,0,0,0,0,'','',1,0,0,'','',0,0) 
GO

INSERT INTO ICClassLinkEntry(FSourClassTypeID,FDestClassTypeID,FSourPage,FSourFKey,FDestPage,FDestFKey,FIsCheck,FIsGroup,FIsFilter,FDoAction,FAllowModified,FCheckStatCol,FHaveCheckCol,FISUserDefine,FControl,FRedNeg,FBeforeFormula,FAfterFormula,FSourTypeID,FDestTypeID) 
VALUES (200000024,-41,1,'FDate',1,'Fdate',0,0,0,0,0,'','',1,0,0,'','',0,0) 
GO

INSERT INTO ICClassLinkEntry(FSourClassTypeID,FDestClassTypeID,FSourPage,FSourFKey,FDestPage,FDestFKey,FIsCheck,FIsGroup,FIsFilter,FDoAction,FAllowModified,FCheckStatCol,FHaveCheckCol,FISUserDefine,FControl,FRedNeg,FBeforeFormula,FAfterFormula,FSourTypeID,FDestTypeID) 
VALUES (200000024,-41,2,'FDCStockID',2,'FDCStockID',0,0,0,0,0,'','',1,0,0,'','',0,0) 
GO

INSERT INTO ICClassLinkEntry(FSourClassTypeID,FDestClassTypeID,FSourPage,FSourFKey,FDestPage,FDestFKey,FIsCheck,FIsGroup,FIsFilter,FDoAction,FAllowModified,FCheckStatCol,FHaveCheckCol,FISUserDefine,FControl,FRedNeg,FBeforeFormula,FAfterFormula,FSourTypeID,FDestTypeID) 
VALUES (200000024,-41,2,'FItemId',2,'FItemID',0,0,0,0,0,'','',1,0,0,'','',0,0) 
GO

INSERT INTO ICClassLinkEntry(FSourClassTypeID,FDestClassTypeID,FSourPage,FSourFKey,FDestPage,FDestFKey,FIsCheck,FIsGroup,FIsFilter,FDoAction,FAllowModified,FCheckStatCol,FHaveCheckCol,FISUserDefine,FControl,FRedNeg,FBeforeFormula,FAfterFormula,FSourTypeID,FDestTypeID) 
VALUES (200000024,-41,2,'FNoOutStockQty',2,'FDefaultBaseQty',0,0,0,0,0,'','',1,0,0,'','',0,0) 
GO

INSERT INTO ICClassLinkEntry(FSourClassTypeID,FDestClassTypeID,FSourPage,FSourFKey,FDestPage,FDestFKey,FIsCheck,FIsGroup,FIsFilter,FDoAction,FAllowModified,FCheckStatCol,FHaveCheckCol,FISUserDefine,FControl,FRedNeg,FBeforeFormula,FAfterFormula,FSourTypeID,FDestTypeID) 
VALUES (200000024,-41,2,'FNoOutStockQty',2,'FDefaultQty',0,0,0,0,0,'','',1,0,0,'','',0,0) 
GO

INSERT INTO ICClassLinkEntry(FSourClassTypeID,FDestClassTypeID,FSourPage,FSourFKey,FDestPage,FDestFKey,FIsCheck,FIsGroup,FIsFilter,FDoAction,FAllowModified,FCheckStatCol,FHaveCheckCol,FISUserDefine,FControl,FRedNeg,FBeforeFormula,FAfterFormula,FSourTypeID,FDestTypeID) 
VALUES (200000024,-41,2,'FQty',2,'Fauxqty',1,0,0,0,0,'','',1,0,0,'','',0,0) 
GO

INSERT INTO ICClassLinkEntry(FSourClassTypeID,FDestClassTypeID,FSourPage,FSourFKey,FDestPage,FDestFKey,FIsCheck,FIsGroup,FIsFilter,FDoAction,FAllowModified,FCheckStatCol,FHaveCheckCol,FISUserDefine,FControl,FRedNeg,FBeforeFormula,FAfterFormula,FSourTypeID,FDestTypeID) 
VALUES (200000024,-41,2,'FSCStockID',2,'FSCStockID',0,0,0,0,0,'','',1,0,0,'','',0,0) 
GO

INSERT INTO ICClassLinkEntry(FSourClassTypeID,FDestClassTypeID,FSourPage,FSourFKey,FDestPage,FDestFKey,FIsCheck,FIsGroup,FIsFilter,FDoAction,FAllowModified,FCheckStatCol,FHaveCheckCol,FISUserDefine,FControl,FRedNeg,FBeforeFormula,FAfterFormula,FSourTypeID,FDestTypeID) 
VALUES (200000024,-41,2,'FUnitId',2,'FUnitID',0,0,0,0,0,'','',1,0,0,'','',0,0) 
GO

/****** Object:Data   选单钩稽明细：ICClassLinkCommit    Script Date: 2014-01-09 ******/

 DELETE ICClassLinkCommit WHERE FDstClsTypID = 200000024 OR FSrcClsTypID =  200000024
GO
INSERT INTO ICClassLinkCommit(FSrcClsTypID,FDstClsTypID,FControl,FCheckKey,FCommitKey,FFlagKey,FIsUsrDef,FIsLimit,FControlFormula,FFlagFormula,FSourTypeID,FDestTypeID) 
VALUES (200000024,-41,1,'FQty','FCGStockQty','',0,0,'','',0,0) 
GO

/****** Object:Data   选单流程基本信息：ICClassWorkFlow    Script Date: 2014-01-09 ******/


GO
DECLARE @MaxID AS INT

SELECT @MaxID = ISNUll(Max(FID),10000) FROM ICClassWorkFlow

INSERT INTO ICClassWorkFlow(FID,FName_CHS,FName_CHT,FName_EN,FSubSysID) 
VALUES ( @MaxID + 1,'调拨申请单','單據流程25','Document Process25',23) 


UPDATE ICMaxNum SET FMaxNum = @MaxID + 2 WHERE FTableName = 'ICClassWorkFlow'
GO


/****** Object:Data   选单流程关联单据：ICClassWorkFlowBill    Script Date: 2014-01-09 ******/

DELETE ICClassWorkFlowBill WHERE FClassTypeID = 200000024
GO
INSERT INTO ICClassWorkFlowBill(FID,FClassTypeID,FTop,FLeft,FWidth,FHeight) 
VALUES (-227,-41,2490,1190,2500,2000) 
GO

INSERT INTO ICClassWorkFlowBill(FID,FClassTypeID,FTop,FLeft,FWidth,FHeight) 
VALUES (-226,-41,11770,6480,2500,2000) 
GO

INSERT INTO ICClassWorkFlowBill(FID,FClassTypeID,FTop,FLeft,FWidth,FHeight) 
VALUES (-225,-41,9950,8150,2500,2000) 
GO

INSERT INTO ICClassWorkFlowBill(FID,FClassTypeID,FTop,FLeft,FWidth,FHeight) 
VALUES (-221,-41,2880,6930,2500,2000) 
GO

INSERT INTO ICClassWorkFlowBill(FID,FClassTypeID,FTop,FLeft,FWidth,FHeight) 
VALUES (-221,200000024,2490,2380,2500,2000) 
GO

INSERT INTO ICClassWorkFlowBill(FID,FClassTypeID,FTop,FLeft,FWidth,FHeight) 
VALUES (-220,-41,2490,1190,2500,2000) 
GO

DELETE ICClassWorkFlowBill WHERE FID < 0 AND FEntryID NOT IN ( SELECT MAX(FEntryID)  FROM ICClassWorkFlowBill WHERE FID < 0 GROUP BY FClassTypeID HAVING COUNT(FClassTypeID) >= 1 ) 
 UPDATE ICClassWorkFlowBill SET FID =( SELECT MAX(FID) FROM ICClassWorkFlow ) WHERE FID < 0 
 DELETE ICClassWorkFlowBill WHERE FID < 0 
/****** Object:Data   选单流程关联关系：ICClassWorkFlowJoin    Script Date: 2014-01-09 ******/

 DELETE ICClassWorkFlowJoin WHERE FDestClassTypeID = 200000024 OR FSourClassTypeID = 200000024
GO
INSERT INTO ICClassWorkFlowJoin(FID,FSourClassTypeID,FDestClassTypeID) 
VALUES (-221,200000024,-41) 
GO

 UPDATE ICClassWorkFlowJoin SET FID =( SELECT MAX(FID) FROM ICClassWorkFlow ) WHERE FID < 0 
 DELETE ICClassWorkFlowJoin WHERE FID < 0 
/****** Object:Data   网络控制模板数据：ICClassMutex    Script Date: 2014-01-09 ******/

Delete ICClassMutex WHERE FClassTypeID=200000024
GO
/****** Object:Data   打印控制模板数据：ICPrintMaxCount    Script Date: 2014-01-09 ******/

Delete ICPrintMaxCount WHERE FID =200000024
GO
INSERT INTO ICPrintMaxCount(FPos,FID,FName,FName_CHT,FName_EN,FPrintControlOrNo,FPrintMaxCount) 
VALUES (200000024,200000024,'调拨申请单_BOS','單據200000024_BOS','Doc200000024_BOS',0,0) 
GO

/****** Object:Data   多级审核配置模板数据：ICClassMCFlowInfo    Script Date: 2014-01-09 ******/

DELETE ICClassMCFlowInfo WHERE FID = 200000024
GO
INSERT INTO ICClassMCFlowInfo(FID,FIsRun,FMaxLevel,FChkLevel,FChkModel,FCanModify,FCheckerField,FCheckDateField,FInputIdea,FShowTip,FCanCheckAfterEnd,FIsMobileServiceRun,FIsSelectMsgUser,FIsNoCheckSelf,FMobileInfoCanReply) 
VALUES (200000024,1,1,1,0,0,'FChecker','FCheckDate',1,1,0,0,0,0,0) 
GO

 EXEC  p_CreateMCDetailTable @ClassTypeID = 200000024
/****** Object:Data   多级审核的工作流任务（各审核级次）模板数据：ICClassMCTasks    Script Date: 2014-01-09 ******/

DELETE ICClassMCTasks WHERE FID = 200000024
GO
INSERT INTO ICClassMCTasks(FID,FTask,FTag,FX,FY) 
VALUES (200000024,'BillMCBegin','待审单据',770,930) 
GO

INSERT INTO ICClassMCTasks(FID,FTask,FTag,FX,FY) 
VALUES (200000024,'BillMCEnd','审核结束',13470,6800) 
GO

INSERT INTO ICClassMCTasks(FID,FTask,FTag,FX,FY) 
VALUES (200000024,'MC1','一级审核',770,6800) 
GO

/****** Object:Data   多级审核的流程流转和规则模板数据：ICClassMCRule    Script Date: 2014-01-09 ******/

DELETE ICClassMCRule WHERE FID = 200000024
GO
/****** Object:Data   单据操作明细模板数据：ICClassBillAction    Script Date: 2014-01-09 ******/

DELETE ICClassBillAction WHERE FClassTypeID = 200000024
GO
DECLARE @MaxID AS INT

SELECT @MaxID = ISNUll(Max(FID),10000) FROM ICClassBillAction

INSERT INTO ICClassBillAction(FID,FClassTypeID,FCode,FName_CHS,FName_CHT,FName_EN,FDescriptions_CHS,FDescriptions_CHT,FDescriptions_EN,FEnvironment,FRightMask,FRightUseMask,FRightGroupMask,FRightControl,FAddLog,FIsPredefine,FIsFirst,FShortCut,FListActionCirculation) 
VALUES ( @MaxID + 1,200000024,'mnuBOSViewVoucher','查看凭证','查看凭证','查看凭证','查看凭证','查看凭证','查看凭证',0,1024,0,7,1,0,1,0,0,1) 

INSERT INTO ICClassBillAction(FID,FClassTypeID,FCode,FName_CHS,FName_CHT,FName_EN,FDescriptions_CHS,FDescriptions_CHT,FDescriptions_EN,FEnvironment,FRightMask,FRightUseMask,FRightGroupMask,FRightControl,FAddLog,FIsPredefine,FIsFirst,FShortCut,FListActionCirculation) 
VALUES ( @MaxID + 2,200000024,'mnuEditCopy','复制','複製','Copy','复制','複製','Copy',39,131072,0,7,1,0,1,0,0,1) 

INSERT INTO ICClassBillAction(FID,FClassTypeID,FCode,FName_CHS,FName_CHT,FName_EN,FDescriptions_CHS,FDescriptions_CHT,FDescriptions_EN,FEnvironment,FRightMask,FRightUseMask,FRightGroupMask,FRightControl,FAddLog,FIsPredefine,FIsFirst,FShortCut,FListActionCirculation) 
VALUES ( @MaxID + 3,200000024,'mnuEditCopyDoc','按单复制','按單複製','Copy Document','按单复制','按單複製','Copy Document',64,131072,0,7,1,0,1,0,0,1) 

INSERT INTO ICClassBillAction(FID,FClassTypeID,FCode,FName_CHS,FName_CHT,FName_EN,FDescriptions_CHS,FDescriptions_CHT,FDescriptions_EN,FEnvironment,FRightMask,FRightUseMask,FRightGroupMask,FRightControl,FAddLog,FIsPredefine,FIsFirst,FShortCut,FListActionCirculation) 
VALUES ( @MaxID + 4,200000024,'mnuEditCopyEntry','按分录合并复制','按分錄合併複製','Consolidate Selected Invoices & Copy','按分录合并复制','按分錄合併複製','Consolidate Selected Invoices & Copy',64,131072,0,7,1,0,1,0,0,1) 

INSERT INTO ICClassBillAction(FID,FClassTypeID,FCode,FName_CHS,FName_CHT,FName_EN,FDescriptions_CHS,FDescriptions_CHT,FDescriptions_EN,FEnvironment,FRightMask,FRightUseMask,FRightGroupMask,FRightControl,FAddLog,FIsPredefine,FIsFirst,FShortCut,FListActionCirculation) 
VALUES ( @MaxID + 5,200000024,'mnuEditDelete','删除','刪除','Del.','删除','刪除','Del.',64,65536,0,7,1,1,1,0,0,1) 

INSERT INTO ICClassBillAction(FID,FClassTypeID,FCode,FName_CHS,FName_CHT,FName_EN,FDescriptions_CHS,FDescriptions_CHT,FDescriptions_EN,FEnvironment,FRightMask,FRightUseMask,FRightGroupMask,FRightControl,FAddLog,FIsPredefine,FIsFirst,FShortCut,FListActionCirculation) 
VALUES ( @MaxID + 6,200000024,'mnuEditModify','修改','修改','Edit','修改','修改','Edit',4160,4194304,0,7,1,0,1,0,0,1) 

INSERT INTO ICClassBillAction(FID,FClassTypeID,FCode,FName_CHS,FName_CHT,FName_EN,FDescriptions_CHS,FDescriptions_CHT,FDescriptions_EN,FEnvironment,FRightMask,FRightUseMask,FRightGroupMask,FRightControl,FAddLog,FIsPredefine,FIsFirst,FShortCut,FListActionCirculation) 
VALUES ( @MaxID + 7,200000024,'mnuExportData','引出内部数据','引出內部資料','Export','引出内部数据','引出內部資料','Export',5056,16,0,7,1,0,1,0,0,1) 

INSERT INTO ICClassBillAction(FID,FClassTypeID,FCode,FName_CHS,FName_CHT,FName_EN,FDescriptions_CHS,FDescriptions_CHT,FDescriptions_EN,FEnvironment,FRightMask,FRightUseMask,FRightGroupMask,FRightControl,FAddLog,FIsPredefine,FIsFirst,FShortCut,FListActionCirculation) 
VALUES ( @MaxID + 8,200000024,'mnuFileNew','新增','新增','New','新增','新增','New',103,131072,0,7,1,0,1,0,0,1) 

INSERT INTO ICClassBillAction(FID,FClassTypeID,FCode,FName_CHS,FName_CHT,FName_EN,FDescriptions_CHS,FDescriptions_CHT,FDescriptions_EN,FEnvironment,FRightMask,FRightUseMask,FRightGroupMask,FRightControl,FAddLog,FIsPredefine,FIsFirst,FShortCut,FListActionCirculation) 
VALUES ( @MaxID + 9,200000024,'mnuFilePrint','打印','列印','Print','打印','列印','Print',5095,32768,0,7,1,0,1,0,0,1) 

INSERT INTO ICClassBillAction(FID,FClassTypeID,FCode,FName_CHS,FName_CHT,FName_EN,FDescriptions_CHS,FDescriptions_CHT,FDescriptions_EN,FEnvironment,FRightMask,FRightUseMask,FRightGroupMask,FRightControl,FAddLog,FIsPredefine,FIsFirst,FShortCut,FListActionCirculation) 
VALUES ( @MaxID + 10,200000024,'mnuFileSave','保存','保存','Save','保存','保存','Save',6,0,0,7,0,1,1,0,0,1) 

INSERT INTO ICClassBillAction(FID,FClassTypeID,FCode,FName_CHS,FName_CHT,FName_EN,FDescriptions_CHS,FDescriptions_CHT,FDescriptions_EN,FEnvironment,FRightMask,FRightUseMask,FRightGroupMask,FRightControl,FAddLog,FIsPredefine,FIsFirst,FShortCut,FListActionCirculation) 
VALUES ( @MaxID + 11,200000024,'mnuFileView','查看','查看','View','查看','查看','View',960,2097152,0,7,1,0,1,0,0,1) 

INSERT INTO ICClassBillAction(FID,FClassTypeID,FCode,FName_CHS,FName_CHT,FName_EN,FDescriptions_CHS,FDescriptions_CHT,FDescriptions_EN,FEnvironment,FRightMask,FRightUseMask,FRightGroupMask,FRightControl,FAddLog,FIsPredefine,FIsFirst,FShortCut,FListActionCirculation) 
VALUES ( @MaxID + 12,200000024,'mnuMakeOneToOne','按单生成凭证','按单生成凭证','按单生成凭证','按单生成凭证','按单生成凭证','按单生成凭证',0,128,0,7,1,1,1,0,0,1) 

INSERT INTO ICClassBillAction(FID,FClassTypeID,FCode,FName_CHS,FName_CHT,FName_EN,FDescriptions_CHS,FDescriptions_CHT,FDescriptions_EN,FEnvironment,FRightMask,FRightUseMask,FRightGroupMask,FRightControl,FAddLog,FIsPredefine,FIsFirst,FShortCut,FListActionCirculation) 
VALUES ( @MaxID + 13,200000024,'mnuMultiToOne','合并生成凭证','合并生成凭证','合并生成凭证','合并生成凭证','合并生成凭证','合并生成凭证',0,512,0,7,1,1,1,0,0,1) 

INSERT INTO ICClassBillAction(FID,FClassTypeID,FCode,FName_CHS,FName_CHT,FName_EN,FDescriptions_CHS,FDescriptions_CHT,FDescriptions_EN,FEnvironment,FRightMask,FRightUseMask,FRightGroupMask,FRightControl,FAddLog,FIsPredefine,FIsFirst,FShortCut,FListActionCirculation) 
VALUES ( @MaxID + 14,200000024,'mnuStockQuery','库存查询','庫存查詢','Stock Query','库存查询','庫存查詢','Stock Query',0,0,0,7,0,1,1,0,0,1) 


UPDATE ICMaxNum SET FMaxNum = @MaxID + 15 WHERE FTableName = 'ICClassBillAction'
GO


/****** Object:Data   单据操作日志模板数据：t_LogFunction    Script Date: 2014-01-09 ******/

DELETE t_LogFunction WHERE FFunctionID LIKE 'BOS200000024%'
GO
INSERT INTO t_LogFunction(FFunctionID,FFunctionName,FSubSysID,FFunctionName_Cht,FFunctionName_EN) 
VALUES ('BOS200000024_mnuEditDelete','销售管理系统-业务单据-调拨申请单-删除',23,'銷售管制系統-業務單據-單據200000024-刪除','Sales Management-Business document-Doc200000024-Del.') 
GO

INSERT INTO t_LogFunction(FFunctionID,FFunctionName,FSubSysID,FFunctionName_Cht,FFunctionName_EN) 
VALUES ('BOS200000024_mnuEditMultiCheck','销售管理系统-业务单据-调拨申请单-多级审核',23,'銷售管制系統-業務單據-單據200000024-多級審核','Sales Management-Business document-Doc200000024-Multi-level Check') 
GO

INSERT INTO t_LogFunction(FFunctionID,FFunctionName,FSubSysID,FFunctionName_Cht,FFunctionName_EN) 
VALUES ('BOS200000024_mnuEditUnMultiCheck','销售管理系统-业务单据-调拨申请单-驳回审核',23,'銷售管制系統-業務單據-單據200000024-駁回審核','Sales Management-Business document-Doc200000024-Reject Check') 
GO

INSERT INTO t_LogFunction(FFunctionID,FFunctionName,FSubSysID,FFunctionName_Cht,FFunctionName_EN) 
VALUES ('BOS200000024_mnuFileSave','销售管理系统-业务单据-调拨申请单-保存',23,'銷售管制系統-業務單據-單據200000024-保存','Sales Management-Business document-Doc200000024-Save') 
GO

INSERT INTO t_LogFunction(FFunctionID,FFunctionName,FSubSysID,FFunctionName_Cht,FFunctionName_EN) 
VALUES ('BOS200000024_mnuMakeOneToOne','销售管理系统-业务单据-调拨申请单-按单生成凭证',23,'銷售管制系統-業務單據-單據200000024-按单生成凭证','Sales Management-Business document-Doc200000024-按单生成凭证') 
GO

INSERT INTO t_LogFunction(FFunctionID,FFunctionName,FSubSysID,FFunctionName_Cht,FFunctionName_EN) 
VALUES ('BOS200000024_mnuMultiToOne','销售管理系统-业务单据-调拨申请单-合并生成凭证',23,'銷售管制系統-業務單據-單據200000024-合并生成凭证','Sales Management-Business document-Doc200000024-合并生成凭证') 
GO

INSERT INTO t_LogFunction(FFunctionID,FFunctionName,FSubSysID,FFunctionName_Cht,FFunctionName_EN) 
VALUES ('BOS200000024_mnuStockQuery','销售管理系统-业务单据-调拨申请单-库存查询',23,'銷售管制系統-業務單據-單據200000024-庫存查詢','Sales Management-Business document-Doc200000024-Stock Query') 
GO

/****** Object:Data   单据操作位置模板数据：ICClassActionPosition    Script Date: 2014-01-09 ******/

DELETE ICClassActionPosition WHERE FClassTypeID = 200000024
GO
/****** Object:Data   单据扩展服务模板数据：ICClassActionList    Script Date: 2014-01-09 ******/

DELETE ICClassActionList WHERE FClassTypeID = 200000024
GO
INSERT INTO ICClassActionList(FClassTypeID,FClassActionID,FObject,FDefineType,FSourceType,FSourceField,FAction,FExpression,FOrder,FDescription) 
VALUES (200000024,1,'FItemId',0,4096,'FAction','FBASEPROPERTY,FUNITID=FUNITID','',1,'Add by Function SetSouceAction') 
GO

INSERT INTO ICClassActionList(FClassTypeID,FClassActionID,FObject,FDefineType,FSourceType,FSourceField,FAction,FExpression,FOrder,FDescription) 
VALUES (200000024,5,'FItemId',0,4096,'FAction','FQTY2','',2,'Add by Function SetSouceAction') 
GO

INSERT INTO ICClassActionList(FClassTypeID,FClassActionID,FObject,FDefineType,FSourceType,FSourceField,FAction,FExpression,FOrder,FDescription) 
VALUES (200000024,1,'FItemId',0,4096,'FAction','FBaseProperty2','',3,'Add by Function SetSouceAction') 
GO

INSERT INTO ICClassActionList(FClassTypeID,FClassActionID,FObject,FDefineType,FSourceType,FSourceField,FAction,FExpression,FOrder,FDescription) 
VALUES (200000024,1,'FItemId',0,4096,'FAction','FBaseProperty3','',4,'Add by Function SetSouceAction') 
GO

INSERT INTO ICClassActionList(FClassTypeID,FClassActionID,FObject,FDefineType,FSourceType,FSourceField,FAction,FExpression,FOrder,FDescription) 
VALUES (200000024,1,'FItemId',0,4096,'FAction','FBaseProperty2','',5,'Add by Function SetSouceAction') 
GO

INSERT INTO ICClassActionList(FClassTypeID,FClassActionID,FObject,FDefineType,FSourceType,FSourceField,FAction,FExpression,FOrder,FDescription) 
VALUES (200000024,1,'FItemId',0,4096,'FAction','FBaseProperty3','',6,'Add by Function SetSouceAction') 
GO

INSERT INTO ICClassActionList(FClassTypeID,FClassActionID,FObject,FDefineType,FSourceType,FSourceField,FAction,FExpression,FOrder,FDescription) 
VALUES (200000024,5,'FItemId',0,4096,'FAction','FQty1','',7,'Add by Function SetSouceAction') 
GO

INSERT INTO ICClassActionList(FClassTypeID,FClassActionID,FObject,FDefineType,FSourceType,FSourceField,FAction,FExpression,FOrder,FDescription) 
VALUES (200000024,1,'FItemId',0,4096,'FAction','FBaseProperty3','',8,'Add by Function SetSouceAction') 
GO

INSERT INTO ICClassActionList(FClassTypeID,FClassActionID,FObject,FDefineType,FSourceType,FSourceField,FAction,FExpression,FOrder,FDescription) 
VALUES (200000024,1,'FItemId',0,4096,'FAction','FBaseProperty3','',9,'Add by Function SetSouceAction') 
GO

INSERT INTO ICClassActionList(FClassTypeID,FClassActionID,FObject,FDefineType,FSourceType,FSourceField,FAction,FExpression,FOrder,FDescription) 
VALUES (200000024,1,'FItemId',0,4096,'FAction','FBaseProperty4','',10,'Add by Function SetSouceAction') 
GO

INSERT INTO ICClassActionList(FClassTypeID,FClassActionID,FObject,FDefineType,FSourceType,FSourceField,FAction,FExpression,FOrder,FDescription) 
VALUES (200000024,1,'FItemId',0,4096,'FAction','FBaseProperty4','',11,'Add by Function SetSouceAction') 
GO

INSERT INTO ICClassActionList(FClassTypeID,FClassActionID,FObject,FDefineType,FSourceType,FSourceField,FAction,FExpression,FOrder,FDescription) 
VALUES (200000024,1,'FItemId',0,4096,'FAction','FBaseProperty5','',12,'Add by Function SetSouceAction') 
GO

INSERT INTO ICClassActionList(FClassTypeID,FClassActionID,FObject,FDefineType,FSourceType,FSourceField,FAction,FExpression,FOrder,FDescription) 
VALUES (200000024,1,'FItemId',0,4096,'FAction','FBaseProperty5','',13,'Add by Function SetSouceAction') 
GO

INSERT INTO ICClassActionList(FClassTypeID,FClassActionID,FObject,FDefineType,FSourceType,FSourceField,FAction,FExpression,FOrder,FDescription) 
VALUES (200000024,5,'FItemId',0,4096,'FLoadAction','FQTY2','',1,'Add by Function SetSouceAction') 
GO

INSERT INTO ICClassActionList(FClassTypeID,FClassActionID,FObject,FDefineType,FSourceType,FSourceField,FAction,FExpression,FOrder,FDescription) 
VALUES (200000024,5,'FItemId',0,4096,'FLoadAction','FQty1','',2,'Add by Function SetSouceAction') 
GO

INSERT INTO ICClassActionList(FClassTypeID,FClassActionID,FObject,FDefineType,FSourceType,FSourceField,FAction,FExpression,FOrder,FDescription) 
VALUES (200000024,1,'FProductID',0,4096,'FAction','FBaseProperty1','',1,'Add by Function SetSouceAction') 
GO



/**End  新单据模板数据脚本，名称 调拨申请单    Script Date: 2014-01-09 **/
