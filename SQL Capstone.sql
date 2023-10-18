--                                           CAPSTONE PROJECT SQL SCRIPT
/*                                                     CONTENT
	                                   SECTION 1: Basic Queries to get the details
                                       SECTION 2: Created VIEWS
                                       SECTION 3: Created Stored Procedures */
/*    
----------------------------------------------SECTION 1: Basic Queries-------------------------------------------------
*/ 
                                                
   
use classicmodels;

-- 1.Finding the Top 10 customers who have made the maximum puchase

select customerName as Customer_name, sum(p.amount) as Amount_spent
from customers c
inner join payments p
on p.customerNumber=c.customerNumber
group by Customer_name
order by Amount_spent desc
limit 10;

-- 2.Finding Country wise customers

select country, count(distinct(customerName)) as No_of_customers
from customers
group by country
order by No_of_customers desc;

-- 3.Customers wise total ordered amount

select customerName, sum(od.quantityOrdered*od.priceEach) as Ordered_Amount
from customers c
inner join orders o using(customerNumber)
inner join orderdetails od using(orderNumber)
group by customerName
order by Ordered_Amount desc;


-- 4.Customer total paid amount

select customerName, sum(amount) as Paid_amount
from customers
inner join payments using(customerNumber)
group by customerName
order by Paid_amount desc;

-- 5.Product wise Sales

select p.productName as Product_name,sum(o.quantityOrdered*o.priceEach) as Total_sales
from products p
inner join orderdetails o using(productCode)
group by Product_name
order by Total_sales desc;


-- 6.Product Line wise Total Sales

select p.productLine as Product_line,sum(o.quantityOrdered*o.priceEach) as Total_sales
from products p
inner join orderdetails o using(productCode)
group by Product_line
order by Total_sales desc;

-- 7.Least 5 ordered products

select productName as Product_name, sum(o.quantityOrdered) as Total_Ordered_quantity
from products p
inner join orderdetails o using(productCode)
group by Product_name
order by Total_Ordered_quantity;

-- 8.Top 5 ordered products

select productName as Product_name, sum(o.quantityOrdered) as Total_Ordered_quantity
from products p
inner join orderdetails o using(productCode)
group by Product_name
order by Total_Ordered_quantity desc
limit 5;

-- 9.Top 10 Invoiced Product

select p.productName as Product_name,sum(o.quantityOrdered*o.priceEach) as Total_sales
from products p
inner join orderdetails o using(productCode)
group by Product_name
order by Total_sales desc
limit 10;


--  10.Total Sales 2003

select year(o.orderDate) as Year_2003, sum(od.quantityOrdered*od.priceEach) as Total_Sales
from orders o
inner join orderdetails od using(orderNumber)
group by Year_2003
having Year_2003 ="2003";

-- 11.Total Sales 2004

select year(o.orderDate) as Year_2004, sum(od.quantityOrdered*od.priceEach) as Total_Sales
from orders o
inner join orderdetails od using(orderNumber)
group by Year_2004
having Year_2004 ="2004";


-- 12.Total Sales 2005

select year(o.orderDate) as Year_2005, sum(od.quantityOrdered*od.priceEach) as Total_Sales
from orders o
inner join orderdetails od using(orderNumber)
group by Year_2005
having Year_2005 ="2005";

-- 13.Quarterly Sales for Year 2003

select year(o.orderDate) as Year_2003,quarter(o.orderDate) as Quarter_sales_2003,sum(od.quantityOrdered*od.priceEach) as Total_Sales
from orders o
inner join orderdetails od using(orderNumber)
group by Quarter_sales_2003,Year_2003
having Year_2003="2003";


-- 14.Quarterly Sales for Year 2004

select year(o.orderDate) as Year_2004,quarter(o.orderDate) as Quarter_sales_2004,sum(od.quantityOrdered*od.priceEach) as Total_Sales
from orders o
inner join orderdetails od using(orderNumber)
group by Quarter_sales_2004,Year_2004
having Year_2004="2004";

-- 15.Quarterly Sales for Year 2005

select year(o.orderDate) as Year_2005,quarter(o.orderDate) as Quarter_sales_2005,sum(od.quantityOrdered*od.priceEach) as Total_Sales
from orders o
inner join orderdetails od using(orderNumber)
group by Quarter_sales_2005,Year_2005
having Year_2005="2005";

-- 16. Total Customers
select count(distinct(customerNumber)) as Total_Customers
from customers;

-- 17. Total Sales Representatives Names
select concat(firstName," ",lastName) as Sales_Rep_full_name
from employees
where jobTitle="Sales Rep";

-- 18. Total count of Sales Representatives
select count(firstName) as Sales_rep_count
from employees
where jobTitle="Sales Rep";

-- 19. Total Sales Amount
select sum(quantityOrdered*priceEach) as Total_Sales_Amount
from orderdetails;

-- 20. Total Profit

select (sum(od.quantityOrdered*od.priceEach)- sum(od.quantityOrdered*p.buyPrice)) as Total_Profit
from orderdetails od
inner join products p using(productCode);

-- 21.Total Products

select count(distinct(productName)) as Product_Counts
from products;

-- 22.Total No. of orders

select count(distinct(orderNumber)) as Total_no_of_orders
from orders;

-- 23.Total No. of Shipped Orders

select count(distinct(orderNumber)) as Total_Shipped_Orders
from orders
where status="Shipped";

-- 24.Credit Limit Country wise

select country, sum(creditLimit) as Total_Credit_Limit
from customers
group by country
order by country desc;

-- 25.Total Customer by country

select country, count(distinct(customerName)) as Customer_counts
from customers
group by country
order by country desc;


-- 26.Profit per Product Lines

select p.productLine as Product_line, sum((od.quantityOrdered*od.priceEach)-(od.quantityOrdered*p.buyPrice)) as Total_Profit
from orderdetails od 
inner join products p using(productCode)
group by Product_line
order by Total_profit desc;

-- 26.Maximum Profit by product name

select p.productName as Product_name, sum((od.quantityOrdered*od.priceEach)-(od.quantityOrdered*p.buyPrice)) as Total_Profit
from orderdetails od 
inner join products p using(productCode)
group by Product_name
order by Total_profit desc;

-- 27. Individual Total Sales done by Sales Representatives 

select concat(e.firstName," ",e.lastName) as Sales_Rep_full_name, sum(o.quantityOrdered*o.priceEach) as Sales_amount
from employees e
inner join customers c 
on e.employeeNumber=c.salesRepEmployeeNumber
inner join orders using (customerNumber)
inner join orderdetails o using (orderNumber)
where e.jobTitle="Sales Rep"
group by Sales_Rep_full_name
order by Sales_amount desc;

/*    
----------------------------------------------SECTION 2: Created Views-------------------------------------------------
*/ 

-- 1. Total Sales by Sales Representatives
create view Sales_by_Sales_Rep as
select concat(e.firstName," ",e.lastName) as Sales_Rep_full_name, sum(o.quantityOrdered*o.priceEach) as Sales_amount
from employees e
inner join customers c 
on e.employeeNumber=c.salesRepEmployeeNumber
inner join orders using (customerNumber)
inner join orderdetails o using (orderNumber)
where e.jobTitle="Sales Rep"
group by Sales_Rep_full_name
order by Sales_amount desc;

-- 2. Product wise Sales

create view Product_wise_Sales as
select p.productName as Product_name, sum((od.quantityOrdered*od.priceEach)-(od.quantityOrdered*p.buyPrice)) as Total_Profit
from orderdetails od 
inner join products p using(productCode)
group by Product_name
order by Total_profit desc;

-- 3. Pofit per Product Lines

create view profit_per_productline as
select p.productLine as Product_line, sum((od.quantityOrdered*od.priceEach)-(od.quantityOrdered*p.buyPrice)) as Total_Profit
from orderdetails od 
inner join products p using(productCode)
group by Product_line
order by Total_profit desc;

-- 4. Customer per country

create view customers_per_country as
select country, count(distinct(customerName)) as Customer_counts
from customers
group by country
order by country desc;

-- 5. Credit Limit Country wise

create view country_credit_limit as
select country, sum(creditLimit) as Total_Credit_Limit
from customers
group by country
order by country desc;


-- 6.Quarterly Sales for Year 2003
create view Quarter_wise_sales_2003 as
select year(o.orderDate) as Year_2003,quarter(o.orderDate) as Quarter_sales_2003,sum(od.quantityOrdered*od.priceEach) as Total_Sales
from orders o
inner join orderdetails od using(orderNumber)
group by Quarter_sales_2003,Year_2003
having Year_2003="2003";


-- 7.Quarterly Sales for Year 2004
create view Quarter_wise_sales_2004 as
select year(o.orderDate) as Year_2004,quarter(o.orderDate) as Quarter_sales_2004,sum(od.quantityOrdered*od.priceEach) as Total_Sales
from orders o
inner join orderdetails od using(orderNumber)
group by Quarter_sales_2004,Year_2004
having Year_2004="2004";

-- 8.Quarterly Sales for Year 2005
create view Quarter_wise_sales_2005 as
select year(o.orderDate) as Year_2005,quarter(o.orderDate) as Quarter_sales_2005,sum(od.quantityOrdered*od.priceEach) as Total_Sales
from orders o
inner join orderdetails od using(orderNumber)
group by Quarter_sales_2005,Year_2005
having Year_2005="2005";


-- 9.Quantity wise products order

create view product_qty_ordered as
select productName as Product_name, sum(o.quantityOrdered) as Total_Ordered_quantity
from products p
inner join orderdetails o using(productCode)
group by Product_name
order by Total_Ordered_quantity desc;

-- 10.Product wise Sales

create view product_total_sales as
select p.productName as Product_name,sum(o.quantityOrdered*o.priceEach) as Total_sales
from products p
inner join orderdetails o using(productCode)
group by Product_name
order by Total_sales desc;


-- 11. Product Line wise Total Sales
create view productline_total_sales as
select p.productLine as Product_line,sum(o.quantityOrdered*o.priceEach) as Total_sales
from products p
inner join orderdetails o using(productCode)
group by Product_line
order by Total_sales desc;

-- 12. Customers wise total ordered amount
create view customer_total_amount as
select customerName, sum(od.quantityOrdered*od.priceEach) as Ordered_Amount
from customers c
inner join orders o using(customerNumber)
inner join orderdetails od using(orderNumber)
group by customerName
order by Ordered_Amount desc;


-- 13. Customer total paid amount
create view customer_paid_amount as
select customerName, sum(amount) as Paid_amount
from customers
inner join payments using(customerNumber)
group by customerName
order by Paid_amount desc;

/*    
----------------------------------------------SECTION 3: STORE PROCEDURES-------------------------------------------------
*/

delimiter //
create procedure customer_details(in customerNumber int)
begin
select customerName, concat(contactFirstName,' ',contactLastName) as SPOC, phone, addressLine1 as full_address, city, country, creditLimit
from customers
where customers.customerNumber= customerNumber;
end
//

delimiter //
create procedure country_wise_customer(country nvarchar(30))
begin
select customerName,concat(contactFirstName,' ',contactLastName) as SPOC, phone, city,country
from customers
where customers.country= country;
end
//

delimiter //
create procedure products_by_productline(in productLine char(20))
begin
select pl.productLine,ps.productName,ps.productCode, ps.productVendor
from productlines pl
inner join products ps using(productLine)
where pl.productLine= productLine;
end
//

delimiter // 
create procedure country_wise_sales(in country char(30))
begin
select c.country as Country_name, sum(od.quantityOrdered*od.priceEach)
from orderdetails od
inner join orders o using(orderNumber)
inner join customers c using(customerNumber)
where c.country=country
group by Country_name;
end
//

delimiter //
create procedure sales_rep_sales(in firstName char(30))
begin
select concat(e.firstName," ",e.lastName) as Sales_Rep_full_name, sum(o.quantityOrdered*o.priceEach) as Sales_amount
from employees e
inner join customers c 
on e.employeeNumber=c.salesRepEmployeeNumber
inner join orders using (customerNumber)
inner join orderdetails o using (orderNumber)
where e.jobTitle="Sales Rep" and e.firstName=firstName
group by Sales_Rep_full_name;
end
//


delimiter //
create procedure year_wise_sales(in enteryear char(10))
select year(o.orderDate) as entered_year,sum(od.quantityOrdered*od.priceEach) as Total_Sales
from orders o
inner join orderdetails od using(orderNumber)
where year(o.orderDate)=enteryear
group by entered_year;
end
//


delimiter ;

/*---------------------------------------THANK YOU------------------------------------------------*/
-- Submitted by: Amrith Vasundharan