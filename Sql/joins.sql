--Join SH.CUSTOMERS and SH.SALES to find customers with the highest sales totals.

select 
    a.cust_id,
    a.CUST_FIRST_NAME || ' ' || a.cust_last_name as cust_full_name,
    count(b.quantity_sold)
from sh.customers a 
inner join sh.sales b on 
a.cust_id = b.cust_id
group by a.cust_id, a.CUST_FIRST_NAME || ' ' || a.cust_last_name
order by count(b.QUANTITY_SOLD)desc
fetch first 1 rows only

--For each customer, show their total sales amount and their rank within country.

select
    a.cust_id,
    a.country_id,
    sum(b.amount_sold) as total_sold,
    rank() over (partition by a.country_id order by sum(b.amount_sold)) as rank_in_country
from sh.customers a
inner join sh.sales b
on a.cust_id = b.cust_id
group by a.cust_id, a.COUNTRY_Id
order by a.country_id, rank_in_country

--Find customers who purchased more than average sales amount of their country.

select 
    a.cust_id,
    round(avg(b.amount_sold), 2) as average_sales
from sh.customers a
inner join sh.sales b
on a.cust_id = b.CUST_ID
group by a.cust_id, a.country_id
having avg(b.amount_sold) > (
    SELECT AVG(c.amount_sold)
    FROM sh.sales c
    INNER JOIN sh.customers d ON c.cust_id = d.cust_id
    WHERE d.country_id = a.country_id
)
ORDER BY average_sales DESC;

--Display top 3 spenders per state.

select  
    cust_id,
    cust_state_province,
    amount_spent,
    ranked from(
        select 
            a.cust_id,
            a.cust_state_province,
            sum(b.amount_sold) as amount_spent,
            rank() over (partition by a.cust_state_province order by sum(b.amount_sold) desc) as ranked
        from sh.customers a
        inner join sh.sales b
        on a.cust_id = b.cust_id
        group by a.cust_state_province, a.cust_id
    )
where ranked <= 3
order by cust_state_province, ranked;


--Rank customers within each country by total sales quantity.

select
    a.cust_id,
    a.country_id,
    sum(b.quantity_sold) as total_sold,
    rank() over (partition by a.country_id order by sum(b.quantity_sold)) as rank_in_country
from sh.customers a
inner join sh.sales b
on a.cust_id = b.cust_id
group by a.cust_id, a.COUNTRY_Id
order by a.country_id, rank_in_country

--Calculate each customer’s contribution percentage to country-level sales.


--Identify customers whose sales have decreased compared to previous month.


--Show customers who have never made a sale.


--Find correlation between credit limit and total sales (using GROUP BY + analytics).


--Show moving average of monthly sales per customer.

