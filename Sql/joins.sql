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

select
    a.cust_id,
    a.country_id,
    sum(b.amount_sold) as customer_total_sales,
    country_totals.country_sales,
    round((sum(b.amount_sold) / country_totals.country_sales) * 100, 2) as contribution_percentage
from sh.customers a
inner join sh.sales b on a.cust_id = b.cust_id
inner join (
    select
        country_id,
        sum(amount_sold) as country_sales
    from sh.customers c
    inner join sh.sales s on c.cust_id = s.cust_id
    group by country_id
) country_totals on a.country_id = country_totals.country_id
group by a.cust_id, a.country_id, country_totals.country_sales
order by a.country_id, contribution_percentage desc;

--Identify customers whose sales have decreased compared to previous month.

with monthly_sales as (
    select
        cust_id,
        to_char(time_id, 'yyyy-mm') as year_month,
        sum(amount_sold) as total_sales
    from sh.sales
    group by cust_id, to_char(time_id, 'yyyy-mm')
),
sales_with_lag as (
    select
        cust_id,
        year_month,
        total_sales,
        lag(total_sales) over (partition by cust_id order by year_month) as prev_month_sales
    from monthly_sales
)
select 
    cust_id,
    year_month,
    total_sales,
    prev_month_sales
from sales_with_lag
where prev_month_sales is not null
  and total_sales < prev_month_sales
order by cust_id, year_month;

--Show customers who have never made a sale.

select
    a.cust_id,
    a.cust_first_name || ' ' || a.cust_last_name as full_name
from sh.customers a
left join sh.sales b 
on a.cust_id = b.CUST_ID
where b.cust_id is null;

--Find correlation between credit limit and total sales (using GROUP BY + analytics).

with customer_sales as (
    select
        a.cust_id,
        max(a.cust_credit_limit) as credit_limit,
        sum(b.amount_sold) as total_sales
    from sh.customers a
    left join sh.sales b on a.cust_id = b.cust_id
    group by a.cust_id
)
select
    corr(credit_limit, total_sales) as credit_sales_correlation
from customer_sales;

--Show moving average of monthly sales per customer.

with monthly_sales as (
    select
        cust_id,
        to_char(time_id, 'mm-yyyy') as month_year,
        sum(amount_sold) as total_sales
    from sh.sales
    group by cust_id, to_char(time_id, 'mm-yyyy')
)
select
    cust_id,
    year_month,
    total_sales,
    avg(total_sales) over (
        partition by cust_id
        order by month_year
        rows between 2 preceding and current row
    ) as moving_avg_sales
from monthly_sales
order by cust_id, month_year;
