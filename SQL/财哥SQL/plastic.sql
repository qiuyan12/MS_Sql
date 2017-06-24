

/**Begin 新单据模板数据脚本，名称 塑胶子件收料申请单    Script Date: 2013-11-26 **/


/****** Object:Data   单据描述：ICClassType    Script Date: 2013-11-26 ******/

--select max(fid)+1 fid from ICClassType
Delete ICClassType WHERE FID=200000022
GO
INSERT INTO ICClassType(FID,FName_CHS,FName_CHT,FName_EN,FShowIndex,FTableName,FShowType,FTemplateID,FImgID,FModel,FLogic,FBillWidth,FBillHeight,FMenuControl,FFunctionID,FFilter,FBillTypeID,FIsManageBillNo,FBillNoKey,FEntryCount,FLayerCount,FLayerNames,FPrimaryKey,FEPrimaryKey,FClassTypeKey,FIndexKey,FObjectType,FObjectID,FGroupIDView,FGroupIDManage,FComponentExt,FBillNoManageType,FAccessoryTypeID,FControl,FTimeStamp,FExtBaseDataAccess) 
VALUES (200000022,'塑胶子件收料申请单','單據200000022','Doc200000022',0,'t_BosPlasticPoInStock',0,200000022,'',2,3,9540,5490,'',23,'',3,0,'',0,1,'CHS=;CHT=;EN=','FID','FEntryID','FClassTypeID','FIndex',4100,200000022,2101,2102,'FBillevents=|FLstEvents=MySister.clsPlanChangeStockList|FBaseLstEvents=|FBeforeSave=|FAfterSave=|FBeforeDel=|FAfterDel=|FBeforeMultiCheck=|FAfterMultiCheck=|FIsUseProc=|',1,80000028,2483,NULL,'') 
GO

/****** Object:Data   单据分录描述：ICClassTypeEntry    Script Date: 2013-11-26 ******/

Delete ICClassTypeEntry WHERE FParentID=200000022
GO
INSERT INTO ICClassTypeEntry(FIndex,FParentID,FTableName,FLeft,FTop,FWidth,FHeight,FLayer,FEntryType,FTabIndex,FMustInput,FKeyField,FDescription_CHS,FDescription_CHT,FDescription_EN,FFilter,FUserDefine,FContainer) 
VALUES (1,200000022,'t_BosPlasticPoInStock',0,2190,4000,4740,0,0,0,1,'','','','','',1,'') 
GO

INSERT INTO ICClassTypeEntry(FIndex,FParentID,FTableName,FLeft,FTop,FWidth,FHeight,FLayer,FEntryType,FTabIndex,FMustInput,FKeyField,FDescription_CHS,FDescription_CHT,FDescription_EN,FFilter,FUserDefine,FContainer) 
VALUES (2,200000022,'t_BosPlasticPoInStockEntry',225,1585,9095,3250,0,1,10,0,'','','','','',1,'') 
GO

/****** Object:Data   单据模板字段描述：ICClassTableInfo    Script Date: 2013-11-26 ******/

Delete ICClassTableInfo WHERE FClassTypeID=200000022
GO
INSERT INTO ICClassTableInfo(FClassTypeID,FPage,FCaption_CHS,FCaption_CHT,FCaption_EN,FKey,FFieldName,FTableName,FTableNameAs,FListIndex,FListClassName,FVisible,FEnable,FNeedSave,FMustInput,FCtlType,FProperty,FLookUpType,FLookUpClassID,FLookUpList,FSRCFieldName,FSRCTableName,FSRCTableNameAs,FDSPFieldName,FFNDFieldName,FValueLocation,FFilter,FFilterGroup,FValueType,FDspColType,FEditlen,FValuePrecision,FSaveRule,FDefValue,FAction,FUserDefine,FNote,FKeyWord,FLeft,FTop,FHeight,FWidth,FCondition,FTabIndex,FLock,FSum,FPrec,FScale,FLayer,FLoadAction,FUnControl,FFont,FSourceType,FSubKey,FParentKey,FConditionExt,FFrameBorder,FFrameBorderColor,FLabelWidth,FLabelColor,FTextColor,FIsF7,FContainer,FStyle) 
VALUES (200000022,1,'单据编号','單據編號','Doc No.','FBillNo','FBillNo','t_BosPlasticPoInStock','',0,2,-1,0,1,1,1,'',0,0,'','','','','','',1,'','',167,500,30,30,'','','',1,'','BILLNO',7200,765,375,2130,'0',0,0,0,0,0,0,'',1,'',3,'','',0,2,0,0,0,0,0,'',0) 
GO

INSERT INTO ICClassTableInfo(FClassTypeID,FPage,FCaption_CHS,FCaption_CHT,FCaption_EN,FKey,FFieldName,FTableName,FTableNameAs,FListIndex,FListClassName,FVisible,FEnable,FNeedSave,FMustInput,FCtlType,FProperty,FLookUpType,FLookUpClassID,FLookUpList,FSRCFieldName,FSRCTableName,FSRCTableNameAs,FDSPFieldName,FFNDFieldName,FValueLocation,FFilter,FFilterGroup,FValueType,FDspColType,FEditlen,FValuePrecision,FSaveRule,FDefValue,FAction,FUserDefine,FNote,FKeyWord,FLeft,FTop,FHeight,FWidth,FCondition,FTabIndex,FLock,FSum,FPrec,FScale,FLayer,FLoadAction,FUnControl,FFont,FSourceType,FSubKey,FParentKey,FConditionExt,FFrameBorder,FFrameBorderColor,FLabelWidth,FLabelColor,FTextColor,FIsF7,FContainer,FStyle) 
VALUES (200000022,1,'内码','內碼','ISN','FID','FID','t_BosPlasticPoInStock','',5,2,0,1,1,0,3,'',0,0,'','','','','','',1,'','',56,500,255,4,'','','',1,'','PRIMARY',240,120,405,2535,'-1',4,0,0,0,0,0,'',1,'',0,'','',0,0,0,0,0,0,0,'',0) 
GO

INSERT INTO ICClassTableInfo(FClassTypeID,FPage,FCaption_CHS,FCaption_CHT,FCaption_EN,FKey,FFieldName,FTableName,FTableNameAs,FListIndex,FListClassName,FVisible,FEnable,FNeedSave,FMustInput,FCtlType,FProperty,FLookUpType,FLookUpClassID,FLookUpList,FSRCFieldName,FSRCTableName,FSRCTableNameAs,FDSPFieldName,FFNDFieldName,FValueLocation,FFilter,FFilterGroup,FValueType,FDspColType,FEditlen,FValuePrecision,FSaveRule,FDefValue,FAction,FUserDefine,FNote,FKeyWord,FLeft,FTop,FHeight,FWidth,FCondition,FTabIndex,FLock,FSum,FPrec,FScale,FLayer,FLoadAction,FUnControl,FFont,FSourceType,FSubKey,FParentKey,FConditionExt,FFrameBorder,FFrameBorderColor,FLabelWidth,FLabelColor,FTextColor,FIsF7,FContainer,FStyle) 
VALUES (200000022,1,'日期','日期','Date','FDate','FDate','t_BosPlasticPoInStock','',3,2,-1,0,1,1,0,'',0,0,'','','','','','',1,'','',61,0,8,8,'','','',1,'','',2415,4950,375,1935,'2,13',5,0,0,3,23,0,'',1,'',0,'','',0,2,0,0,0,0,0,'',0) 
GO

INSERT INTO ICClassTableInfo(FClassTypeID,FPage,FCaption_CHS,FCaption_CHT,FCaption_EN,FKey,FFieldName,FTableName,FTableNameAs,FListIndex,FListClassName,FVisible,FEnable,FNeedSave,FMustInput,FCtlType,FProperty,FLookUpType,FLookUpClassID,FLookUpList,FSRCFieldName,FSRCTableName,FSRCTableNameAs,FDSPFieldName,FFNDFieldName,FValueLocation,FFilter,FFilterGroup,FValueType,FDspColType,FEditlen,FValuePrecision,FSaveRule,FDefValue,FAction,FUserDefine,FNote,FKeyWord,FLeft,FTop,FHeight,FWidth,FCondition,FTabIndex,FLock,FSum,FPrec,FScale,FLayer,FLoadAction,FUnControl,FFont,FSourceType,FSubKey,FParentKey,FConditionExt,FFrameBorder,FFrameBorderColor,FLabelWidth,FLabelColor,FTextColor,FIsF7,FContainer,FStyle) 
VALUES (200000022,1,'备注','備註','Remarks','FNOTE','FNOTE','t_BosPlasticPoInStock','',7,2,-1,0,1,0,999,'',0,0,'','','','','','',0,'','',231,500,50,50,'','','',1,'','',165,1185,300,9180,'0,13',6,0,0,0,0,0,'',55,'',0,'','',0,2,0,0,0,0,0,'',0) 
GO

INSERT INTO ICClassTableInfo(FClassTypeID,FPage,FCaption_CHS,FCaption_CHT,FCaption_EN,FKey,FFieldName,FTableName,FTableNameAs,FListIndex,FListClassName,FVisible,FEnable,FNeedSave,FMustInput,FCtlType,FProperty,FLookUpType,FLookUpClassID,FLookUpList,FSRCFieldName,FSRCTableName,FSRCTableNameAs,FDSPFieldName,FFNDFieldName,FValueLocation,FFilter,FFilterGroup,FValueType,FDspColType,FEditlen,FValuePrecision,FSaveRule,FDefValue,FAction,FUserDefine,FNote,FKeyWord,FLeft,FTop,FHeight,FWidth,FCondition,FTabIndex,FLock,FSum,FPrec,FScale,FLayer,FLoadAction,FUnControl,FFont,FSourceType,FSubKey,FParentKey,FConditionExt,FFrameBorder,FFrameBorderColor,FLabelWidth,FLabelColor,FTextColor,FIsF7,FContainer,FStyle) 
VALUES (200000022,1,'审核','用戶','User','FChecker','FChecker','t_BosPlasticPoInStock','',4,2,-1,1,1,0,1,'',7,9,'','FUserID','t_User','','FName','FName',1,'','',56,500,255,4,'','0','',1,'','',4935,4950,375,1785,'0',7,-1,0,0,6,0,'',1,'',4,'','',1000000,2,0,0,0,0,0,'',0) 
GO

INSERT INTO ICClassTableInfo(FClassTypeID,FPage,FCaption_CHS,FCaption_CHT,FCaption_EN,FKey,FFieldName,FTableName,FTableNameAs,FListIndex,FListClassName,FVisible,FEnable,FNeedSave,FMustInput,FCtlType,FProperty,FLookUpType,FLookUpClassID,FLookUpList,FSRCFieldName,FSRCTableName,FSRCTableNameAs,FDSPFieldName,FFNDFieldName,FValueLocation,FFilter,FFilterGroup,FValueType,FDspColType,FEditlen,FValuePrecision,FSaveRule,FDefValue,FAction,FUserDefine,FNote,FKeyWord,FLeft,FTop,FHeight,FWidth,FCondition,FTabIndex,FLock,FSum,FPrec,FScale,FLayer,FLoadAction,FUnControl,FFont,FSourceType,FSubKey,FParentKey,FConditionExt,FFrameBorder,FFrameBorderColor,FLabelWidth,FLabelColor,FTextColor,FIsF7,FContainer,FStyle) 
VALUES (200000022,1,'制单人','制單人','Prep. by','FBiller','FBiller','t_BosPlasticPoInStock','',2,2,-1,-1,1,0,1,'',7,9,'','FUserID','t_User','t_User1','FName','FName',1,'','',56,500,255,4,'','','',1,'','USER',255,4950,375,1770,'0,9',8,-1,0,0,6,0,'',1,'',8,'','',0,2,0,0,0,0,0,'',0) 
GO

INSERT INTO ICClassTableInfo(FClassTypeID,FPage,FCaption_CHS,FCaption_CHT,FCaption_EN,FKey,FFieldName,FTableName,FTableNameAs,FListIndex,FListClassName,FVisible,FEnable,FNeedSave,FMustInput,FCtlType,FProperty,FLookUpType,FLookUpClassID,FLookUpList,FSRCFieldName,FSRCTableName,FSRCTableNameAs,FDSPFieldName,FFNDFieldName,FValueLocation,FFilter,FFilterGroup,FValueType,FDspColType,FEditlen,FValuePrecision,FSaveRule,FDefValue,FAction,FUserDefine,FNote,FKeyWord,FLeft,FTop,FHeight,FWidth,FCondition,FTabIndex,FLock,FSum,FPrec,FScale,FLayer,FLoadAction,FUnControl,FFont,FSourceType,FSubKey,FParentKey,FConditionExt,FFrameBorder,FFrameBorderColor,FLabelWidth,FLabelColor,FTextColor,FIsF7,FContainer,FStyle) 
VALUES (200000022,1,'审核日期','日期1','Date1','FCheckDate','FCheckDate','t_BosPlasticPoInStock','',6,2,-1,0,1,0,0,'',0,0,'','','','','','',1,'','',61,0,8,8,'','','',1,'','',7200,4950,375,2070,'2,13',9,-1,0,3,23,0,'',1,'',0,'','',0,2,0,0,0,0,0,'',0) 
GO

INSERT INTO ICClassTableInfo(FClassTypeID,FPage,FCaption_CHS,FCaption_CHT,FCaption_EN,FKey,FFieldName,FTableName,FTableNameAs,FListIndex,FListClassName,FVisible,FEnable,FNeedSave,FMustInput,FCtlType,FProperty,FLookUpType,FLookUpClassID,FLookUpList,FSRCFieldName,FSRCTableName,FSRCTableNameAs,FDSPFieldName,FFNDFieldName,FValueLocation,FFilter,FFilterGroup,FValueType,FDspColType,FEditlen,FValuePrecision,FSaveRule,FDefValue,FAction,FUserDefine,FNote,FKeyWord,FLeft,FTop,FHeight,FWidth,FCondition,FTabIndex,FLock,FSum,FPrec,FScale,FLayer,FLoadAction,FUnControl,FFont,FSourceType,FSubKey,FParentKey,FConditionExt,FFrameBorder,FFrameBorderColor,FLabelWidth,FLabelColor,FTextColor,FIsF7,FContainer,FStyle) 
VALUES (200000022,1,'事务类型','事務類型','Transaction Type','FClassTypeID','FClassTypeID','t_BosPlasticPoInStock','',8,2,0,1,1,0,1,'',0,0,'','FID','ICClassType','','FName','FName',1,'','',56,500,255,4,'','','',1,'','CLASSTYPEID',240,120,405,2535,'-1',10,0,0,0,0,0,'',1,'',0,'','',0,0,0,0,0,0,0,'',0) 
GO

INSERT INTO ICClassTableInfo(FClassTypeID,FPage,FCaption_CHS,FCaption_CHT,FCaption_EN,FKey,FFieldName,FTableName,FTableNameAs,FListIndex,FListClassName,FVisible,FEnable,FNeedSave,FMustInput,FCtlType,FProperty,FLookUpType,FLookUpClassID,FLookUpList,FSRCFieldName,FSRCTableName,FSRCTableNameAs,FDSPFieldName,FFNDFieldName,FValueLocation,FFilter,FFilterGroup,FValueType,FDspColType,FEditlen,FValuePrecision,FSaveRule,FDefValue,FAction,FUserDefine,FNote,FKeyWord,FLeft,FTop,FHeight,FWidth,FCondition,FTabIndex,FLock,FSum,FPrec,FScale,FLayer,FLoadAction,FUnControl,FFont,FSourceType,FSubKey,FParentKey,FConditionExt,FFrameBorder,FFrameBorderColor,FLabelWidth,FLabelColor,FTextColor,FIsF7,FContainer,FStyle) 
VALUES (200000022,1,'销售订单','文本1','Text1','FSeBillNo','FSeBillNo','t_BosPlasticPoInStock','',1,2,-1,0,1,0,1,'',0,0,'','','','','FName','',1,'','',167,500,50,50,'','','',1,'','',180,765,375,2595,'0,13',27,-1,0,0,0,0,'',19,'',0,'','',0,2,0,0,0,0,0,'',0) 
GO

INSERT INTO ICClassTableInfo(FClassTypeID,FPage,FCaption_CHS,FCaption_CHT,FCaption_EN,FKey,FFieldName,FTableName,FTableNameAs,FListIndex,FListClassName,FVisible,FEnable,FNeedSave,FMustInput,FCtlType,FProperty,FLookUpType,FLookUpClassID,FLookUpList,FSRCFieldName,FSRCTableName,FSRCTableNameAs,FDSPFieldName,FFNDFieldName,FValueLocation,FFilter,FFilterGroup,FValueType,FDspColType,FEditlen,FValuePrecision,FSaveRule,FDefValue,FAction,FUserDefine,FNote,FKeyWord,FLeft,FTop,FHeight,FWidth,FCondition,FTabIndex,FLock,FSum,FPrec,FScale,FLayer,FLoadAction,FUnControl,FFont,FSourceType,FSubKey,FParentKey,FConditionExt,FFrameBorder,FFrameBorderColor,FLabelWidth,FLabelColor,FTextColor,FIsF7,FContainer,FStyle) 
VALUES (200000022,1,'运算编号','文本2','Text2','FRunID','FRunID','t_BosPlasticPoInStock','',0,2,-1,0,1,0,1,'',0,0,'','','','','FName','',1,'','',167,500,50,50,'','','',1,'','',5205,765,375,1890,'0,13',28,-1,0,0,0,0,'',19,'',0,'','',0,2,0,0,0,0,0,'',0) 
GO

INSERT INTO ICClassTableInfo(FClassTypeID,FPage,FCaption_CHS,FCaption_CHT,FCaption_EN,FKey,FFieldName,FTableName,FTableNameAs,FListIndex,FListClassName,FVisible,FEnable,FNeedSave,FMustInput,FCtlType,FProperty,FLookUpType,FLookUpClassID,FLookUpList,FSRCFieldName,FSRCTableName,FSRCTableNameAs,FDSPFieldName,FFNDFieldName,FValueLocation,FFilter,FFilterGroup,FValueType,FDspColType,FEditlen,FValuePrecision,FSaveRule,FDefValue,FAction,FUserDefine,FNote,FKeyWord,FLeft,FTop,FHeight,FWidth,FCondition,FTabIndex,FLock,FSum,FPrec,FScale,FLayer,FLoadAction,FUnControl,FFont,FSourceType,FSubKey,FParentKey,FConditionExt,FFrameBorder,FFrameBorderColor,FLabelWidth,FLabelColor,FTextColor,FIsF7,FContainer,FStyle) 
VALUES (200000022,1,'工厂交期','日期2','Date2','FFacDate','FFacDate','t_BosPlasticPoInStock','',0,2,-1,0,1,0,0,'',0,0,'','','','','','',1,'','',61,0,8,8,'','','',1,'','',2835,2160,285,2235,'2,13',29,0,0,3,23,0,'',1,'',0,'','',0,2,0,0,0,0,0,'',0) 
GO

INSERT INTO ICClassTableInfo(FClassTypeID,FPage,FCaption_CHS,FCaption_CHT,FCaption_EN,FKey,FFieldName,FTableName,FTableNameAs,FListIndex,FListClassName,FVisible,FEnable,FNeedSave,FMustInput,FCtlType,FProperty,FLookUpType,FLookUpClassID,FLookUpList,FSRCFieldName,FSRCTableName,FSRCTableNameAs,FDSPFieldName,FFNDFieldName,FValueLocation,FFilter,FFilterGroup,FValueType,FDspColType,FEditlen,FValuePrecision,FSaveRule,FDefValue,FAction,FUserDefine,FNote,FKeyWord,FLeft,FTop,FHeight,FWidth,FCondition,FTabIndex,FLock,FSum,FPrec,FScale,FLayer,FLoadAction,FUnControl,FFont,FSourceType,FSubKey,FParentKey,FConditionExt,FFrameBorder,FFrameBorderColor,FLabelWidth,FLabelColor,FTextColor,FIsF7,FContainer,FStyle) 
VALUES (200000022,1,'单据类型','基礎資料1','Master Data1','FBillType','FBillType','t_BosPlasticPoInStock','',0,2,-1,0,1,0,1,'',2,10007,'','FInterID','t_SubMessage','t_SubMessage1','FName','FID',1,'','',56,500,255,4,'','','',1,'','',180,330,315,2595,'0',30,0,0,0,10,0,'',17,'',1,'','',0,2,0,0,0,0,0,'',0) 
GO

INSERT INTO ICClassTableInfo(FClassTypeID,FPage,FCaption_CHS,FCaption_CHT,FCaption_EN,FKey,FFieldName,FTableName,FTableNameAs,FListIndex,FListClassName,FVisible,FEnable,FNeedSave,FMustInput,FCtlType,FProperty,FLookUpType,FLookUpClassID,FLookUpList,FSRCFieldName,FSRCTableName,FSRCTableNameAs,FDSPFieldName,FFNDFieldName,FValueLocation,FFilter,FFilterGroup,FValueType,FDspColType,FEditlen,FValuePrecision,FSaveRule,FDefValue,FAction,FUserDefine,FNote,FKeyWord,FLeft,FTop,FHeight,FWidth,FCondition,FTabIndex,FLock,FSum,FPrec,FScale,FLayer,FLoadAction,FUnControl,FFont,FSourceType,FSubKey,FParentKey,FConditionExt,FFrameBorder,FFrameBorderColor,FLabelWidth,FLabelColor,FTextColor,FIsF7,FContainer,FStyle) 
VALUES (200000022,1,'采购订单','文本3','Text3','FPOBillNO','FPOBillNO','t_BosPlasticPoInStock','',0,2,-1,0,1,0,1,'',0,0,'','','','','FName','',1,'','',167,500,50,50,'','','',1,'','',7200,330,315,2130,'0,13',31,0,0,0,0,0,'',19,'',0,'','',0,2,0,0,0,0,0,'',0) 
GO

INSERT INTO ICClassTableInfo(FClassTypeID,FPage,FCaption_CHS,FCaption_CHT,FCaption_EN,FKey,FFieldName,FTableName,FTableNameAs,FListIndex,FListClassName,FVisible,FEnable,FNeedSave,FMustInput,FCtlType,FProperty,FLookUpType,FLookUpClassID,FLookUpList,FSRCFieldName,FSRCTableName,FSRCTableNameAs,FDSPFieldName,FFNDFieldName,FValueLocation,FFilter,FFilterGroup,FValueType,FDspColType,FEditlen,FValuePrecision,FSaveRule,FDefValue,FAction,FUserDefine,FNote,FKeyWord,FLeft,FTop,FHeight,FWidth,FCondition,FTabIndex,FLock,FSum,FPrec,FScale,FLayer,FLoadAction,FUnControl,FFont,FSourceType,FSubKey,FParentKey,FConditionExt,FFrameBorder,FFrameBorderColor,FLabelWidth,FLabelColor,FTextColor,FIsF7,FContainer,FStyle) 
VALUES (200000022,1,'供应商','供應商1','Vendor1','FBase','FSupplyID','t_BosPlasticPoInStock','',0,2,-1,0,1,0,1,'',1,8,'','FItemID','t_Supplier','t_Supplier1','FName','FNumber',1,'','',56,500,255,4,'','','',1,'','',2970,765,375,2010,'0',32,0,0,0,10,0,'',17,'',1,'','',0,2,0,0,0,0,0,'',0) 
GO

INSERT INTO ICClassTableInfo(FClassTypeID,FPage,FCaption_CHS,FCaption_CHT,FCaption_EN,FKey,FFieldName,FTableName,FTableNameAs,FListIndex,FListClassName,FVisible,FEnable,FNeedSave,FMustInput,FCtlType,FProperty,FLookUpType,FLookUpClassID,FLookUpList,FSRCFieldName,FSRCTableName,FSRCTableNameAs,FDSPFieldName,FFNDFieldName,FValueLocation,FFilter,FFilterGroup,FValueType,FDspColType,FEditlen,FValuePrecision,FSaveRule,FDefValue,FAction,FUserDefine,FNote,FKeyWord,FLeft,FTop,FHeight,FWidth,FCondition,FTabIndex,FLock,FSum,FPrec,FScale,FLayer,FLoadAction,FUnControl,FFont,FSourceType,FSubKey,FParentKey,FConditionExt,FFrameBorder,FFrameBorderColor,FLabelWidth,FLabelColor,FTextColor,FIsF7,FContainer,FStyle) 
VALUES (200000022,2,'分录内码','分錄內碼','Entry ISN','FEntryID2','FEntryID','t_BosPlasticPoInStockEntry','',10,0,0,1,0,0,3,'',0,0,'','','','','','',1,'','',56,500,255,4,'','','',1,'','ENTRYKEY',240,120,350,1800,'-1',-1,0,0,0,0,0,'',1,'',0,'','',0,0,0,0,0,0,0,'',0) 
GO

INSERT INTO ICClassTableInfo(FClassTypeID,FPage,FCaption_CHS,FCaption_CHT,FCaption_EN,FKey,FFieldName,FTableName,FTableNameAs,FListIndex,FListClassName,FVisible,FEnable,FNeedSave,FMustInput,FCtlType,FProperty,FLookUpType,FLookUpClassID,FLookUpList,FSRCFieldName,FSRCTableName,FSRCTableNameAs,FDSPFieldName,FFNDFieldName,FValueLocation,FFilter,FFilterGroup,FValueType,FDspColType,FEditlen,FValuePrecision,FSaveRule,FDefValue,FAction,FUserDefine,FNote,FKeyWord,FLeft,FTop,FHeight,FWidth,FCondition,FTabIndex,FLock,FSum,FPrec,FScale,FLayer,FLoadAction,FUnControl,FFont,FSourceType,FSubKey,FParentKey,FConditionExt,FFrameBorder,FFrameBorderColor,FLabelWidth,FLabelColor,FTextColor,FIsF7,FContainer,FStyle) 
VALUES (200000022,2,'单据内码','單據內碼','Doc ISN','FID2','FID','t_BosPlasticPoInStockEntry','',33,0,0,1,1,1,3,'',0,0,'','','','','','',1,'','',56,500,255,4,'','','',1,'','PARENTID',240,120,350,1800,'-1',-1,0,0,0,0,0,'',1,'',0,'','',0,0,0,0,0,0,0,'',0) 
GO

INSERT INTO ICClassTableInfo(FClassTypeID,FPage,FCaption_CHS,FCaption_CHT,FCaption_EN,FKey,FFieldName,FTableName,FTableNameAs,FListIndex,FListClassName,FVisible,FEnable,FNeedSave,FMustInput,FCtlType,FProperty,FLookUpType,FLookUpClassID,FLookUpList,FSRCFieldName,FSRCTableName,FSRCTableNameAs,FDSPFieldName,FFNDFieldName,FValueLocation,FFilter,FFilterGroup,FValueType,FDspColType,FEditlen,FValuePrecision,FSaveRule,FDefValue,FAction,FUserDefine,FNote,FKeyWord,FLeft,FTop,FHeight,FWidth,FCondition,FTabIndex,FLock,FSum,FPrec,FScale,FLayer,FLoadAction,FUnControl,FFont,FSourceType,FSubKey,FParentKey,FConditionExt,FFrameBorder,FFrameBorderColor,FLabelWidth,FLabelColor,FTextColor,FIsF7,FContainer,FStyle) 
VALUES (200000022,2,'行号','行號','Row No.','FIndex2','FIndex','t_BosPlasticPoInStockEntry','',34,0,0,1,1,0,3,'',0,0,'','','','','','',1,'','',56,500,255,4,'','','',1,'','INDEX',240,120,350,1800,'-1',-1,-1,0,0,0,0,'',1,'',0,'','',0,0,0,0,0,0,0,'',0) 
GO

INSERT INTO ICClassTableInfo(FClassTypeID,FPage,FCaption_CHS,FCaption_CHT,FCaption_EN,FKey,FFieldName,FTableName,FTableNameAs,FListIndex,FListClassName,FVisible,FEnable,FNeedSave,FMustInput,FCtlType,FProperty,FLookUpType,FLookUpClassID,FLookUpList,FSRCFieldName,FSRCTableName,FSRCTableNameAs,FDSPFieldName,FFNDFieldName,FValueLocation,FFilter,FFilterGroup,FValueType,FDspColType,FEditlen,FValuePrecision,FSaveRule,FDefValue,FAction,FUserDefine,FNote,FKeyWord,FLeft,FTop,FHeight,FWidth,FCondition,FTabIndex,FLock,FSum,FPrec,FScale,FLayer,FLoadAction,FUnControl,FFont,FSourceType,FSubKey,FParentKey,FConditionExt,FFrameBorder,FFrameBorderColor,FLabelWidth,FLabelColor,FTextColor,FIsF7,FContainer,FStyle) 
VALUES (200000022,2,'成本对象','成本對象','Cost Object','FCostObjID','FCostObjID','t_BosPlasticPoInStockEntry','',10,0,-1,0,1,0,1,'',1,2001,'','FItemID','cbCostObj','','FName','FNumber',1,'','',56,500,255,4,'','','',1,'','',5158,7738,346,2500,'0',0,-1,0,0,10,0,'',17,'',1,'','',0,2,0,0,0,0,0,'',0) 
GO

INSERT INTO ICClassTableInfo(FClassTypeID,FPage,FCaption_CHS,FCaption_CHT,FCaption_EN,FKey,FFieldName,FTableName,FTableNameAs,FListIndex,FListClassName,FVisible,FEnable,FNeedSave,FMustInput,FCtlType,FProperty,FLookUpType,FLookUpClassID,FLookUpList,FSRCFieldName,FSRCTableName,FSRCTableNameAs,FDSPFieldName,FFNDFieldName,FValueLocation,FFilter,FFilterGroup,FValueType,FDspColType,FEditlen,FValuePrecision,FSaveRule,FDefValue,FAction,FUserDefine,FNote,FKeyWord,FLeft,FTop,FHeight,FWidth,FCondition,FTabIndex,FLock,FSum,FPrec,FScale,FLayer,FLoadAction,FUnControl,FFont,FSourceType,FSubKey,FParentKey,FConditionExt,FFrameBorder,FFrameBorderColor,FLabelWidth,FLabelColor,FTextColor,FIsF7,FContainer,FStyle) 
VALUES (200000022,2,'产品','物料1','Mtrl1','FProductID','FProductID','t_BosPlasticPoInStockEntry','',17,0,-1,0,1,0,1,'',1,4,'','FItemID','t_ICItem','t_ICItem1','FNumber','FNumber',1,'','',56,500,255,4,'','','',1,'','',5158,7738,346,2500,'0',1,-1,0,0,10,0,'',17,'',1,'','',0,2,0,0,0,0,0,'',0) 
GO

INSERT INTO ICClassTableInfo(FClassTypeID,FPage,FCaption_CHS,FCaption_CHT,FCaption_EN,FKey,FFieldName,FTableName,FTableNameAs,FListIndex,FListClassName,FVisible,FEnable,FNeedSave,FMustInput,FCtlType,FProperty,FLookUpType,FLookUpClassID,FLookUpList,FSRCFieldName,FSRCTableName,FSRCTableNameAs,FDSPFieldName,FFNDFieldName,FValueLocation,FFilter,FFilterGroup,FValueType,FDspColType,FEditlen,FValuePrecision,FSaveRule,FDefValue,FAction,FUserDefine,FNote,FKeyWord,FLeft,FTop,FHeight,FWidth,FCondition,FTabIndex,FLock,FSum,FPrec,FScale,FLayer,FLoadAction,FUnControl,FFont,FSourceType,FSubKey,FParentKey,FConditionExt,FFrameBorder,FFrameBorderColor,FLabelWidth,FLabelColor,FTextColor,FIsF7,FContainer,FStyle) 
VALUES (200000022,2,'产品名称','基礎資料屬性1','Master Data Property1','FBaseProperty1','FProductID','t_BosPlasticPoInStockEntry','',19,0,-1,0,0,0,1,'',0,4,'','FItemID','t_ICItem','t_ICItem1','FName','',3,'','',167,500,255,0,'','','',1,'','',0,0,0,2500,'0',2,-1,0,0,0,0,'',55,'',2,'','',0,2,0,0,0,0,0,'',0) 
GO

INSERT INTO ICClassTableInfo(FClassTypeID,FPage,FCaption_CHS,FCaption_CHT,FCaption_EN,FKey,FFieldName,FTableName,FTableNameAs,FListIndex,FListClassName,FVisible,FEnable,FNeedSave,FMustInput,FCtlType,FProperty,FLookUpType,FLookUpClassID,FLookUpList,FSRCFieldName,FSRCTableName,FSRCTableNameAs,FDSPFieldName,FFNDFieldName,FValueLocation,FFilter,FFilterGroup,FValueType,FDspColType,FEditlen,FValuePrecision,FSaveRule,FDefValue,FAction,FUserDefine,FNote,FKeyWord,FLeft,FTop,FHeight,FWidth,FCondition,FTabIndex,FLock,FSum,FPrec,FScale,FLayer,FLoadAction,FUnControl,FFont,FSourceType,FSubKey,FParentKey,FConditionExt,FFrameBorder,FFrameBorderColor,FLabelWidth,FLabelColor,FTextColor,FIsF7,FContainer,FStyle) 
VALUES (200000022,2,'产品数量','小數5','Decimal Fraction5','FICMOQty','FICMOQty','t_BosPlasticPoInStockEntry','',10,0,-1,0,1,0,2,'',0,0,'','','','','','',1,'','',106,9,20,13,'','','',1,'','',0,0,350,2500,'1,13',3,0,0,28,2,0,'',17,'',0,'','',0,2,0,0,0,0,0,'',0) 
GO

INSERT INTO ICClassTableInfo(FClassTypeID,FPage,FCaption_CHS,FCaption_CHT,FCaption_EN,FKey,FFieldName,FTableName,FTableNameAs,FListIndex,FListClassName,FVisible,FEnable,FNeedSave,FMustInput,FCtlType,FProperty,FLookUpType,FLookUpClassID,FLookUpList,FSRCFieldName,FSRCTableName,FSRCTableNameAs,FDSPFieldName,FFNDFieldName,FValueLocation,FFilter,FFilterGroup,FValueType,FDspColType,FEditlen,FValuePrecision,FSaveRule,FDefValue,FAction,FUserDefine,FNote,FKeyWord,FLeft,FTop,FHeight,FWidth,FCondition,FTabIndex,FLock,FSum,FPrec,FScale,FLayer,FLoadAction,FUnControl,FFont,FSourceType,FSubKey,FParentKey,FConditionExt,FFrameBorder,FFrameBorderColor,FLabelWidth,FLabelColor,FTextColor,FIsF7,FContainer,FStyle) 
VALUES (200000022,2,'物料','物料','Mtrl','FItemId','FItemId','t_BosPlasticPoInStockEntry','',10,0,-1,0,1,1,1,'',1,4,'','FItemID','t_ICItem','','FNumber','FNumber',1,'','',56,500,255,4,'','','TakeBaseData{FBaseProperty,FUnitId=FUnitID}',1,'','',5158,7738,346,1860,'0',4,0,0,0,10,0,'',17,'',1,'','',0,2,0,0,0,0,0,'',0) 
GO

INSERT INTO ICClassTableInfo(FClassTypeID,FPage,FCaption_CHS,FCaption_CHT,FCaption_EN,FKey,FFieldName,FTableName,FTableNameAs,FListIndex,FListClassName,FVisible,FEnable,FNeedSave,FMustInput,FCtlType,FProperty,FLookUpType,FLookUpClassID,FLookUpList,FSRCFieldName,FSRCTableName,FSRCTableNameAs,FDSPFieldName,FFNDFieldName,FValueLocation,FFilter,FFilterGroup,FValueType,FDspColType,FEditlen,FValuePrecision,FSaveRule,FDefValue,FAction,FUserDefine,FNote,FKeyWord,FLeft,FTop,FHeight,FWidth,FCondition,FTabIndex,FLock,FSum,FPrec,FScale,FLayer,FLoadAction,FUnControl,FFont,FSourceType,FSubKey,FParentKey,FConditionExt,FFrameBorder,FFrameBorderColor,FLabelWidth,FLabelColor,FTextColor,FIsF7,FContainer,FStyle) 
VALUES (200000022,2,'名称','基礎資料屬性','Master Data Property','FBaseProperty','FItemId','t_BosPlasticPoInStockEntry','',11,0,-1,0,0,0,1,'',0,4,'','FItemID','t_ICItem','','FName','',3,'','',167,500,255,0,'','','',1,'','',0,0,0,2500,'0',5,-1,0,0,0,0,'',55,'',2,'','',0,2,0,0,0,0,0,'',0) 
GO

INSERT INTO ICClassTableInfo(FClassTypeID,FPage,FCaption_CHS,FCaption_CHT,FCaption_EN,FKey,FFieldName,FTableName,FTableNameAs,FListIndex,FListClassName,FVisible,FEnable,FNeedSave,FMustInput,FCtlType,FProperty,FLookUpType,FLookUpClassID,FLookUpList,FSRCFieldName,FSRCTableName,FSRCTableNameAs,FDSPFieldName,FFNDFieldName,FValueLocation,FFilter,FFilterGroup,FValueType,FDspColType,FEditlen,FValuePrecision,FSaveRule,FDefValue,FAction,FUserDefine,FNote,FKeyWord,FLeft,FTop,FHeight,FWidth,FCondition,FTabIndex,FLock,FSum,FPrec,FScale,FLayer,FLoadAction,FUnControl,FFont,FSourceType,FSubKey,FParentKey,FConditionExt,FFrameBorder,FFrameBorderColor,FLabelWidth,FLabelColor,FTextColor,FIsF7,FContainer,FStyle) 
VALUES (200000022,2,'规格型号','基礎資料屬性2','Master Data Property2','FBaseProperty2','FItemId','t_BosPlasticPoInStockEntry','',18,0,-1,0,0,0,1,'',0,4,'','FItemID','t_ICItem','','FModel','',3,'','',167,500,255,0,'','','',1,'','',0,0,0,2500,'0',6,-1,0,0,0,0,'',55,'',2,'','',0,2,0,0,0,0,0,'',0) 
GO

INSERT INTO ICClassTableInfo(FClassTypeID,FPage,FCaption_CHS,FCaption_CHT,FCaption_EN,FKey,FFieldName,FTableName,FTableNameAs,FListIndex,FListClassName,FVisible,FEnable,FNeedSave,FMustInput,FCtlType,FProperty,FLookUpType,FLookUpClassID,FLookUpList,FSRCFieldName,FSRCTableName,FSRCTableNameAs,FDSPFieldName,FFNDFieldName,FValueLocation,FFilter,FFilterGroup,FValueType,FDspColType,FEditlen,FValuePrecision,FSaveRule,FDefValue,FAction,FUserDefine,FNote,FKeyWord,FLeft,FTop,FHeight,FWidth,FCondition,FTabIndex,FLock,FSum,FPrec,FScale,FLayer,FLoadAction,FUnControl,FFont,FSourceType,FSubKey,FParentKey,FConditionExt,FFrameBorder,FFrameBorderColor,FLabelWidth,FLabelColor,FTextColor,FIsF7,FContainer,FStyle) 
VALUES (200000022,2,'计量单位','計量單位','Unit of Measure (UoM)','FUnitId','FUnitId','t_BosPlasticPoInStockEntry','',20,0,-1,0,1,1,1,'FItemId.FUnitGroupID',6,7,'','FItemID','t_Measureunit','','FName','FNumber',1,'','',56,500,255,4,'','','',1,'','',5158,7738,346,1290,'0',7,0,0,0,10,0,'',17,'',1,'','',0,2,0,0,0,0,0,'',0) 
GO

INSERT INTO ICClassTableInfo(FClassTypeID,FPage,FCaption_CHS,FCaption_CHT,FCaption_EN,FKey,FFieldName,FTableName,FTableNameAs,FListIndex,FListClassName,FVisible,FEnable,FNeedSave,FMustInput,FCtlType,FProperty,FLookUpType,FLookUpClassID,FLookUpList,FSRCFieldName,FSRCTableName,FSRCTableNameAs,FDSPFieldName,FFNDFieldName,FValueLocation,FFilter,FFilterGroup,FValueType,FDspColType,FEditlen,FValuePrecision,FSaveRule,FDefValue,FAction,FUserDefine,FNote,FKeyWord,FLeft,FTop,FHeight,FWidth,FCondition,FTabIndex,FLock,FSum,FPrec,FScale,FLayer,FLoadAction,FUnControl,FFont,FSourceType,FSubKey,FParentKey,FConditionExt,FFrameBorder,FFrameBorderColor,FLabelWidth,FLabelColor,FTextColor,FIsF7,FContainer,FStyle) 
VALUES (200000022,2,'单位用量','小數3','Decimal Fraction3','FPerQty','FPerQty','t_BosPlasticPoInStockEntry','',10,0,-1,0,1,0,2,'',0,0,'','','','','','',1,'','',106,9,20,13,'','','',1,'','',0,0,350,2500,'1,13',8,0,0,28,2,0,'',17,'',0,'','',0,2,0,0,0,0,0,'',0) 
GO

INSERT INTO ICClassTableInfo(FClassTypeID,FPage,FCaption_CHS,FCaption_CHT,FCaption_EN,FKey,FFieldName,FTableName,FTableNameAs,FListIndex,FListClassName,FVisible,FEnable,FNeedSave,FMustInput,FCtlType,FProperty,FLookUpType,FLookUpClassID,FLookUpList,FSRCFieldName,FSRCTableName,FSRCTableNameAs,FDSPFieldName,FFNDFieldName,FValueLocation,FFilter,FFilterGroup,FValueType,FDspColType,FEditlen,FValuePrecision,FSaveRule,FDefValue,FAction,FUserDefine,FNote,FKeyWord,FLeft,FTop,FHeight,FWidth,FCondition,FTabIndex,FLock,FSum,FPrec,FScale,FLayer,FLoadAction,FUnControl,FFont,FSourceType,FSubKey,FParentKey,FConditionExt,FFrameBorder,FFrameBorderColor,FLabelWidth,FLabelColor,FTextColor,FIsF7,FContainer,FStyle) 
VALUES (200000022,2,'BOM数量','小數6','Decimal Fraction6','FBomQty','FBomQty','t_BosPlasticPoInStockEntry','',10,0,-1,0,1,0,2,'',0,0,'','','','','','',1,'','',106,9,20,13,'','','',1,'','',0,0,350,2500,'1,13',9,0,1,28,2,0,'',17,'',0,'','',0,2,0,0,0,0,0,'',0) 
GO

INSERT INTO ICClassTableInfo(FClassTypeID,FPage,FCaption_CHS,FCaption_CHT,FCaption_EN,FKey,FFieldName,FTableName,FTableNameAs,FListIndex,FListClassName,FVisible,FEnable,FNeedSave,FMustInput,FCtlType,FProperty,FLookUpType,FLookUpClassID,FLookUpList,FSRCFieldName,FSRCTableName,FSRCTableNameAs,FDSPFieldName,FFNDFieldName,FValueLocation,FFilter,FFilterGroup,FValueType,FDspColType,FEditlen,FValuePrecision,FSaveRule,FDefValue,FAction,FUserDefine,FNote,FKeyWord,FLeft,FTop,FHeight,FWidth,FCondition,FTabIndex,FLock,FSum,FPrec,FScale,FLayer,FLoadAction,FUnControl,FFont,FSourceType,FSubKey,FParentKey,FConditionExt,FFrameBorder,FFrameBorderColor,FLabelWidth,FLabelColor,FTextColor,FIsF7,FContainer,FStyle) 
VALUES (200000022,2,'源单内码','源單內碼','Source Doc ISN','FID_SRC','FID_SRC','t_BosPlasticPoInStockEntry','',14,0,12,0,1,0,3,'',0,0,'','','','','','',1,'','',56,10,10,4,'','','',1,'','SRCID',0,0,350,2500,'-1',9,-1,0,0,0,0,'',33,'',0,'','',0,0,0,0,0,0,0,'',0) 
GO

INSERT INTO ICClassTableInfo(FClassTypeID,FPage,FCaption_CHS,FCaption_CHT,FCaption_EN,FKey,FFieldName,FTableName,FTableNameAs,FListIndex,FListClassName,FVisible,FEnable,FNeedSave,FMustInput,FCtlType,FProperty,FLookUpType,FLookUpClassID,FLookUpList,FSRCFieldName,FSRCTableName,FSRCTableNameAs,FDSPFieldName,FFNDFieldName,FValueLocation,FFilter,FFilterGroup,FValueType,FDspColType,FEditlen,FValuePrecision,FSaveRule,FDefValue,FAction,FUserDefine,FNote,FKeyWord,FLeft,FTop,FHeight,FWidth,FCondition,FTabIndex,FLock,FSum,FPrec,FScale,FLayer,FLoadAction,FUnControl,FFont,FSourceType,FSubKey,FParentKey,FConditionExt,FFrameBorder,FFrameBorderColor,FLabelWidth,FLabelColor,FTextColor,FIsF7,FContainer,FStyle) 
VALUES (200000022,2,'源单分录','源單分錄','Source Entry ISN','FEntryID_SRC','FEntryID_SRC','t_BosPlasticPoInStockEntry','',15,0,12,0,1,0,3,'FID_SRC',0,0,'','','','','','',1,'','',56,10,10,4,'','','',1,'','SRCENTRYID',0,0,350,2500,'-1',10,-1,0,0,0,0,'',33,'',0,'','',0,0,0,0,0,0,0,'',0) 
GO

INSERT INTO ICClassTableInfo(FClassTypeID,FPage,FCaption_CHS,FCaption_CHT,FCaption_EN,FKey,FFieldName,FTableName,FTableNameAs,FListIndex,FListClassName,FVisible,FEnable,FNeedSave,FMustInput,FCtlType,FProperty,FLookUpType,FLookUpClassID,FLookUpList,FSRCFieldName,FSRCTableName,FSRCTableNameAs,FDSPFieldName,FFNDFieldName,FValueLocation,FFilter,FFilterGroup,FValueType,FDspColType,FEditlen,FValuePrecision,FSaveRule,FDefValue,FAction,FUserDefine,FNote,FKeyWord,FLeft,FTop,FHeight,FWidth,FCondition,FTabIndex,FLock,FSum,FPrec,FScale,FLayer,FLoadAction,FUnControl,FFont,FSourceType,FSubKey,FParentKey,FConditionExt,FFrameBorder,FFrameBorderColor,FLabelWidth,FLabelColor,FTextColor,FIsF7,FContainer,FStyle) 
VALUES (200000022,2,'损耗率(%)','小數1','Decimal Fraction1','FScrap','FScrap','t_BosPlasticPoInStockEntry','',25,0,-1,0,1,0,2,'',0,0,'','','','','','',1,'','',106,9,20,13,'','','',1,'','',0,0,350,2500,'1,13',10,-1,0,28,4,0,'',17,'',0,'','',0,2,0,0,0,0,0,'',0) 
GO

INSERT INTO ICClassTableInfo(FClassTypeID,FPage,FCaption_CHS,FCaption_CHT,FCaption_EN,FKey,FFieldName,FTableName,FTableNameAs,FListIndex,FListClassName,FVisible,FEnable,FNeedSave,FMustInput,FCtlType,FProperty,FLookUpType,FLookUpClassID,FLookUpList,FSRCFieldName,FSRCTableName,FSRCTableNameAs,FDSPFieldName,FFNDFieldName,FValueLocation,FFilter,FFilterGroup,FValueType,FDspColType,FEditlen,FValuePrecision,FSaveRule,FDefValue,FAction,FUserDefine,FNote,FKeyWord,FLeft,FTop,FHeight,FWidth,FCondition,FTabIndex,FLock,FSum,FPrec,FScale,FLayer,FLoadAction,FUnControl,FFont,FSourceType,FSubKey,FParentKey,FConditionExt,FFrameBorder,FFrameBorderColor,FLabelWidth,FLabelColor,FTextColor,FIsF7,FContainer,FStyle) 
VALUES (200000022,2,'损耗数','小數4','Decimal Fraction4','FScrapQty','FScrapQty','t_BosPlasticPoInStockEntry','',10,0,-1,0,1,0,2,'',0,0,'','','','','','',1,'','',106,9,20,13,'','','',1,'','',0,0,350,2500,'1,13',11,0,1,28,2,0,'',17,'',0,'','',0,2,0,0,0,0,0,'',0) 
GO

INSERT INTO ICClassTableInfo(FClassTypeID,FPage,FCaption_CHS,FCaption_CHT,FCaption_EN,FKey,FFieldName,FTableName,FTableNameAs,FListIndex,FListClassName,FVisible,FEnable,FNeedSave,FMustInput,FCtlType,FProperty,FLookUpType,FLookUpClassID,FLookUpList,FSRCFieldName,FSRCTableName,FSRCTableNameAs,FDSPFieldName,FFNDFieldName,FValueLocation,FFilter,FFilterGroup,FValueType,FDspColType,FEditlen,FValuePrecision,FSaveRule,FDefValue,FAction,FUserDefine,FNote,FKeyWord,FLeft,FTop,FHeight,FWidth,FCondition,FTabIndex,FLock,FSum,FPrec,FScale,FLayer,FLoadAction,FUnControl,FFont,FSourceType,FSubKey,FParentKey,FConditionExt,FFrameBorder,FFrameBorderColor,FLabelWidth,FLabelColor,FTextColor,FIsF7,FContainer,FStyle) 
VALUES (200000022,2,'数量','小數2','Decimal Fraction2','FQty','FQty','t_BosPlasticPoInStockEntry','',10,0,-1,0,1,0,2,'',0,0,'','','','','','',1,'','',106,9,20,13,'','','',1,'','',0,0,350,2500,'1,13',12,0,1,28,4,0,'',17,'',0,'','',0,2,0,0,0,0,0,'',0) 
GO

INSERT INTO ICClassTableInfo(FClassTypeID,FPage,FCaption_CHS,FCaption_CHT,FCaption_EN,FKey,FFieldName,FTableName,FTableNameAs,FListIndex,FListClassName,FVisible,FEnable,FNeedSave,FMustInput,FCtlType,FProperty,FLookUpType,FLookUpClassID,FLookUpList,FSRCFieldName,FSRCTableName,FSRCTableNameAs,FDSPFieldName,FFNDFieldName,FValueLocation,FFilter,FFilterGroup,FValueType,FDspColType,FEditlen,FValuePrecision,FSaveRule,FDefValue,FAction,FUserDefine,FNote,FKeyWord,FLeft,FTop,FHeight,FWidth,FCondition,FTabIndex,FLock,FSum,FPrec,FScale,FLayer,FLoadAction,FUnControl,FFont,FSourceType,FSubKey,FParentKey,FConditionExt,FFrameBorder,FFrameBorderColor,FLabelWidth,FLabelColor,FTextColor,FIsF7,FContainer,FStyle) 
VALUES (200000022,2,'备损率(%)','小數','Decimal Fraction','FPrepScrap','FPrepScrap','t_BosPlasticPoInStockEntry','',23,0,12,0,1,0,2,'',0,0,'','','','','','',1,'','',106,9,20,13,'','','',1,'','',0,0,350,0,'1,13',13,-1,0,28,2,0,'',17,'',0,'','',0,2,0,0,0,0,0,'',0) 
GO

INSERT INTO ICClassTableInfo(FClassTypeID,FPage,FCaption_CHS,FCaption_CHT,FCaption_EN,FKey,FFieldName,FTableName,FTableNameAs,FListIndex,FListClassName,FVisible,FEnable,FNeedSave,FMustInput,FCtlType,FProperty,FLookUpType,FLookUpClassID,FLookUpList,FSRCFieldName,FSRCTableName,FSRCTableNameAs,FDSPFieldName,FFNDFieldName,FValueLocation,FFilter,FFilterGroup,FValueType,FDspColType,FEditlen,FValuePrecision,FSaveRule,FDefValue,FAction,FUserDefine,FNote,FKeyWord,FLeft,FTop,FHeight,FWidth,FCondition,FTabIndex,FLock,FSum,FPrec,FScale,FLayer,FLoadAction,FUnControl,FFont,FSourceType,FSubKey,FParentKey,FConditionExt,FFrameBorder,FFrameBorderColor,FLabelWidth,FLabelColor,FTextColor,FIsF7,FContainer,FStyle) 
VALUES (200000022,2,'仓库','倉庫','Warehouse','FStockID','FStockID','t_BosPlasticPoInStockEntry','',12,0,-1,0,1,1,1,'',1,5,'','FItemID','t_Stock','','FName','FNumber',1,'','',56,500,255,4,'','','',1,'','',5158,7738,346,2500,'0',13,0,0,0,10,0,'',17,'',1,'','',0,2,0,0,0,0,0,'',0) 
GO

INSERT INTO ICClassTableInfo(FClassTypeID,FPage,FCaption_CHS,FCaption_CHT,FCaption_EN,FKey,FFieldName,FTableName,FTableNameAs,FListIndex,FListClassName,FVisible,FEnable,FNeedSave,FMustInput,FCtlType,FProperty,FLookUpType,FLookUpClassID,FLookUpList,FSRCFieldName,FSRCTableName,FSRCTableNameAs,FDSPFieldName,FFNDFieldName,FValueLocation,FFilter,FFilterGroup,FValueType,FDspColType,FEditlen,FValuePrecision,FSaveRule,FDefValue,FAction,FUserDefine,FNote,FKeyWord,FLeft,FTop,FHeight,FWidth,FCondition,FTabIndex,FLock,FSum,FPrec,FScale,FLayer,FLoadAction,FUnControl,FFont,FSourceType,FSubKey,FParentKey,FConditionExt,FFrameBorder,FFrameBorderColor,FLabelWidth,FLabelColor,FTextColor,FIsF7,FContainer,FStyle) 
VALUES (200000022,2,'备损数','數量2','Quantity2','FPrepScrapQty','FPrepScrapQty','t_BosPlasticPoInStockEntry','',24,0,12,0,1,0,2,'FUnitId',0,0,'','','','','','',1,'','',106,9,28,13,'','','',1,'','QTY',0,0,350,0,'1,13',14,-1,1,28,10,0,'',17,'',0,'','',0,2,0,0,0,0,0,'',0) 
GO

INSERT INTO ICClassTableInfo(FClassTypeID,FPage,FCaption_CHS,FCaption_CHT,FCaption_EN,FKey,FFieldName,FTableName,FTableNameAs,FListIndex,FListClassName,FVisible,FEnable,FNeedSave,FMustInput,FCtlType,FProperty,FLookUpType,FLookUpClassID,FLookUpList,FSRCFieldName,FSRCTableName,FSRCTableNameAs,FDSPFieldName,FFNDFieldName,FValueLocation,FFilter,FFilterGroup,FValueType,FDspColType,FEditlen,FValuePrecision,FSaveRule,FDefValue,FAction,FUserDefine,FNote,FKeyWord,FLeft,FTop,FHeight,FWidth,FCondition,FTabIndex,FLock,FSum,FPrec,FScale,FLayer,FLoadAction,FUnControl,FFont,FSourceType,FSubKey,FParentKey,FConditionExt,FFrameBorder,FFrameBorderColor,FLabelWidth,FLabelColor,FTextColor,FIsF7,FContainer,FStyle) 
VALUES (200000022,2,'备注','文本','Text','FRemark','FRemark','t_BosPlasticPoInStockEntry','',34,0,-1,0,1,0,1,'',0,0,'','','','','FName','',1,'','',167,500,50,50,'','','',1,'','',0,0,350,2500,'0,13',14,0,0,0,0,0,'',19,'',0,'','',0,2,0,0,0,0,0,'',0) 
GO

INSERT INTO ICClassTableInfo(FClassTypeID,FPage,FCaption_CHS,FCaption_CHT,FCaption_EN,FKey,FFieldName,FTableName,FTableNameAs,FListIndex,FListClassName,FVisible,FEnable,FNeedSave,FMustInput,FCtlType,FProperty,FLookUpType,FLookUpClassID,FLookUpList,FSRCFieldName,FSRCTableName,FSRCTableNameAs,FDSPFieldName,FFNDFieldName,FValueLocation,FFilter,FFilterGroup,FValueType,FDspColType,FEditlen,FValuePrecision,FSaveRule,FDefValue,FAction,FUserDefine,FNote,FKeyWord,FLeft,FTop,FHeight,FWidth,FCondition,FTabIndex,FLock,FSum,FPrec,FScale,FLayer,FLoadAction,FUnControl,FFont,FSourceType,FSubKey,FParentKey,FConditionExt,FFrameBorder,FFrameBorderColor,FLabelWidth,FLabelColor,FTextColor,FIsF7,FContainer,FStyle) 
VALUES (200000022,2,'源单编号','源單編號','Source Doc NO.','FBillNo_SRC','FBillNo_SRC','t_BosPlasticPoInStockEntry','',13,0,-1,0,1,0,1,'FID_SRC',12,0,'','','','','','',1,'','',167,500,50,50,'','','',1,'','SRCBILLNO',0,0,350,2500,'-1',15,-1,0,0,0,0,'',33,'',0,'','',0,0,0,0,0,0,0,'',0) 
GO

INSERT INTO ICClassTableInfo(FClassTypeID,FPage,FCaption_CHS,FCaption_CHT,FCaption_EN,FKey,FFieldName,FTableName,FTableNameAs,FListIndex,FListClassName,FVisible,FEnable,FNeedSave,FMustInput,FCtlType,FProperty,FLookUpType,FLookUpClassID,FLookUpList,FSRCFieldName,FSRCTableName,FSRCTableNameAs,FDSPFieldName,FFNDFieldName,FValueLocation,FFilter,FFilterGroup,FValueType,FDspColType,FEditlen,FValuePrecision,FSaveRule,FDefValue,FAction,FUserDefine,FNote,FKeyWord,FLeft,FTop,FHeight,FWidth,FCondition,FTabIndex,FLock,FSum,FPrec,FScale,FLayer,FLoadAction,FUnControl,FFont,FSourceType,FSubKey,FParentKey,FConditionExt,FFrameBorder,FFrameBorderColor,FLabelWidth,FLabelColor,FTextColor,FIsF7,FContainer,FStyle) 
VALUES (200000022,2,'源单类型','源單類型','Source Doc Type','FClassID_SRC','FClassID_SRC','t_BosPlasticPoInStockEntry','',16,0,-1,0,1,0,8,'FID_SRC',11,1,'','FID','ICClassType','ICClassType1','FName','FName',1,'','',56,500,255,255,'','','',1,'','SRCCLASSTYPE',0,0,350,2500,'-1',16,-1,0,0,0,0,'',33,'',0,'','',0,0,0,0,0,0,0,'',0) 
GO

INSERT INTO ICClassTableInfo(FClassTypeID,FPage,FCaption_CHS,FCaption_CHT,FCaption_EN,FKey,FFieldName,FTableName,FTableNameAs,FListIndex,FListClassName,FVisible,FEnable,FNeedSave,FMustInput,FCtlType,FProperty,FLookUpType,FLookUpClassID,FLookUpList,FSRCFieldName,FSRCTableName,FSRCTableNameAs,FDSPFieldName,FFNDFieldName,FValueLocation,FFilter,FFilterGroup,FValueType,FDspColType,FEditlen,FValuePrecision,FSaveRule,FDefValue,FAction,FUserDefine,FNote,FKeyWord,FLeft,FTop,FHeight,FWidth,FCondition,FTabIndex,FLock,FSum,FPrec,FScale,FLayer,FLoadAction,FUnControl,FFont,FSourceType,FSubKey,FParentKey,FConditionExt,FFrameBorder,FFrameBorderColor,FLabelWidth,FLabelColor,FTextColor,FIsF7,FContainer,FStyle) 
VALUES (200000022,2,'供应商','供應商','Vendor','FSupplyID','FSupplyID','t_BosPlasticPoInStockEntry','',33,0,-1,0,1,0,1,'',1,8,'','FItemID','t_Supplier','','FName','FNumber',1,'','',56,500,255,4,'','','',1,'','',5158,7738,346,2500,'0',17,0,0,0,10,0,'',17,'',1,'','',0,2,0,0,0,0,0,'',0) 
GO

INSERT INTO ICClassTableInfo(FClassTypeID,FPage,FCaption_CHS,FCaption_CHT,FCaption_EN,FKey,FFieldName,FTableName,FTableNameAs,FListIndex,FListClassName,FVisible,FEnable,FNeedSave,FMustInput,FCtlType,FProperty,FLookUpType,FLookUpClassID,FLookUpList,FSRCFieldName,FSRCTableName,FSRCTableNameAs,FDSPFieldName,FFNDFieldName,FValueLocation,FFilter,FFilterGroup,FValueType,FDspColType,FEditlen,FValuePrecision,FSaveRule,FDefValue,FAction,FUserDefine,FNote,FKeyWord,FLeft,FTop,FHeight,FWidth,FCondition,FTabIndex,FLock,FSum,FPrec,FScale,FLayer,FLoadAction,FUnControl,FFont,FSourceType,FSubKey,FParentKey,FConditionExt,FFrameBorder,FFrameBorderColor,FLabelWidth,FLabelColor,FTextColor,FIsF7,FContainer,FStyle) 
VALUES (200000022,2,'是否倒冲','基礎資料屬性3','Master Data Property3','FBaseProperty3','FItemId','t_BosPlasticPoInStockEntry','',9,0,-1,0,0,0,1,'',0,4,'','FItemID','t_ICItem','','F_115','',3,'','',167,500,255,0,'','','',1,'','',0,0,0,0,'0',18,-1,0,0,0,0,'',55,'',2,'','',0,2,0,0,0,0,0,'',0) 
GO

INSERT INTO ICClassTableInfo(FClassTypeID,FPage,FCaption_CHS,FCaption_CHT,FCaption_EN,FKey,FFieldName,FTableName,FTableNameAs,FListIndex,FListClassName,FVisible,FEnable,FNeedSave,FMustInput,FCtlType,FProperty,FLookUpType,FLookUpClassID,FLookUpList,FSRCFieldName,FSRCTableName,FSRCTableNameAs,FDSPFieldName,FFNDFieldName,FValueLocation,FFilter,FFilterGroup,FValueType,FDspColType,FEditlen,FValuePrecision,FSaveRule,FDefValue,FAction,FUserDefine,FNote,FKeyWord,FLeft,FTop,FHeight,FWidth,FCondition,FTabIndex,FLock,FSum,FPrec,FScale,FLayer,FLoadAction,FUnControl,FFont,FSourceType,FSubKey,FParentKey,FConditionExt,FFrameBorder,FFrameBorderColor,FLabelWidth,FLabelColor,FTextColor,FIsF7,FContainer,FStyle) 
VALUES (200000022,2,'物料属性','基礎資料屬性4','Master Data Property4','FBaseProperty4','FItemId','t_BosPlasticPoInStockEntry','',9,0,-1,0,0,0,1,'',0,4,'','FItemID','t_ICItem','','FErpClsID','',3,'','',167,500,255,0,'','','',1,'','',0,0,0,2500,'0',19,-1,0,0,0,0,'',55,'',2,'','',0,2,0,0,0,0,0,'',0) 
GO

INSERT INTO ICClassTableInfo(FClassTypeID,FPage,FCaption_CHS,FCaption_CHT,FCaption_EN,FKey,FFieldName,FTableName,FTableNameAs,FListIndex,FListClassName,FVisible,FEnable,FNeedSave,FMustInput,FCtlType,FProperty,FLookUpType,FLookUpClassID,FLookUpList,FSRCFieldName,FSRCTableName,FSRCTableNameAs,FDSPFieldName,FFNDFieldName,FValueLocation,FFilter,FFilterGroup,FValueType,FDspColType,FEditlen,FValuePrecision,FSaveRule,FDefValue,FAction,FUserDefine,FNote,FKeyWord,FLeft,FTop,FHeight,FWidth,FCondition,FTabIndex,FLock,FSum,FPrec,FScale,FLayer,FLoadAction,FUnControl,FFont,FSourceType,FSubKey,FParentKey,FConditionExt,FFrameBorder,FFrameBorderColor,FLabelWidth,FLabelColor,FTextColor,FIsF7,FContainer,FStyle) 
VALUES (200000022,2,'仓管员','基礎資料屬性5','Master Data Property5','FBaseProperty5','FItemId','t_BosPlasticPoInStockEntry','',9,0,-1,0,0,0,1,'',0,4,'','FItemID','t_ICItem','','F_106','',3,'','',167,500,255,0,'','','',1,'','',0,0,0,2500,'0',20,-1,0,0,0,0,'',55,'',2,'','',0,2,0,0,0,0,0,'',0) 
GO

INSERT INTO ICClassTableInfo(FClassTypeID,FPage,FCaption_CHS,FCaption_CHT,FCaption_EN,FKey,FFieldName,FTableName,FTableNameAs,FListIndex,FListClassName,FVisible,FEnable,FNeedSave,FMustInput,FCtlType,FProperty,FLookUpType,FLookUpClassID,FLookUpList,FSRCFieldName,FSRCTableName,FSRCTableNameAs,FDSPFieldName,FFNDFieldName,FValueLocation,FFilter,FFilterGroup,FValueType,FDspColType,FEditlen,FValuePrecision,FSaveRule,FDefValue,FAction,FUserDefine,FNote,FKeyWord,FLeft,FTop,FHeight,FWidth,FCondition,FTabIndex,FLock,FSum,FPrec,FScale,FLayer,FLoadAction,FUnControl,FFont,FSourceType,FSubKey,FParentKey,FConditionExt,FFrameBorder,FFrameBorderColor,FLabelWidth,FLabelColor,FTextColor,FIsF7,FContainer,FStyle) 
VALUES (200000022,2,'行业务关闭','基礎資料','Master Data','FMrpClosed','FMrpClosed','t_BosPlasticPoInStockEntry','',10,0,-1,0,1,0,1,'',2,10003,'','FInterID','t_SubMessage','','FName','FID',1,'','',56,500,255,4,'','','',1,'','',5158,7738,346,2500,'0',21,-1,0,0,10,0,'',17,'',1,'','',0,2,0,0,0,0,0,'',0) 
GO

INSERT INTO ICClassTableInfo(FClassTypeID,FPage,FCaption_CHS,FCaption_CHT,FCaption_EN,FKey,FFieldName,FTableName,FTableNameAs,FListIndex,FListClassName,FVisible,FEnable,FNeedSave,FMustInput,FCtlType,FProperty,FLookUpType,FLookUpClassID,FLookUpList,FSRCFieldName,FSRCTableName,FSRCTableNameAs,FDSPFieldName,FFNDFieldName,FValueLocation,FFilter,FFilterGroup,FValueType,FDspColType,FEditlen,FValuePrecision,FSaveRule,FDefValue,FAction,FUserDefine,FNote,FKeyWord,FLeft,FTop,FHeight,FWidth,FCondition,FTabIndex,FLock,FSum,FPrec,FScale,FLayer,FLoadAction,FUnControl,FFont,FSourceType,FSubKey,FParentKey,FConditionExt,FFrameBorder,FFrameBorderColor,FLabelWidth,FLabelColor,FTextColor,FIsF7,FContainer,FStyle) 
VALUES (200000022,2,'原物料','基礎資料2','Master Data2','folditemid','folditemid','t_BosPlasticPoInStockEntry','',10,0,-1,0,1,0,1,'',1,4,'','FItemID','t_ICItem','t_ICItem2','FName','FNumber',1,'','',56,500,255,4,'','','',1,'','',5158,7738,346,0,'0',22,-1,0,0,10,0,'',17,'',1,'','',0,2,0,0,0,0,0,'',0) 
GO

INSERT INTO ICClassTableInfo(FClassTypeID,FPage,FCaption_CHS,FCaption_CHT,FCaption_EN,FKey,FFieldName,FTableName,FTableNameAs,FListIndex,FListClassName,FVisible,FEnable,FNeedSave,FMustInput,FCtlType,FProperty,FLookUpType,FLookUpClassID,FLookUpList,FSRCFieldName,FSRCTableName,FSRCTableNameAs,FDSPFieldName,FFNDFieldName,FValueLocation,FFilter,FFilterGroup,FValueType,FDspColType,FEditlen,FValuePrecision,FSaveRule,FDefValue,FAction,FUserDefine,FNote,FKeyWord,FLeft,FTop,FHeight,FWidth,FCondition,FTabIndex,FLock,FSum,FPrec,FScale,FLayer,FLoadAction,FUnControl,FFont,FSourceType,FSubKey,FParentKey,FConditionExt,FFrameBorder,FFrameBorderColor,FLabelWidth,FLabelColor,FTextColor,FIsF7,FContainer,FStyle) 
VALUES (200000022,2,'关联数','小數8','Decimal Fraction8','FCommitQty','FCommitQty','t_BosPlasticPoInStockEntry','',10,0,-1,0,1,0,2,'',0,0,'','','','','','',1,'','',106,9,20,13,'','','',1,'','',0,0,350,2500,'1,13',23,-1,1,28,2,0,'',17,'',0,'','',0,2,0,0,0,0,0,'',0) 
GO

INSERT INTO ICClassTableInfo(FClassTypeID,FPage,FCaption_CHS,FCaption_CHT,FCaption_EN,FKey,FFieldName,FTableName,FTableNameAs,FListIndex,FListClassName,FVisible,FEnable,FNeedSave,FMustInput,FCtlType,FProperty,FLookUpType,FLookUpClassID,FLookUpList,FSRCFieldName,FSRCTableName,FSRCTableNameAs,FDSPFieldName,FFNDFieldName,FValueLocation,FFilter,FFilterGroup,FValueType,FDspColType,FEditlen,FValuePrecision,FSaveRule,FDefValue,FAction,FUserDefine,FNote,FKeyWord,FLeft,FTop,FHeight,FWidth,FCondition,FTabIndex,FLock,FSum,FPrec,FScale,FLayer,FLoadAction,FUnControl,FFont,FSourceType,FSubKey,FParentKey,FConditionExt,FFrameBorder,FFrameBorderColor,FLabelWidth,FLabelColor,FTextColor,FIsF7,FContainer,FStyle) 
VALUES (200000022,2,'未出数','小數7','Decimal Fraction7','FNoOutStockQty','FNoOutStockQty','t_BosPlasticPoInStockEntry','',10,0,-1,0,1,0,2,'',0,0,'','','','','','',1,'','',106,9,20,13,'','','',1,'','',0,0,350,2500,'1,13',24,-1,1,28,2,0,'',17,'',0,'','',0,2,0,0,0,0,0,'',0) 
GO

INSERT INTO ICClassTableInfo(FClassTypeID,FPage,FCaption_CHS,FCaption_CHT,FCaption_EN,FKey,FFieldName,FTableName,FTableNameAs,FListIndex,FListClassName,FVisible,FEnable,FNeedSave,FMustInput,FCtlType,FProperty,FLookUpType,FLookUpClassID,FLookUpList,FSRCFieldName,FSRCTableName,FSRCTableNameAs,FDSPFieldName,FFNDFieldName,FValueLocation,FFilter,FFilterGroup,FValueType,FDspColType,FEditlen,FValuePrecision,FSaveRule,FDefValue,FAction,FUserDefine,FNote,FKeyWord,FLeft,FTop,FHeight,FWidth,FCondition,FTabIndex,FLock,FSum,FPrec,FScale,FLayer,FLoadAction,FUnControl,FFont,FSourceType,FSubKey,FParentKey,FConditionExt,FFrameBorder,FFrameBorderColor,FLabelWidth,FLabelColor,FTextColor,FIsF7,FContainer,FStyle) 
VALUES (200000022,2,'关联调拨数','數量6','Quantity6','FCGStockQty','FCGStockQty','t_BosPlasticPoInStockEntry','',35,0,12,0,1,0,2,'FUnitId',0,0,'','','','','','',1,'','',106,2,28,13,'','','',1,'','QTY',0,0,350,0,'1,13',25,-1,1,28,10,0,'',17,'',0,'','',0,2,0,0,0,0,0,'',0) 
GO

INSERT INTO ICClassTableInfo(FClassTypeID,FPage,FCaption_CHS,FCaption_CHT,FCaption_EN,FKey,FFieldName,FTableName,FTableNameAs,FListIndex,FListClassName,FVisible,FEnable,FNeedSave,FMustInput,FCtlType,FProperty,FLookUpType,FLookUpClassID,FLookUpList,FSRCFieldName,FSRCTableName,FSRCTableNameAs,FDSPFieldName,FFNDFieldName,FValueLocation,FFilter,FFilterGroup,FValueType,FDspColType,FEditlen,FValuePrecision,FSaveRule,FDefValue,FAction,FUserDefine,FNote,FKeyWord,FLeft,FTop,FHeight,FWidth,FCondition,FTabIndex,FLock,FSum,FPrec,FScale,FLayer,FLoadAction,FUnControl,FFont,FSourceType,FSubKey,FParentKey,FConditionExt,FFrameBorder,FFrameBorderColor,FLabelWidth,FLabelColor,FTextColor,FIsF7,FContainer,FStyle) 
VALUES (200000022,2,'产品短代码','文本4','Text4','FProShortNumber','FProShortNumber','t_BosPlasticPoInStockEntry','',10,0,-1,0,1,0,1,'',0,0,'','','','','FName','',1,'','',167,500,50,50,'','','',1,'','',0,0,350,2500,'0,13',25,-1,0,0,0,0,'',19,'',0,'','',0,2,0,0,0,0,0,'',0) 
GO

INSERT INTO ICClassTableInfo(FClassTypeID,FPage,FCaption_CHS,FCaption_CHT,FCaption_EN,FKey,FFieldName,FTableName,FTableNameAs,FListIndex,FListClassName,FVisible,FEnable,FNeedSave,FMustInput,FCtlType,FProperty,FLookUpType,FLookUpClassID,FLookUpList,FSRCFieldName,FSRCTableName,FSRCTableNameAs,FDSPFieldName,FFNDFieldName,FValueLocation,FFilter,FFilterGroup,FValueType,FDspColType,FEditlen,FValuePrecision,FSaveRule,FDefValue,FAction,FUserDefine,FNote,FKeyWord,FLeft,FTop,FHeight,FWidth,FCondition,FTabIndex,FLock,FSum,FPrec,FScale,FLayer,FLoadAction,FUnControl,FFont,FSourceType,FSubKey,FParentKey,FConditionExt,FFrameBorder,FFrameBorderColor,FLabelWidth,FLabelColor,FTextColor,FIsF7,FContainer,FStyle) 
VALUES (200000022,2,'物料短代码','文本5','Text5','FItemShortNumber','FItemShortNumber','t_BosPlasticPoInStockEntry','',10,0,-1,0,1,0,1,'',0,0,'','','','','FName','',1,'','',167,500,50,50,'','','',1,'','',0,0,350,2500,'0,13',26,-1,0,0,0,0,'',19,'',0,'','',0,2,0,0,0,0,0,'',0) 
GO

/****** Object:Data   单据模板通用控件描述：ICClassCtl    Script Date: 2013-11-26 ******/

Delete ICClassCtl WHERE FClassTypeID=200000022
GO
/****** Object:Data   单据编号：ICBillNo    Script Date: 2013-11-26 ******/

 IF NOT EXISTS (SELECT * FROM  ICBillNo WHERE FBillID=200000022) 
 BEGIN 
  INSERT INTO ICBillNo(FBillID,FBillName,FPreLetter,FSufLetter,FCurNo,FBillName_CHT,FBillName_EN,FFormat,FPos,FCanAlterBillNo,FCheckAfterSave,FUseBillCodeRule,FDesc) 
  VALUES (200000022,'塑胶子件收料申请单_BOS','','',4718,'單據200000022_BOS','Doc200000022_BOS','00000000',200000022,0,0,1,'BS+000002') 
end 

GO

/****** Object:Data   单据编号：t_BillCodeRule    Script Date: 2013-11-26 ******/

 IF NOT EXISTS (SELECT * FROM  t_BillCodeRule WHERE FBillTypeID=200000022) 
 BEGIN 
INSERT INTO t_BillCodeRule(FBillTypeID,FClassIndex,FProjectID,FProjectVal,FFormatIndex,FLength,FAddChar,FReChar,FBillType,FIsBy) 
VALUES ('200000022',1,1,'BS',0,2,'','','',0) 

INSERT INTO t_BillCodeRule(FBillTypeID,FClassIndex,FProjectID,FProjectVal,FFormatIndex,FLength,FAddChar,FReChar,FBillType,FIsBy) 
VALUES ('200000022',2,3,'4718',0,6,'','','',0) 

 END 

/****** Object:Data   单据权限类弄表：t_ObjectAccessType    Script Date: 2013-11-26 ******/

Delete t_ObjectAccessType WHERE FObjectType=4100 And FObjectID =200000022
GO
INSERT INTO t_ObjectAccessType(FObjectType,FObjectID,FIndex,FAccessMask,FAccessUse,FName,FDescription,FName_cht,FName_en,FDescription_cht,FDescription_en) 
VALUES (4100,200000022,1,2097152,1048576,'查看','查看','查看','View','查看','View') 
GO

INSERT INTO t_ObjectAccessType(FObjectType,FObjectID,FIndex,FAccessMask,FAccessUse,FName,FDescription,FName_cht,FName_en,FDescription_cht,FDescription_en) 
VALUES (4100,200000022,2,1024,0,'查看凭证','查看凭证','查看凭证','查看凭证','查看凭证','查看凭证') 
GO

INSERT INTO t_ObjectAccessType(FObjectType,FObjectID,FIndex,FAccessMask,FAccessUse,FName,FDescription,FName_cht,FName_en,FDescription_cht,FDescription_en) 
VALUES (4100,200000022,3,131072,3145728,'新增','新增','新增','New','新增','New') 
GO

INSERT INTO t_ObjectAccessType(FObjectType,FObjectID,FIndex,FAccessMask,FAccessUse,FName,FDescription,FName_cht,FName_en,FDescription_cht,FDescription_en) 
VALUES (4100,200000022,4,65536,3145728,'删除','删除','刪除','Delete','刪除','Delete') 
GO

INSERT INTO t_ObjectAccessType(FObjectType,FObjectID,FIndex,FAccessMask,FAccessUse,FName,FDescription,FName_cht,FName_en,FDescription_cht,FDescription_en) 
VALUES (4100,200000022,5,4194304,3145728,'修改','修改','修改','Edit','修改','Edit') 
GO

INSERT INTO t_ObjectAccessType(FObjectType,FObjectID,FIndex,FAccessMask,FAccessUse,FName,FDescription,FName_cht,FName_en,FDescription_cht,FDescription_en) 
VALUES (4100,200000022,6,16,3145728,'引出内部数据','引出内部数据','引出內部資料','Export','引出內部資料','Export') 
GO

INSERT INTO t_ObjectAccessType(FObjectType,FObjectID,FIndex,FAccessMask,FAccessUse,FName,FDescription,FName_cht,FName_en,FDescription_cht,FDescription_en) 
VALUES (4100,200000022,7,32768,3145728,'打印','打印','列印','Print','列印','Print') 
GO

INSERT INTO t_ObjectAccessType(FObjectType,FObjectID,FIndex,FAccessMask,FAccessUse,FName,FDescription,FName_cht,FName_en,FDescription_cht,FDescription_en) 
VALUES (4100,200000022,8,128,0,'按单生成凭证','按单生成凭证','按单生成凭证','按单生成凭证','按单生成凭证','按单生成凭证') 
GO

INSERT INTO t_ObjectAccessType(FObjectType,FObjectID,FIndex,FAccessMask,FAccessUse,FName,FDescription,FName_cht,FName_en,FDescription_cht,FDescription_en) 
VALUES (4100,200000022,9,512,0,'合并生成凭证','合并生成凭证','合并生成凭证','合并生成凭证','合并生成凭证','合并生成凭证') 
GO

/****** Object:Data   单据权限对象表：t_ObjectType    Script Date: 2013-11-26 ******/

Delete t_ObjectType WHERE FObjectType=4100 And FObjectID =200000022
GO
INSERT INTO t_ObjectType(FObjectType,FObjectID,FName,FDescription,FName_cht,FName_en,FDescription_cht,FDescription_en) 
VALUES (4100,200000022,'塑胶子件收料申请单','','單據200000022','Doc200000022',NULL,NULL) 
GO

/****** Object:Data   单据权限表：t_ObjectAccess    Script Date: 2013-11-26 ******/

Delete t_ObjectAccess WHERE FObjectType=4100 And FObjectID =200000022
GO
INSERT INTO t_ObjectAccess(FGroupID,FObjectType,FObjectID,FIndex) 
VALUES (2101,4100,200000022,0) 
GO

INSERT INTO t_ObjectAccess(FGroupID,FObjectType,FObjectID,FIndex) 
VALUES (2101,4100,200000022,1) 
GO

INSERT INTO t_ObjectAccess(FGroupID,FObjectType,FObjectID,FIndex) 
VALUES (2102,4100,200000022,0) 
GO

INSERT INTO t_ObjectAccess(FGroupID,FObjectType,FObjectID,FIndex) 
VALUES (2102,4100,200000022,1) 
GO

INSERT INTO t_ObjectAccess(FGroupID,FObjectType,FObjectID,FIndex) 
VALUES (2102,4100,200000022,2) 
GO

INSERT INTO t_ObjectAccess(FGroupID,FObjectType,FObjectID,FIndex) 
VALUES (2102,4100,200000022,3) 
GO

INSERT INTO t_ObjectAccess(FGroupID,FObjectType,FObjectID,FIndex) 
VALUES (2102,4100,200000022,4) 
GO

INSERT INTO t_ObjectAccess(FGroupID,FObjectType,FObjectID,FIndex) 
VALUES (2102,4100,200000022,5) 
GO

INSERT INTO t_ObjectAccess(FGroupID,FObjectType,FObjectID,FIndex) 
VALUES (2102,4100,200000022,6) 
GO

INSERT INTO t_ObjectAccess(FGroupID,FObjectType,FObjectID,FIndex) 
VALUES (2102,4100,200000022,7) 
GO

INSERT INTO t_ObjectAccess(FGroupID,FObjectType,FObjectID,FIndex) 
VALUES (2102,4100,200000022,8) 
GO

INSERT INTO t_ObjectAccess(FGroupID,FObjectType,FObjectID,FIndex) 
VALUES (2102,4100,200000022,9) 
GO

/****** Object:Data   选单关联：ICClassLink    Script Date: 2013-11-26 ******/

Delete ICClassLink WHERE FDestClassTypeID = 200000022 OR FSourClassTypeID =  200000022
GO
INSERT INTO ICClassLink(FSourClassTypeID,FDestClassTypeID,FSourBillShowIndex,FAllowCopy,FAllowCheck,FAllowForceCheck,FFlowControl,FDeCondition,FCondition,FDeHCondition,FDeBCondition,FSourBillFID,FSourBillFEntryID,FSourBillFBillNo,FObjectName,FObjectType,FObjectID,FIsUsed,FUsePage,FDefaultPage,FSRCIDKey,FSRCEntryIDKey,FSRCBillNoKey,FSRCClassIDKey,FISUserDefine,FDestTranTypeID,FSourTranTypeID,FSelectListID,FMustSelected,FSystemReserved,FROB,FFieldName,FRemark,FUseSpec,FSrcDestPage,FSrcPage,FToRed,FSourTypeID,FDestTypeID,FLookUpConditionUp,FLookUpConditionDown,FDefault) 
VALUES (-71,200000022,0,2,0,0,0,'','','','','FInterID','FEntryID','FBillNo','',0,0,2,',1,2,',',1,2,','FID_SRC','FEntryID_SRC','FBillNo_SRC','FClassID_SRC',1,200000022,71,26,1,0,0,'','',-1,2,2,0,0,0,'','',0) 
GO

INSERT INTO ICClassLink(FSourClassTypeID,FDestClassTypeID,FSourBillShowIndex,FAllowCopy,FAllowCheck,FAllowForceCheck,FFlowControl,FDeCondition,FCondition,FDeHCondition,FDeBCondition,FSourBillFID,FSourBillFEntryID,FSourBillFBillNo,FObjectName,FObjectType,FObjectID,FIsUsed,FUsePage,FDefaultPage,FSRCIDKey,FSRCEntryIDKey,FSRCBillNoKey,FSRCClassIDKey,FISUserDefine,FDestTranTypeID,FSourTranTypeID,FSelectListID,FMustSelected,FSystemReserved,FROB,FFieldName,FRemark,FUseSpec,FSrcDestPage,FSrcPage,FToRed,FSourTypeID,FDestTypeID,FLookUpConditionUp,FLookUpConditionDown,FDefault) 
VALUES (200000022,-29,0,0,1,0,0,'','','','','FID','FEntryID2','FBillNo','',0,0,0,',1,2,',',1,2,','FSourceInterID','FSourceEntryID','FSourceBillNo','FSourceTranType',1,29,200000022,200000022,0,0,0,'200000022','<FAction=,CanMultiSelBill;/>',-1,0,0,0,0,0,'','',0) 
GO

INSERT INTO ICClassLink(FSourClassTypeID,FDestClassTypeID,FSourBillShowIndex,FAllowCopy,FAllowCheck,FAllowForceCheck,FFlowControl,FDeCondition,FCondition,FDeHCondition,FDeBCondition,FSourBillFID,FSourBillFEntryID,FSourBillFBillNo,FObjectName,FObjectType,FObjectID,FIsUsed,FUsePage,FDefaultPage,FSRCIDKey,FSRCEntryIDKey,FSRCBillNoKey,FSRCClassIDKey,FISUserDefine,FDestTranTypeID,FSourTranTypeID,FSelectListID,FMustSelected,FSystemReserved,FROB,FFieldName,FRemark,FUseSpec,FSrcDestPage,FSrcPage,FToRed,FSourTypeID,FDestTypeID,FLookUpConditionUp,FLookUpConditionDown,FDefault) 
VALUES (200000022,-24,0,0,1,0,0,'','isnull(t_BosPlasticPoInStock.FChecker,0)>0','','','FID','FEntryID2','FBillNo','',0,0,2,',1,2,',',1,2,','FSourceInterID','FSourceEntryID','FSourceBillNo','FSourceTranType',1,24,200000022,200000022,0,0,0,'200000022','<FAction=,CanMultiSelBill;/>',-1,0,0,0,0,0,'','',0) 
GO

/****** Object:Data   选单关联明细：ICClassLinkEntry    Script Date: 2013-11-26 ******/

Delete ICClassLinkEntry WHERE FDestClassTypeID=200000022 OR FSourClassTypeID =  200000022
GO
INSERT INTO ICClassLinkEntry(FSourClassTypeID,FDestClassTypeID,FSourPage,FSourFKey,FDestPage,FDestFKey,FIsCheck,FIsGroup,FIsFilter,FDoAction,FAllowModified,FCheckStatCol,FHaveCheckCol,FISUserDefine,FControl,FRedNeg,FBeforeFormula,FAfterFormula,FSourTypeID,FDestTypeID) 
VALUES (-71,200000022,1,'FBillNo',1,'FPOBillNO',0,0,0,0,0,'','',1,0,0,'','',0,0) 
GO

INSERT INTO ICClassLinkEntry(FSourClassTypeID,FDestClassTypeID,FSourPage,FSourFKey,FDestPage,FDestFKey,FIsCheck,FIsGroup,FIsFilter,FDoAction,FAllowModified,FCheckStatCol,FHaveCheckCol,FISUserDefine,FControl,FRedNeg,FBeforeFormula,FAfterFormula,FSourTypeID,FDestTypeID) 
VALUES (-71,200000022,1,'FHeadSelfP0238',1,'FSeBillNo',0,0,0,0,0,'','',1,0,0,'','',0,0) 
GO

INSERT INTO ICClassLinkEntry(FSourClassTypeID,FDestClassTypeID,FSourPage,FSourFKey,FDestPage,FDestFKey,FIsCheck,FIsGroup,FIsFilter,FDoAction,FAllowModified,FCheckStatCol,FHaveCheckCol,FISUserDefine,FControl,FRedNeg,FBeforeFormula,FAfterFormula,FSourTypeID,FDestTypeID) 
VALUES (-71,200000022,2,'FItemID',2,'FProductID',0,0,0,0,0,'','',1,0,0,'','',0,0) 
GO

INSERT INTO ICClassLinkEntry(FSourClassTypeID,FDestClassTypeID,FSourPage,FSourFKey,FDestPage,FDestFKey,FIsCheck,FIsGroup,FIsFilter,FDoAction,FAllowModified,FCheckStatCol,FHaveCheckCol,FISUserDefine,FControl,FRedNeg,FBeforeFormula,FAfterFormula,FSourTypeID,FDestTypeID) 
VALUES (-71,200000022,1,'FSupplyID',1,'FBase',0,0,0,0,0,'','',1,0,0,'','',0,0) 
GO

INSERT INTO ICClassLinkEntry(FSourClassTypeID,FDestClassTypeID,FSourPage,FSourFKey,FDestPage,FDestFKey,FIsCheck,FIsGroup,FIsFilter,FDoAction,FAllowModified,FCheckStatCol,FHaveCheckCol,FISUserDefine,FControl,FRedNeg,FBeforeFormula,FAfterFormula,FSourTypeID,FDestTypeID) 
VALUES (200000022,-29,2,'FBaseProperty',2,'FItemName',0,0,0,0,0,'','',1,0,0,'','',0,0) 
GO

INSERT INTO ICClassLinkEntry(FSourClassTypeID,FDestClassTypeID,FSourPage,FSourFKey,FDestPage,FDestFKey,FIsCheck,FIsGroup,FIsFilter,FDoAction,FAllowModified,FCheckStatCol,FHaveCheckCol,FISUserDefine,FControl,FRedNeg,FBeforeFormula,FAfterFormula,FSourTypeID,FDestTypeID) 
VALUES (200000022,-29,2,'FBaseProperty2',2,'FItemModel',0,0,0,0,0,'','',1,0,0,'','',0,0) 
GO

INSERT INTO ICClassLinkEntry(FSourClassTypeID,FDestClassTypeID,FSourPage,FSourFKey,FDestPage,FDestFKey,FIsCheck,FIsGroup,FIsFilter,FDoAction,FAllowModified,FCheckStatCol,FHaveCheckCol,FISUserDefine,FControl,FRedNeg,FBeforeFormula,FAfterFormula,FSourTypeID,FDestTypeID) 
VALUES (200000022,-29,2,'FCostObjID',2,'FEntrySelfB0939',0,0,0,0,0,'','',1,0,0,'','',0,0) 
GO

INSERT INTO ICClassLinkEntry(FSourClassTypeID,FDestClassTypeID,FSourPage,FSourFKey,FDestPage,FDestFKey,FIsCheck,FIsGroup,FIsFilter,FDoAction,FAllowModified,FCheckStatCol,FHaveCheckCol,FISUserDefine,FControl,FRedNeg,FBeforeFormula,FAfterFormula,FSourTypeID,FDestTypeID) 
VALUES (200000022,-29,2,'FItemId',2,'FItemID',0,0,0,0,0,'','',1,0,0,'','',0,0) 
GO

INSERT INTO ICClassLinkEntry(FSourClassTypeID,FDestClassTypeID,FSourPage,FSourFKey,FDestPage,FDestFKey,FIsCheck,FIsGroup,FIsFilter,FDoAction,FAllowModified,FCheckStatCol,FHaveCheckCol,FISUserDefine,FControl,FRedNeg,FBeforeFormula,FAfterFormula,FSourTypeID,FDestTypeID) 
VALUES (200000022,-29,2,'FNoOutStockQty',2,'Fauxqty',1,0,0,0,0,'','',1,0,0,'','',0,0) 
GO

INSERT INTO ICClassLinkEntry(FSourClassTypeID,FDestClassTypeID,FSourPage,FSourFKey,FDestPage,FDestFKey,FIsCheck,FIsGroup,FIsFilter,FDoAction,FAllowModified,FCheckStatCol,FHaveCheckCol,FISUserDefine,FControl,FRedNeg,FBeforeFormula,FAfterFormula,FSourTypeID,FDestTypeID) 
VALUES (200000022,-29,2,'FUnitId',2,'FUnitID',0,0,0,0,0,'','',1,0,0,'','',0,0) 
GO

INSERT INTO ICClassLinkEntry(FSourClassTypeID,FDestClassTypeID,FSourPage,FSourFKey,FDestPage,FDestFKey,FIsCheck,FIsGroup,FIsFilter,FDoAction,FAllowModified,FCheckStatCol,FHaveCheckCol,FISUserDefine,FControl,FRedNeg,FBeforeFormula,FAfterFormula,FSourTypeID,FDestTypeID) 
VALUES (200000022,-24,2,'FBaseProperty',2,'FItemName',0,0,0,0,0,'','',1,0,0,'','',0,0) 
GO

INSERT INTO ICClassLinkEntry(FSourClassTypeID,FDestClassTypeID,FSourPage,FSourFKey,FDestPage,FDestFKey,FIsCheck,FIsGroup,FIsFilter,FDoAction,FAllowModified,FCheckStatCol,FHaveCheckCol,FISUserDefine,FControl,FRedNeg,FBeforeFormula,FAfterFormula,FSourTypeID,FDestTypeID) 
VALUES (200000022,-24,2,'FBaseProperty2',2,'FItemModel',0,0,0,0,0,'','',1,0,0,'','',0,0) 
GO

INSERT INTO ICClassLinkEntry(FSourClassTypeID,FDestClassTypeID,FSourPage,FSourFKey,FDestPage,FDestFKey,FIsCheck,FIsGroup,FIsFilter,FDoAction,FAllowModified,FCheckStatCol,FHaveCheckCol,FISUserDefine,FControl,FRedNeg,FBeforeFormula,FAfterFormula,FSourTypeID,FDestTypeID) 
VALUES (200000022,-24,1,'FBillNo',2,'FSourceBillNo',0,0,0,0,0,'','',1,0,0,'','',0,0) 
GO

INSERT INTO ICClassLinkEntry(FSourClassTypeID,FDestClassTypeID,FSourPage,FSourFKey,FDestPage,FDestFKey,FIsCheck,FIsGroup,FIsFilter,FDoAction,FAllowModified,FCheckStatCol,FHaveCheckCol,FISUserDefine,FControl,FRedNeg,FBeforeFormula,FAfterFormula,FSourTypeID,FDestTypeID) 
VALUES (200000022,-24,2,'FCostObjID',2,'FCostOBJID',0,0,0,0,0,'','',1,0,0,'','',0,0) 
GO

INSERT INTO ICClassLinkEntry(FSourClassTypeID,FDestClassTypeID,FSourPage,FSourFKey,FDestPage,FDestFKey,FIsCheck,FIsGroup,FIsFilter,FDoAction,FAllowModified,FCheckStatCol,FHaveCheckCol,FISUserDefine,FControl,FRedNeg,FBeforeFormula,FAfterFormula,FSourTypeID,FDestTypeID) 
VALUES (200000022,-24,2,'FItemId',2,'FItemID',0,0,0,0,0,'','',1,0,0,'','',0,0) 
GO

INSERT INTO ICClassLinkEntry(FSourClassTypeID,FDestClassTypeID,FSourPage,FSourFKey,FDestPage,FDestFKey,FIsCheck,FIsGroup,FIsFilter,FDoAction,FAllowModified,FCheckStatCol,FHaveCheckCol,FISUserDefine,FControl,FRedNeg,FBeforeFormula,FAfterFormula,FSourTypeID,FDestTypeID) 
VALUES (200000022,-24,2,'FQty',2,'Fauxqty',1,0,0,0,0,'','',1,0,0,'','',0,0) 
GO

INSERT INTO ICClassLinkEntry(FSourClassTypeID,FDestClassTypeID,FSourPage,FSourFKey,FDestPage,FDestFKey,FIsCheck,FIsGroup,FIsFilter,FDoAction,FAllowModified,FCheckStatCol,FHaveCheckCol,FISUserDefine,FControl,FRedNeg,FBeforeFormula,FAfterFormula,FSourTypeID,FDestTypeID) 
VALUES (200000022,-24,2,'FQty',2,'FAuxQtyMust',1,0,0,0,0,'','',1,0,0,'','',0,0) 
GO

INSERT INTO ICClassLinkEntry(FSourClassTypeID,FDestClassTypeID,FSourPage,FSourFKey,FDestPage,FDestFKey,FIsCheck,FIsGroup,FIsFilter,FDoAction,FAllowModified,FCheckStatCol,FHaveCheckCol,FISUserDefine,FControl,FRedNeg,FBeforeFormula,FAfterFormula,FSourTypeID,FDestTypeID) 
VALUES (200000022,-24,2,'FUnitId',2,'FUnitID',0,0,0,0,0,'','',1,0,0,'','',0,0) 
GO

/****** Object:Data   选单钩稽明细：ICClassLinkCommit    Script Date: 2013-11-26 ******/

 DELETE ICClassLinkCommit WHERE FDstClsTypID = 200000022 OR FSrcClsTypID =  200000022
GO
INSERT INTO ICClassLinkCommit(FSrcClsTypID,FDstClsTypID,FControl,FCheckKey,FCommitKey,FFlagKey,FIsUsrDef,FIsLimit,FControlFormula,FFlagFormula,FSourTypeID,FDestTypeID) 
VALUES (200000022,-29,1,'FNoOutStockQty','FCommitQty','',0,0,'','',0,0) 
GO

INSERT INTO ICClassLinkCommit(FSrcClsTypID,FDstClsTypID,FControl,FCheckKey,FCommitKey,FFlagKey,FIsUsrDef,FIsLimit,FControlFormula,FFlagFormula,FSourTypeID,FDestTypeID) 
VALUES (200000022,-24,1,'FQty','FCommitQty','',0,0,'','',0,0) 
GO

/****** Object:Data   选单流程基本信息：ICClassWorkFlow    Script Date: 2013-11-26 ******/


GO
DECLARE @MaxID AS INT

SELECT @MaxID = ISNUll(Max(FID),10000) FROM ICClassWorkFlow

INSERT INTO ICClassWorkFlow(FID,FName_CHS,FName_CHT,FName_EN,FSubSysID) 
VALUES ( @MaxID + 1,'计划投料单','單據流程33','Document Process33',23) 


UPDATE ICMaxNum SET FMaxNum = @MaxID + 2 WHERE FTableName = 'ICClassWorkFlow'
GO


/****** Object:Data   选单流程关联单据：ICClassWorkFlowBill    Script Date: 2013-11-26 ******/

DELETE ICClassWorkFlowBill WHERE FClassTypeID = 200000022
GO
INSERT INTO ICClassWorkFlowBill(FID,FClassTypeID,FTop,FLeft,FWidth,FHeight) 
VALUES (-229,-71,2570,8520,2500,2000) 
GO

INSERT INTO ICClassWorkFlowBill(FID,FClassTypeID,FTop,FLeft,FWidth,FHeight) 
VALUES (-227,-71,6400,6220,2500,2000) 
GO

INSERT INTO ICClassWorkFlowBill(FID,FClassTypeID,FTop,FLeft,FWidth,FHeight) 
VALUES (-227,-29,13650,11400,2500,2000) 
GO

INSERT INTO ICClassWorkFlowBill(FID,FClassTypeID,FTop,FLeft,FWidth,FHeight) 
VALUES (-227,-24,10350,11300,2500,2000) 
GO

INSERT INTO ICClassWorkFlowBill(FID,FClassTypeID,FTop,FLeft,FWidth,FHeight) 
VALUES (-227,200000022,9820,2990,2500,2000) 
GO

INSERT INTO ICClassWorkFlowBill(FID,FClassTypeID,FTop,FLeft,FWidth,FHeight) 
VALUES (-223,-24,2570,7940,2500,2000) 
GO

INSERT INTO ICClassWorkFlowBill(FID,FClassTypeID,FTop,FLeft,FWidth,FHeight) 
VALUES (-222,-24,2570,7940,2500,2000) 
GO

INSERT INTO ICClassWorkFlowBill(FID,FClassTypeID,FTop,FLeft,FWidth,FHeight) 
VALUES (-221,-29,2490,6510,2500,2000) 
GO

INSERT INTO ICClassWorkFlowBill(FID,FClassTypeID,FTop,FLeft,FWidth,FHeight) 
VALUES (-219,-29,2490,6510,2500,2000) 
GO

INSERT INTO ICClassWorkFlowBill(FID,FClassTypeID,FTop,FLeft,FWidth,FHeight) 
VALUES (-218,-29,2490,6510,2500,2000) 
GO

INSERT INTO ICClassWorkFlowBill(FID,FClassTypeID,FTop,FLeft,FWidth,FHeight) 
VALUES (-217,-71,8260,16350,2500,2000) 
GO

INSERT INTO ICClassWorkFlowBill(FID,FClassTypeID,FTop,FLeft,FWidth,FHeight) 
VALUES (-217,-29,2490,6510,2500,2000) 
GO

INSERT INTO ICClassWorkFlowBill(FID,FClassTypeID,FTop,FLeft,FWidth,FHeight) 
VALUES (-10,-71,9970,6160,2500,2000) 
GO

INSERT INTO ICClassWorkFlowBill(FID,FClassTypeID,FTop,FLeft,FWidth,FHeight) 
VALUES (-9,-71,6990,5900,2500,2000) 
GO

INSERT INTO ICClassWorkFlowBill(FID,FClassTypeID,FTop,FLeft,FWidth,FHeight) 
VALUES (-5,-71,8020,6140,2500,2000) 
GO

INSERT INTO ICClassWorkFlowBill(FID,FClassTypeID,FTop,FLeft,FWidth,FHeight) 
VALUES (-4,-71,8260,16350,2500,2000) 
GO

DELETE ICClassWorkFlowBill WHERE FID < 0 AND FEntryID NOT IN ( SELECT MAX(FEntryID)  FROM ICClassWorkFlowBill WHERE FID < 0 GROUP BY FClassTypeID HAVING COUNT(FClassTypeID) >= 1 ) 
 UPDATE ICClassWorkFlowBill SET FID =( SELECT MAX(FID) FROM ICClassWorkFlow ) WHERE FID < 0 
 DELETE ICClassWorkFlowBill WHERE FID < 0 
/****** Object:Data   选单流程关联关系：ICClassWorkFlowJoin    Script Date: 2013-11-26 ******/

 DELETE ICClassWorkFlowJoin WHERE FDestClassTypeID = 200000022 OR FSourClassTypeID = 200000022
GO
INSERT INTO ICClassWorkFlowJoin(FID,FSourClassTypeID,FDestClassTypeID) 
VALUES (-227,-71,200000022) 
GO

INSERT INTO ICClassWorkFlowJoin(FID,FSourClassTypeID,FDestClassTypeID) 
VALUES (-227,200000022,-24) 
GO

INSERT INTO ICClassWorkFlowJoin(FID,FSourClassTypeID,FDestClassTypeID) 
VALUES (-227,200000022,-29) 
GO

 UPDATE ICClassWorkFlowJoin SET FID =( SELECT MAX(FID) FROM ICClassWorkFlow ) WHERE FID < 0 
 DELETE ICClassWorkFlowJoin WHERE FID < 0 
/****** Object:Data   网络控制模板数据：ICClassMutex    Script Date: 2013-11-26 ******/

Delete ICClassMutex WHERE FClassTypeID=200000022
GO
/****** Object:Data   打印控制模板数据：ICPrintMaxCount    Script Date: 2013-11-26 ******/

Delete ICPrintMaxCount WHERE FID =200000022
GO
INSERT INTO ICPrintMaxCount(FPos,FID,FName,FName_CHT,FName_EN,FPrintControlOrNo,FPrintMaxCount) 
VALUES (200000022,200000022,'塑胶子件收料申请单_BOS','單據200000022_BOS','Doc200000022_BOS',0,0) 
GO

/****** Object:Data   多级审核配置模板数据：ICClassMCFlowInfo    Script Date: 2013-11-26 ******/

DELETE ICClassMCFlowInfo WHERE FID = 200000022
GO
INSERT INTO ICClassMCFlowInfo(FID,FIsRun,FMaxLevel,FChkLevel,FChkModel,FCanModify,FCheckerField,FCheckDateField,FInputIdea,FShowTip,FCanCheckAfterEnd,FIsMobileServiceRun,FIsSelectMsgUser,FIsNoCheckSelf,FMobileInfoCanReply) 
VALUES (200000022,1,1,1,0,0,'FChecker','FCheckDate',1,1,0,0,0,0,0) 
GO

 EXEC  p_CreateMCDetailTable @ClassTypeID = 200000022
/****** Object:Data   多级审核的工作流任务（各审核级次）模板数据：ICClassMCTasks    Script Date: 2013-11-26 ******/

DELETE ICClassMCTasks WHERE FID = 200000022
GO
INSERT INTO ICClassMCTasks(FID,FTask,FTag,FX,FY) 
VALUES (200000022,'BillMCBegin','待审单据',770,930) 
GO

INSERT INTO ICClassMCTasks(FID,FTask,FTag,FX,FY) 
VALUES (200000022,'BillMCEnd','审核结束',13470,6800) 
GO

INSERT INTO ICClassMCTasks(FID,FTask,FTag,FX,FY) 
VALUES (200000022,'MC1','一级审核',770,6800) 
GO

/****** Object:Data   多级审核的流程流转和规则模板数据：ICClassMCRule    Script Date: 2013-11-26 ******/

DELETE ICClassMCRule WHERE FID = 200000022
GO
/****** Object:Data   单据操作明细模板数据：ICClassBillAction    Script Date: 2013-11-26 ******/

DELETE ICClassBillAction WHERE FClassTypeID = 200000022
GO
DECLARE @MaxID AS INT

SELECT @MaxID = ISNUll(Max(FID),10000) FROM ICClassBillAction

INSERT INTO ICClassBillAction(FID,FClassTypeID,FCode,FName_CHS,FName_CHT,FName_EN,FDescriptions_CHS,FDescriptions_CHT,FDescriptions_EN,FEnvironment,FRightMask,FRightUseMask,FRightGroupMask,FRightControl,FAddLog,FIsPredefine,FIsFirst,FShortCut,FListActionCirculation) 
VALUES ( @MaxID + 1,200000022,'mnuBOSViewVoucher','查看凭证','查看凭证','查看凭证','查看凭证','查看凭证','查看凭证',0,1024,0,7,1,0,1,0,0,1) 

INSERT INTO ICClassBillAction(FID,FClassTypeID,FCode,FName_CHS,FName_CHT,FName_EN,FDescriptions_CHS,FDescriptions_CHT,FDescriptions_EN,FEnvironment,FRightMask,FRightUseMask,FRightGroupMask,FRightControl,FAddLog,FIsPredefine,FIsFirst,FShortCut,FListActionCirculation) 
VALUES ( @MaxID + 2,200000022,'mnuEditCopy','复制','複製','Copy','复制','複製','Copy',39,131072,0,7,1,0,1,0,0,1) 

INSERT INTO ICClassBillAction(FID,FClassTypeID,FCode,FName_CHS,FName_CHT,FName_EN,FDescriptions_CHS,FDescriptions_CHT,FDescriptions_EN,FEnvironment,FRightMask,FRightUseMask,FRightGroupMask,FRightControl,FAddLog,FIsPredefine,FIsFirst,FShortCut,FListActionCirculation) 
VALUES ( @MaxID + 3,200000022,'mnuEditCopyDoc','按单复制','按單複製','Copy Document','按单复制','按單複製','Copy Document',64,131072,0,7,1,0,1,0,0,1) 

INSERT INTO ICClassBillAction(FID,FClassTypeID,FCode,FName_CHS,FName_CHT,FName_EN,FDescriptions_CHS,FDescriptions_CHT,FDescriptions_EN,FEnvironment,FRightMask,FRightUseMask,FRightGroupMask,FRightControl,FAddLog,FIsPredefine,FIsFirst,FShortCut,FListActionCirculation) 
VALUES ( @MaxID + 4,200000022,'mnuEditCopyEntry','按分录合并复制','按分錄合併複製','Consolidate Selected Invoices & Copy','按分录合并复制','按分錄合併複製','Consolidate Selected Invoices & Copy',64,131072,0,7,1,0,1,0,0,1) 

INSERT INTO ICClassBillAction(FID,FClassTypeID,FCode,FName_CHS,FName_CHT,FName_EN,FDescriptions_CHS,FDescriptions_CHT,FDescriptions_EN,FEnvironment,FRightMask,FRightUseMask,FRightGroupMask,FRightControl,FAddLog,FIsPredefine,FIsFirst,FShortCut,FListActionCirculation) 
VALUES ( @MaxID + 5,200000022,'mnuEditDelete','删除','刪除','Del.','删除','刪除','Del.',64,65536,0,7,1,1,1,0,0,1) 

INSERT INTO ICClassBillAction(FID,FClassTypeID,FCode,FName_CHS,FName_CHT,FName_EN,FDescriptions_CHS,FDescriptions_CHT,FDescriptions_EN,FEnvironment,FRightMask,FRightUseMask,FRightGroupMask,FRightControl,FAddLog,FIsPredefine,FIsFirst,FShortCut,FListActionCirculation) 
VALUES ( @MaxID + 6,200000022,'mnuEditModify','修改','修改','Edit','修改','修改','Edit',4160,4194304,0,7,1,0,1,0,0,1) 

INSERT INTO ICClassBillAction(FID,FClassTypeID,FCode,FName_CHS,FName_CHT,FName_EN,FDescriptions_CHS,FDescriptions_CHT,FDescriptions_EN,FEnvironment,FRightMask,FRightUseMask,FRightGroupMask,FRightControl,FAddLog,FIsPredefine,FIsFirst,FShortCut,FListActionCirculation) 
VALUES ( @MaxID + 7,200000022,'mnuExportData','引出内部数据','引出內部資料','Export','引出内部数据','引出內部資料','Export',5056,16,0,7,1,0,1,0,0,1) 

INSERT INTO ICClassBillAction(FID,FClassTypeID,FCode,FName_CHS,FName_CHT,FName_EN,FDescriptions_CHS,FDescriptions_CHT,FDescriptions_EN,FEnvironment,FRightMask,FRightUseMask,FRightGroupMask,FRightControl,FAddLog,FIsPredefine,FIsFirst,FShortCut,FListActionCirculation) 
VALUES ( @MaxID + 8,200000022,'mnuFileNew','新增','新增','New','新增','新增','New',103,131072,0,7,1,0,1,0,0,1) 

INSERT INTO ICClassBillAction(FID,FClassTypeID,FCode,FName_CHS,FName_CHT,FName_EN,FDescriptions_CHS,FDescriptions_CHT,FDescriptions_EN,FEnvironment,FRightMask,FRightUseMask,FRightGroupMask,FRightControl,FAddLog,FIsPredefine,FIsFirst,FShortCut,FListActionCirculation) 
VALUES ( @MaxID + 9,200000022,'mnuFilePrint','打印','列印','Print','打印','列印','Print',5095,32768,0,7,1,0,1,0,0,1) 

INSERT INTO ICClassBillAction(FID,FClassTypeID,FCode,FName_CHS,FName_CHT,FName_EN,FDescriptions_CHS,FDescriptions_CHT,FDescriptions_EN,FEnvironment,FRightMask,FRightUseMask,FRightGroupMask,FRightControl,FAddLog,FIsPredefine,FIsFirst,FShortCut,FListActionCirculation) 
VALUES ( @MaxID + 10,200000022,'mnuFileSave','保存','保存','Save','保存','保存','Save',6,0,0,7,0,1,1,0,0,1) 

INSERT INTO ICClassBillAction(FID,FClassTypeID,FCode,FName_CHS,FName_CHT,FName_EN,FDescriptions_CHS,FDescriptions_CHT,FDescriptions_EN,FEnvironment,FRightMask,FRightUseMask,FRightGroupMask,FRightControl,FAddLog,FIsPredefine,FIsFirst,FShortCut,FListActionCirculation) 
VALUES ( @MaxID + 11,200000022,'mnuFileView','查看','查看','View','查看','查看','View',960,2097152,0,7,1,0,1,0,0,1) 

INSERT INTO ICClassBillAction(FID,FClassTypeID,FCode,FName_CHS,FName_CHT,FName_EN,FDescriptions_CHS,FDescriptions_CHT,FDescriptions_EN,FEnvironment,FRightMask,FRightUseMask,FRightGroupMask,FRightControl,FAddLog,FIsPredefine,FIsFirst,FShortCut,FListActionCirculation) 
VALUES ( @MaxID + 12,200000022,'mnuMakeOneToOne','按单生成凭证','按单生成凭证','按单生成凭证','按单生成凭证','按单生成凭证','按单生成凭证',0,128,0,7,1,1,1,0,0,1) 

INSERT INTO ICClassBillAction(FID,FClassTypeID,FCode,FName_CHS,FName_CHT,FName_EN,FDescriptions_CHS,FDescriptions_CHT,FDescriptions_EN,FEnvironment,FRightMask,FRightUseMask,FRightGroupMask,FRightControl,FAddLog,FIsPredefine,FIsFirst,FShortCut,FListActionCirculation) 
VALUES ( @MaxID + 13,200000022,'mnuMultiToOne','合并生成凭证','合并生成凭证','合并生成凭证','合并生成凭证','合并生成凭证','合并生成凭证',0,512,0,7,1,1,1,0,0,1) 

INSERT INTO ICClassBillAction(FID,FClassTypeID,FCode,FName_CHS,FName_CHT,FName_EN,FDescriptions_CHS,FDescriptions_CHT,FDescriptions_EN,FEnvironment,FRightMask,FRightUseMask,FRightGroupMask,FRightControl,FAddLog,FIsPredefine,FIsFirst,FShortCut,FListActionCirculation) 
VALUES ( @MaxID + 14,200000022,'mnuStockQuery','库存查询','庫存查詢','Stock Query','库存查询','庫存查詢','Stock Query',0,0,0,7,0,1,1,0,0,1) 


UPDATE ICMaxNum SET FMaxNum = @MaxID + 15 WHERE FTableName = 'ICClassBillAction'
GO


/****** Object:Data   单据操作日志模板数据：t_LogFunction    Script Date: 2013-11-26 ******/

DELETE t_LogFunction WHERE FFunctionID LIKE 'BOS200000022%'
GO
INSERT INTO t_LogFunction(FFunctionID,FFunctionName,FSubSysID,FFunctionName_Cht,FFunctionName_EN) 
VALUES ('BOS200000022_mnuEditDelete','销售管理系统-业务单据-塑胶子件收料申请单-删除',23,'銷售管制系統-業務單據-單據200000022-刪除','Sales Management-Business document-Doc200000022-Del.') 
GO

INSERT INTO t_LogFunction(FFunctionID,FFunctionName,FSubSysID,FFunctionName_Cht,FFunctionName_EN) 
VALUES ('BOS200000022_mnuEditMultiCheck','销售管理系统-业务单据-计划投料单-多级审核',23,'銷售管制系統-業務單據-單據200000022-多級審核','Sales Management-Business document-Doc200000022-Multi-level Check') 
GO

INSERT INTO t_LogFunction(FFunctionID,FFunctionName,FSubSysID,FFunctionName_Cht,FFunctionName_EN) 
VALUES ('BOS200000022_mnuEditUnMultiCheck','销售管理系统-业务单据-计划投料单-驳回审核',23,'銷售管制系統-業務單據-單據200000022-駁回審核','Sales Management-Business document-Doc200000022-Reject Check') 
GO

INSERT INTO t_LogFunction(FFunctionID,FFunctionName,FSubSysID,FFunctionName_Cht,FFunctionName_EN) 
VALUES ('BOS200000022_mnuFileSave','销售管理系统-业务单据-塑胶子件收料申请单-保存',23,'銷售管制系統-業務單據-單據200000022-保存','Sales Management-Business document-Doc200000022-Save') 
GO

INSERT INTO t_LogFunction(FFunctionID,FFunctionName,FSubSysID,FFunctionName_Cht,FFunctionName_EN) 
VALUES ('BOS200000022_mnuMakeOneToOne','销售管理系统-业务单据-塑胶子件收料申请单-按单生成凭证',23,'銷售管制系統-業務單據-單據200000022-按单生成凭证','Sales Management-Business document-Doc200000022-按单生成凭证') 
GO

INSERT INTO t_LogFunction(FFunctionID,FFunctionName,FSubSysID,FFunctionName_Cht,FFunctionName_EN) 
VALUES ('BOS200000022_mnuMultiToOne','销售管理系统-业务单据-塑胶子件收料申请单-合并生成凭证',23,'銷售管制系統-業務單據-單據200000022-合并生成凭证','Sales Management-Business document-Doc200000022-合并生成凭证') 
GO

INSERT INTO t_LogFunction(FFunctionID,FFunctionName,FSubSysID,FFunctionName_Cht,FFunctionName_EN) 
VALUES ('BOS200000022_mnuStockQuery','销售管理系统-业务单据-塑胶子件收料申请单-库存查询',23,'銷售管制系統-業務單據-單據200000022-庫存查詢','Sales Management-Business document-Doc200000022-Stock Query') 
GO

/****** Object:Data   单据操作位置模板数据：ICClassActionPosition    Script Date: 2013-11-26 ******/

DELETE ICClassActionPosition WHERE FClassTypeID = 200000022
GO
/****** Object:Data   单据扩展服务模板数据：ICClassActionList    Script Date: 2013-11-26 ******/

DELETE ICClassActionList WHERE FClassTypeID = 200000022
GO
INSERT INTO ICClassActionList(FClassTypeID,FClassActionID,FObject,FDefineType,FSourceType,FSourceField,FAction,FExpression,FOrder,FDescription) 
VALUES (200000022,1,'FItemId',0,4096,'FAction','FBASEPROPERTY,FUNITID=FUNITID','',1,'Add by Function SetSouceAction') 
GO

INSERT INTO ICClassActionList(FClassTypeID,FClassActionID,FObject,FDefineType,FSourceType,FSourceField,FAction,FExpression,FOrder,FDescription) 
VALUES (200000022,5,'FItemId',0,4096,'FAction','FQTY2','',2,'Add by Function SetSouceAction') 
GO

INSERT INTO ICClassActionList(FClassTypeID,FClassActionID,FObject,FDefineType,FSourceType,FSourceField,FAction,FExpression,FOrder,FDescription) 
VALUES (200000022,1,'FItemId',0,4096,'FAction','FBaseProperty2','',3,'Add by Function SetSouceAction') 
GO

INSERT INTO ICClassActionList(FClassTypeID,FClassActionID,FObject,FDefineType,FSourceType,FSourceField,FAction,FExpression,FOrder,FDescription) 
VALUES (200000022,1,'FItemId',0,4096,'FAction','FBaseProperty3','',4,'Add by Function SetSouceAction') 
GO

INSERT INTO ICClassActionList(FClassTypeID,FClassActionID,FObject,FDefineType,FSourceType,FSourceField,FAction,FExpression,FOrder,FDescription) 
VALUES (200000022,1,'FItemId',0,4096,'FAction','FBaseProperty2','',5,'Add by Function SetSouceAction') 
GO

INSERT INTO ICClassActionList(FClassTypeID,FClassActionID,FObject,FDefineType,FSourceType,FSourceField,FAction,FExpression,FOrder,FDescription) 
VALUES (200000022,1,'FItemId',0,4096,'FAction','FBaseProperty3','',6,'Add by Function SetSouceAction') 
GO

INSERT INTO ICClassActionList(FClassTypeID,FClassActionID,FObject,FDefineType,FSourceType,FSourceField,FAction,FExpression,FOrder,FDescription) 
VALUES (200000022,1,'FItemId',0,4096,'FAction','FBaseProperty3','',7,'Add by Function SetSouceAction') 
GO

INSERT INTO ICClassActionList(FClassTypeID,FClassActionID,FObject,FDefineType,FSourceType,FSourceField,FAction,FExpression,FOrder,FDescription) 
VALUES (200000022,1,'FItemId',0,4096,'FAction','FBaseProperty3','',8,'Add by Function SetSouceAction') 
GO

INSERT INTO ICClassActionList(FClassTypeID,FClassActionID,FObject,FDefineType,FSourceType,FSourceField,FAction,FExpression,FOrder,FDescription) 
VALUES (200000022,1,'FItemId',0,4096,'FAction','FBaseProperty4','',9,'Add by Function SetSouceAction') 
GO

INSERT INTO ICClassActionList(FClassTypeID,FClassActionID,FObject,FDefineType,FSourceType,FSourceField,FAction,FExpression,FOrder,FDescription) 
VALUES (200000022,1,'FItemId',0,4096,'FAction','FBaseProperty4','',10,'Add by Function SetSouceAction') 
GO

INSERT INTO ICClassActionList(FClassTypeID,FClassActionID,FObject,FDefineType,FSourceType,FSourceField,FAction,FExpression,FOrder,FDescription) 
VALUES (200000022,1,'FItemId',0,4096,'FAction','FBaseProperty5','',11,'Add by Function SetSouceAction') 
GO

INSERT INTO ICClassActionList(FClassTypeID,FClassActionID,FObject,FDefineType,FSourceType,FSourceField,FAction,FExpression,FOrder,FDescription) 
VALUES (200000022,1,'FItemId',0,4096,'FAction','FBaseProperty5','',12,'Add by Function SetSouceAction') 
GO

INSERT INTO ICClassActionList(FClassTypeID,FClassActionID,FObject,FDefineType,FSourceType,FSourceField,FAction,FExpression,FOrder,FDescription) 
VALUES (200000022,1,'FItemId',0,4096,'FAction','FBaseProperty3','',13,'Add by Function SetSouceAction') 
GO

INSERT INTO ICClassActionList(FClassTypeID,FClassActionID,FObject,FDefineType,FSourceType,FSourceField,FAction,FExpression,FOrder,FDescription) 
VALUES (200000022,5,'FItemId',0,4096,'FAction','FQty1','',14,'Add by Function SetSouceAction') 
GO

INSERT INTO ICClassActionList(FClassTypeID,FClassActionID,FObject,FDefineType,FSourceType,FSourceField,FAction,FExpression,FOrder,FDescription) 
VALUES (200000022,5,'FItemId',0,4096,'FLoadAction','FQTY2','',1,'Add by Function SetSouceAction') 
GO

INSERT INTO ICClassActionList(FClassTypeID,FClassActionID,FObject,FDefineType,FSourceType,FSourceField,FAction,FExpression,FOrder,FDescription) 
VALUES (200000022,5,'FItemId',0,4096,'FLoadAction','FQty1','',2,'Add by Function SetSouceAction') 
GO

INSERT INTO ICClassActionList(FClassTypeID,FClassActionID,FObject,FDefineType,FSourceType,FSourceField,FAction,FExpression,FOrder,FDescription) 
VALUES (200000022,1,'FProductID',0,4096,'FAction','FBaseProperty1','',1,'Add by Function SetSouceAction') 
GO

INSERT INTO ICClassActionList(FClassTypeID,FClassActionID,FObject,FDefineType,FSourceType,FSourceField,FAction,FExpression,FOrder,FDescription) 
VALUES (200000022,1,'FProductID',0,4096,'FAction','FBaseProperty6','',2,'Add by Function SetSouceAction') 
GO



/**End  新单据模板数据脚本，名称 塑胶子件收料申请单    Script Date: 2013-11-26 **/
