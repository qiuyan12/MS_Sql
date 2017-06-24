

/**Begin �µ���ģ�����ݽű������� �ܽ��Ӽ��������뵥    Script Date: 2013-11-26 **/


/****** Object:Data   ����������ICClassType    Script Date: 2013-11-26 ******/

--select max(fid)+1 fid from ICClassType
Delete ICClassType WHERE FID=200000022
GO
INSERT INTO ICClassType(FID,FName_CHS,FName_CHT,FName_EN,FShowIndex,FTableName,FShowType,FTemplateID,FImgID,FModel,FLogic,FBillWidth,FBillHeight,FMenuControl,FFunctionID,FFilter,FBillTypeID,FIsManageBillNo,FBillNoKey,FEntryCount,FLayerCount,FLayerNames,FPrimaryKey,FEPrimaryKey,FClassTypeKey,FIndexKey,FObjectType,FObjectID,FGroupIDView,FGroupIDManage,FComponentExt,FBillNoManageType,FAccessoryTypeID,FControl,FTimeStamp,FExtBaseDataAccess) 
VALUES (200000022,'�ܽ��Ӽ��������뵥','�Γ�200000022','Doc200000022',0,'t_BosPlasticPoInStock',0,200000022,'',2,3,9540,5490,'',23,'',3,0,'',0,1,'CHS=;CHT=;EN=','FID','FEntryID','FClassTypeID','FIndex',4100,200000022,2101,2102,'FBillevents=|FLstEvents=MySister.clsPlanChangeStockList|FBaseLstEvents=|FBeforeSave=|FAfterSave=|FBeforeDel=|FAfterDel=|FBeforeMultiCheck=|FAfterMultiCheck=|FIsUseProc=|',1,80000028,2483,NULL,'') 
GO

/****** Object:Data   ���ݷ�¼������ICClassTypeEntry    Script Date: 2013-11-26 ******/

Delete ICClassTypeEntry WHERE FParentID=200000022
GO
INSERT INTO ICClassTypeEntry(FIndex,FParentID,FTableName,FLeft,FTop,FWidth,FHeight,FLayer,FEntryType,FTabIndex,FMustInput,FKeyField,FDescription_CHS,FDescription_CHT,FDescription_EN,FFilter,FUserDefine,FContainer) 
VALUES (1,200000022,'t_BosPlasticPoInStock',0,2190,4000,4740,0,0,0,1,'','','','','',1,'') 
GO

INSERT INTO ICClassTypeEntry(FIndex,FParentID,FTableName,FLeft,FTop,FWidth,FHeight,FLayer,FEntryType,FTabIndex,FMustInput,FKeyField,FDescription_CHS,FDescription_CHT,FDescription_EN,FFilter,FUserDefine,FContainer) 
VALUES (2,200000022,'t_BosPlasticPoInStockEntry',225,1585,9095,3250,0,1,10,0,'','','','','',1,'') 
GO

/****** Object:Data   ����ģ���ֶ�������ICClassTableInfo    Script Date: 2013-11-26 ******/

Delete ICClassTableInfo WHERE FClassTypeID=200000022
GO
INSERT INTO ICClassTableInfo(FClassTypeID,FPage,FCaption_CHS,FCaption_CHT,FCaption_EN,FKey,FFieldName,FTableName,FTableNameAs,FListIndex,FListClassName,FVisible,FEnable,FNeedSave,FMustInput,FCtlType,FProperty,FLookUpType,FLookUpClassID,FLookUpList,FSRCFieldName,FSRCTableName,FSRCTableNameAs,FDSPFieldName,FFNDFieldName,FValueLocation,FFilter,FFilterGroup,FValueType,FDspColType,FEditlen,FValuePrecision,FSaveRule,FDefValue,FAction,FUserDefine,FNote,FKeyWord,FLeft,FTop,FHeight,FWidth,FCondition,FTabIndex,FLock,FSum,FPrec,FScale,FLayer,FLoadAction,FUnControl,FFont,FSourceType,FSubKey,FParentKey,FConditionExt,FFrameBorder,FFrameBorderColor,FLabelWidth,FLabelColor,FTextColor,FIsF7,FContainer,FStyle) 
VALUES (200000022,1,'���ݱ��','�Γ���̖','Doc No.','FBillNo','FBillNo','t_BosPlasticPoInStock','',0,2,-1,0,1,1,1,'',0,0,'','','','','','',1,'','',167,500,30,30,'','','',1,'','BILLNO',7200,765,375,2130,'0',0,0,0,0,0,0,'',1,'',3,'','',0,2,0,0,0,0,0,'',0) 
GO

INSERT INTO ICClassTableInfo(FClassTypeID,FPage,FCaption_CHS,FCaption_CHT,FCaption_EN,FKey,FFieldName,FTableName,FTableNameAs,FListIndex,FListClassName,FVisible,FEnable,FNeedSave,FMustInput,FCtlType,FProperty,FLookUpType,FLookUpClassID,FLookUpList,FSRCFieldName,FSRCTableName,FSRCTableNameAs,FDSPFieldName,FFNDFieldName,FValueLocation,FFilter,FFilterGroup,FValueType,FDspColType,FEditlen,FValuePrecision,FSaveRule,FDefValue,FAction,FUserDefine,FNote,FKeyWord,FLeft,FTop,FHeight,FWidth,FCondition,FTabIndex,FLock,FSum,FPrec,FScale,FLayer,FLoadAction,FUnControl,FFont,FSourceType,FSubKey,FParentKey,FConditionExt,FFrameBorder,FFrameBorderColor,FLabelWidth,FLabelColor,FTextColor,FIsF7,FContainer,FStyle) 
VALUES (200000022,1,'����','�ȴa','ISN','FID','FID','t_BosPlasticPoInStock','',5,2,0,1,1,0,3,'',0,0,'','','','','','',1,'','',56,500,255,4,'','','',1,'','PRIMARY',240,120,405,2535,'-1',4,0,0,0,0,0,'',1,'',0,'','',0,0,0,0,0,0,0,'',0) 
GO

INSERT INTO ICClassTableInfo(FClassTypeID,FPage,FCaption_CHS,FCaption_CHT,FCaption_EN,FKey,FFieldName,FTableName,FTableNameAs,FListIndex,FListClassName,FVisible,FEnable,FNeedSave,FMustInput,FCtlType,FProperty,FLookUpType,FLookUpClassID,FLookUpList,FSRCFieldName,FSRCTableName,FSRCTableNameAs,FDSPFieldName,FFNDFieldName,FValueLocation,FFilter,FFilterGroup,FValueType,FDspColType,FEditlen,FValuePrecision,FSaveRule,FDefValue,FAction,FUserDefine,FNote,FKeyWord,FLeft,FTop,FHeight,FWidth,FCondition,FTabIndex,FLock,FSum,FPrec,FScale,FLayer,FLoadAction,FUnControl,FFont,FSourceType,FSubKey,FParentKey,FConditionExt,FFrameBorder,FFrameBorderColor,FLabelWidth,FLabelColor,FTextColor,FIsF7,FContainer,FStyle) 
VALUES (200000022,1,'����','����','Date','FDate','FDate','t_BosPlasticPoInStock','',3,2,-1,0,1,1,0,'',0,0,'','','','','','',1,'','',61,0,8,8,'','','',1,'','',2415,4950,375,1935,'2,13',5,0,0,3,23,0,'',1,'',0,'','',0,2,0,0,0,0,0,'',0) 
GO

INSERT INTO ICClassTableInfo(FClassTypeID,FPage,FCaption_CHS,FCaption_CHT,FCaption_EN,FKey,FFieldName,FTableName,FTableNameAs,FListIndex,FListClassName,FVisible,FEnable,FNeedSave,FMustInput,FCtlType,FProperty,FLookUpType,FLookUpClassID,FLookUpList,FSRCFieldName,FSRCTableName,FSRCTableNameAs,FDSPFieldName,FFNDFieldName,FValueLocation,FFilter,FFilterGroup,FValueType,FDspColType,FEditlen,FValuePrecision,FSaveRule,FDefValue,FAction,FUserDefine,FNote,FKeyWord,FLeft,FTop,FHeight,FWidth,FCondition,FTabIndex,FLock,FSum,FPrec,FScale,FLayer,FLoadAction,FUnControl,FFont,FSourceType,FSubKey,FParentKey,FConditionExt,FFrameBorder,FFrameBorderColor,FLabelWidth,FLabelColor,FTextColor,FIsF7,FContainer,FStyle) 
VALUES (200000022,1,'��ע','���]','Remarks','FNOTE','FNOTE','t_BosPlasticPoInStock','',7,2,-1,0,1,0,999,'',0,0,'','','','','','',0,'','',231,500,50,50,'','','',1,'','',165,1185,300,9180,'0,13',6,0,0,0,0,0,'',55,'',0,'','',0,2,0,0,0,0,0,'',0) 
GO

INSERT INTO ICClassTableInfo(FClassTypeID,FPage,FCaption_CHS,FCaption_CHT,FCaption_EN,FKey,FFieldName,FTableName,FTableNameAs,FListIndex,FListClassName,FVisible,FEnable,FNeedSave,FMustInput,FCtlType,FProperty,FLookUpType,FLookUpClassID,FLookUpList,FSRCFieldName,FSRCTableName,FSRCTableNameAs,FDSPFieldName,FFNDFieldName,FValueLocation,FFilter,FFilterGroup,FValueType,FDspColType,FEditlen,FValuePrecision,FSaveRule,FDefValue,FAction,FUserDefine,FNote,FKeyWord,FLeft,FTop,FHeight,FWidth,FCondition,FTabIndex,FLock,FSum,FPrec,FScale,FLayer,FLoadAction,FUnControl,FFont,FSourceType,FSubKey,FParentKey,FConditionExt,FFrameBorder,FFrameBorderColor,FLabelWidth,FLabelColor,FTextColor,FIsF7,FContainer,FStyle) 
VALUES (200000022,1,'���','�Ñ�','User','FChecker','FChecker','t_BosPlasticPoInStock','',4,2,-1,1,1,0,1,'',7,9,'','FUserID','t_User','','FName','FName',1,'','',56,500,255,4,'','0','',1,'','',4935,4950,375,1785,'0',7,-1,0,0,6,0,'',1,'',4,'','',1000000,2,0,0,0,0,0,'',0) 
GO

INSERT INTO ICClassTableInfo(FClassTypeID,FPage,FCaption_CHS,FCaption_CHT,FCaption_EN,FKey,FFieldName,FTableName,FTableNameAs,FListIndex,FListClassName,FVisible,FEnable,FNeedSave,FMustInput,FCtlType,FProperty,FLookUpType,FLookUpClassID,FLookUpList,FSRCFieldName,FSRCTableName,FSRCTableNameAs,FDSPFieldName,FFNDFieldName,FValueLocation,FFilter,FFilterGroup,FValueType,FDspColType,FEditlen,FValuePrecision,FSaveRule,FDefValue,FAction,FUserDefine,FNote,FKeyWord,FLeft,FTop,FHeight,FWidth,FCondition,FTabIndex,FLock,FSum,FPrec,FScale,FLayer,FLoadAction,FUnControl,FFont,FSourceType,FSubKey,FParentKey,FConditionExt,FFrameBorder,FFrameBorderColor,FLabelWidth,FLabelColor,FTextColor,FIsF7,FContainer,FStyle) 
VALUES (200000022,1,'�Ƶ���','�Ɔ���','Prep. by','FBiller','FBiller','t_BosPlasticPoInStock','',2,2,-1,-1,1,0,1,'',7,9,'','FUserID','t_User','t_User1','FName','FName',1,'','',56,500,255,4,'','','',1,'','USER',255,4950,375,1770,'0,9',8,-1,0,0,6,0,'',1,'',8,'','',0,2,0,0,0,0,0,'',0) 
GO

INSERT INTO ICClassTableInfo(FClassTypeID,FPage,FCaption_CHS,FCaption_CHT,FCaption_EN,FKey,FFieldName,FTableName,FTableNameAs,FListIndex,FListClassName,FVisible,FEnable,FNeedSave,FMustInput,FCtlType,FProperty,FLookUpType,FLookUpClassID,FLookUpList,FSRCFieldName,FSRCTableName,FSRCTableNameAs,FDSPFieldName,FFNDFieldName,FValueLocation,FFilter,FFilterGroup,FValueType,FDspColType,FEditlen,FValuePrecision,FSaveRule,FDefValue,FAction,FUserDefine,FNote,FKeyWord,FLeft,FTop,FHeight,FWidth,FCondition,FTabIndex,FLock,FSum,FPrec,FScale,FLayer,FLoadAction,FUnControl,FFont,FSourceType,FSubKey,FParentKey,FConditionExt,FFrameBorder,FFrameBorderColor,FLabelWidth,FLabelColor,FTextColor,FIsF7,FContainer,FStyle) 
VALUES (200000022,1,'�������','����1','Date1','FCheckDate','FCheckDate','t_BosPlasticPoInStock','',6,2,-1,0,1,0,0,'',0,0,'','','','','','',1,'','',61,0,8,8,'','','',1,'','',7200,4950,375,2070,'2,13',9,-1,0,3,23,0,'',1,'',0,'','',0,2,0,0,0,0,0,'',0) 
GO

INSERT INTO ICClassTableInfo(FClassTypeID,FPage,FCaption_CHS,FCaption_CHT,FCaption_EN,FKey,FFieldName,FTableName,FTableNameAs,FListIndex,FListClassName,FVisible,FEnable,FNeedSave,FMustInput,FCtlType,FProperty,FLookUpType,FLookUpClassID,FLookUpList,FSRCFieldName,FSRCTableName,FSRCTableNameAs,FDSPFieldName,FFNDFieldName,FValueLocation,FFilter,FFilterGroup,FValueType,FDspColType,FEditlen,FValuePrecision,FSaveRule,FDefValue,FAction,FUserDefine,FNote,FKeyWord,FLeft,FTop,FHeight,FWidth,FCondition,FTabIndex,FLock,FSum,FPrec,FScale,FLayer,FLoadAction,FUnControl,FFont,FSourceType,FSubKey,FParentKey,FConditionExt,FFrameBorder,FFrameBorderColor,FLabelWidth,FLabelColor,FTextColor,FIsF7,FContainer,FStyle) 
VALUES (200000022,1,'��������','�����','Transaction Type','FClassTypeID','FClassTypeID','t_BosPlasticPoInStock','',8,2,0,1,1,0,1,'',0,0,'','FID','ICClassType','','FName','FName',1,'','',56,500,255,4,'','','',1,'','CLASSTYPEID',240,120,405,2535,'-1',10,0,0,0,0,0,'',1,'',0,'','',0,0,0,0,0,0,0,'',0) 
GO

INSERT INTO ICClassTableInfo(FClassTypeID,FPage,FCaption_CHS,FCaption_CHT,FCaption_EN,FKey,FFieldName,FTableName,FTableNameAs,FListIndex,FListClassName,FVisible,FEnable,FNeedSave,FMustInput,FCtlType,FProperty,FLookUpType,FLookUpClassID,FLookUpList,FSRCFieldName,FSRCTableName,FSRCTableNameAs,FDSPFieldName,FFNDFieldName,FValueLocation,FFilter,FFilterGroup,FValueType,FDspColType,FEditlen,FValuePrecision,FSaveRule,FDefValue,FAction,FUserDefine,FNote,FKeyWord,FLeft,FTop,FHeight,FWidth,FCondition,FTabIndex,FLock,FSum,FPrec,FScale,FLayer,FLoadAction,FUnControl,FFont,FSourceType,FSubKey,FParentKey,FConditionExt,FFrameBorder,FFrameBorderColor,FLabelWidth,FLabelColor,FTextColor,FIsF7,FContainer,FStyle) 
VALUES (200000022,1,'���۶���','�ı�1','Text1','FSeBillNo','FSeBillNo','t_BosPlasticPoInStock','',1,2,-1,0,1,0,1,'',0,0,'','','','','FName','',1,'','',167,500,50,50,'','','',1,'','',180,765,375,2595,'0,13',27,-1,0,0,0,0,'',19,'',0,'','',0,2,0,0,0,0,0,'',0) 
GO

INSERT INTO ICClassTableInfo(FClassTypeID,FPage,FCaption_CHS,FCaption_CHT,FCaption_EN,FKey,FFieldName,FTableName,FTableNameAs,FListIndex,FListClassName,FVisible,FEnable,FNeedSave,FMustInput,FCtlType,FProperty,FLookUpType,FLookUpClassID,FLookUpList,FSRCFieldName,FSRCTableName,FSRCTableNameAs,FDSPFieldName,FFNDFieldName,FValueLocation,FFilter,FFilterGroup,FValueType,FDspColType,FEditlen,FValuePrecision,FSaveRule,FDefValue,FAction,FUserDefine,FNote,FKeyWord,FLeft,FTop,FHeight,FWidth,FCondition,FTabIndex,FLock,FSum,FPrec,FScale,FLayer,FLoadAction,FUnControl,FFont,FSourceType,FSubKey,FParentKey,FConditionExt,FFrameBorder,FFrameBorderColor,FLabelWidth,FLabelColor,FTextColor,FIsF7,FContainer,FStyle) 
VALUES (200000022,1,'������','�ı�2','Text2','FRunID','FRunID','t_BosPlasticPoInStock','',0,2,-1,0,1,0,1,'',0,0,'','','','','FName','',1,'','',167,500,50,50,'','','',1,'','',5205,765,375,1890,'0,13',28,-1,0,0,0,0,'',19,'',0,'','',0,2,0,0,0,0,0,'',0) 
GO

INSERT INTO ICClassTableInfo(FClassTypeID,FPage,FCaption_CHS,FCaption_CHT,FCaption_EN,FKey,FFieldName,FTableName,FTableNameAs,FListIndex,FListClassName,FVisible,FEnable,FNeedSave,FMustInput,FCtlType,FProperty,FLookUpType,FLookUpClassID,FLookUpList,FSRCFieldName,FSRCTableName,FSRCTableNameAs,FDSPFieldName,FFNDFieldName,FValueLocation,FFilter,FFilterGroup,FValueType,FDspColType,FEditlen,FValuePrecision,FSaveRule,FDefValue,FAction,FUserDefine,FNote,FKeyWord,FLeft,FTop,FHeight,FWidth,FCondition,FTabIndex,FLock,FSum,FPrec,FScale,FLayer,FLoadAction,FUnControl,FFont,FSourceType,FSubKey,FParentKey,FConditionExt,FFrameBorder,FFrameBorderColor,FLabelWidth,FLabelColor,FTextColor,FIsF7,FContainer,FStyle) 
VALUES (200000022,1,'��������','����2','Date2','FFacDate','FFacDate','t_BosPlasticPoInStock','',0,2,-1,0,1,0,0,'',0,0,'','','','','','',1,'','',61,0,8,8,'','','',1,'','',2835,2160,285,2235,'2,13',29,0,0,3,23,0,'',1,'',0,'','',0,2,0,0,0,0,0,'',0) 
GO

INSERT INTO ICClassTableInfo(FClassTypeID,FPage,FCaption_CHS,FCaption_CHT,FCaption_EN,FKey,FFieldName,FTableName,FTableNameAs,FListIndex,FListClassName,FVisible,FEnable,FNeedSave,FMustInput,FCtlType,FProperty,FLookUpType,FLookUpClassID,FLookUpList,FSRCFieldName,FSRCTableName,FSRCTableNameAs,FDSPFieldName,FFNDFieldName,FValueLocation,FFilter,FFilterGroup,FValueType,FDspColType,FEditlen,FValuePrecision,FSaveRule,FDefValue,FAction,FUserDefine,FNote,FKeyWord,FLeft,FTop,FHeight,FWidth,FCondition,FTabIndex,FLock,FSum,FPrec,FScale,FLayer,FLoadAction,FUnControl,FFont,FSourceType,FSubKey,FParentKey,FConditionExt,FFrameBorder,FFrameBorderColor,FLabelWidth,FLabelColor,FTextColor,FIsF7,FContainer,FStyle) 
VALUES (200000022,1,'��������','���A�Y��1','Master Data1','FBillType','FBillType','t_BosPlasticPoInStock','',0,2,-1,0,1,0,1,'',2,10007,'','FInterID','t_SubMessage','t_SubMessage1','FName','FID',1,'','',56,500,255,4,'','','',1,'','',180,330,315,2595,'0',30,0,0,0,10,0,'',17,'',1,'','',0,2,0,0,0,0,0,'',0) 
GO

INSERT INTO ICClassTableInfo(FClassTypeID,FPage,FCaption_CHS,FCaption_CHT,FCaption_EN,FKey,FFieldName,FTableName,FTableNameAs,FListIndex,FListClassName,FVisible,FEnable,FNeedSave,FMustInput,FCtlType,FProperty,FLookUpType,FLookUpClassID,FLookUpList,FSRCFieldName,FSRCTableName,FSRCTableNameAs,FDSPFieldName,FFNDFieldName,FValueLocation,FFilter,FFilterGroup,FValueType,FDspColType,FEditlen,FValuePrecision,FSaveRule,FDefValue,FAction,FUserDefine,FNote,FKeyWord,FLeft,FTop,FHeight,FWidth,FCondition,FTabIndex,FLock,FSum,FPrec,FScale,FLayer,FLoadAction,FUnControl,FFont,FSourceType,FSubKey,FParentKey,FConditionExt,FFrameBorder,FFrameBorderColor,FLabelWidth,FLabelColor,FTextColor,FIsF7,FContainer,FStyle) 
VALUES (200000022,1,'�ɹ�����','�ı�3','Text3','FPOBillNO','FPOBillNO','t_BosPlasticPoInStock','',0,2,-1,0,1,0,1,'',0,0,'','','','','FName','',1,'','',167,500,50,50,'','','',1,'','',7200,330,315,2130,'0,13',31,0,0,0,0,0,'',19,'',0,'','',0,2,0,0,0,0,0,'',0) 
GO

INSERT INTO ICClassTableInfo(FClassTypeID,FPage,FCaption_CHS,FCaption_CHT,FCaption_EN,FKey,FFieldName,FTableName,FTableNameAs,FListIndex,FListClassName,FVisible,FEnable,FNeedSave,FMustInput,FCtlType,FProperty,FLookUpType,FLookUpClassID,FLookUpList,FSRCFieldName,FSRCTableName,FSRCTableNameAs,FDSPFieldName,FFNDFieldName,FValueLocation,FFilter,FFilterGroup,FValueType,FDspColType,FEditlen,FValuePrecision,FSaveRule,FDefValue,FAction,FUserDefine,FNote,FKeyWord,FLeft,FTop,FHeight,FWidth,FCondition,FTabIndex,FLock,FSum,FPrec,FScale,FLayer,FLoadAction,FUnControl,FFont,FSourceType,FSubKey,FParentKey,FConditionExt,FFrameBorder,FFrameBorderColor,FLabelWidth,FLabelColor,FTextColor,FIsF7,FContainer,FStyle) 
VALUES (200000022,1,'��Ӧ��','������1','Vendor1','FBase','FSupplyID','t_BosPlasticPoInStock','',0,2,-1,0,1,0,1,'',1,8,'','FItemID','t_Supplier','t_Supplier1','FName','FNumber',1,'','',56,500,255,4,'','','',1,'','',2970,765,375,2010,'0',32,0,0,0,10,0,'',17,'',1,'','',0,2,0,0,0,0,0,'',0) 
GO

INSERT INTO ICClassTableInfo(FClassTypeID,FPage,FCaption_CHS,FCaption_CHT,FCaption_EN,FKey,FFieldName,FTableName,FTableNameAs,FListIndex,FListClassName,FVisible,FEnable,FNeedSave,FMustInput,FCtlType,FProperty,FLookUpType,FLookUpClassID,FLookUpList,FSRCFieldName,FSRCTableName,FSRCTableNameAs,FDSPFieldName,FFNDFieldName,FValueLocation,FFilter,FFilterGroup,FValueType,FDspColType,FEditlen,FValuePrecision,FSaveRule,FDefValue,FAction,FUserDefine,FNote,FKeyWord,FLeft,FTop,FHeight,FWidth,FCondition,FTabIndex,FLock,FSum,FPrec,FScale,FLayer,FLoadAction,FUnControl,FFont,FSourceType,FSubKey,FParentKey,FConditionExt,FFrameBorder,FFrameBorderColor,FLabelWidth,FLabelColor,FTextColor,FIsF7,FContainer,FStyle) 
VALUES (200000022,2,'��¼����','��䛃ȴa','Entry ISN','FEntryID2','FEntryID','t_BosPlasticPoInStockEntry','',10,0,0,1,0,0,3,'',0,0,'','','','','','',1,'','',56,500,255,4,'','','',1,'','ENTRYKEY',240,120,350,1800,'-1',-1,0,0,0,0,0,'',1,'',0,'','',0,0,0,0,0,0,0,'',0) 
GO

INSERT INTO ICClassTableInfo(FClassTypeID,FPage,FCaption_CHS,FCaption_CHT,FCaption_EN,FKey,FFieldName,FTableName,FTableNameAs,FListIndex,FListClassName,FVisible,FEnable,FNeedSave,FMustInput,FCtlType,FProperty,FLookUpType,FLookUpClassID,FLookUpList,FSRCFieldName,FSRCTableName,FSRCTableNameAs,FDSPFieldName,FFNDFieldName,FValueLocation,FFilter,FFilterGroup,FValueType,FDspColType,FEditlen,FValuePrecision,FSaveRule,FDefValue,FAction,FUserDefine,FNote,FKeyWord,FLeft,FTop,FHeight,FWidth,FCondition,FTabIndex,FLock,FSum,FPrec,FScale,FLayer,FLoadAction,FUnControl,FFont,FSourceType,FSubKey,FParentKey,FConditionExt,FFrameBorder,FFrameBorderColor,FLabelWidth,FLabelColor,FTextColor,FIsF7,FContainer,FStyle) 
VALUES (200000022,2,'��������','�Γ��ȴa','Doc ISN','FID2','FID','t_BosPlasticPoInStockEntry','',33,0,0,1,1,1,3,'',0,0,'','','','','','',1,'','',56,500,255,4,'','','',1,'','PARENTID',240,120,350,1800,'-1',-1,0,0,0,0,0,'',1,'',0,'','',0,0,0,0,0,0,0,'',0) 
GO

INSERT INTO ICClassTableInfo(FClassTypeID,FPage,FCaption_CHS,FCaption_CHT,FCaption_EN,FKey,FFieldName,FTableName,FTableNameAs,FListIndex,FListClassName,FVisible,FEnable,FNeedSave,FMustInput,FCtlType,FProperty,FLookUpType,FLookUpClassID,FLookUpList,FSRCFieldName,FSRCTableName,FSRCTableNameAs,FDSPFieldName,FFNDFieldName,FValueLocation,FFilter,FFilterGroup,FValueType,FDspColType,FEditlen,FValuePrecision,FSaveRule,FDefValue,FAction,FUserDefine,FNote,FKeyWord,FLeft,FTop,FHeight,FWidth,FCondition,FTabIndex,FLock,FSum,FPrec,FScale,FLayer,FLoadAction,FUnControl,FFont,FSourceType,FSubKey,FParentKey,FConditionExt,FFrameBorder,FFrameBorderColor,FLabelWidth,FLabelColor,FTextColor,FIsF7,FContainer,FStyle) 
VALUES (200000022,2,'�к�','��̖','Row No.','FIndex2','FIndex','t_BosPlasticPoInStockEntry','',34,0,0,1,1,0,3,'',0,0,'','','','','','',1,'','',56,500,255,4,'','','',1,'','INDEX',240,120,350,1800,'-1',-1,-1,0,0,0,0,'',1,'',0,'','',0,0,0,0,0,0,0,'',0) 
GO

INSERT INTO ICClassTableInfo(FClassTypeID,FPage,FCaption_CHS,FCaption_CHT,FCaption_EN,FKey,FFieldName,FTableName,FTableNameAs,FListIndex,FListClassName,FVisible,FEnable,FNeedSave,FMustInput,FCtlType,FProperty,FLookUpType,FLookUpClassID,FLookUpList,FSRCFieldName,FSRCTableName,FSRCTableNameAs,FDSPFieldName,FFNDFieldName,FValueLocation,FFilter,FFilterGroup,FValueType,FDspColType,FEditlen,FValuePrecision,FSaveRule,FDefValue,FAction,FUserDefine,FNote,FKeyWord,FLeft,FTop,FHeight,FWidth,FCondition,FTabIndex,FLock,FSum,FPrec,FScale,FLayer,FLoadAction,FUnControl,FFont,FSourceType,FSubKey,FParentKey,FConditionExt,FFrameBorder,FFrameBorderColor,FLabelWidth,FLabelColor,FTextColor,FIsF7,FContainer,FStyle) 
VALUES (200000022,2,'�ɱ�����','�ɱ�����','Cost Object','FCostObjID','FCostObjID','t_BosPlasticPoInStockEntry','',10,0,-1,0,1,0,1,'',1,2001,'','FItemID','cbCostObj','','FName','FNumber',1,'','',56,500,255,4,'','','',1,'','',5158,7738,346,2500,'0',0,-1,0,0,10,0,'',17,'',1,'','',0,2,0,0,0,0,0,'',0) 
GO

INSERT INTO ICClassTableInfo(FClassTypeID,FPage,FCaption_CHS,FCaption_CHT,FCaption_EN,FKey,FFieldName,FTableName,FTableNameAs,FListIndex,FListClassName,FVisible,FEnable,FNeedSave,FMustInput,FCtlType,FProperty,FLookUpType,FLookUpClassID,FLookUpList,FSRCFieldName,FSRCTableName,FSRCTableNameAs,FDSPFieldName,FFNDFieldName,FValueLocation,FFilter,FFilterGroup,FValueType,FDspColType,FEditlen,FValuePrecision,FSaveRule,FDefValue,FAction,FUserDefine,FNote,FKeyWord,FLeft,FTop,FHeight,FWidth,FCondition,FTabIndex,FLock,FSum,FPrec,FScale,FLayer,FLoadAction,FUnControl,FFont,FSourceType,FSubKey,FParentKey,FConditionExt,FFrameBorder,FFrameBorderColor,FLabelWidth,FLabelColor,FTextColor,FIsF7,FContainer,FStyle) 
VALUES (200000022,2,'��Ʒ','����1','Mtrl1','FProductID','FProductID','t_BosPlasticPoInStockEntry','',17,0,-1,0,1,0,1,'',1,4,'','FItemID','t_ICItem','t_ICItem1','FNumber','FNumber',1,'','',56,500,255,4,'','','',1,'','',5158,7738,346,2500,'0',1,-1,0,0,10,0,'',17,'',1,'','',0,2,0,0,0,0,0,'',0) 
GO

INSERT INTO ICClassTableInfo(FClassTypeID,FPage,FCaption_CHS,FCaption_CHT,FCaption_EN,FKey,FFieldName,FTableName,FTableNameAs,FListIndex,FListClassName,FVisible,FEnable,FNeedSave,FMustInput,FCtlType,FProperty,FLookUpType,FLookUpClassID,FLookUpList,FSRCFieldName,FSRCTableName,FSRCTableNameAs,FDSPFieldName,FFNDFieldName,FValueLocation,FFilter,FFilterGroup,FValueType,FDspColType,FEditlen,FValuePrecision,FSaveRule,FDefValue,FAction,FUserDefine,FNote,FKeyWord,FLeft,FTop,FHeight,FWidth,FCondition,FTabIndex,FLock,FSum,FPrec,FScale,FLayer,FLoadAction,FUnControl,FFont,FSourceType,FSubKey,FParentKey,FConditionExt,FFrameBorder,FFrameBorderColor,FLabelWidth,FLabelColor,FTextColor,FIsF7,FContainer,FStyle) 
VALUES (200000022,2,'��Ʒ����','���A�Y�ό���1','Master Data Property1','FBaseProperty1','FProductID','t_BosPlasticPoInStockEntry','',19,0,-1,0,0,0,1,'',0,4,'','FItemID','t_ICItem','t_ICItem1','FName','',3,'','',167,500,255,0,'','','',1,'','',0,0,0,2500,'0',2,-1,0,0,0,0,'',55,'',2,'','',0,2,0,0,0,0,0,'',0) 
GO

INSERT INTO ICClassTableInfo(FClassTypeID,FPage,FCaption_CHS,FCaption_CHT,FCaption_EN,FKey,FFieldName,FTableName,FTableNameAs,FListIndex,FListClassName,FVisible,FEnable,FNeedSave,FMustInput,FCtlType,FProperty,FLookUpType,FLookUpClassID,FLookUpList,FSRCFieldName,FSRCTableName,FSRCTableNameAs,FDSPFieldName,FFNDFieldName,FValueLocation,FFilter,FFilterGroup,FValueType,FDspColType,FEditlen,FValuePrecision,FSaveRule,FDefValue,FAction,FUserDefine,FNote,FKeyWord,FLeft,FTop,FHeight,FWidth,FCondition,FTabIndex,FLock,FSum,FPrec,FScale,FLayer,FLoadAction,FUnControl,FFont,FSourceType,FSubKey,FParentKey,FConditionExt,FFrameBorder,FFrameBorderColor,FLabelWidth,FLabelColor,FTextColor,FIsF7,FContainer,FStyle) 
VALUES (200000022,2,'��Ʒ����','С��5','Decimal Fraction5','FICMOQty','FICMOQty','t_BosPlasticPoInStockEntry','',10,0,-1,0,1,0,2,'',0,0,'','','','','','',1,'','',106,9,20,13,'','','',1,'','',0,0,350,2500,'1,13',3,0,0,28,2,0,'',17,'',0,'','',0,2,0,0,0,0,0,'',0) 
GO

INSERT INTO ICClassTableInfo(FClassTypeID,FPage,FCaption_CHS,FCaption_CHT,FCaption_EN,FKey,FFieldName,FTableName,FTableNameAs,FListIndex,FListClassName,FVisible,FEnable,FNeedSave,FMustInput,FCtlType,FProperty,FLookUpType,FLookUpClassID,FLookUpList,FSRCFieldName,FSRCTableName,FSRCTableNameAs,FDSPFieldName,FFNDFieldName,FValueLocation,FFilter,FFilterGroup,FValueType,FDspColType,FEditlen,FValuePrecision,FSaveRule,FDefValue,FAction,FUserDefine,FNote,FKeyWord,FLeft,FTop,FHeight,FWidth,FCondition,FTabIndex,FLock,FSum,FPrec,FScale,FLayer,FLoadAction,FUnControl,FFont,FSourceType,FSubKey,FParentKey,FConditionExt,FFrameBorder,FFrameBorderColor,FLabelWidth,FLabelColor,FTextColor,FIsF7,FContainer,FStyle) 
VALUES (200000022,2,'����','����','Mtrl','FItemId','FItemId','t_BosPlasticPoInStockEntry','',10,0,-1,0,1,1,1,'',1,4,'','FItemID','t_ICItem','','FNumber','FNumber',1,'','',56,500,255,4,'','','TakeBaseData{FBaseProperty,FUnitId=FUnitID}',1,'','',5158,7738,346,1860,'0',4,0,0,0,10,0,'',17,'',1,'','',0,2,0,0,0,0,0,'',0) 
GO

INSERT INTO ICClassTableInfo(FClassTypeID,FPage,FCaption_CHS,FCaption_CHT,FCaption_EN,FKey,FFieldName,FTableName,FTableNameAs,FListIndex,FListClassName,FVisible,FEnable,FNeedSave,FMustInput,FCtlType,FProperty,FLookUpType,FLookUpClassID,FLookUpList,FSRCFieldName,FSRCTableName,FSRCTableNameAs,FDSPFieldName,FFNDFieldName,FValueLocation,FFilter,FFilterGroup,FValueType,FDspColType,FEditlen,FValuePrecision,FSaveRule,FDefValue,FAction,FUserDefine,FNote,FKeyWord,FLeft,FTop,FHeight,FWidth,FCondition,FTabIndex,FLock,FSum,FPrec,FScale,FLayer,FLoadAction,FUnControl,FFont,FSourceType,FSubKey,FParentKey,FConditionExt,FFrameBorder,FFrameBorderColor,FLabelWidth,FLabelColor,FTextColor,FIsF7,FContainer,FStyle) 
VALUES (200000022,2,'����','���A�Y�ό���','Master Data Property','FBaseProperty','FItemId','t_BosPlasticPoInStockEntry','',11,0,-1,0,0,0,1,'',0,4,'','FItemID','t_ICItem','','FName','',3,'','',167,500,255,0,'','','',1,'','',0,0,0,2500,'0',5,-1,0,0,0,0,'',55,'',2,'','',0,2,0,0,0,0,0,'',0) 
GO

INSERT INTO ICClassTableInfo(FClassTypeID,FPage,FCaption_CHS,FCaption_CHT,FCaption_EN,FKey,FFieldName,FTableName,FTableNameAs,FListIndex,FListClassName,FVisible,FEnable,FNeedSave,FMustInput,FCtlType,FProperty,FLookUpType,FLookUpClassID,FLookUpList,FSRCFieldName,FSRCTableName,FSRCTableNameAs,FDSPFieldName,FFNDFieldName,FValueLocation,FFilter,FFilterGroup,FValueType,FDspColType,FEditlen,FValuePrecision,FSaveRule,FDefValue,FAction,FUserDefine,FNote,FKeyWord,FLeft,FTop,FHeight,FWidth,FCondition,FTabIndex,FLock,FSum,FPrec,FScale,FLayer,FLoadAction,FUnControl,FFont,FSourceType,FSubKey,FParentKey,FConditionExt,FFrameBorder,FFrameBorderColor,FLabelWidth,FLabelColor,FTextColor,FIsF7,FContainer,FStyle) 
VALUES (200000022,2,'����ͺ�','���A�Y�ό���2','Master Data Property2','FBaseProperty2','FItemId','t_BosPlasticPoInStockEntry','',18,0,-1,0,0,0,1,'',0,4,'','FItemID','t_ICItem','','FModel','',3,'','',167,500,255,0,'','','',1,'','',0,0,0,2500,'0',6,-1,0,0,0,0,'',55,'',2,'','',0,2,0,0,0,0,0,'',0) 
GO

INSERT INTO ICClassTableInfo(FClassTypeID,FPage,FCaption_CHS,FCaption_CHT,FCaption_EN,FKey,FFieldName,FTableName,FTableNameAs,FListIndex,FListClassName,FVisible,FEnable,FNeedSave,FMustInput,FCtlType,FProperty,FLookUpType,FLookUpClassID,FLookUpList,FSRCFieldName,FSRCTableName,FSRCTableNameAs,FDSPFieldName,FFNDFieldName,FValueLocation,FFilter,FFilterGroup,FValueType,FDspColType,FEditlen,FValuePrecision,FSaveRule,FDefValue,FAction,FUserDefine,FNote,FKeyWord,FLeft,FTop,FHeight,FWidth,FCondition,FTabIndex,FLock,FSum,FPrec,FScale,FLayer,FLoadAction,FUnControl,FFont,FSourceType,FSubKey,FParentKey,FConditionExt,FFrameBorder,FFrameBorderColor,FLabelWidth,FLabelColor,FTextColor,FIsF7,FContainer,FStyle) 
VALUES (200000022,2,'������λ','Ӌ����λ','Unit of Measure (UoM)','FUnitId','FUnitId','t_BosPlasticPoInStockEntry','',20,0,-1,0,1,1,1,'FItemId.FUnitGroupID',6,7,'','FItemID','t_Measureunit','','FName','FNumber',1,'','',56,500,255,4,'','','',1,'','',5158,7738,346,1290,'0',7,0,0,0,10,0,'',17,'',1,'','',0,2,0,0,0,0,0,'',0) 
GO

INSERT INTO ICClassTableInfo(FClassTypeID,FPage,FCaption_CHS,FCaption_CHT,FCaption_EN,FKey,FFieldName,FTableName,FTableNameAs,FListIndex,FListClassName,FVisible,FEnable,FNeedSave,FMustInput,FCtlType,FProperty,FLookUpType,FLookUpClassID,FLookUpList,FSRCFieldName,FSRCTableName,FSRCTableNameAs,FDSPFieldName,FFNDFieldName,FValueLocation,FFilter,FFilterGroup,FValueType,FDspColType,FEditlen,FValuePrecision,FSaveRule,FDefValue,FAction,FUserDefine,FNote,FKeyWord,FLeft,FTop,FHeight,FWidth,FCondition,FTabIndex,FLock,FSum,FPrec,FScale,FLayer,FLoadAction,FUnControl,FFont,FSourceType,FSubKey,FParentKey,FConditionExt,FFrameBorder,FFrameBorderColor,FLabelWidth,FLabelColor,FTextColor,FIsF7,FContainer,FStyle) 
VALUES (200000022,2,'��λ����','С��3','Decimal Fraction3','FPerQty','FPerQty','t_BosPlasticPoInStockEntry','',10,0,-1,0,1,0,2,'',0,0,'','','','','','',1,'','',106,9,20,13,'','','',1,'','',0,0,350,2500,'1,13',8,0,0,28,2,0,'',17,'',0,'','',0,2,0,0,0,0,0,'',0) 
GO

INSERT INTO ICClassTableInfo(FClassTypeID,FPage,FCaption_CHS,FCaption_CHT,FCaption_EN,FKey,FFieldName,FTableName,FTableNameAs,FListIndex,FListClassName,FVisible,FEnable,FNeedSave,FMustInput,FCtlType,FProperty,FLookUpType,FLookUpClassID,FLookUpList,FSRCFieldName,FSRCTableName,FSRCTableNameAs,FDSPFieldName,FFNDFieldName,FValueLocation,FFilter,FFilterGroup,FValueType,FDspColType,FEditlen,FValuePrecision,FSaveRule,FDefValue,FAction,FUserDefine,FNote,FKeyWord,FLeft,FTop,FHeight,FWidth,FCondition,FTabIndex,FLock,FSum,FPrec,FScale,FLayer,FLoadAction,FUnControl,FFont,FSourceType,FSubKey,FParentKey,FConditionExt,FFrameBorder,FFrameBorderColor,FLabelWidth,FLabelColor,FTextColor,FIsF7,FContainer,FStyle) 
VALUES (200000022,2,'BOM����','С��6','Decimal Fraction6','FBomQty','FBomQty','t_BosPlasticPoInStockEntry','',10,0,-1,0,1,0,2,'',0,0,'','','','','','',1,'','',106,9,20,13,'','','',1,'','',0,0,350,2500,'1,13',9,0,1,28,2,0,'',17,'',0,'','',0,2,0,0,0,0,0,'',0) 
GO

INSERT INTO ICClassTableInfo(FClassTypeID,FPage,FCaption_CHS,FCaption_CHT,FCaption_EN,FKey,FFieldName,FTableName,FTableNameAs,FListIndex,FListClassName,FVisible,FEnable,FNeedSave,FMustInput,FCtlType,FProperty,FLookUpType,FLookUpClassID,FLookUpList,FSRCFieldName,FSRCTableName,FSRCTableNameAs,FDSPFieldName,FFNDFieldName,FValueLocation,FFilter,FFilterGroup,FValueType,FDspColType,FEditlen,FValuePrecision,FSaveRule,FDefValue,FAction,FUserDefine,FNote,FKeyWord,FLeft,FTop,FHeight,FWidth,FCondition,FTabIndex,FLock,FSum,FPrec,FScale,FLayer,FLoadAction,FUnControl,FFont,FSourceType,FSubKey,FParentKey,FConditionExt,FFrameBorder,FFrameBorderColor,FLabelWidth,FLabelColor,FTextColor,FIsF7,FContainer,FStyle) 
VALUES (200000022,2,'Դ������','Դ�΃ȴa','Source Doc ISN','FID_SRC','FID_SRC','t_BosPlasticPoInStockEntry','',14,0,12,0,1,0,3,'',0,0,'','','','','','',1,'','',56,10,10,4,'','','',1,'','SRCID',0,0,350,2500,'-1',9,-1,0,0,0,0,'',33,'',0,'','',0,0,0,0,0,0,0,'',0) 
GO

INSERT INTO ICClassTableInfo(FClassTypeID,FPage,FCaption_CHS,FCaption_CHT,FCaption_EN,FKey,FFieldName,FTableName,FTableNameAs,FListIndex,FListClassName,FVisible,FEnable,FNeedSave,FMustInput,FCtlType,FProperty,FLookUpType,FLookUpClassID,FLookUpList,FSRCFieldName,FSRCTableName,FSRCTableNameAs,FDSPFieldName,FFNDFieldName,FValueLocation,FFilter,FFilterGroup,FValueType,FDspColType,FEditlen,FValuePrecision,FSaveRule,FDefValue,FAction,FUserDefine,FNote,FKeyWord,FLeft,FTop,FHeight,FWidth,FCondition,FTabIndex,FLock,FSum,FPrec,FScale,FLayer,FLoadAction,FUnControl,FFont,FSourceType,FSubKey,FParentKey,FConditionExt,FFrameBorder,FFrameBorderColor,FLabelWidth,FLabelColor,FTextColor,FIsF7,FContainer,FStyle) 
VALUES (200000022,2,'Դ����¼','Դ�η��','Source Entry ISN','FEntryID_SRC','FEntryID_SRC','t_BosPlasticPoInStockEntry','',15,0,12,0,1,0,3,'FID_SRC',0,0,'','','','','','',1,'','',56,10,10,4,'','','',1,'','SRCENTRYID',0,0,350,2500,'-1',10,-1,0,0,0,0,'',33,'',0,'','',0,0,0,0,0,0,0,'',0) 
GO

INSERT INTO ICClassTableInfo(FClassTypeID,FPage,FCaption_CHS,FCaption_CHT,FCaption_EN,FKey,FFieldName,FTableName,FTableNameAs,FListIndex,FListClassName,FVisible,FEnable,FNeedSave,FMustInput,FCtlType,FProperty,FLookUpType,FLookUpClassID,FLookUpList,FSRCFieldName,FSRCTableName,FSRCTableNameAs,FDSPFieldName,FFNDFieldName,FValueLocation,FFilter,FFilterGroup,FValueType,FDspColType,FEditlen,FValuePrecision,FSaveRule,FDefValue,FAction,FUserDefine,FNote,FKeyWord,FLeft,FTop,FHeight,FWidth,FCondition,FTabIndex,FLock,FSum,FPrec,FScale,FLayer,FLoadAction,FUnControl,FFont,FSourceType,FSubKey,FParentKey,FConditionExt,FFrameBorder,FFrameBorderColor,FLabelWidth,FLabelColor,FTextColor,FIsF7,FContainer,FStyle) 
VALUES (200000022,2,'�����(%)','С��1','Decimal Fraction1','FScrap','FScrap','t_BosPlasticPoInStockEntry','',25,0,-1,0,1,0,2,'',0,0,'','','','','','',1,'','',106,9,20,13,'','','',1,'','',0,0,350,2500,'1,13',10,-1,0,28,4,0,'',17,'',0,'','',0,2,0,0,0,0,0,'',0) 
GO

INSERT INTO ICClassTableInfo(FClassTypeID,FPage,FCaption_CHS,FCaption_CHT,FCaption_EN,FKey,FFieldName,FTableName,FTableNameAs,FListIndex,FListClassName,FVisible,FEnable,FNeedSave,FMustInput,FCtlType,FProperty,FLookUpType,FLookUpClassID,FLookUpList,FSRCFieldName,FSRCTableName,FSRCTableNameAs,FDSPFieldName,FFNDFieldName,FValueLocation,FFilter,FFilterGroup,FValueType,FDspColType,FEditlen,FValuePrecision,FSaveRule,FDefValue,FAction,FUserDefine,FNote,FKeyWord,FLeft,FTop,FHeight,FWidth,FCondition,FTabIndex,FLock,FSum,FPrec,FScale,FLayer,FLoadAction,FUnControl,FFont,FSourceType,FSubKey,FParentKey,FConditionExt,FFrameBorder,FFrameBorderColor,FLabelWidth,FLabelColor,FTextColor,FIsF7,FContainer,FStyle) 
VALUES (200000022,2,'�����','С��4','Decimal Fraction4','FScrapQty','FScrapQty','t_BosPlasticPoInStockEntry','',10,0,-1,0,1,0,2,'',0,0,'','','','','','',1,'','',106,9,20,13,'','','',1,'','',0,0,350,2500,'1,13',11,0,1,28,2,0,'',17,'',0,'','',0,2,0,0,0,0,0,'',0) 
GO

INSERT INTO ICClassTableInfo(FClassTypeID,FPage,FCaption_CHS,FCaption_CHT,FCaption_EN,FKey,FFieldName,FTableName,FTableNameAs,FListIndex,FListClassName,FVisible,FEnable,FNeedSave,FMustInput,FCtlType,FProperty,FLookUpType,FLookUpClassID,FLookUpList,FSRCFieldName,FSRCTableName,FSRCTableNameAs,FDSPFieldName,FFNDFieldName,FValueLocation,FFilter,FFilterGroup,FValueType,FDspColType,FEditlen,FValuePrecision,FSaveRule,FDefValue,FAction,FUserDefine,FNote,FKeyWord,FLeft,FTop,FHeight,FWidth,FCondition,FTabIndex,FLock,FSum,FPrec,FScale,FLayer,FLoadAction,FUnControl,FFont,FSourceType,FSubKey,FParentKey,FConditionExt,FFrameBorder,FFrameBorderColor,FLabelWidth,FLabelColor,FTextColor,FIsF7,FContainer,FStyle) 
VALUES (200000022,2,'����','С��2','Decimal Fraction2','FQty','FQty','t_BosPlasticPoInStockEntry','',10,0,-1,0,1,0,2,'',0,0,'','','','','','',1,'','',106,9,20,13,'','','',1,'','',0,0,350,2500,'1,13',12,0,1,28,4,0,'',17,'',0,'','',0,2,0,0,0,0,0,'',0) 
GO

INSERT INTO ICClassTableInfo(FClassTypeID,FPage,FCaption_CHS,FCaption_CHT,FCaption_EN,FKey,FFieldName,FTableName,FTableNameAs,FListIndex,FListClassName,FVisible,FEnable,FNeedSave,FMustInput,FCtlType,FProperty,FLookUpType,FLookUpClassID,FLookUpList,FSRCFieldName,FSRCTableName,FSRCTableNameAs,FDSPFieldName,FFNDFieldName,FValueLocation,FFilter,FFilterGroup,FValueType,FDspColType,FEditlen,FValuePrecision,FSaveRule,FDefValue,FAction,FUserDefine,FNote,FKeyWord,FLeft,FTop,FHeight,FWidth,FCondition,FTabIndex,FLock,FSum,FPrec,FScale,FLayer,FLoadAction,FUnControl,FFont,FSourceType,FSubKey,FParentKey,FConditionExt,FFrameBorder,FFrameBorderColor,FLabelWidth,FLabelColor,FTextColor,FIsF7,FContainer,FStyle) 
VALUES (200000022,2,'������(%)','С��','Decimal Fraction','FPrepScrap','FPrepScrap','t_BosPlasticPoInStockEntry','',23,0,12,0,1,0,2,'',0,0,'','','','','','',1,'','',106,9,20,13,'','','',1,'','',0,0,350,0,'1,13',13,-1,0,28,2,0,'',17,'',0,'','',0,2,0,0,0,0,0,'',0) 
GO

INSERT INTO ICClassTableInfo(FClassTypeID,FPage,FCaption_CHS,FCaption_CHT,FCaption_EN,FKey,FFieldName,FTableName,FTableNameAs,FListIndex,FListClassName,FVisible,FEnable,FNeedSave,FMustInput,FCtlType,FProperty,FLookUpType,FLookUpClassID,FLookUpList,FSRCFieldName,FSRCTableName,FSRCTableNameAs,FDSPFieldName,FFNDFieldName,FValueLocation,FFilter,FFilterGroup,FValueType,FDspColType,FEditlen,FValuePrecision,FSaveRule,FDefValue,FAction,FUserDefine,FNote,FKeyWord,FLeft,FTop,FHeight,FWidth,FCondition,FTabIndex,FLock,FSum,FPrec,FScale,FLayer,FLoadAction,FUnControl,FFont,FSourceType,FSubKey,FParentKey,FConditionExt,FFrameBorder,FFrameBorderColor,FLabelWidth,FLabelColor,FTextColor,FIsF7,FContainer,FStyle) 
VALUES (200000022,2,'�ֿ�','�}��','Warehouse','FStockID','FStockID','t_BosPlasticPoInStockEntry','',12,0,-1,0,1,1,1,'',1,5,'','FItemID','t_Stock','','FName','FNumber',1,'','',56,500,255,4,'','','',1,'','',5158,7738,346,2500,'0',13,0,0,0,10,0,'',17,'',1,'','',0,2,0,0,0,0,0,'',0) 
GO

INSERT INTO ICClassTableInfo(FClassTypeID,FPage,FCaption_CHS,FCaption_CHT,FCaption_EN,FKey,FFieldName,FTableName,FTableNameAs,FListIndex,FListClassName,FVisible,FEnable,FNeedSave,FMustInput,FCtlType,FProperty,FLookUpType,FLookUpClassID,FLookUpList,FSRCFieldName,FSRCTableName,FSRCTableNameAs,FDSPFieldName,FFNDFieldName,FValueLocation,FFilter,FFilterGroup,FValueType,FDspColType,FEditlen,FValuePrecision,FSaveRule,FDefValue,FAction,FUserDefine,FNote,FKeyWord,FLeft,FTop,FHeight,FWidth,FCondition,FTabIndex,FLock,FSum,FPrec,FScale,FLayer,FLoadAction,FUnControl,FFont,FSourceType,FSubKey,FParentKey,FConditionExt,FFrameBorder,FFrameBorderColor,FLabelWidth,FLabelColor,FTextColor,FIsF7,FContainer,FStyle) 
VALUES (200000022,2,'������','����2','Quantity2','FPrepScrapQty','FPrepScrapQty','t_BosPlasticPoInStockEntry','',24,0,12,0,1,0,2,'FUnitId',0,0,'','','','','','',1,'','',106,9,28,13,'','','',1,'','QTY',0,0,350,0,'1,13',14,-1,1,28,10,0,'',17,'',0,'','',0,2,0,0,0,0,0,'',0) 
GO

INSERT INTO ICClassTableInfo(FClassTypeID,FPage,FCaption_CHS,FCaption_CHT,FCaption_EN,FKey,FFieldName,FTableName,FTableNameAs,FListIndex,FListClassName,FVisible,FEnable,FNeedSave,FMustInput,FCtlType,FProperty,FLookUpType,FLookUpClassID,FLookUpList,FSRCFieldName,FSRCTableName,FSRCTableNameAs,FDSPFieldName,FFNDFieldName,FValueLocation,FFilter,FFilterGroup,FValueType,FDspColType,FEditlen,FValuePrecision,FSaveRule,FDefValue,FAction,FUserDefine,FNote,FKeyWord,FLeft,FTop,FHeight,FWidth,FCondition,FTabIndex,FLock,FSum,FPrec,FScale,FLayer,FLoadAction,FUnControl,FFont,FSourceType,FSubKey,FParentKey,FConditionExt,FFrameBorder,FFrameBorderColor,FLabelWidth,FLabelColor,FTextColor,FIsF7,FContainer,FStyle) 
VALUES (200000022,2,'��ע','�ı�','Text','FRemark','FRemark','t_BosPlasticPoInStockEntry','',34,0,-1,0,1,0,1,'',0,0,'','','','','FName','',1,'','',167,500,50,50,'','','',1,'','',0,0,350,2500,'0,13',14,0,0,0,0,0,'',19,'',0,'','',0,2,0,0,0,0,0,'',0) 
GO

INSERT INTO ICClassTableInfo(FClassTypeID,FPage,FCaption_CHS,FCaption_CHT,FCaption_EN,FKey,FFieldName,FTableName,FTableNameAs,FListIndex,FListClassName,FVisible,FEnable,FNeedSave,FMustInput,FCtlType,FProperty,FLookUpType,FLookUpClassID,FLookUpList,FSRCFieldName,FSRCTableName,FSRCTableNameAs,FDSPFieldName,FFNDFieldName,FValueLocation,FFilter,FFilterGroup,FValueType,FDspColType,FEditlen,FValuePrecision,FSaveRule,FDefValue,FAction,FUserDefine,FNote,FKeyWord,FLeft,FTop,FHeight,FWidth,FCondition,FTabIndex,FLock,FSum,FPrec,FScale,FLayer,FLoadAction,FUnControl,FFont,FSourceType,FSubKey,FParentKey,FConditionExt,FFrameBorder,FFrameBorderColor,FLabelWidth,FLabelColor,FTextColor,FIsF7,FContainer,FStyle) 
VALUES (200000022,2,'Դ�����','Դ�ξ�̖','Source Doc NO.','FBillNo_SRC','FBillNo_SRC','t_BosPlasticPoInStockEntry','',13,0,-1,0,1,0,1,'FID_SRC',12,0,'','','','','','',1,'','',167,500,50,50,'','','',1,'','SRCBILLNO',0,0,350,2500,'-1',15,-1,0,0,0,0,'',33,'',0,'','',0,0,0,0,0,0,0,'',0) 
GO

INSERT INTO ICClassTableInfo(FClassTypeID,FPage,FCaption_CHS,FCaption_CHT,FCaption_EN,FKey,FFieldName,FTableName,FTableNameAs,FListIndex,FListClassName,FVisible,FEnable,FNeedSave,FMustInput,FCtlType,FProperty,FLookUpType,FLookUpClassID,FLookUpList,FSRCFieldName,FSRCTableName,FSRCTableNameAs,FDSPFieldName,FFNDFieldName,FValueLocation,FFilter,FFilterGroup,FValueType,FDspColType,FEditlen,FValuePrecision,FSaveRule,FDefValue,FAction,FUserDefine,FNote,FKeyWord,FLeft,FTop,FHeight,FWidth,FCondition,FTabIndex,FLock,FSum,FPrec,FScale,FLayer,FLoadAction,FUnControl,FFont,FSourceType,FSubKey,FParentKey,FConditionExt,FFrameBorder,FFrameBorderColor,FLabelWidth,FLabelColor,FTextColor,FIsF7,FContainer,FStyle) 
VALUES (200000022,2,'Դ������','Դ�����','Source Doc Type','FClassID_SRC','FClassID_SRC','t_BosPlasticPoInStockEntry','',16,0,-1,0,1,0,8,'FID_SRC',11,1,'','FID','ICClassType','ICClassType1','FName','FName',1,'','',56,500,255,255,'','','',1,'','SRCCLASSTYPE',0,0,350,2500,'-1',16,-1,0,0,0,0,'',33,'',0,'','',0,0,0,0,0,0,0,'',0) 
GO

INSERT INTO ICClassTableInfo(FClassTypeID,FPage,FCaption_CHS,FCaption_CHT,FCaption_EN,FKey,FFieldName,FTableName,FTableNameAs,FListIndex,FListClassName,FVisible,FEnable,FNeedSave,FMustInput,FCtlType,FProperty,FLookUpType,FLookUpClassID,FLookUpList,FSRCFieldName,FSRCTableName,FSRCTableNameAs,FDSPFieldName,FFNDFieldName,FValueLocation,FFilter,FFilterGroup,FValueType,FDspColType,FEditlen,FValuePrecision,FSaveRule,FDefValue,FAction,FUserDefine,FNote,FKeyWord,FLeft,FTop,FHeight,FWidth,FCondition,FTabIndex,FLock,FSum,FPrec,FScale,FLayer,FLoadAction,FUnControl,FFont,FSourceType,FSubKey,FParentKey,FConditionExt,FFrameBorder,FFrameBorderColor,FLabelWidth,FLabelColor,FTextColor,FIsF7,FContainer,FStyle) 
VALUES (200000022,2,'��Ӧ��','������','Vendor','FSupplyID','FSupplyID','t_BosPlasticPoInStockEntry','',33,0,-1,0,1,0,1,'',1,8,'','FItemID','t_Supplier','','FName','FNumber',1,'','',56,500,255,4,'','','',1,'','',5158,7738,346,2500,'0',17,0,0,0,10,0,'',17,'',1,'','',0,2,0,0,0,0,0,'',0) 
GO

INSERT INTO ICClassTableInfo(FClassTypeID,FPage,FCaption_CHS,FCaption_CHT,FCaption_EN,FKey,FFieldName,FTableName,FTableNameAs,FListIndex,FListClassName,FVisible,FEnable,FNeedSave,FMustInput,FCtlType,FProperty,FLookUpType,FLookUpClassID,FLookUpList,FSRCFieldName,FSRCTableName,FSRCTableNameAs,FDSPFieldName,FFNDFieldName,FValueLocation,FFilter,FFilterGroup,FValueType,FDspColType,FEditlen,FValuePrecision,FSaveRule,FDefValue,FAction,FUserDefine,FNote,FKeyWord,FLeft,FTop,FHeight,FWidth,FCondition,FTabIndex,FLock,FSum,FPrec,FScale,FLayer,FLoadAction,FUnControl,FFont,FSourceType,FSubKey,FParentKey,FConditionExt,FFrameBorder,FFrameBorderColor,FLabelWidth,FLabelColor,FTextColor,FIsF7,FContainer,FStyle) 
VALUES (200000022,2,'�Ƿ񵹳�','���A�Y�ό���3','Master Data Property3','FBaseProperty3','FItemId','t_BosPlasticPoInStockEntry','',9,0,-1,0,0,0,1,'',0,4,'','FItemID','t_ICItem','','F_115','',3,'','',167,500,255,0,'','','',1,'','',0,0,0,0,'0',18,-1,0,0,0,0,'',55,'',2,'','',0,2,0,0,0,0,0,'',0) 
GO

INSERT INTO ICClassTableInfo(FClassTypeID,FPage,FCaption_CHS,FCaption_CHT,FCaption_EN,FKey,FFieldName,FTableName,FTableNameAs,FListIndex,FListClassName,FVisible,FEnable,FNeedSave,FMustInput,FCtlType,FProperty,FLookUpType,FLookUpClassID,FLookUpList,FSRCFieldName,FSRCTableName,FSRCTableNameAs,FDSPFieldName,FFNDFieldName,FValueLocation,FFilter,FFilterGroup,FValueType,FDspColType,FEditlen,FValuePrecision,FSaveRule,FDefValue,FAction,FUserDefine,FNote,FKeyWord,FLeft,FTop,FHeight,FWidth,FCondition,FTabIndex,FLock,FSum,FPrec,FScale,FLayer,FLoadAction,FUnControl,FFont,FSourceType,FSubKey,FParentKey,FConditionExt,FFrameBorder,FFrameBorderColor,FLabelWidth,FLabelColor,FTextColor,FIsF7,FContainer,FStyle) 
VALUES (200000022,2,'��������','���A�Y�ό���4','Master Data Property4','FBaseProperty4','FItemId','t_BosPlasticPoInStockEntry','',9,0,-1,0,0,0,1,'',0,4,'','FItemID','t_ICItem','','FErpClsID','',3,'','',167,500,255,0,'','','',1,'','',0,0,0,2500,'0',19,-1,0,0,0,0,'',55,'',2,'','',0,2,0,0,0,0,0,'',0) 
GO

INSERT INTO ICClassTableInfo(FClassTypeID,FPage,FCaption_CHS,FCaption_CHT,FCaption_EN,FKey,FFieldName,FTableName,FTableNameAs,FListIndex,FListClassName,FVisible,FEnable,FNeedSave,FMustInput,FCtlType,FProperty,FLookUpType,FLookUpClassID,FLookUpList,FSRCFieldName,FSRCTableName,FSRCTableNameAs,FDSPFieldName,FFNDFieldName,FValueLocation,FFilter,FFilterGroup,FValueType,FDspColType,FEditlen,FValuePrecision,FSaveRule,FDefValue,FAction,FUserDefine,FNote,FKeyWord,FLeft,FTop,FHeight,FWidth,FCondition,FTabIndex,FLock,FSum,FPrec,FScale,FLayer,FLoadAction,FUnControl,FFont,FSourceType,FSubKey,FParentKey,FConditionExt,FFrameBorder,FFrameBorderColor,FLabelWidth,FLabelColor,FTextColor,FIsF7,FContainer,FStyle) 
VALUES (200000022,2,'�ֹ�Ա','���A�Y�ό���5','Master Data Property5','FBaseProperty5','FItemId','t_BosPlasticPoInStockEntry','',9,0,-1,0,0,0,1,'',0,4,'','FItemID','t_ICItem','','F_106','',3,'','',167,500,255,0,'','','',1,'','',0,0,0,2500,'0',20,-1,0,0,0,0,'',55,'',2,'','',0,2,0,0,0,0,0,'',0) 
GO

INSERT INTO ICClassTableInfo(FClassTypeID,FPage,FCaption_CHS,FCaption_CHT,FCaption_EN,FKey,FFieldName,FTableName,FTableNameAs,FListIndex,FListClassName,FVisible,FEnable,FNeedSave,FMustInput,FCtlType,FProperty,FLookUpType,FLookUpClassID,FLookUpList,FSRCFieldName,FSRCTableName,FSRCTableNameAs,FDSPFieldName,FFNDFieldName,FValueLocation,FFilter,FFilterGroup,FValueType,FDspColType,FEditlen,FValuePrecision,FSaveRule,FDefValue,FAction,FUserDefine,FNote,FKeyWord,FLeft,FTop,FHeight,FWidth,FCondition,FTabIndex,FLock,FSum,FPrec,FScale,FLayer,FLoadAction,FUnControl,FFont,FSourceType,FSubKey,FParentKey,FConditionExt,FFrameBorder,FFrameBorderColor,FLabelWidth,FLabelColor,FTextColor,FIsF7,FContainer,FStyle) 
VALUES (200000022,2,'��ҵ��ر�','���A�Y��','Master Data','FMrpClosed','FMrpClosed','t_BosPlasticPoInStockEntry','',10,0,-1,0,1,0,1,'',2,10003,'','FInterID','t_SubMessage','','FName','FID',1,'','',56,500,255,4,'','','',1,'','',5158,7738,346,2500,'0',21,-1,0,0,10,0,'',17,'',1,'','',0,2,0,0,0,0,0,'',0) 
GO

INSERT INTO ICClassTableInfo(FClassTypeID,FPage,FCaption_CHS,FCaption_CHT,FCaption_EN,FKey,FFieldName,FTableName,FTableNameAs,FListIndex,FListClassName,FVisible,FEnable,FNeedSave,FMustInput,FCtlType,FProperty,FLookUpType,FLookUpClassID,FLookUpList,FSRCFieldName,FSRCTableName,FSRCTableNameAs,FDSPFieldName,FFNDFieldName,FValueLocation,FFilter,FFilterGroup,FValueType,FDspColType,FEditlen,FValuePrecision,FSaveRule,FDefValue,FAction,FUserDefine,FNote,FKeyWord,FLeft,FTop,FHeight,FWidth,FCondition,FTabIndex,FLock,FSum,FPrec,FScale,FLayer,FLoadAction,FUnControl,FFont,FSourceType,FSubKey,FParentKey,FConditionExt,FFrameBorder,FFrameBorderColor,FLabelWidth,FLabelColor,FTextColor,FIsF7,FContainer,FStyle) 
VALUES (200000022,2,'ԭ����','���A�Y��2','Master Data2','folditemid','folditemid','t_BosPlasticPoInStockEntry','',10,0,-1,0,1,0,1,'',1,4,'','FItemID','t_ICItem','t_ICItem2','FName','FNumber',1,'','',56,500,255,4,'','','',1,'','',5158,7738,346,0,'0',22,-1,0,0,10,0,'',17,'',1,'','',0,2,0,0,0,0,0,'',0) 
GO

INSERT INTO ICClassTableInfo(FClassTypeID,FPage,FCaption_CHS,FCaption_CHT,FCaption_EN,FKey,FFieldName,FTableName,FTableNameAs,FListIndex,FListClassName,FVisible,FEnable,FNeedSave,FMustInput,FCtlType,FProperty,FLookUpType,FLookUpClassID,FLookUpList,FSRCFieldName,FSRCTableName,FSRCTableNameAs,FDSPFieldName,FFNDFieldName,FValueLocation,FFilter,FFilterGroup,FValueType,FDspColType,FEditlen,FValuePrecision,FSaveRule,FDefValue,FAction,FUserDefine,FNote,FKeyWord,FLeft,FTop,FHeight,FWidth,FCondition,FTabIndex,FLock,FSum,FPrec,FScale,FLayer,FLoadAction,FUnControl,FFont,FSourceType,FSubKey,FParentKey,FConditionExt,FFrameBorder,FFrameBorderColor,FLabelWidth,FLabelColor,FTextColor,FIsF7,FContainer,FStyle) 
VALUES (200000022,2,'������','С��8','Decimal Fraction8','FCommitQty','FCommitQty','t_BosPlasticPoInStockEntry','',10,0,-1,0,1,0,2,'',0,0,'','','','','','',1,'','',106,9,20,13,'','','',1,'','',0,0,350,2500,'1,13',23,-1,1,28,2,0,'',17,'',0,'','',0,2,0,0,0,0,0,'',0) 
GO

INSERT INTO ICClassTableInfo(FClassTypeID,FPage,FCaption_CHS,FCaption_CHT,FCaption_EN,FKey,FFieldName,FTableName,FTableNameAs,FListIndex,FListClassName,FVisible,FEnable,FNeedSave,FMustInput,FCtlType,FProperty,FLookUpType,FLookUpClassID,FLookUpList,FSRCFieldName,FSRCTableName,FSRCTableNameAs,FDSPFieldName,FFNDFieldName,FValueLocation,FFilter,FFilterGroup,FValueType,FDspColType,FEditlen,FValuePrecision,FSaveRule,FDefValue,FAction,FUserDefine,FNote,FKeyWord,FLeft,FTop,FHeight,FWidth,FCondition,FTabIndex,FLock,FSum,FPrec,FScale,FLayer,FLoadAction,FUnControl,FFont,FSourceType,FSubKey,FParentKey,FConditionExt,FFrameBorder,FFrameBorderColor,FLabelWidth,FLabelColor,FTextColor,FIsF7,FContainer,FStyle) 
VALUES (200000022,2,'δ����','С��7','Decimal Fraction7','FNoOutStockQty','FNoOutStockQty','t_BosPlasticPoInStockEntry','',10,0,-1,0,1,0,2,'',0,0,'','','','','','',1,'','',106,9,20,13,'','','',1,'','',0,0,350,2500,'1,13',24,-1,1,28,2,0,'',17,'',0,'','',0,2,0,0,0,0,0,'',0) 
GO

INSERT INTO ICClassTableInfo(FClassTypeID,FPage,FCaption_CHS,FCaption_CHT,FCaption_EN,FKey,FFieldName,FTableName,FTableNameAs,FListIndex,FListClassName,FVisible,FEnable,FNeedSave,FMustInput,FCtlType,FProperty,FLookUpType,FLookUpClassID,FLookUpList,FSRCFieldName,FSRCTableName,FSRCTableNameAs,FDSPFieldName,FFNDFieldName,FValueLocation,FFilter,FFilterGroup,FValueType,FDspColType,FEditlen,FValuePrecision,FSaveRule,FDefValue,FAction,FUserDefine,FNote,FKeyWord,FLeft,FTop,FHeight,FWidth,FCondition,FTabIndex,FLock,FSum,FPrec,FScale,FLayer,FLoadAction,FUnControl,FFont,FSourceType,FSubKey,FParentKey,FConditionExt,FFrameBorder,FFrameBorderColor,FLabelWidth,FLabelColor,FTextColor,FIsF7,FContainer,FStyle) 
VALUES (200000022,2,'����������','����6','Quantity6','FCGStockQty','FCGStockQty','t_BosPlasticPoInStockEntry','',35,0,12,0,1,0,2,'FUnitId',0,0,'','','','','','',1,'','',106,2,28,13,'','','',1,'','QTY',0,0,350,0,'1,13',25,-1,1,28,10,0,'',17,'',0,'','',0,2,0,0,0,0,0,'',0) 
GO

INSERT INTO ICClassTableInfo(FClassTypeID,FPage,FCaption_CHS,FCaption_CHT,FCaption_EN,FKey,FFieldName,FTableName,FTableNameAs,FListIndex,FListClassName,FVisible,FEnable,FNeedSave,FMustInput,FCtlType,FProperty,FLookUpType,FLookUpClassID,FLookUpList,FSRCFieldName,FSRCTableName,FSRCTableNameAs,FDSPFieldName,FFNDFieldName,FValueLocation,FFilter,FFilterGroup,FValueType,FDspColType,FEditlen,FValuePrecision,FSaveRule,FDefValue,FAction,FUserDefine,FNote,FKeyWord,FLeft,FTop,FHeight,FWidth,FCondition,FTabIndex,FLock,FSum,FPrec,FScale,FLayer,FLoadAction,FUnControl,FFont,FSourceType,FSubKey,FParentKey,FConditionExt,FFrameBorder,FFrameBorderColor,FLabelWidth,FLabelColor,FTextColor,FIsF7,FContainer,FStyle) 
VALUES (200000022,2,'��Ʒ�̴���','�ı�4','Text4','FProShortNumber','FProShortNumber','t_BosPlasticPoInStockEntry','',10,0,-1,0,1,0,1,'',0,0,'','','','','FName','',1,'','',167,500,50,50,'','','',1,'','',0,0,350,2500,'0,13',25,-1,0,0,0,0,'',19,'',0,'','',0,2,0,0,0,0,0,'',0) 
GO

INSERT INTO ICClassTableInfo(FClassTypeID,FPage,FCaption_CHS,FCaption_CHT,FCaption_EN,FKey,FFieldName,FTableName,FTableNameAs,FListIndex,FListClassName,FVisible,FEnable,FNeedSave,FMustInput,FCtlType,FProperty,FLookUpType,FLookUpClassID,FLookUpList,FSRCFieldName,FSRCTableName,FSRCTableNameAs,FDSPFieldName,FFNDFieldName,FValueLocation,FFilter,FFilterGroup,FValueType,FDspColType,FEditlen,FValuePrecision,FSaveRule,FDefValue,FAction,FUserDefine,FNote,FKeyWord,FLeft,FTop,FHeight,FWidth,FCondition,FTabIndex,FLock,FSum,FPrec,FScale,FLayer,FLoadAction,FUnControl,FFont,FSourceType,FSubKey,FParentKey,FConditionExt,FFrameBorder,FFrameBorderColor,FLabelWidth,FLabelColor,FTextColor,FIsF7,FContainer,FStyle) 
VALUES (200000022,2,'���϶̴���','�ı�5','Text5','FItemShortNumber','FItemShortNumber','t_BosPlasticPoInStockEntry','',10,0,-1,0,1,0,1,'',0,0,'','','','','FName','',1,'','',167,500,50,50,'','','',1,'','',0,0,350,2500,'0,13',26,-1,0,0,0,0,'',19,'',0,'','',0,2,0,0,0,0,0,'',0) 
GO

/****** Object:Data   ����ģ��ͨ�ÿؼ�������ICClassCtl    Script Date: 2013-11-26 ******/

Delete ICClassCtl WHERE FClassTypeID=200000022
GO
/****** Object:Data   ���ݱ�ţ�ICBillNo    Script Date: 2013-11-26 ******/

 IF NOT EXISTS (SELECT * FROM  ICBillNo WHERE FBillID=200000022) 
 BEGIN 
  INSERT INTO ICBillNo(FBillID,FBillName,FPreLetter,FSufLetter,FCurNo,FBillName_CHT,FBillName_EN,FFormat,FPos,FCanAlterBillNo,FCheckAfterSave,FUseBillCodeRule,FDesc) 
  VALUES (200000022,'�ܽ��Ӽ��������뵥_BOS','','',4718,'�Γ�200000022_BOS','Doc200000022_BOS','00000000',200000022,0,0,1,'BS+000002') 
end 

GO

/****** Object:Data   ���ݱ�ţ�t_BillCodeRule    Script Date: 2013-11-26 ******/

 IF NOT EXISTS (SELECT * FROM  t_BillCodeRule WHERE FBillTypeID=200000022) 
 BEGIN 
INSERT INTO t_BillCodeRule(FBillTypeID,FClassIndex,FProjectID,FProjectVal,FFormatIndex,FLength,FAddChar,FReChar,FBillType,FIsBy) 
VALUES ('200000022',1,1,'BS',0,2,'','','',0) 

INSERT INTO t_BillCodeRule(FBillTypeID,FClassIndex,FProjectID,FProjectVal,FFormatIndex,FLength,FAddChar,FReChar,FBillType,FIsBy) 
VALUES ('200000022',2,3,'4718',0,6,'','','',0) 

 END 

/****** Object:Data   ����Ȩ����Ū��t_ObjectAccessType    Script Date: 2013-11-26 ******/

Delete t_ObjectAccessType WHERE FObjectType=4100 And FObjectID =200000022
GO
INSERT INTO t_ObjectAccessType(FObjectType,FObjectID,FIndex,FAccessMask,FAccessUse,FName,FDescription,FName_cht,FName_en,FDescription_cht,FDescription_en) 
VALUES (4100,200000022,1,2097152,1048576,'�鿴','�鿴','�鿴','View','�鿴','View') 
GO

INSERT INTO t_ObjectAccessType(FObjectType,FObjectID,FIndex,FAccessMask,FAccessUse,FName,FDescription,FName_cht,FName_en,FDescription_cht,FDescription_en) 
VALUES (4100,200000022,2,1024,0,'�鿴ƾ֤','�鿴ƾ֤','�鿴ƾ֤','�鿴ƾ֤','�鿴ƾ֤','�鿴ƾ֤') 
GO

INSERT INTO t_ObjectAccessType(FObjectType,FObjectID,FIndex,FAccessMask,FAccessUse,FName,FDescription,FName_cht,FName_en,FDescription_cht,FDescription_en) 
VALUES (4100,200000022,3,131072,3145728,'����','����','����','New','����','New') 
GO

INSERT INTO t_ObjectAccessType(FObjectType,FObjectID,FIndex,FAccessMask,FAccessUse,FName,FDescription,FName_cht,FName_en,FDescription_cht,FDescription_en) 
VALUES (4100,200000022,4,65536,3145728,'ɾ��','ɾ��','�h��','Delete','�h��','Delete') 
GO

INSERT INTO t_ObjectAccessType(FObjectType,FObjectID,FIndex,FAccessMask,FAccessUse,FName,FDescription,FName_cht,FName_en,FDescription_cht,FDescription_en) 
VALUES (4100,200000022,5,4194304,3145728,'�޸�','�޸�','�޸�','Edit','�޸�','Edit') 
GO

INSERT INTO t_ObjectAccessType(FObjectType,FObjectID,FIndex,FAccessMask,FAccessUse,FName,FDescription,FName_cht,FName_en,FDescription_cht,FDescription_en) 
VALUES (4100,200000022,6,16,3145728,'�����ڲ�����','�����ڲ�����','�����Ȳ��Y��','Export','�����Ȳ��Y��','Export') 
GO

INSERT INTO t_ObjectAccessType(FObjectType,FObjectID,FIndex,FAccessMask,FAccessUse,FName,FDescription,FName_cht,FName_en,FDescription_cht,FDescription_en) 
VALUES (4100,200000022,7,32768,3145728,'��ӡ','��ӡ','��ӡ','Print','��ӡ','Print') 
GO

INSERT INTO t_ObjectAccessType(FObjectType,FObjectID,FIndex,FAccessMask,FAccessUse,FName,FDescription,FName_cht,FName_en,FDescription_cht,FDescription_en) 
VALUES (4100,200000022,8,128,0,'��������ƾ֤','��������ƾ֤','��������ƾ֤','��������ƾ֤','��������ƾ֤','��������ƾ֤') 
GO

INSERT INTO t_ObjectAccessType(FObjectType,FObjectID,FIndex,FAccessMask,FAccessUse,FName,FDescription,FName_cht,FName_en,FDescription_cht,FDescription_en) 
VALUES (4100,200000022,9,512,0,'�ϲ�����ƾ֤','�ϲ�����ƾ֤','�ϲ�����ƾ֤','�ϲ�����ƾ֤','�ϲ�����ƾ֤','�ϲ�����ƾ֤') 
GO

/****** Object:Data   ����Ȩ�޶����t_ObjectType    Script Date: 2013-11-26 ******/

Delete t_ObjectType WHERE FObjectType=4100 And FObjectID =200000022
GO
INSERT INTO t_ObjectType(FObjectType,FObjectID,FName,FDescription,FName_cht,FName_en,FDescription_cht,FDescription_en) 
VALUES (4100,200000022,'�ܽ��Ӽ��������뵥','','�Γ�200000022','Doc200000022',NULL,NULL) 
GO

/****** Object:Data   ����Ȩ�ޱ�t_ObjectAccess    Script Date: 2013-11-26 ******/

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

/****** Object:Data   ѡ��������ICClassLink    Script Date: 2013-11-26 ******/

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

/****** Object:Data   ѡ��������ϸ��ICClassLinkEntry    Script Date: 2013-11-26 ******/

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

/****** Object:Data   ѡ��������ϸ��ICClassLinkCommit    Script Date: 2013-11-26 ******/

 DELETE ICClassLinkCommit WHERE FDstClsTypID = 200000022 OR FSrcClsTypID =  200000022
GO
INSERT INTO ICClassLinkCommit(FSrcClsTypID,FDstClsTypID,FControl,FCheckKey,FCommitKey,FFlagKey,FIsUsrDef,FIsLimit,FControlFormula,FFlagFormula,FSourTypeID,FDestTypeID) 
VALUES (200000022,-29,1,'FNoOutStockQty','FCommitQty','',0,0,'','',0,0) 
GO

INSERT INTO ICClassLinkCommit(FSrcClsTypID,FDstClsTypID,FControl,FCheckKey,FCommitKey,FFlagKey,FIsUsrDef,FIsLimit,FControlFormula,FFlagFormula,FSourTypeID,FDestTypeID) 
VALUES (200000022,-24,1,'FQty','FCommitQty','',0,0,'','',0,0) 
GO

/****** Object:Data   ѡ�����̻�����Ϣ��ICClassWorkFlow    Script Date: 2013-11-26 ******/


GO
DECLARE @MaxID AS INT

SELECT @MaxID = ISNUll(Max(FID),10000) FROM ICClassWorkFlow

INSERT INTO ICClassWorkFlow(FID,FName_CHS,FName_CHT,FName_EN,FSubSysID) 
VALUES ( @MaxID + 1,'�ƻ�Ͷ�ϵ�','�Γ�����33','Document Process33',23) 


UPDATE ICMaxNum SET FMaxNum = @MaxID + 2 WHERE FTableName = 'ICClassWorkFlow'
GO


/****** Object:Data   ѡ�����̹������ݣ�ICClassWorkFlowBill    Script Date: 2013-11-26 ******/

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
/****** Object:Data   ѡ�����̹�����ϵ��ICClassWorkFlowJoin    Script Date: 2013-11-26 ******/

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
/****** Object:Data   �������ģ�����ݣ�ICClassMutex    Script Date: 2013-11-26 ******/

Delete ICClassMutex WHERE FClassTypeID=200000022
GO
/****** Object:Data   ��ӡ����ģ�����ݣ�ICPrintMaxCount    Script Date: 2013-11-26 ******/

Delete ICPrintMaxCount WHERE FID =200000022
GO
INSERT INTO ICPrintMaxCount(FPos,FID,FName,FName_CHT,FName_EN,FPrintControlOrNo,FPrintMaxCount) 
VALUES (200000022,200000022,'�ܽ��Ӽ��������뵥_BOS','�Γ�200000022_BOS','Doc200000022_BOS',0,0) 
GO

/****** Object:Data   �༶�������ģ�����ݣ�ICClassMCFlowInfo    Script Date: 2013-11-26 ******/

DELETE ICClassMCFlowInfo WHERE FID = 200000022
GO
INSERT INTO ICClassMCFlowInfo(FID,FIsRun,FMaxLevel,FChkLevel,FChkModel,FCanModify,FCheckerField,FCheckDateField,FInputIdea,FShowTip,FCanCheckAfterEnd,FIsMobileServiceRun,FIsSelectMsgUser,FIsNoCheckSelf,FMobileInfoCanReply) 
VALUES (200000022,1,1,1,0,0,'FChecker','FCheckDate',1,1,0,0,0,0,0) 
GO

 EXEC  p_CreateMCDetailTable @ClassTypeID = 200000022
/****** Object:Data   �༶��˵Ĺ��������񣨸���˼��Σ�ģ�����ݣ�ICClassMCTasks    Script Date: 2013-11-26 ******/

DELETE ICClassMCTasks WHERE FID = 200000022
GO
INSERT INTO ICClassMCTasks(FID,FTask,FTag,FX,FY) 
VALUES (200000022,'BillMCBegin','���󵥾�',770,930) 
GO

INSERT INTO ICClassMCTasks(FID,FTask,FTag,FX,FY) 
VALUES (200000022,'BillMCEnd','��˽���',13470,6800) 
GO

INSERT INTO ICClassMCTasks(FID,FTask,FTag,FX,FY) 
VALUES (200000022,'MC1','һ�����',770,6800) 
GO

/****** Object:Data   �༶��˵�������ת�͹���ģ�����ݣ�ICClassMCRule    Script Date: 2013-11-26 ******/

DELETE ICClassMCRule WHERE FID = 200000022
GO
/****** Object:Data   ���ݲ�����ϸģ�����ݣ�ICClassBillAction    Script Date: 2013-11-26 ******/

DELETE ICClassBillAction WHERE FClassTypeID = 200000022
GO
DECLARE @MaxID AS INT

SELECT @MaxID = ISNUll(Max(FID),10000) FROM ICClassBillAction

INSERT INTO ICClassBillAction(FID,FClassTypeID,FCode,FName_CHS,FName_CHT,FName_EN,FDescriptions_CHS,FDescriptions_CHT,FDescriptions_EN,FEnvironment,FRightMask,FRightUseMask,FRightGroupMask,FRightControl,FAddLog,FIsPredefine,FIsFirst,FShortCut,FListActionCirculation) 
VALUES ( @MaxID + 1,200000022,'mnuBOSViewVoucher','�鿴ƾ֤','�鿴ƾ֤','�鿴ƾ֤','�鿴ƾ֤','�鿴ƾ֤','�鿴ƾ֤',0,1024,0,7,1,0,1,0,0,1) 

INSERT INTO ICClassBillAction(FID,FClassTypeID,FCode,FName_CHS,FName_CHT,FName_EN,FDescriptions_CHS,FDescriptions_CHT,FDescriptions_EN,FEnvironment,FRightMask,FRightUseMask,FRightGroupMask,FRightControl,FAddLog,FIsPredefine,FIsFirst,FShortCut,FListActionCirculation) 
VALUES ( @MaxID + 2,200000022,'mnuEditCopy','����','�}�u','Copy','����','�}�u','Copy',39,131072,0,7,1,0,1,0,0,1) 

INSERT INTO ICClassBillAction(FID,FClassTypeID,FCode,FName_CHS,FName_CHT,FName_EN,FDescriptions_CHS,FDescriptions_CHT,FDescriptions_EN,FEnvironment,FRightMask,FRightUseMask,FRightGroupMask,FRightControl,FAddLog,FIsPredefine,FIsFirst,FShortCut,FListActionCirculation) 
VALUES ( @MaxID + 3,200000022,'mnuEditCopyDoc','��������','�����}�u','Copy Document','��������','�����}�u','Copy Document',64,131072,0,7,1,0,1,0,0,1) 

INSERT INTO ICClassBillAction(FID,FClassTypeID,FCode,FName_CHS,FName_CHT,FName_EN,FDescriptions_CHS,FDescriptions_CHT,FDescriptions_EN,FEnvironment,FRightMask,FRightUseMask,FRightGroupMask,FRightControl,FAddLog,FIsPredefine,FIsFirst,FShortCut,FListActionCirculation) 
VALUES ( @MaxID + 4,200000022,'mnuEditCopyEntry','����¼�ϲ�����','����䛺ρ��}�u','Consolidate Selected Invoices & Copy','����¼�ϲ�����','����䛺ρ��}�u','Consolidate Selected Invoices & Copy',64,131072,0,7,1,0,1,0,0,1) 

INSERT INTO ICClassBillAction(FID,FClassTypeID,FCode,FName_CHS,FName_CHT,FName_EN,FDescriptions_CHS,FDescriptions_CHT,FDescriptions_EN,FEnvironment,FRightMask,FRightUseMask,FRightGroupMask,FRightControl,FAddLog,FIsPredefine,FIsFirst,FShortCut,FListActionCirculation) 
VALUES ( @MaxID + 5,200000022,'mnuEditDelete','ɾ��','�h��','Del.','ɾ��','�h��','Del.',64,65536,0,7,1,1,1,0,0,1) 

INSERT INTO ICClassBillAction(FID,FClassTypeID,FCode,FName_CHS,FName_CHT,FName_EN,FDescriptions_CHS,FDescriptions_CHT,FDescriptions_EN,FEnvironment,FRightMask,FRightUseMask,FRightGroupMask,FRightControl,FAddLog,FIsPredefine,FIsFirst,FShortCut,FListActionCirculation) 
VALUES ( @MaxID + 6,200000022,'mnuEditModify','�޸�','�޸�','Edit','�޸�','�޸�','Edit',4160,4194304,0,7,1,0,1,0,0,1) 

INSERT INTO ICClassBillAction(FID,FClassTypeID,FCode,FName_CHS,FName_CHT,FName_EN,FDescriptions_CHS,FDescriptions_CHT,FDescriptions_EN,FEnvironment,FRightMask,FRightUseMask,FRightGroupMask,FRightControl,FAddLog,FIsPredefine,FIsFirst,FShortCut,FListActionCirculation) 
VALUES ( @MaxID + 7,200000022,'mnuExportData','�����ڲ�����','�����Ȳ��Y��','Export','�����ڲ�����','�����Ȳ��Y��','Export',5056,16,0,7,1,0,1,0,0,1) 

INSERT INTO ICClassBillAction(FID,FClassTypeID,FCode,FName_CHS,FName_CHT,FName_EN,FDescriptions_CHS,FDescriptions_CHT,FDescriptions_EN,FEnvironment,FRightMask,FRightUseMask,FRightGroupMask,FRightControl,FAddLog,FIsPredefine,FIsFirst,FShortCut,FListActionCirculation) 
VALUES ( @MaxID + 8,200000022,'mnuFileNew','����','����','New','����','����','New',103,131072,0,7,1,0,1,0,0,1) 

INSERT INTO ICClassBillAction(FID,FClassTypeID,FCode,FName_CHS,FName_CHT,FName_EN,FDescriptions_CHS,FDescriptions_CHT,FDescriptions_EN,FEnvironment,FRightMask,FRightUseMask,FRightGroupMask,FRightControl,FAddLog,FIsPredefine,FIsFirst,FShortCut,FListActionCirculation) 
VALUES ( @MaxID + 9,200000022,'mnuFilePrint','��ӡ','��ӡ','Print','��ӡ','��ӡ','Print',5095,32768,0,7,1,0,1,0,0,1) 

INSERT INTO ICClassBillAction(FID,FClassTypeID,FCode,FName_CHS,FName_CHT,FName_EN,FDescriptions_CHS,FDescriptions_CHT,FDescriptions_EN,FEnvironment,FRightMask,FRightUseMask,FRightGroupMask,FRightControl,FAddLog,FIsPredefine,FIsFirst,FShortCut,FListActionCirculation) 
VALUES ( @MaxID + 10,200000022,'mnuFileSave','����','����','Save','����','����','Save',6,0,0,7,0,1,1,0,0,1) 

INSERT INTO ICClassBillAction(FID,FClassTypeID,FCode,FName_CHS,FName_CHT,FName_EN,FDescriptions_CHS,FDescriptions_CHT,FDescriptions_EN,FEnvironment,FRightMask,FRightUseMask,FRightGroupMask,FRightControl,FAddLog,FIsPredefine,FIsFirst,FShortCut,FListActionCirculation) 
VALUES ( @MaxID + 11,200000022,'mnuFileView','�鿴','�鿴','View','�鿴','�鿴','View',960,2097152,0,7,1,0,1,0,0,1) 

INSERT INTO ICClassBillAction(FID,FClassTypeID,FCode,FName_CHS,FName_CHT,FName_EN,FDescriptions_CHS,FDescriptions_CHT,FDescriptions_EN,FEnvironment,FRightMask,FRightUseMask,FRightGroupMask,FRightControl,FAddLog,FIsPredefine,FIsFirst,FShortCut,FListActionCirculation) 
VALUES ( @MaxID + 12,200000022,'mnuMakeOneToOne','��������ƾ֤','��������ƾ֤','��������ƾ֤','��������ƾ֤','��������ƾ֤','��������ƾ֤',0,128,0,7,1,1,1,0,0,1) 

INSERT INTO ICClassBillAction(FID,FClassTypeID,FCode,FName_CHS,FName_CHT,FName_EN,FDescriptions_CHS,FDescriptions_CHT,FDescriptions_EN,FEnvironment,FRightMask,FRightUseMask,FRightGroupMask,FRightControl,FAddLog,FIsPredefine,FIsFirst,FShortCut,FListActionCirculation) 
VALUES ( @MaxID + 13,200000022,'mnuMultiToOne','�ϲ�����ƾ֤','�ϲ�����ƾ֤','�ϲ�����ƾ֤','�ϲ�����ƾ֤','�ϲ�����ƾ֤','�ϲ�����ƾ֤',0,512,0,7,1,1,1,0,0,1) 

INSERT INTO ICClassBillAction(FID,FClassTypeID,FCode,FName_CHS,FName_CHT,FName_EN,FDescriptions_CHS,FDescriptions_CHT,FDescriptions_EN,FEnvironment,FRightMask,FRightUseMask,FRightGroupMask,FRightControl,FAddLog,FIsPredefine,FIsFirst,FShortCut,FListActionCirculation) 
VALUES ( @MaxID + 14,200000022,'mnuStockQuery','����ѯ','����ԃ','Stock Query','����ѯ','����ԃ','Stock Query',0,0,0,7,0,1,1,0,0,1) 


UPDATE ICMaxNum SET FMaxNum = @MaxID + 15 WHERE FTableName = 'ICClassBillAction'
GO


/****** Object:Data   ���ݲ�����־ģ�����ݣ�t_LogFunction    Script Date: 2013-11-26 ******/

DELETE t_LogFunction WHERE FFunctionID LIKE 'BOS200000022%'
GO
INSERT INTO t_LogFunction(FFunctionID,FFunctionName,FSubSysID,FFunctionName_Cht,FFunctionName_EN) 
VALUES ('BOS200000022_mnuEditDelete','���۹���ϵͳ-ҵ�񵥾�-�ܽ��Ӽ��������뵥-ɾ��',23,'�N�۹���ϵ�y-�I�ՆΓ�-�Γ�200000022-�h��','Sales Management-Business document-Doc200000022-Del.') 
GO

INSERT INTO t_LogFunction(FFunctionID,FFunctionName,FSubSysID,FFunctionName_Cht,FFunctionName_EN) 
VALUES ('BOS200000022_mnuEditMultiCheck','���۹���ϵͳ-ҵ�񵥾�-�ƻ�Ͷ�ϵ�-�༶���',23,'�N�۹���ϵ�y-�I�ՆΓ�-�Γ�200000022-�༉����','Sales Management-Business document-Doc200000022-Multi-level Check') 
GO

INSERT INTO t_LogFunction(FFunctionID,FFunctionName,FSubSysID,FFunctionName_Cht,FFunctionName_EN) 
VALUES ('BOS200000022_mnuEditUnMultiCheck','���۹���ϵͳ-ҵ�񵥾�-�ƻ�Ͷ�ϵ�-�������',23,'�N�۹���ϵ�y-�I�ՆΓ�-�Γ�200000022-�g�،���','Sales Management-Business document-Doc200000022-Reject Check') 
GO

INSERT INTO t_LogFunction(FFunctionID,FFunctionName,FSubSysID,FFunctionName_Cht,FFunctionName_EN) 
VALUES ('BOS200000022_mnuFileSave','���۹���ϵͳ-ҵ�񵥾�-�ܽ��Ӽ��������뵥-����',23,'�N�۹���ϵ�y-�I�ՆΓ�-�Γ�200000022-����','Sales Management-Business document-Doc200000022-Save') 
GO

INSERT INTO t_LogFunction(FFunctionID,FFunctionName,FSubSysID,FFunctionName_Cht,FFunctionName_EN) 
VALUES ('BOS200000022_mnuMakeOneToOne','���۹���ϵͳ-ҵ�񵥾�-�ܽ��Ӽ��������뵥-��������ƾ֤',23,'�N�۹���ϵ�y-�I�ՆΓ�-�Γ�200000022-��������ƾ֤','Sales Management-Business document-Doc200000022-��������ƾ֤') 
GO

INSERT INTO t_LogFunction(FFunctionID,FFunctionName,FSubSysID,FFunctionName_Cht,FFunctionName_EN) 
VALUES ('BOS200000022_mnuMultiToOne','���۹���ϵͳ-ҵ�񵥾�-�ܽ��Ӽ��������뵥-�ϲ�����ƾ֤',23,'�N�۹���ϵ�y-�I�ՆΓ�-�Γ�200000022-�ϲ�����ƾ֤','Sales Management-Business document-Doc200000022-�ϲ�����ƾ֤') 
GO

INSERT INTO t_LogFunction(FFunctionID,FFunctionName,FSubSysID,FFunctionName_Cht,FFunctionName_EN) 
VALUES ('BOS200000022_mnuStockQuery','���۹���ϵͳ-ҵ�񵥾�-�ܽ��Ӽ��������뵥-����ѯ',23,'�N�۹���ϵ�y-�I�ՆΓ�-�Γ�200000022-����ԃ','Sales Management-Business document-Doc200000022-Stock Query') 
GO

/****** Object:Data   ���ݲ���λ��ģ�����ݣ�ICClassActionPosition    Script Date: 2013-11-26 ******/

DELETE ICClassActionPosition WHERE FClassTypeID = 200000022
GO
/****** Object:Data   ������չ����ģ�����ݣ�ICClassActionList    Script Date: 2013-11-26 ******/

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



/**End  �µ���ģ�����ݽű������� �ܽ��Ӽ��������뵥    Script Date: 2013-11-26 **/
