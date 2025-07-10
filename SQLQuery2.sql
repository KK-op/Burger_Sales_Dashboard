use Burger_Sales;

select * from Burger_Sales_table;
select sum(total_price) as total_revenue from Burger_Sales_table;
select CAST(sum(total_price)/count( distinct order_id) as decimal(10,2)) as Average_order_value from Burger_Sales_table;
select sum(quantity) as Total_Burgers_sold from Burger_Sales_table where item_category like 'Burger%';
select count(distinct(order_id)) as Total_orders from Burger_Sales_table ;
select cast (cast(sum(quantity) as decimal(10,2)) / 
(select cast (count(distinct(order_id)) as decimal(10,2)) from burger_sales_table)as decimal(10,2))
as AVG_Burgers_per_order from Burger_Sales_table
where item_category like 'Burger%';


--NO. of orders per day
select DATENAME(DAY,order_date) as date ,Count(distinct(order_id)) 
as number_of_orders from Burger_Sales_table
group by Datename(Day,order_date)
order by cast(Datename(Day,order_date) as decimal (10,0));

--NO. of orders weekly
select DATENAME(WEEKDAY,order_date) as week, Count(distinct(order_id)) 
as number_of_orders from Burger_Sales_table
group by Datename(WEEKDAY,order_date)
order by DATENAME(WEEKDAY,order_date);

--NO. of orders monthly
select DATENAME(MONTH,order_date) as week ,Count(distinct(order_id)) 
as number_of_orders from Burger_Sales_table
group by Datename(MONTH,order_date)
order by Datename(MONTH,order_date);

--Hourly Trend
select datepart(HOUR,order_time) as Hour ,Count(distinct(order_id)) 
as number_of_orders from Burger_Sales_table
group by datepart(HOUR,order_time)
order by datepart(HOUR,order_time);

-- "% of total sales by item_category"
select item_category,round((sum(total_price)/(select sum(total_price) from burger_sales_table)),4)*100
as percentage 
from burger_sales_table
group by item_category;


-- "% of total sales by item_category in a particular month like January"
select item_category,round((sum(total_price)/(select sum(total_price) from burger_sales_table where datename(month,order_date)='January')),4)*100
as percentage 
from burger_sales_table
where datename(month,order_date)='January'
group by item_category;

-- "% of total  sales by item_name 
select item_name,round((sum(total_price)/(select sum(total_price) from burger_sales_table)),4)*100
as percentage 
from burger_sales_table
group by item_name;

--"% of total sales by channel"
select channel,CAST((sum(total_price)/(select sum(total_price) from burger_sales_table)) as decimal(10,2))*100
as percentage 
from burger_sales_table
group by channel;

--"% of total sales by channel in quarter 1"
select channel,cast((sum(total_price)/(select sum(total_price) from burger_sales_table where datepart(Quarter,order_date)=1))as decimal(10,2))*100
as percentage 
from burger_sales_table
where datepart(Quarter,order_date)=1
group by channel;

--Total items Sold by item_category
create view  TIS as
select item_category,sum(quantity)
as total_items_sold
from burger_sales_table
group by item_category;

select * from TIS;

--Top 5 best burgers sold as per total items sold
select top 5 item_name, sum(quantity) as Sold_Burgers
from burger_sales_table
where item_name like '%Burger' or item_name like '%Maharaja'
group by item_name 
order by sum(quantity) desc;

--Bottom 5  burgers sold as per total items sold
select top 5 item_name, sum(quantity) as Sold_Burgers
from burger_sales_table
where item_name like '%Burger' or item_name like '%Maharaja'
group by item_name 
order by sum(quantity);

--Top 5 items sold
select top 5 item_name, sum(quantity) as Sold_Burgers
from burger_sales_table
group by item_name 
order by sum(quantity) desc;

--Bottom 5 worst selling items
select top 5 item_name, sum(quantity) as Sold_Burgers
from burger_sales_table
group by item_name 
order by sum(quantity) asc;
