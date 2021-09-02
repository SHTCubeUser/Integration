USE [is21olap]
GO
/****** Object:  View [dbo].[v_InventoryInfo]    Script Date: 9/2/2021 2:50:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[v_InventoryInfo] AS
select h.trandate, d.item_id, h.location_id, 0 yr_opening,
       sum(d.original_quantity*-1) as qty, sum(d.amount*-1) local_amount,
	   sum(round(d.amount*-1*r.exrate,0)) us_amount, sum(d.original_quantity*-1*wac) item_cost
from [Transactions] h (nolock)
inner join [Transaction_lines] d (nolock)
on h.transaction_id = d.transaction_id
inner join [Locations] l (nolock)
on h.location_id = l.location_id
inner join v_exchange_rate r (nolock)
on h.currency_id = r.currency_id
and h.trandate = r.effdate
inner join (
select item_id, avg(average_cost) wac
from Item_Loc_Map (nolock)
group by item_id) i
on d.item_id = i.item_id
group by h.trandate, d.item_id, h.location_id
GO
