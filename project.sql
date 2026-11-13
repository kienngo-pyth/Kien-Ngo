USE fp20c12
GO

--1
;WITH xmas_sales AS (	
	SELECT
	CASE WHEN MONTH([date]) = 1 
	THEN YEAR ([date]) - 1
	ELSE YEAR ([date]) END AS xmas_year,
	CASE WHEN MONTH ([date]) = 1
		THEN CONCAT(YEAR([date]) - 1, '-', YEAR([date]))
		ELSE CONCAT(YEAR([date]), '-', YEAR([date]) + 1)
		END AS xmas_season,
		YEAR([date]) AS [year], EOMONTH([date]) AS end_date_of_month,
		DATEPART(WEEKDAY, [date]) AS [weekday],
		CASE DATEPART(WEEKDAY, [date])
			WHEN 1 THEN 'Sunday'
			WHEN 2 THEN 'Monday'
			WHEN 3 THEN 'Tuesday'
			WHEN 4 THEN 'Wednesday'
			WHEN 5 THEN 'Thursday'
			WHEN 6 THEN 'Friday'
			WHEN 7 THEN 'Saturday'
		END AS weekday_name,
		DATEPART(HOUR, [time]) AS [hour],
		s.*
	FROM dbo.xmas_sales s
	WHERE EOMONTH([date]) <> '2018-01-01'
), s AS (
	SELECT xmas_year, xmas_season, SUM(total_sales) AS sales, SUM(quantity) AS quantity, SUM(cost) AS cost, SUM(profit) AS profit
	FROM xmas_sales
	GROUP BY xmas_year, xmas_season
)
SELECT xmas_year, xmas_season, ROUND(1.0 * sales / 1000000, 2) AS sales, ROUND(1.0 * quantity / 1000, 1) AS quantity, ROUND(1.0 * cost / 1000000, 2) AS cost, ROUND(1.0 * profit / 1000000, 2) AS profit
FROM s