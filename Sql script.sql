create database BI_Marathon_Alena;
use BI_Marathon_Alena;

create table temp_table(
product varchar(255)
,date varchar(255)
,copyright_cr int
,counterfeit_cr int
,trademark_cr int
,copyright_r int
,counterfeit_r int
,trademark_r int
,copyright_rr dec(4,2)
,counterfeit_rr dec(4,2)
,trademark_rr dec(4,2)
);

truncate temp_table;
;

-- create #1  dimention product
create table product (
product_id int not null auto_increment
,product varchar(255)
,primary key (product_id)
)
;

Select * From product
;

-- create fact #1 table
create table fact_content_removerd (
fact_content_removerd_id int not null auto_increment
,date varchar(225)
,copyright_cr int
,trademark_cr int
,counterfeit_cr int
,product_id int
,primary key (fact_content_removerd_id)
, FOREIGN KEY (product_id) REFERENCES product (product_id) ON DELETE SET NULL
)
;

-- create fact #2 table
create table fact_reports (
fact_reports_id int not null auto_increment
,date varchar(225)
,copyright_r int
,trademark_r int
,counterfeit_r int
,product_id int
,primary key (fact_reports_id)
, FOREIGN KEY (product_id) REFERENCES product (product_id) ON DELETE SET NULL
)
;

-- create fact #3 table
create table fact_removal_rate (
fact_removal_rate_id int not null auto_increment
,date varchar(225)
,copyright_rr dec(4,2)
,trademark_rr dec(4,2)
,counterfeit_rr dec(4,2)
,product_id int
,primary key (fact_removal_rate_id)
, FOREIGN KEY (product_id) REFERENCES product (product_id) ON DELETE SET NULL
)
;

-- uploading product table
INSERT IGNORE INTO product (product)
SELECT DISTINCT product FROM temp_table
;

Select * From product;

-- uploading #1 fact table 
INSERT IGNORE INTO fact_content_removerd (date, copyright_cr, trademark_cr, counterfeit_cr, product_id)
SELECT DISTINCT
	t.date
    ,t.copyright_cr
    ,t.trademark_cr
    ,t.counterfeit_cr
    ,p.product_id 
From temp_table t
JOIN product p ON p.product=t.product
;

-- uploading #2 fact table 
INSERT IGNORE INTO fact_reports (date, copyright_r, trademark_r, counterfeit_r, product_id)
SELECT DISTINCT
	t.date
    ,t.copyright_r
    ,t.trademark_r
    ,t.counterfeit_r
    ,p.product_id 
From temp_table t
JOIN product p ON p.product=t.product
;

-- uploading #3 fact table 
INSERT IGNORE INTO fact_removal_rate (date, copyright_rr, trademark_rr, counterfeit_rr, product_id)
SELECT DISTINCT
	t.date
    ,t.copyright_rr
    ,t.trademark_rr
    ,t.counterfeit_rr
    ,p.product_id 
From temp_table t
JOIN product p ON p.product=t.product
;
