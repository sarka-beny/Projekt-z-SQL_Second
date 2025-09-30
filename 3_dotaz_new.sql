--3. Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)? 

--procentuální meziroční nárůst
WITH price_compare AS (
    SELECT
        category,
  		YEAR,
        avg(avg_price) AS price_actual,
        LAG(avg(avg_price)) OVER (PARTITION BY category ORDER BY year) AS price_previous
    FROM t_sarka_celoudova_project_SQL_primary_final 
    GROUP BY category, year
    ORDER BY year
)
SELECT DISTINCT 
	category, 
	round((avg((price_actual/price_previous)-1)*100)::NUMERIC, 2) AS price_increase_percentage,
	year
	FROM price_compare
	GROUP BY category, year
	ORDER BY price_increase_percentage, YEAR, category ;

--průměrný procentuální nárůst
WITH price_compare AS (
    SELECT 
        category,
        category_code,
  		YEAR,
        avg(avg_price) AS price_actual,
        LAG(avg(avg_price)) OVER (PARTITION BY category ORDER BY YEAR) AS price_previous
    FROM t_sarka_celoudova_project_SQL_primary_final p1
    GROUP BY category, category_code, year
)
SELECT DISTINCT 
	category, 
	category_code,
	round((avg((price_actual/price_previous)-1)*100)::NUMERIC, 2) AS avg_price_increase
	FROM price_compare
	GROUP BY category, category_code
	ORDER BY avg_price_increase, category_code ;



