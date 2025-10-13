/*

Assign row numbers to customers ordered by credit limit descending.

select 
    ROW_NUMBER() over(order by cust_credit_limit desc) as ROW_NUMBER,
    cust_id,
    cust_first_name,
    cust_credit_limit
from sh.customers ;


Rank customers within each state by credit limit.

select 
    rank() OVER (PARTITION by cust_state_province order by cust_credit_limit) as rc,
    cust_credit_limit,
    cust_state_province
from sh.customers

Use DENSE_RANK() to find the top 5 credit holders per country.

select * from(select
    DENSE_RANK() over (partition by country_id order by cust_credit_limit desc) as DC,
    cust_first_name,
    country_id
from sh.CUSTOMERS)
where DC <= 5

Divide customers into 4 quartiles based on their credit limit using NTILE(4).

select
    cust_id, 
    cust_credit_limit,
    ntile(4) over (order by cust_credit_limit) as limitt
from sh.customers;

Calculate a running total of credit limits ordered by customer_id.

select
    cust_id, 
    cust_credit_limit,
    sum(CUST_CREDIT_LIMIT) over (order by cust_id)
from sh.customers;

Show cumulative average credit limit by country.

select
    country_id, 
    cust_credit_limit,
    avg(CUST_CREDIT_LIMIT) over (order by country_id)
from sh.customers;

Compare each customer’s credit limit to the previous one using LAG().

 select 
    cust_id,
    cust_credit_limit,
    lag(cust_credit_limit) over (order by cust_id) as lagging
from sh.customers;

Show next customer’s credit limit using LEAD().

 select 
    cust_id,
    cust_credit_limit,
    lead(cust_credit_limit) over (order by cust_id) as leadings
from sh.customers;

Display the difference between each customer’s credit limit and the previous one.

 select 
    cust_id,
    cust_credit_limit,
    cust_credit_limit - lag(CUST_CREDIT_LIMIT, 1, 0) over (order by cust_id) as diff
from sh.customers;

For each country, display the first and last credit limit using FIRST_VALUE() and LAST_VALUE().

 select 
    country_id,
    cust_credit_limit,
    FIRST_VALUE(cust_credit_limit) over (partition by country_id order by cust_credit_limit rows between unbounded preceding and unbounded following) as first_credit_value,
    LAST_VALUE(cust_credit_limit) over (partition by country_id order by cust_credit_limit rows between unbounded preceding and unbounded following) as last_credit_value
from sh.CUSTOMERS

Compute percentage rank (PERCENT_RANK()) of customers based on credit limit.

 select
    cust_id,
    cust_credit_limit,
    PERCENT_RANK() over (order by cust_credit_limit) as pecentage_rank
from sh.customers 

Show each customer’s position in percentile (CUME_DIST() function).

 select
    cust_id,
    cust_credit_limit,
    CUME_DIST() over (order by cust_credit_limit) as cumedist
from sh.customers

Display the difference between the maximum and current credit limit for each customer.

 select 
    cust_id,
    cust_credit_limit,
    max(cust_credit_limit) over()- cust_credit_limit as diff
from sh.customers 

Rank income levels by their average credit limit.

 select
    cust_income_level,
    avg(cust_credit_limit) as average,
    rank() over (order by avg(cust_credit_limit) desc) as Ranking
from sh.customers
group by CUST_INCOME_LEVEL
order by Ranking 

Calculate the average credit limit over the last 10 customers (sliding window).
 SELECT
  cust_id,
  cust_credit_limit,
  AVG(cust_credit_limit) OVER (ORDER BY cust_id ROWS BETWEEN 9 PRECEDING AND CURRENT ROW) AS avg_last_10
FROM sh.customers

For each state, calculate the cumulative total of credit limits ordered by city.

 select 
    cust_city_id,
    cust_state_province,
    cust_credit_limit,
    sum(cust_credit_limit) over (partition by CUST_STATE_PROVINCE order by CUST_CITY_ID) 
from sh.customers

Find customers whose credit limit equals the median credit limit (use PERCENTILE_CONT(0.5)).

 with median_value as(
    select 
    PERCENTILE_CONT(0.5) within group (order by cust_credit_limit) as val
    from sh.customers
)

SELECT
    cust_id, 
    CUST_CREDIT_LIMIT
from sh.customers, median_value
where 
customers.CUST_CREDIT_LIMIT = median_value.val;

Display the highest 3 credit holders per state using ROW_NUMBER() and PARTITION BY.

 select
    cust_id, cust_state_province, cust_credit_limit
from(
    select 
        cust_id, cust_state_province, cust_credit_limit,
        row_number() over (partition by cust_state_province order by cust_credit_limit desc) as rn
    from sh.customers
)
where rn <= 3
order by cust_state_province, rn

Identify customers whose credit limit increased compared to previous row (using LAG).

 with customer_lag as(
    select 
    cust_id,
    cust_credit_limit,
    lag(cust_credit_limit) over (order by cust_id) as lagging
from sh.customers 
)
select 
    cust_id, CUST_CREDIT_LIMIT, lagging 
from customer_lag
where 
    CUST_CREDIT_LIMIT > lagging

Calculate moving average of credit limits with a window of 3.

 select  
    cust_id,
    cust_credit_limit,
    avg(cust_credit_limit) over (order by cust_id rows between 2 preceding and current row) as moving_avg
from sh.customers

Show cumulative percentage of total credit limit per country.

 select
  country_id,
  cust_credit_limit,
  sum(cust_credit_limit) over (partition by country_id order by cust_credit_limit) as cumulative_credit_limit,
  sum(cust_credit_limit) over (partition by country_id) as total_credit_limit,
  100.0 * sum(cust_credit_limit) over (partition by country_id order by cust_credit_limit) /
  sum(cust_credit_limit) over (partition by country_id) as cumulative_percentage
from sh.customers
order by country_id, cust_credit_limit

Rank customers by age (derived from CUST_YEAR_OF_BIRTH).

 select 
  cust_id,
  cust_year_of_birth,
  extract(year from current_date) - cust_year_of_birth as age,
  rank() over (order by extract(year from current_date) - cust_year_of_birth desc) as age_rank
from sh.customers

Calculate difference in age between current and previous customer in the same state.

 with cust_age as (
  select
    cust_id,
    cust_state_province,
    cust_year_of_birth,
    extract(year from current_date) - cust_year_of_birth as age
  from sh.customers
)
select
  cust_id,
  cust_state_province,
  age,
  lag(age) over (partition by cust_state_province order by age desc) as prev_age,
  age - lag(age) over (partition by cust_state_province order by age desc) as age_diff
from cust_age

Use RANK() and DENSE_RANK() to show how ties are treated differently.

 select
    cust_id,
    cust_credit_limit,
    rank() over (order by cust_credit_limit desc) as ranking,
    DENSE_RANK() over (order by cust_credit_limit desc) as densing
from sh.customers 

Compare each state’s average credit limit with country average using window partition.

 select
  country_id,
  cust_state_province,
  cust_credit_limit,
  avg(cust_credit_limit) over (partition by cust_state_province) as avg_credit_limit_state,
  avg(cust_credit_limit) over (partition by country_id) as avg_credit_limit_country
from sh.customers

Show total credit per state and also its rank within each country.

 select
  country_id,
  cust_state_province,
  sum(cust_credit_limit) as total_credit_limit,
  rank() over (partition by country_id order by sum(cust_credit_limit) desc) as rank_within_country
from sh.customers
group by country_id, CUST_STATE_PROVINCE
order by country_id, rank_within_country

Find customers whose credit limit is above the 90th percentile of their income level.

 with income_percentiles as (
  select
    cust_id,
    cust_income_level,
    cust_credit_limit,
    percentile_cont(0.9) within group (order by cust_credit_limit) over (partition by cust_income_level) as credit_limit_90th_percentile
  from sh.customers
)
select
  cust_id,
  cust_income_level,
  cust_credit_limit,
  credit_limit_90th_percentile
from income_percentiles
where cust_credit_limit > credit_limit_90th_percentile

Display top 3 and bottom 3 customers per country by credit limit.

 with rankedcustomers as (
  select
    cust_id,
    country_id,
    cust_credit_limit,
    row_number() over (partition by country_id order by cust_credit_limit desc) as rank_desc,
    row_number() over (partition by country_id order by cust_credit_limit asc) as rank_asc
  from sh.customers
)
select cust_id, country_id, cust_credit_limit
from rankedcustomers
where rank_desc <= 3 or rank_asc <= 3
order by country_id, rank_desc

Calculate rolling sum of 5 customers’ credit limit within each country.

 select
  cust_id,
  country_id,
  cust_credit_limit,
  sum(cust_credit_limit) over (
    partition by country_id
    order by cust_id
    rows between 4 preceding and current row
  ) as rolling_sum_5_credit_limit
from sh.customers

*/