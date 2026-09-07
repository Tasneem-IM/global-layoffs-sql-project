-- EXPLORATORY DATA ANALYSIS
  select *
  from laypffs_test2;
  
   -- identifying the maximum single-day layoffs and finding companies where 100% of employees were let go
   select company, max(total_laid_off)
   from laypffs_test2 
   group by company
   order by 2 desc;
   
   select *
   from laypffs_test2
   where percentage_laid_off=1;
   
   -- which companies, industries, and countries were most impacted.
	SELECT country, SUM(total_laid_off) 
    FROM laypffs_test2
    GROUP BY country
    ORDER BY 2 DESC;
    
    -- total layoffs by calendar year to show trends over time
    select substring(`date`,1,4) as year ,sum(total_laid_off)
    from laypffs_test2 
    group by substring(`date`,1,4)
	order by 1;
    
    SELECT YEAR(date), SUM(total_laid_off) 
    FROM laypffs_test2 
    GROUP BY YEAR(date);
    
    -- create a month-by-month cumulative sum of layoffs.
    select substring(`date`,1,7) ,SUM(total_laid_off) 
    from laypffs_test2
    group by substring(`date`,1,7)
    order by 1  ;
    
    WITH rolling_total AS 
    (SELECT SUBSTRING(date,1,7) AS month, SUM(total_laid_off) AS total_off 
    FROM laypffs_test2 GROUP BY month) 
    SELECT month, total_off, SUM(total_off) OVER(ORDER BY month) AS rolling_total 
    FROM rolling_total;
    
    -- calculate the top 5 companies with the most layoffs per year
     WITH company_year AS 
     (
     SELECT company, YEAR(date) AS years, SUM(total_laid_off) AS total_laid_off 
     FROM laypffs_test2 
     GROUP BY company, years
     )
     , company_year_rank AS 
     (
     SELECT *, DENSE_RANK() OVER(PARTITION BY years ORDER BY total_laid_off DESC) AS ranking 
     FROM company_year 
     WHERE years IS NOT NULL
     ) 
     SELECT * 
     FROM company_year_rank 
     WHERE ranking <= 5
