USE [is21olap]
GO
/****** Object:  View [dbo].[v_ByTx_Ranking]    Script Date: 9/2/2021 2:50:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE view [dbo].[v_ByTx_Ranking] as
select Yr, Mth, a.BI_Loc, location_id, CustPerTx, DENSE_RANK() OVER (Partition By Yr, Mth order by CustPerTx desc) Rank
from
(
select BI_Loc, year(trandate) Yr, month(trandate) Mth, count(distinct entity_id) CustCnt,
count(distinct tranid) txcnt, count(distinct entity_id) / count(distinct tranid) CustPerTx
from SalesInfo
where cust_name not like '%Walk-in%'
group by BI_Loc, year(trandate), month(trandate)
) a
inner join LocMapping
on a.BI_Loc = LocMapping.BI_Loc
GO
