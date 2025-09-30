--2. Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období 
--v dostupných datech cen a mezd?

WITH 
pay AS (
	SELECT
		YEAR,
		round (avg (avg_pay)::NUMERIC, 2) AS avg_pay
	FROM t_sarka_celoudova_project_SQL_primary_final
	GROUP BY YEAR
), 
price AS (
	SELECT DISTINCT
		YEAR,
		category,
		round(avg_price::NUMERIC, 2) AS avg_price
	FROM t_sarka_celoudova_project_SQL_primary_final 
	GROUP BY YEAR, category, avg_price
	HAVING category IN ('Mléko polotučné pasterované', 'Chléb konzumní kmínový')
)
SELECT 
	price.YEAR,
	category,
	round((avg_pay/avg_price)::NUMERIC, 2) AS how_much
FROM price 
JOIN pay ON pay.YEAR = price.YEAR
ORDER BY "year" --desc
--limit 2
;

--k získaní dat pouze za první období je možné využít zakomentovanou část výše "limit 2" 
--k získání dat pouze za poslední období je možné využít zakomentovanou část "desc" a současně "limit 2"
--z tohoto důvodů ponechávám tyto zakomentované části