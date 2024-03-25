create database if not exists walmart;

create table if not exists sales(
    invoice_id varchar(30) not null primary key,
    branch varchar(5) not null,
    city varchar(30) not null,
    customer_type varchar(20) not null,
    gender varchar(10) not null,
    product_line varchar(100) not null,
    unit_price decimal(10,2) not null,
    quantity int not null,
    VAT float(6,4) not null,
    total decimal(12,4) not null,
    date DATETIME not null,
    time TIME not null,
    payment_method varchar(15) not null,
    cogs decimal(10,2) not null,
    gross_margin_pct float(11,9),
    gross_income decimal(12,4) not null,
    ratinf float (2,1) not null
);
-- ------------------------------------------------------------------------------------------------------------------------------------

-- ------------------------------------------------------------------------------------------------------------------------------------

-- ---------------------------------------------------- FEATURE ENGINEERING -----------------------------------------------------------

-- ADDING A NEW COLUMN WHICH INDICATES THE TIME OF THE DAY(MORNING, AFTERNOON, EVENING)
-- time_of_date 

select time,
	(case 
		when `time` between "00:00:00" and "12:00:00" then "Morning"
        when `time` between "12:00:00" and "16:00:00" then "Afternoon"
		else "Evening"
	end
    ) as time_of_date
from sales;


alter table sales add column time_of_date varchar(20);


update sales 
set time_of_date = (case 
		when `time` between "00:00:00" and "12:00:00" then "Morning"
        when `time` between "12:00:00" and "16:00:00" then "Afternoon"
		else "Evening"
	end
    );
    
select time_of_date from sales;


-- ADDING A NEW COLUMN WHICH INDICATES THE DAY NAME 
-- day_name

select date,dayname(date) from sales;

alter table sales add column day_name varchar(15);

update sales
set day_name = dayname(date);

select day_name from sales;


-- ADDING A NEW COLUMN WHICH INDICATES THE MONTH NAME
-- month_name

alter table sales add column month_name varchar(15);

update sales 
set month_name = monthname(date);

select date, month_name from sales;
-- ----------------------------------------------------------

-- ----------------------------------------------------------

-- ------------------------------------------------------ EXPLORATORY DATA ANALYSIS -------------------------------------------------------

-- 1. HOW MANY UNIQUE CITIES DOES THE DATA HAVE?
select distinct city as Unique_Cities from sales;

-- 2. HOW MANY UNIQUE BRANCHES DOES THE DATA HAVE?
select distinct branch as Unique_Branches from sales;

-- 3. IN WHICH CITY IS EACH BRANCH?
select distinct city,branch from sales;

-- 4. HOW MANY UNIQUE PRODUCT LINES DOES THE DATA HAVE?
select distinct product_line from sales;

-- 5. WHAT IS THE MOST COMMON PAYMENT METHOD?
select 
	payment_method,count(payment_method) as total 
    from sales 
    group by payment_method 
    order by total desc;
    
    -- Ewallet is the most common payment method

-- 6. WHAT IS THE MOST SELLING PRODUCT LINE?
select 
	product_line, count(product_line) as total 
    from sales 
    group by product_line
    order by total desc;
    
    -- Fashion accessories is the most selling product line
    
-- 7. WHAT IS THE TOTAL REVENUE BY MONTH?
select month_name as month, sum(total) as total_revenue 
from sales
group by month
order by total_revenue desc;

-- 8. WHICH MONTH HAD THE LARGEST COGS?
select month_name as month , sum(cogs) as total_cogs 
from sales
group by month
order by total_cogs desc;

  -- January had the largest COGS

-- 9. WHAT PRODUCT LINE HAD THE LARGEST REVENUE?
select product_line, sum(total) as revenue 
from sales 
group by product_line
order by revenue desc;

  -- Fashion and bevarages had the largest revenue

-- 10. WHICH CITY HAS THE LARGEST REVENUE?
select city, sum(total) as revenue 
from sales 
group by city
order by revenue desc;

	-- Naypyitaw had the largest revenue
    
-- 11. WHAT PRODUCT LINE HAS THE LARGEST VAT?
select product_line, avg(VAT) as avg_tax
from sales
group by product_line
order by avg_tax desc;

	-- Home and lifestyle had the largest vat

-- 12. FETCH EACH PRODUCT LINE AND ADD A COLUMN TO THOSE PRODUCT LINE SHOWING "GOOD", "BAD".
-- 		GOOD IF ITS GREATER THAN AVERAGE SALES
SELECT 
	AVG(quantity) AS avg_qnty
FROM sales;

SELECT
	product_line,
	CASE
		WHEN AVG(quantity) > 6 THEN "Good"
        ELSE "Bad"
    END AS remark
FROM sales
GROUP BY product_line;

-- 13. WHICH BRANCH SOLD MORE PRODUCTS THAN AVERAGE PRODUCT SOLD?
select 
	branch , sum(quantity) as qty
    from sales 
    group by branch
    having qty > (select avg(quantity) from sales)
    order by qty desc;
    
    -- Branch 'A' has sold more products than average products sold.
    
-- 14. WHAT IS THE MOST COMMON PRODUCT LINE BY GENDER?
select gender,product_line,count(product_line) as total_cnt
from sales
group by gender, product_line
order by total_cnt desc;

	-- Fashion accessories is the most common product line by gender(FEMALE)

-- 15. WHAT IS THE AVERAGE RATING OF EACH PRODUCT LINE?
select product_line, round(avg(rating),2) as average_rating
from sales 
group by product_line;

-- 16. NO OF SALES MADE IN EACH TIME OF THE DAY PER WEEKDAY	
select day_name, time_of_date, count(time_of_date) as cnt
from sales where day_name = "Monday"
group by day_name , time_of_date 
order by cnt desc;

-- 17. WHICH OF THE CUSTOMER TYPES BRINGS THE MOST REVENUE?
select customer_type, sum(total) as total_revenue 
from sales
group by customer_type
order by total_revenue;

	-- 'Member' customer type brings the most revenue

-- 18. WHICH CITY HAS THE LARGEST TAX PERCENT/VAT(VALUE ADDED TAX)?
select city, avg(VAT) as tax
from sales
group by city
order by tax;

	-- 'Yangon' city has the largest tax percent/VAT

-- 19.WHICH CUSTOMER TYPE PAYS THE MOST IN VAT?
select customer_type, avg(VAT) as avg
from sales 
group by customer_type
order by avg;

	-- 'Normal' customer type pays the most in VAT

-- 20. HOW MANY UNIQUE CUSTOMER TYPES DOES THE DATA HAVE?
select distinct(customer_type) 
from sales;

-- 21. HOW MANY UNIQUE PAYMENT METHODS DOES THE DATA HAVE ?
select distinct(payment_method) 
from sales;

-- 22. WHAT IS THE MOST COMMON CUSTOMER TYPE?
select customer_type, count(customer_type)
from sales
group by customer_type
order by count(customer_type) desc;

	-- 'Member' is the most common customer type.

-- 23. WHICH CUSTOMER TYPE BUYS THE MOST?
SELECT
	customer_type,
    COUNT(*)
FROM sales
GROUP BY customer_type;

	-- 'Member' customer type buys the most.

-- 24. WHAT IS THE GENDER OF MOST OF THE CUSTOMERS?
select gender, count(gender)
from sales
group by gender;

	-- Most of the customers are Female

-- 25. WHAT IS THE GENDER DISTRIBUTION PER BRANCH?
select gender, branch,count(branch)
from sales 
group by gender,branch;

-- 26. WHICH TIME OF THE DAY DO CUSTOMERS GIVE MOST RATINGS?
select time_of_date, count(rating)
from sales 
group by time_of_date
order by count(rating) desc; 

	-- Customers give most ratings in 'Evening' time

-- 27. WHICH TIME OF THE DAY DO THE CUSTOMERS GIVE MOST RATINGS PER BRANCH?
select time_of_date,branch, count(rating)
from sales 
group by time_of_date,branch
order by count(rating) desc; 

	-- Customers give most of the ratings per branch 'B' in the Evening time.
    
-- 28. WHICH DAY OF THE WEEK HAS THE BEST AVG RATINGS?
select day_name, avg(rating)
from sales 
group by day_name
order by avg(rating) desc; 

	-- Monday has the best average ratings

-- 29. WHICH DAY OF THE WEEK HAS THE BEST AVERAGE RATINGS PER BRANCH?
select day_name,branch, avg(rating)
from sales 
group by day_name,branch
order by avg(rating) desc; 

	-- 
	-- Monday has the best average ratings per branch 'B'.

-- -------------------------------------------------------------------------------------------------------------------
-- -------------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------------

    
    













