--4. Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?

--strojové porovnání bez vážených průměrů
WITH lagged AS (
    SELECT 
        year,
        industry_branch_code,
        category_code,
        avg_pay,
        avg_price,
        LAG(avg_pay) OVER (PARTITION BY industry_branch_code, category_code ORDER BY year) AS prev_avg_pay,
        LAG(avg_price) OVER (PARTITION BY industry_branch_code, category_code ORDER BY year) AS prev_avg_price
    FROM t_sarka_celoudova_project_SQL_primary_final
),
changes AS (
    SELECT 
        year,
        ROUND(((AVG(avg_pay) / AVG(prev_avg_pay) - 1) * 100)::NUMERIC, 2) AS pay_increase_percentage,
        ROUND(((AVG(avg_price) / AVG(prev_avg_price) - 1) * 100)::NUMERIC, 2) AS price_increase_percentage
    FROM lagged
    WHERE prev_avg_pay IS NOT NULL AND prev_avg_price IS NOT NULL
    GROUP BY year
)
SELECT 
    year,
    pay_increase_percentage,
    price_increase_percentage,
    ROUND((price_increase_percentage - pay_increase_percentage)::NUMERIC, 2) AS difference
FROM changes
ORDER BY year;

--porovnání pro zástupce cen potravin - chléb
WITH lagged AS (
    SELECT 
        year,
        industry,
        category,
        avg_pay,
        avg_price,
        LAG(avg_pay) OVER (PARTITION BY industry, category ORDER BY year) AS prev_avg_pay,
        LAG(avg_price) OVER (PARTITION BY industry, category ORDER BY year) AS prev_avg_price
    FROM t_sarka_celoudova_project_SQL_primary_final
    WHERE category = 'Chléb konzumní kmínový'
),
changes AS (
    SELECT 
        year,
        ROUND(((AVG(avg_pay) / AVG(prev_avg_pay) - 1) * 100)::NUMERIC, 2) AS pay_increase_percentage,
        ROUND(((AVG(avg_price) / AVG(prev_avg_price) - 1) * 100)::NUMERIC, 2) AS price_increase_percentage
    FROM lagged
    WHERE prev_avg_pay IS NOT NULL AND prev_avg_price IS NOT NULL
    GROUP BY year
)
SELECT 
    year,
    pay_increase_percentage,
    price_increase_percentage,
    ROUND((price_increase_percentage - pay_increase_percentage)::NUMERIC, 2) AS difference
FROM changes
ORDER BY difference desc;
