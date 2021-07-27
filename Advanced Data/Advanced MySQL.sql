use BI_Marathon_Alena;

/* a. CTE 
Show avarage values of each infligement for each metric (reports, content removed, removal rate) */

Select *  From  fact_content_removerd;
Select *  From  fact_removal_rate;
Select *  From  fact_reports;

WITH cte_reports AS (
	Select 	p.product,
			ROUND(AVG(fr.copyright_r)) as avg_cr,
			ROUND(AVG(fr.trademark_r)) as avg_tm,
            ROUND(AVG(fr.counterfeit_r)) as avg_cf
    FROM fact_reports fr
    JOIN product p on fr.product_id=p.product_id
    GROUP BY product
)
, cte_content_removed AS (
	Select 	p.product,
			ROUND(AVG(copyright_cr)) as avg_cr,
			ROUND(AVG(trademark_cr)) as avg_tm,
            ROUND(AVG(counterfeit_cr)) as avg_cf
    FROM fact_content_removerd fcr
    JOIN product p on fcr.product_id=p.product_id
    GROUP BY product
)
, cte_removal_rate AS (
	Select 	p.product,
			ROUND(AVG(copyright_rr)) as avg_cr,
			ROUND(AVG(trademark_rr)) as avg_tm,
            ROUND(AVG(counterfeit_rr)) as avg_cf
    FROM fact_removal_rate frr
    JOIN product p on frr.product_id=p.product_id
    GROUP BY product
) 

SELECT product, avg_cr, avg_tm, avg_cf FROM cte_reports
UNION 
SELECT product, avg_cr, avg_tm , avg_cf FROM cte_content_removed
UNION 
SELECT product, avg_cr, avg_tm, avg_cf FROM cte_removal_rate ;

/* b. Recursive CTEs
 Find copyrights of content removed metric that higher then average number of copyright 
 for 2020 year (from Jan 2020 to Dec 2020) for Facebook only */

Select *  From  fact_content_removerd;

WITH cte_1 as (
Select fact_content_removerd_id
From fact_content_removerd
WHERE product_id = 1  
)
, cte_2 as (
	Select AVG(copyright_cr) as avg_ccr
	From fact_content_removerd
	WHERE date_format(str_to_date(date, '%Y-%m-%d'), '%m-%y') between '01-20' and '12-20'
)

Select 
		fact_content_removerd_id
        , copyright_cr
From fact_content_removerd
Where fact_content_removerd_id in (select fact_content_removerd_id FROM cte_1)
		and copyright_cr >= (Select avg_ccr FROM cte_2)
;

/* c. Pivoting Data with CASE WHEN 
Show for each product the number of copyright cases on January for each year */
Select *  From  fact_content_removerd;

Select 
		p.product
		, fact_content_removerd_id 		
        , sum(CASE WHEN date_format(str_to_date(date, '%Y-%m-%d'), '%m-%y') = '01-17' THEN copyright_cr END) as 'Jan-2017'
        , sum(CASE WHEN date_format(str_to_date(date, '%Y-%m-%d'), '%m-%y') = '01-18' THEN copyright_cr END) as 'Jan-2018'
        , sum(CASE WHEN date_format(str_to_date(date, '%Y-%m-%d'), '%m-%y') = '01-19' THEN copyright_cr END) as 'Jan-2019'
        , sum(CASE WHEN date_format(str_to_date(date, '%Y-%m-%d'), '%m-%y') = '01-20' THEN copyright_cr END) as 'Jan-2020'
From fact_content_removerd as fcr
Join product as p on p.product_id = fcr.product_id
Where date_format(str_to_date(date, '%Y-%m-%d'), '%m-%y') between '01-17' and '01-20'
Group by 1,2
;

/* d. Self Joins
For reports table find the dates and product ids when number of copyrights less then number of trademark */

Select *  From  fact_reports;

Select 
		a.date, a.product_id
From  
		fact_reports as a
        JOIN fact_reports as b on a.date=b.date and a.product_id=b.product_id
Where a.copyright_r < b.trademark_r
;

-- e. Window Functions

Select 
		date
        , copyright_r
        , row_number() over (order by copyright_r desc) as row_numb
        , rank() over (order by copyright_r desc) as rank_nub
        , dense_rank() over (order by copyright_r desc) as dense_rank_numb
From  
		fact_reports
Where product_id = 1
;

-- f. Calculate Running Totals for Facebook counterfeit in reports

Select 
		date
        , counterfeit_r
        , SUM(counterfeit_r) over (order by date) as Cumulative
From  
		fact_reports
Where product_id = 1
;

/* g. Calculating Delta Values
 Compare the number of trademark for each month */
 
Select 
		date
        , trademark_r
        , trademark_r - LAG(trademark_r, 1) over (order by date) 
From  
		fact_reports
Where product_id = 1
;

-- h. EXCEPT vs NOT IN

Select fact_reports_id, product_id, date, copyright_r, trademark_r, counterfeit_r FROM fact_reports
Except
Select fact_content_removerd_id, product_id, date, copyright_cr, trademark_cr, counterfeit_cr FROM fact_content_removerd
;

/* i. Date-time Manipulation 
Show number of infligement in reports by month and extract month from date */

select 
		EXTRACT(MONTH from date) as month_
        , copyright_r
        , trademark_r
        , counterfeit_r 

FROM fact_reports
Where product_id = 2
;

/* Find all dates with higher copyright number compared to its previous dates */
select 
		a.fact_reports_id
FROM fact_reports a, 
		fact_reports b
Where a.copyright_r > b.copyright_r 
		and datediff(a.date_format(str_to_date(date, '%Y-%m-%d'), '%d-%m-%y'), b.date_format(str_to_date(date, '%Y-%m-%d'), '%d-%m-%y')) = 12 
;

select 
		date_trunc('MONTH', str_to_date(date, '%Y-%m-%d'), '%d-%m-%y')
FROM fact_reports;



 