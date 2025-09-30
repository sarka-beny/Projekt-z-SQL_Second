--Má výška HDP vliv na změny ve mzdách a cenách potravin? Neboli, pokud HDP vzroste výrazněji v jednom roce,
-- projeví se to na cenách potravin či mzdách ve stejném nebo následujícím roce výraznějším růstem?


WITH dotaz_5 AS (
	SELECT 
		t1.*, 
		t2.gdp
	FROM t_sarka_celoudova_project_SQL_primary_final t1
	JOIN t_sarka_celoudova_project_SQL_secondary_final t2 ON t2.YEAR = t1.year
	AND country = 'Czech Republic'
), 
averages AS (
	SELECT 
		YEAR,		
		avg(avg_pay) AS avg_pay_curr,
		avg(avg_price) AS avg_price_curr,
		gdp
	FROM dotaz_5
	GROUP BY YEAR, gdp
),
lagged_data AS (
	SELECT 
		YEAR,
		gdp,
		LAG(gdp) OVER (ORDER BY year) AS lag_gdp,
		avg_pay_curr,
		LAG(avg_pay_curr) OVER (ORDER BY YEAR) AS lag_avg_pay,
		LEAD(avg_pay_curr) OVER (ORDER BY YEAR) AS lead_avg_pay,
		avg_price_curr,
		LAG(avg_price_curr) OVER (ORDER BY YEAR) AS lag_avg_price,
		LEAD(avg_price_curr)OVER (ORDER BY YEAR) AS lead_avg_price
	FROM averages
)
--changes over time
SELECT 
	YEAR,
	round ((((gdp/lag_gdp)-1)*100)::NUMERIC, 1) AS gdp_increase_percentage,
	round ((((avg_price_curr/lag_avg_price)-1)*100)::NUMERIC, 1) AS price_increase_percentage,
	round ((((lead_avg_price/avg_price_curr)-1)*100)::NUMERIC, 1) AS fut_price_increase_percentage,
	round ((((avg_pay_curr/lag_avg_pay)-1)*100)::NUMERIC, 1) AS pay_increase_percentage,
	round ((((lead_avg_pay/avg_pay_curr)-1)*100)::NUMERIC, 1) AS fut_pay_increase_percentage
FROM lagged_data
WHERE YEAR BETWEEN '2007' AND '2017'
GROUP BY YEAR, gdp, lag_gdp,avg_pay_curr,lag_avg_pay, lead_avg_pay,avg_price_curr, lag_avg_price,lead_avg_price
;




