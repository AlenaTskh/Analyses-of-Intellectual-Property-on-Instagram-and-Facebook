use BI_Marathon_Alena;
-- a. CTE

Select *  From  fact_content_removerd;
Select *  From  fact_removal_rate;
Select *  From  fact_reports;

WITH cte_reports AS (
	Select 	p.product,
			AVG(copyright_r) as avg_cr,
			AVG(trademark_r) as avg_tm,
            AVG(counterfeit_r) as avg_cf
    FROM fact_reports fr
    JOIN product p on fr.product_id=p.product_id
    GROUP BY product
)
, WITH cte_content_removed AS (
	Select 	p.product,
			AVG(copyright_cr) as avg_cr,
			AVG(trademark_cr) as avg_tm,
            AVG(counterfeit_cr) as avg_cf
    FROM fact_content_removerd fcr
    JOIN product p on fcr.product_id=p.product_id
    GROUP BY product
)
, WITH cte_removal_rate AS (
	Select 	p.product,
			AVG(copyright_rr) as avg_cr,
			AVG(trademark_rr) as avg_tm,
            AVG(counterfeit_rr) as avg_cf
    FROM fact_removal_rate frr
    JOIN product p on frr.product_id=p.product_id
    GROUP BY product
) 

SELECT product, avg_cr, avg_tm, avg_cf FROM cte_reports
UNION 
SELECT product, avg_cr, avg_tm , avg_cf FROM cte_content_removed
UNION 
SELECT product, avg_cr, avg_tm, avg_cf FROM cte_removal_rate ;

-- b. Recursive CTEs

Select *  From  temp_table;

WITH cte_fb (
Select product, SUM(copyright_cr) as sum_ccr, SUM(copyright_r) as sum_cr, AVG(copyright_rr) as avr_crr
From temp_table
GROUP by product
Having product = 'Instagram'
)

,WITH cte_insta (
Select product, SUM(copyright_cr)as sum_ccr, SUM(copyright_r) as sum_cr, AVG(copyright_rr) as avr_crr
From temp_table
GROUP by product
Having product = 'Facebook'
)

Select product, sum_ccr, sum_cr, avr_crr From cte_fb
Union
Select product, sum_ccr, sum_cr, avr_crr From cte_insta;

-- c. Pivoting Data with CASE WHEN 

Select *  From  temp_table;

Select fact_content_removerd_id 
		, product_id
        , sum(CASE WHEN date_format((str_to_date(date, '%y,%m%d'), '%m%y') = '01-17' THEN copyright_cr END) as 'Jan-2017'
        , sum(CASE WHEN date_format((str_to_date(date, '%y,%m%d'), '%m%y') = '01-18' THEN copyright_cr END) as 'Jan-2018'
        , sum(CASE WHEN date_format((str_to_date(date, '%y,%m%d'), '%m%y') = '01-19' THEN copyright_cr END) as 'Jan-2019'
        , sum(CASE WHEN date_format((str_to_date(date, '%y,%m%d'), '%m%y') = '01-20' THEN copyright_cr END) as 'Jan-2020'
From fact_content_removerd
Group by 1,2
;

-- d. Self Joins

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
-- f. Calculating Running Totals

Select 
		date
        , counterfeit_r
        , SUM(counterfeit_r) over (order by date) as Cumulative
From  
		fact_reports
Where product_id = 1
;

-- g. Calculating Delta Values
-- Comparing each month number of trademark

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
Select fact_reports_id, product_id, date, copyright_cr, trademark_cr, counterfeit_cr FROM fact_content_removerd
;
-- i. Date-time Manipulation

select 
		EXTRACT(MONTH from date) as month_
        , copyright_r
        , trademark_r
        , counterfeit_r 

FROM fact_reports
Where product_id = 2
;

select 
		fact_reports_id
FROM fact_reports a, fact_reports b
Where a.copyright_r > b.copyright_r 
        and datediff(a.date, b.date) = 1
;
 