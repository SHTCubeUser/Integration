USE [is21olap]
GO
/****** Object:  View [dbo].[v_item_wac]    Script Date: 9/2/2021 2:50:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[v_item_wac] as
select item_id, avg(average_cost) wac
from Item_Loc_Map
group by item_id
GO
