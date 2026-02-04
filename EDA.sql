-- Exploratory Data Analysis

select * from layoffs_staging2;

select Max(total_laid_off),Max(percentage_laid_off) from layoffs_staging2;
select * from layoffs_staging2 where percentage_laid_off = 1 order by funds_raised_millions desc; 

select company,sum(total_laid_off) from layoffs_staging2 group by company order by 2 desc;

select min(`date`),min(`date`) from layoffs_staging2 ;

select industry,sum(total_laid_off) from layoffs_staging2 group by industry order by 2 desc;

select country,sum(total_laid_off) from layoffs_staging2 group by country order by 2 desc;

select year(`date`),sum(total_laid_off) from layoffs_staging2 group by year(`date`) order by 1 desc;

select stage,sum(total_laid_off) from layoffs_staging2 group by stage order by 2 desc;

select company,avg(percentage_laid_off) from layoffs_staging2 group by company order by 2 desc;

select substring(`date`,1,7) as `Month` ,Sum(total_laid_off) from layoffs_staging2 where substring(`date`,1,7) is not null group by `Month` order by 1 asc;

-- Calculating the rolling sum based in the monthly total laid off

with Rolling_total as (
select substring(`date`,1,7) as `Month` ,Sum(total_laid_off) as total_off from layoffs_staging2 where substring(`date`,1,7) is not null group by `Month` order by 1 asc
)
select `Month`,total_off,Sum(total_off) over(order by `Month`) as rolling_total from Rolling_total;

select company,sum(total_laid_off) from layoffs_staging2 group by company order by 2 desc;

-- Company,Year and how many people they laid off
select company,year(`date`),sum(total_laid_off) from layoffs_staging2 group by company ,year(`date`) order by 3 desc;

-- Created CTE where first CTE for  based on company ,Year and sum of laid of where we got the ranking and the next CTE for company year ranking where the ranking is less than or 
-- equal to 5,we hit off first CTE to make Second CTE

with Company_year(company,years,total_load_off ) as
(
select company,year(`date`),sum(total_laid_off) from layoffs_staging2 group by company ,year(`date`) order by 3 desc
),Company_Year_Ranking as 
(
select *,dense_rank() over (partition by years order by total_load_off desc) as ranking from Company_year where years is not null
) 
select * from Company_Year_Ranking where ranking <= 5;








