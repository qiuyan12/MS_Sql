--select*FROM ICBomGroup bomg -- where bomg.FName LIKE '%BOM005036%'

with f as 
(
select * from ICBomGroup boma  
union all
select  bomb.* from ICBomGroup bomb  inner join f as f on bomb.FInterID=f.FParentID
)
 
select f.* from f --where FNumber  like 'V%'