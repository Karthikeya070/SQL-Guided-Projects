-- SQL Retail Sales Project

--Create Table
CREATE TABLE retail_sales(
            transactions_id	int primary key,
			sale_date date, 
			sale_time time,
			customer_id	int,
			gender varchar(15),
			age int,
			category varchar(15),	
			quantity int,
			price_per_unit float,	
			cogs float,
			total_sale float		 
);

select * from retail_sales;

select 
 count(*) 
from retail_sales;

--Cheking for Null values
select * from retail_sales
where 
     transactions_id is null
	 or 
	 sale_date is null
	 or 
	 sale_time is null
	 or 
	 gender is null
	 or
	 category is null
	 or 
	 quantity is null
	 or
	 cogs is null
	 or 
	 total_sale is null;

-- Deleting Null values
delete from retail_sales
where 
     transactions_id is null
	 or 
	 sale_date is null
	 or 
	 sale_time is null
	 or 
	 gender is null
	 or
	 category is null
	 or 
	 quantity is null
	 or
	 cogs is null
	 or 
	 total_sale is null;

select * from retail_sales;

--Data Exploration
select count(*) as total_sales from
retail_sales;

--How many unique customers do we have?
select count(distinct customer_id) as
total_customers from retail_sales;

--How many catogories do we have?
select count(distinct category) as 
total_categories from retail_sales;

-- Data Analysis & Business Key Problems.

-- Write SQL Query to retrieve all columns for sales made on 2022-11-05

select * from retail_sales where
sale_date ='2022-11-05';

--Write SQL query to retrieve all transactions where category is 'Clothing' and quantity
-- sold is more than the 2 in month of Nov-2022

select * 
from retail_sales
where category='Clothing'
and to_char(sale_date,'YYYY-MM') ='2022-11'
and quantity >2;

-- Calculate Total Sales for each category
select category,
sum(total_sale) as total_sales
from retail_sales 
group by category;

-- Average Age of the customer who purchased items from Beauty category

select round(avg(age),2) as avg_age from retail_sales
where category='Beauty';

-- Total sales is greater than 1000.
select * from retail_sales 
where total_sale > 1000;

--Find total no of transactions made by each gender for each category

select category, gender,count(total_sale) as total_sales from
retail_sales group by 
category,gender order by 1;

--Calculate Avg Sales for each month. Find out best selling month in each year.

select year,month,AvgSales from(
select 
extract(year from sale_date) as year,
extract(month from sale_date) as month,
avg(total_sale) as AvgSales,
rank() over(partition by extract(year from sale_date)
order by avg(total_sale)
desc) as rank
from retail_sales 
group by 1,2
) as t1
where rank=1;

--top 5 find customers based on total sales

select customer_id,
sum(total_sale) as TotalSales
from retail_sales 
group by 1 order by 2 desc limit 5;

--Number of Unique Customers who purchased items from Each Category

select category, count(distinct customer_id)
from retail_sales
group by 1;

-- To create each shift and number of orders for each shift
with hourly_sales
as(
select *,
case 
when extract (hour from sale_time) < 12 then 'Morning'
when extract(hour from sale_time) between 12 and 17 then 'Afternoon'
else 'Evening'
end as shift
from retail_sales
)
select shift,count(*) as total_orders
from hourly_sales group by shift;