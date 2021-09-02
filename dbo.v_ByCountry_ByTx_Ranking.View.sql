USE [is21olap]
GO
/****** Object:  View [dbo].[v_ByCountry_ByTx_Ranking]    Script Date: 9/2/2021 2:50:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE view [dbo].[v_ByCountry_ByTx_Ranking] as
select Yr, Mth, country, a.BI_Loc, location_id, CustPerTx, DENSE_RANK() OVER (Partition By Yr, Mth, country order by country, CustPerTx desc) Rank
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
