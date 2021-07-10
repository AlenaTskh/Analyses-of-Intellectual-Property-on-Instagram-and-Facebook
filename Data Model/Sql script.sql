create database BI_Marathon;
use BI_Marathon;
create table content_removed(
product varchar(255)
,metric varchar(255)
,copyright int
,counterfeit int
,trademark int
,year int
,month int
,date date
);


create table removal_rate(
product varchar(255)
,metric varchar(255)
,copyright numeric(8,2)
,counterfeit numeric(8,2)
,trademark numeric(8,2)
,year int
,month int
,date date
);

create table reports(
product varchar(255)
,metric varchar(255)
,copyright int
,counterfeit int
,trademark int
,year int
,month int
,date date
);

-- create #1  dimention product
create table product (
product_id int not null auto_increment
,product varchar(255)
,primary key (product_id)
)
;

-- create #2  dimention date
create table date (
date_id int not null auto_increment
,year int
,month int
,primary key (date_id)
)
;

-- create #3  dimention infringment
create table infringment_name (
infringment_name_id int not null auto_increment
,copyright int
,trademark int
,counterfeit int 
,primary key (infringment_id)
)
;

-- create fact #1 table
create table fact_content_removerd (
fact_cr_id int not null auto_increment
,content_removerd int
,date datetime
,product varchar(255)
,copyright int
,trademark int
,counterfeit int 
,infringment_name_id int 
,product_id int
,primary key (fact_cr_id)
, FOREIGN KEY (infringment_name_id) REFERENCES infringment_name (infringment_name_id) ON DELETE SET NULL
, FOREIGN KEY (product_id) REFERENCES product (product_id) ON DELETE SET NULL
)
;

-- create fact #2 table
create table fact_reports (
fact_r_id int not null auto_increment
,reports int
,date datetime
,product varchar(255)
,copyright int
,trademark int
,counterfeit int 
,infringment_name_id int 
,product_id int
,primary key (fact_r_id)
, FOREIGN KEY (infringment_name_id) REFERENCES infringment_name (infringment_name_id) ON DELETE SET NULL
, FOREIGN KEY (product_id) REFERENCES product (product_id) ON DELETE SET NULL
)
;

-- create fact #3 table
create table fact_removal_rate (
fact_rr_id int not null auto_increment
,reports int
,date datetime
,product varchar(255)
,copyright int
,trademark int
,counterfeit int 
,infringment_name_id int 
,product_id int
,primary key (fact_rr_id)
, FOREIGN KEY (infringment_name_id) REFERENCES infringment_name (infringment_name_id) ON DELETE SET NULL
, FOREIGN KEY (product_id) REFERENCES product (product_id) ON DELETE SET NULL
)
;

-- uploading product table
INSERT IGNORE INTO product (product)
SELECT DISTINCT product FROM content_removed
;

-- uploading infringment table
INSERT IGNORE INTO infringment_name (copyright, trademark, counterfeit)
SELECT DISTINCT copyright, trademark, counterfeit FROM content_removed
;

Select * From infringment_name