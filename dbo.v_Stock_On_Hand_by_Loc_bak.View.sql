USE [is21olap]
GO
/****** Object:  View [dbo].[v_Stock_On_Hand_by_Loc_bak]    Script Date: 9/2/2021 2:50:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[v_Stock_On_Hand_by_Loc_bak] as
select trandate, location_id, item_id, qty, 
		sum(qty) over (partition by item_id, location_id order by item_id, location_id, trandate) as runttl
from (select trandate, h.location_id, item_id, sum(isnull(item_count,0)) qty
		from transactions h
		inner join transaction_lines d
		on h.TRANSACTION_ID =  d.TRANSACTION_ID
		where h.location_id is not null
		and d.item_id is not null
		group by trandate, h.location_id, item_id) a
GO
