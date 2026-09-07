select *
from layoffs;

/* create a duplicated table ,to deal with the data in a safe way with the original one saved  */
create table laypffs_test
like layoffs;

insert laypffs_test
select *
from layoffs;

select *
from laypffs_test;

-- 1-DELETE DUPLICATED DATE
/*deal with the duplicated rows ans delete them */
/*select the duplicated rows */
with dupli_cte as
(
select *,
row_number()over(partition by company, location, industry, total_laid_off, percentage_laid_off, date, stage, country) as dupli
from laypffs_test 
)

select *
from dupli_cte 
where dupli > 1;

/*test one of the duplicated rows*/
select *
from layoffs
where company = 'casper' ;

CREATE TABLE `laypffs_test2` 
(
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
   `row_num` int  
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO laypffs_test2
select *,row_number()over(partition by company, location, industry, total_laid_off, percentage_laid_off, date, stage, country) as dupli
from laypffs_test ;

select *
from laypffs_test2;

delete from laypffs_test2
where row_num > 1;

select*
from laypffs_test2
where row_num > 1;


-- 2-STANDARDIZING DATA
select *
from laypffs_test2 ;
-- company
select company 
from laypffs_test2;

select company, trim(company) 
from laypffs_test2;

update laypffs_test2
set company = trim(company);

select company 
from laypffs_test2;

-- industry
select distinct(industry)
from laypffs_test2
order by 1;

select distinct(industry)
from laypffs_test2
where industry like 'crypto%';

update laypffs_test2
set industry = 'crypto'
where industry like 'crypto%';

-- location
select distinct(location)
from laypffs_test2
order by 1;

-- country
select distinct(country)
from laypffs_test2 
order by 1;

select substring('United States.',1,13);

update laypffs_test2
set country = substring('United States.',1,13)
where country like 'United States.';

-- date
select distinct(`date`) ,str_to_date(`date`,'%m/%d/%y')
from laypffs_test2 
order by 1;

update laypffs_test2
set `date` = str_to_date(`date`,'%m/%d/%Y') ;

ALTER table laypffs_test2
modify column `date` date ; 


-- handling nulls and missing values 
  select *
  from laypffs_test2
  where industry is null 
  or industry = '';
  
  select *
  from laypffs_test2
  where company = 'Airbnb';
  
  update laypffs_test2
  set industry=NUll
  where industry ='';
  
  select t1.industry, t2.industry
  from laypffs_test2 t1
  join laypffs_test2 t2
	on t1.company = t2.company
  where (t1.industry is null or t1.industry = '')
  and t2.industry is not null;
  
  update laypffs_test2 t1
  join laypffs_test2 t2
	on t1.company = t2.company
  set t1.industry = t2.industry 
  where t1.industry is null 
  and t2.industry is not null;
  



