USE [is21olap]
GO
/****** Object:  View [dbo].[v_SalesRank]    Script Date: 9/2/2021 2:50:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





CREATE VIEW [dbo].[v_SalesRank] AS
select BI_Loc, yr, mth,sum(qty) qty, sum(local_amount) local_amount, sum(us_amount) us_amount, location_id, sum(targetamt) targetamt
from (
select m.BI_Loc, year(h.trandate) yr, month(h.trandate) mth, sum(d.original_quantity) qty,
       sum(d.amount*-1) local_amount, sum(round(d.amount*-1*r.exrate,0)) us_amount, h.location_id, sum(t.amount_usd) targetamt
from [Transactions] h
inner join [Transaction_lines] d
on h.transaction_id = d.transaction_id
inner join [Items] i
on d.item_id = i.item_id
inner join [Locations] l
on h.location_id = l.location_id
inner join v_exchange_rate r
on h.currency_id = r.currency_id
and h.trandate = r.effdate
left join LocMapping m
on l.full_name = m.ns_loc
inner join Customers c
on h.entity_id = c.customer_id
inner join targets t
on h.location_id = t.location_id
where h.transaction_type = 'Invoice' and h.[status] = 'Paid in Full'
and d.statistical_value__base_curre = 0
and isnull(h.memo,'') <> 'VOID'
group by m.BI_Loc, year(h.trandate), month(trandate), h.location_id
union
select m.BI_Loc, year(h.trandate) yr, month(h.trandate) mth, sum(d.original_quantity) qty,
       sum(d.amount*-1) local_amount, sum(round(d.amount*-1*r.exrate,0)) us_amount, h.location_id, sum(t.amount_usd) targetamt
from [Transactions] h
inner join [Transaction_lines] d
on h.transaction_id = d.transaction_id
inner join [Items] i
on d.item_id = i.item_id
inner join [Locations] l
on h.location_id = l.location_id
inner join v_exchange_rate r
on h.currency_id = r.currency_id
and h.trandate = r.effdate
left join LocMapping m
on l.full_name = m.ns_loc
inner join Customers c
on h.entity_id = c.customer_id
inner join targets t
on h.location_id = t.location_id
where h.transaction_type = 'Cash Refund'
and d.statistical_value__base_curre = 0
and isnull(h.memo,'') <> 'VOID'
group by m.BI_Loc, year(h.trandate), month(trandate), h.location_id
union
select m.BI_Loc, year(h.trandate) yr, month(h.trandate) mth, sum(d.original_quantity) qty,
       sum(d.amount*-1) local_amount, sum(round(d.amount*-1*r.exrate,0)) us_amount, h.location_id, sum(t.amount_usd) targetamt
from [Transactions] h
inner join [Transaction_lines] d
on h.transaction_id = d.transaction_id
inner join [Items] i
on d.item_id = i.item_id
inner join [Locations] l
on h.location_id = l.location_id
inner join v_exchange_rate r
on h.currency_id = r.currency_id
and h.trandate = r.effdate
left join LocMapping m
on l.full_name = m.ns_loc
inner join Customers c
on h.entity_id = c.customer_id
inner join targets t
on h.location_id = t.location_id
where h.transaction_type = 'Credit Memo' and h.[status] in ('Fully Applied','Open')
and d.statistical_value__base_curre = 0
and isnull(h.memo,'') <> 'VOID'
group by m.BI_Loc, year(h.trandate), month(trandate), h.location_id) a
group by BI_Loc, yr, mth,location_id
GO
