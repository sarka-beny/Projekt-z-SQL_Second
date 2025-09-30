--Sekundární tabulka:Jako dodatečný materiál připravte i tabulku s HDP, GINI koeficientem a populací dalších evropských států ve stejném období, jako primární přehled pro ČR.

CREATE TABLE t_sarka_celoudova_project_SQL_secondary_final AS (
	WITH europe_country AS (
		SELECT DISTINCT country
		FROM countries 
		WHERE continent = 'Europe'
)
SELECT
	YEAR,
	economies.country,
	gdp,
	population,
	gini
FROM economies
JOIN europe_country ON economies.country = europe_country.country 
WHERE YEAR BETWEEN '2006' AND '2018'
ORDER BY YEAR, country
);