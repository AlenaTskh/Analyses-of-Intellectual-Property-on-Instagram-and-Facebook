use BI_Marathon_Alena;

Select * From product;

INSERT INTO product (product)
Values ('Facebook'),
('Instagram')
;

DELETE FROM product WHERE product_id in (3,4);
DELETE FROM product WHERE product_id in (5,6);
DELETE FROM product WHERE product_id in (7,8);

-- Finding Dublicates 

Select
	date,
    Count(*)
From temp_table
Group by date
Having Count(*) > 1;

Select
	product,
    Count(*)
From product
Group by product
Having Count(*) > 1;

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

-- CASE WHEN queries 

SELECT 
	*,
	CASE WHEN copyright_rr >= 40 THEN "Medium"
		WHEN copyright_rr >= 80 THEN "HIGH"
        ELSE "LOW" END AS copyright_rate
FROM fact_removal_rate
;

-- NULLIF querie

SELECT COUNT(NULLIF(copyright_rr, 0)) as not_null FROM fact_removal_rate; 

-- COALESCE querie

SELECT product_id, product, COALESCE(product, 'Facebook') as product_name
FROM product
;  

-- DISTINCT querie

SELECT DISTINCT date 
FROM temp_table; 

-- LEAST/GREATEST querie

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






 
