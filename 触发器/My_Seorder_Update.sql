set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go


ALTER trigger [My_Seorder_Update] on [dbo].[SEOrder]
for insert,update
as
set nocount on

declare @fstatus int,@finterid int
select @finterid=finterid from inserted

--FEntrySelfS0170 未排产数量= fqty 销售订单数量 -FEntrySelfS0169 已排产数量
update m2 set FEntrySelfS0170=m2.fqty-isnull(m2.FEntrySelfS0169,0),FEntrySelfS0168=m2.fqty-m2.fordercommitqty
from seorderentry m2 
inner join seorder m3 on m2.finterid=m3.finterid
where m3.finterid=@finterid


