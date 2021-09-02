USE [is21olap]
GO
/****** Object:  View [dbo].[Monthly_Traffic_Count]    Script Date: 9/2/2021 2:50:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[Monthly_Traffic_Count] as
select year(date_0) yr, month(date_0) mth, location_id, sum(visitor) visitor
from Traffic_Count
group by year(date_0), month(date_0), location_id
GO
