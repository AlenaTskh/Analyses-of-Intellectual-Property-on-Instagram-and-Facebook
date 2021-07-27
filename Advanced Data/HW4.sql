use BI_Marathon_Alena;

Select * From product;

INSERT INTO product (product)
Values ('Facebook'),
('Instagram')
;

DELETE FROM product WHERE product_id in (3,4);
DELETE FROM product WHERE product_id in (5,6);
DELETE FROM product WHERE product_id in (7,8);
DELETE FROM product WHERE product_id in (9,10);

-- Finding Dublicates 
-- 1

Select
	date,
    Count(*)
From temp_table
Group by date
Having Count(*) > 1;

-- 2

Select
	product,
    Count(*)
From product
Group by product
Having Count(*) > 1;

-- 3

WITH cte AS(
	Select 
			product_id
            ,product
            ,ROW_NUMBER() OVER (
				PARTITION BY 
					product
				ORDER BY 
					product
			) as row_num 
		From 
			product
			)
        SELECT * 
        FROM cte
	WHERE row_num > 1
;

/* CASE WHEN queries 
Add LOW MEDIUM AND HIGHT columns of copyright removal rate*/

SELECT 
	date
    , CASE WHEN copyright_rr < 40 THEN copyright_rr END as 'LOW'
	, CASE WHEN copyright_rr >=40 and copyright_rr < 80 THEN copyright_rr END as 'Medium' 
    , CASE WHEN copyright_rr >= 80 THEN copyright_rr END as 'HIGH'
FROM fact_removal_rate
;

/* NULLIF querie. Count in the copyright column how many not null falues  */

SELECT * FROM fact_removal_rate; 

SELECT COUNT(NULLIF(copyright_rr, 0)) as not_null FROM fact_removal_rate; 

-- COALESCE querie. Relturn from product table the first not-null values

SELECT product_id, product, COALESCE(product, 'Facebook') as product_name
FROM product
;  

-- DISTINCT querie. Return all unique dates in the temp_table

SELECT DISTINCT date 
FROM temp_table; 

-- LEAST/GREATEST querie. Create the colunm copyright_new where below 60 number should be equal 60. and higher the 72 should be equal 70.

SELECT *
FROM temp_table
Order by copyright_rr;

SELECT product, copyright_rr, 
GREATEST(60, copyright_rr) copyright_new
FROM temp_table
Order by copyright_rr;

SELECT product, copyright_rr, 
LEAST(72, copyright_rr) copyright_new
FROM temp_table
Order by copyright_rr DESC;



 
