--A. Aggregation & Grouping (20 Questions)

--Find the total, average, minimum, and maximum credit limit of all customers.

select sum(cust_credit_limit), avg(cust_credit_limit), min(cust_credit_limit), max(cust_credit_limit) from sh.CUSTOMERS;

--Count the number of customers in each income level.

select CUST_INCOME_LEVEL, count(*) from sh.CUSTOMERS
group by CUST_INCOME_LEVEL

--Show total credit limit by state and country.

select cust_state_province, sum(cust_credit_limit) from sh.CUSTOMERS
group by CUST_STATE_PROVINCE

--Display average credit limit for each marital status and gender combination.

select avg(cust_credit_limit) as average, cust_marital_status, cust_gender from sh.CUSTOMERS
group by cust_gender, CUST_MARITAL_STATUS
order by average, cust_gender

--Find the top 3 states with the highest average credit limit.

select round(avg(cust_credit_limit),2) as ag, cust_state_province from sh.CUSTOMERS
group by CUST_STATE_PROVINCE
order by ag desc
fetch first 3 rows ONLY;

--Find the country with the maximum total customer credit limit.

select count(*), COUNTRY_ID, sum(cust_credit_limit) as total_credit from sh.customers
group by COUNTRY_ID
order by total_credit desc
fetch first 1 rows only;

--Calculate total and average credit limit for customers born after 1980.

select sum(CUST_CREDIT_LIMIT), avg(CUST_CREDIT_LIMIT) from sh.CUSTOMERS
where CUST_YEAR_OF_BIRTH > 1980

--Find states having more than 50 customers.

select count(cust_id) as dg, cust_state_province from sh.CUSTOMERS
group by cust_state_province
having dg > 50

--List countries where the average credit limit is higher than the global average.

select country_id, avg(cust_credit_limit) as average from sh.customers
group by COUNTRY_ID
having average > (
    select avg(cust_credit_limit) from sh.CUSTOMERS
)

--Calculate the variance and standard deviation of customer credit limits by country.

select country_id, var_samp(cust_credit_limit), stddev(cust_credit_limit) from sh.CUSTOMERS
group by country_id;

--Find the state with the smallest range (max–min) in credit limits.

select max(cust_credit_limit) - min(cust_credit_limit) as low_credit, country_id from sh.CUSTOMERS
group by COUNTRY_ID
order by low_credit
fetch first 1 rows only; 

--Show the total number of customers per income level and the percentage contribution of each.

select cust_income_level, 
       count(*) AS customer_count,
       round(count(*) * 100.0 / sum(count(*)) over (), 2) as percentage_contribution
from sh.CUSTOMERS
group by cust_income_level
order by customer_count desc;

--For each income level, find how many customers have NULL credit limits.

select count(*), cust_income_level from sh.customers 
where CUST_CREDIT_LIMIT is null
group by cust_income_level

--Display countries where the sum of credit limits exceeds 10 million.

select country_id, sum(cust_credit_limit) from sh.CUSTOMERS
group by COUNTRY_ID
having sum(cust_credit_limit) > 100000000

--Find the state that contributes the highest total credit limit to its country.

select country_id, cust_state_province, sum(cust_credit_limit) from sh.CUSTOMERS
group by country_id, CUST_STATE_PROVINCE
order by sum(cust_credit_limit) desc
fetch first 1 rows only

--Show total credit limit per year of birth, sorted by total descending.

select cust_year_of_birth, sum(cust_credit_limit) as descending from sh.customers 
group by CUST_YEAR_OF_BIRTH
order by descending desc

--Identify customers who hold the maximum credit limit in their respective country.

select customer_id, country_id, cust_credit_limit
from (
    select customer_id, country_id, cust_credit_limit,
           ROW_NUMBER() over (PARTITION BY country_id ORDER BY cust_credit_limit DESC) AS rn
    from sh.customers
) 
where rn = 1;

--Show the difference between maximum and average credit limit per country.

select country_id, round(max(cust_credit_limit) - avg(cust_credit_limit), 2) as max_diff from sh.customers 
group by country_id

--Display the overall rank of each state based on its total credit limit (using GROUP BY + analytic rank).

select cust_state_province, 
       total_credit_limit,
       rank() over (order by total_credit_limit desc) as rank
from (
    select cust_state_province, 
           sum(cust_credit_limit) as total_credit_limit
    from sh.customers
    group by cust_state_province
) sub

