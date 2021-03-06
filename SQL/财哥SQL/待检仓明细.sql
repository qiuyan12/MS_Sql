
SET NOCOUNT ON
    DECLARE @CurYear     INT            --当前年份
    DECLARE @CurPeriod   INT            --起始的会计期间
    DECLARE @StartPeriod SMALLINT       --启用期间
    DECLARE @NowPeriod   SMALLINT       --当前期间
    DECLARE @StartTime   DATETIME       --期间开始日期
    DECLARE @EndTime     DATETIME       --期间结束日期
    DECLARE @DiffCount   DECIMAL(28, 0) --计算是否有差异数量
   
     --2.取出当前年份
    SELECT @CurPeriod=FValue FROM t_Systemprofile WHERE FKey='CurrentPeriod' And FCategory='IC'
    SELECT @CurYear=FValue FROM t_Systemprofile WHERE FKey='CurrentYear' And FCategory='IC'
   
    --3.取出当前期间的起始日期
    EXECUTE GetPeriodStartEnd 0, @CurPeriod, @StartTime OUTPUT, @EndTime OUTPUT
   
    --校对虚仓
    SELECT FItemID, FStockID, ISNULL(FBatchNo, 0) AS FBatchNo, ISNULL(FSPID, 0) AS FDCSPID,
           CASE WHEN FKFDate IS NULL THEN ''
                ELSE CONVERT(VARCHAR(10), FKFDate, 120) END AS FKFDate, ISNULL(FKFPeriod, '') AS FKFPeriod,
                SUM(FBegQty) AS FQty, SUM(FSecBegQty) AS FSecQty, 0 AS FTranType, CAST('' AS VARCHAR(30)) AS FBillNo,
                0 AS FEntryID, FAuxPropID
           INTO #PORTQty
           FROM POInvBal
          WHERE FPeriod = @CurPeriod AND FYear = @CurYear
       GROUP BY FItemID, FStockID, FBatchNo, FSPID, FKFDate, FKFPeriod, FAuxPropID
         HAVING (SUM(FBegQty) <> 0 OR SUM(FSecBegQty) <> 0)
    
    --采购收货
    INSERT INTO #PORTQty(FItemID, FStockID, FBatchNo, FDCSPID, FKFDate, FKFPeriod, FQty, FSecQty, FTranType, FBillNo,
                         FEntryID, FAuxPropID)
                  SELECT u1.FItemID, u1.FStockID, ISNULL(u1.FBatchNo, ''), ISNULL(u1.FDCSPID, 0),
                         CASE WHEN u1.FKFDate IS NULL THEN ''
                              ELSE CONVERT(VARCHAR(10), u1.FKFDate, 120) END AS FKFDate, ISNULL(u1.FKFPeriod, '') AS FKFPeriod,
                         SUM(u1.FQty), SUM(u1.FSecQty), v1.FTranType, v1.FBillNo, u1.FEntryID, u1.FAuxPropID
                    FROM POInStock v1, POInStockEntry u1, t_ICItem t1, t_Stock t2
                   WHERE v1.FDate >= @StartTime AND v1.Ftrantype = 72 AND v1.FInterID = u1.FInterID
                     AND u1.FItemID = t1.FItemID AND u1.FStockID = t2.FItemID
                     AND (v1.FCheckerID > 0 OR v1.FCheckerID < 0 OR v1.FUpStockWhenSave = 1)
                     AND v1.FCancelLation = 0 AND t2.FTypeID IN (503)
                GROUP BY u1.FItemID, u1.FStockID, u1.FBatchNo, u1.FDCSPID, u1.FKFDate, u1.FKFPeriod, v1.FTranType,
                         v1.FBillNo, u1.FEntryID, u1.FAuxPropID
    
    --外购入库收料通知
    INSERT INTO #PORTQty(FItemID,FStockID,FBatchNo,FDCSPID,FKFDate,FKFPeriod,FQty,FSecQty, FTranType ,FBillno ,FEntryID,FAuxPropID)
                  SELECT u1.FItemID,u3.FStockID,isnull(u3.FBatchNo,'') as FBatchNo,isnull(u3.FDCSPID,0) as FDCSPID,case when u3.FKFDate is null then '' else convert(VARCHAR (10),u3.FKFDate,120) End as FKFDate,ISNULL(u3.FKFPeriod,'') as FKFPeriod,sum(-u1.FQty), sum(-u1.FSecQty),V1.FTranType ,V1.FBillno ,U1.FEntryID,U1.FAuxPropID
                    FROM ICStockBill v1, ICStockBillEntry u1, POInStock u2, t_ICItem t1, t_Stock t2, POInStockEntry u3
                   WHERE v1.FDate >= @StartTime AND v1.FTranType = 1 AND v1.FInterID = u1.FInterID
                     AND u3.FInterID = u2.FInterID AND u1.FSourceInterID = u2.FInterID
                     AND u1.FSourceEntryID = u3.FEntryID AND u1.FSourceTranType = 72 AND u1.FItemID = t1.FItemID
                     AND t2.FTypeID = 503 AND u3.FStockID = t2.FItemID
                     AND (v1.FCheckerID > 0 OR v1.FCheckerID < 0 OR v1.FUpStockWhenSave = 1) AND v1.FCancelLation = 0
                GROUP BY u1.FItemID, u3.FStockID, u3.FBatchNo, u3.FDCSPID, u3.FKFDate, u3.FKFPeriod, v1.FTranType,
                         v1.FBillNo, u1.FEntryID, u1.FAuxPropID


    
    --采购退货
    INSERT INTO #PORTQty(FItemID,FStockID,FBatchNo,FDCSPID,FKFDate,FKFPeriod,FQty,FSecQty,FTranType ,FBillno ,FEntryID,FAuxPropID)
                  SELECT u1.FItemID,u1.FStockID,isnull(u1.FBatchNo,'') as FBatchNo,isnull(u1.FDCSPID,0) as FDCSPID,case when u1.FKFDate is null then '' else convert(VARCHAR (10),u1.FKFDate,120) End as FKFDate,ISNULL(u1.FKFPeriod,'') as FKFPeriod,sum(-u1.FQty),sum(-u1.FSecQty),
                         V1.FTranType ,V1.FBillno ,U1.FEntryID,U1.FAuxPropID
                    FROM POInStock v1,POInStockEntry u1,t_ICItem t1,t_Stock t2
                   WHERE v1.FDate >= @StartTime AND v1.Ftrantype = 73 AND v1.FInterID = u1.FInterID
                     AND u1.FItemID = t1.FItemID AND u1.FStockID = t2.FItemID AND t2.FTypeID IN (501, 503)
                     AND (v1.FCheckerID > 0 OR v1.FCheckerID < 0 OR v1.FUpStockWhenSave = 1) AND v1.FCancelLation = 0
                GROUP BY u1.FItemID, u1.FStockID, u1.FBatchNo, u1.FDCSPID, u1.FKFDate, u1.FKFPeriod, v1.FTranType,
                         v1.FBillNo, u1.FEntryID, u1.FAuxPropID
    
    --其他入库收料通知出库
    INSERT INTO #PORTQty(FItemID,FStockID,FBatchNo,FDCSPID,FKFDate,FKFPeriod,FQty,FSecQty,FTranType ,FBillno ,FEntryID,FAuxPropID)
                  SELECT u1.FItemID,u3.FStockID,isnull(u3.FBatchNo,'') as FBatchNo,isnull(u3.FDCSPID,0) as FDCSPID,case when u3.FKFDate is null then '' else convert(VARCHAR (10),u3.FKFDate,120) End as FKFDate,ISNULL(u3.FKFPeriod,'') as FKFPeriod,sum(-u1.FQty),sum(-u1.FSecQty),
                         V1.FTranType ,V1.FBillno ,U1.FEntryID,U1.FAuxPropID
                    FROM ICStockBill v1,ICStockBillEntry u1,POInStock u2,t_ICItem t1,t_Stock t2,POInStockEntry u3
                   WHERE v1.FDate >= @StartTime AND v1.FTranType = 10 AND u3.FInterID = u2.FInterID
                     AND v1.FInterID = u1.FInterID AND u1.FSourceInterID = u2.FInterID
                     AND u1.FSourceEntryID = u3.FEntryID AND u1.FSourceTranType = 72 AND u1.FItemID = t1.FItemID
                     AND t2.FTypeID = 503 AND u3.FStockID = t2.FItemID
                     AND (v1.FCheckerID > 0 OR v1.FCheckerID < 0 OR v1.FUpStockWhenSave = 1) AND v1.FCancelLation = 0
                GROUP BY u1.FItemID, u3.FStockID, u3.FBatchNo, u3.FDCSPID, u3.FKFDate, u3.FKFPeriod, v1.FTranType,
                         v1.FBillNo, u1.FEntryID, u1.FAuxPropID
    
    SELECT FItemID, FStockID, FBatchNo, FDCSPID, FKFDate, FKFPeriod, FAuxPropID, SUM(FQty) AS FQty,
           SUM(FSecQty) AS FSecQty
      INTO #PORTSum
      FROM #PORTQty
  GROUP BY FItemID, FStockID, FBatchNo, FDCSPID, FKFDate, FKFPeriod, FAuxPropID
    

                     SELECT '0', t1.FItemID, t1.FStockID, t1.FBatchNo, t1.FDCSPID, t1.FKFDate, t1.FKFPeriod, t1.FQty,
                            t1.FSecQty, 0, t2.FTypeID, t1.FAuxPropID
                       FROM #PORTSum t1, t_Stock t2
                      WHERE t1.FStockID = t2.FItemID and t2.fitemid=16482
    --select * from t_stock
    --删除临时表
    DROP TABLE #PORTQty
    DROP TABLE #PORTSum

