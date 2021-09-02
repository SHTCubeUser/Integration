USE [is21olap]
GO
/****** Object:  View [dbo].[v_exchange_rate]    Script Date: 9/2/2021 2:50:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[v_exchange_rate] AS
WITH C AS
(
	SELECT currency_id,
	       [name],
	       MIN(date_effective) mineffdate,
		   MAX(date_effective) maxeffdate
	FROM v_cur_rate
	GROUP BY currency_id, [name]
)
SELECT C.currency_id,
       C.[name],
	   O.effdate,
	   (
	   SELECT TOP(1) R.exchange_rate
	   FROM v_cur_rate AS R
	   WHERE R.[name] = C.[name]
	         AND R.date_effective <= O.effdate
	   ORDER BY R.date_effective DESC
	   ) AS exrate
FROM C
	INNER JOIN v_cal_table AS O
	ON O.effdate BETWEEN C.mineffdate and C.maxeffdate
GO
