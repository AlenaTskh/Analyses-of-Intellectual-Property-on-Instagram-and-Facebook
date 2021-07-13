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

-- create #2  dimention infringement
create table infringement (
infringement_id int not null auto_increment
,infringement_name varchar(255)
,primary key (infringement_id)
)
;

Select * From infringement
;

-- create fact #1 table
create table fact_content_removerd (
fact_content_removerd_id int not null auto_increment
,content_removerd int
,date varchar(225)
,infringement_id int 
,product_id int
,primary key (fact_content_removerd_id)
, FOREIGN KEY (infringement_id) REFERENCES infringement (infringement_id) ON DELETE SET NULL
, FOREIGN KEY (product_id) REFERENCES product (product_id) ON DELETE SET NULL
)
;

-- create fact #2 table
create table fact_reports (
fact_reports_id int not null auto_increment
,reports int
,date varchar(225)
,infringement_id int 
,product_id int
,primary key (fact_reports_id)
, FOREIGN KEY (infringement_id) REFERENCES infringement (infringement_id) ON DELETE SET NULL
, FOREIGN KEY (product_id) REFERENCES product (product_id) ON DELETE SET NULL
)
;

-- create fact #3 table
create table fact_removal_rate (
fact_removal_rate_id int not null auto_increment
,reports int
,date varchar(225)
,infringement_id int 
,product_id int
,primary key (fact_removal_rate_id)
, FOREIGN KEY (infringement_id) REFERENCES infringement (infringement_id) ON DELETE SET NULL
, FOREIGN KEY (product_id) REFERENCES product (product_id) ON DELETE SET NULL
)
;

-- uploading product table
INSERT IGNORE INTO product (product)
SELECT DISTINCT product FROM temp_table
;

-- uploading infringment table
INSERT IGNORE INTO infringement (infringement_name)
VALUES ('copyright'), 
('trademark'), 
('counterfeit')
;

Select * From infringement;
Select * From product;