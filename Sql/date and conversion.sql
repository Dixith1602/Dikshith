/*

1. Convert CUST_YEAR_OF_BIRTH to age as of today.

select 
    cust_id,
    extract(year from sysdate) - cust_year_of_birth as age
from sh.customers
order by cust_id 

2. Display all customers born between 1980 and 1990.

select
    cust_id,
    cust_year_of_birth
from sh.customers 
where cust_year_of_birth between 1980 and 1990

3. Format must effective from into “Month YYYY” using TO_CHAR.

select 
    to_char(cust_eff_from, 'dd-mon-yyyy') 
from sh.customers

4. Convert income level text (like 'A: Below 30,000') to numeric lower limit.
5. Display customer birth decades (e.g., 1960s, 1970s).

select 
    cust_id,
    floor(cust_year_of_birth/10) * 10 || 's' as decades
from sh.customers

6. Show customers grouped by age bracket (10-year intervals).

select
    cust_id,
    cust_year_of_birth,
case
    when extract(year from sysdate) - cust_year_of_birth between 0 and 9 then '0 to 9'
    when extract(year from sysdate) - cust_year_of_birth between 10 and 19 then '10 to 19'
    when extract(year from sysdate) - cust_year_of_birth between 20 and 29 then '20 to 29'
    when extract(year from sysdate) - cust_year_of_birth between 30 and 39 then '30 to 39'
    when extract(year from sysdate) - cust_year_of_birth between 40 and 49 then '40 to 49'
    when extract(year from sysdate) - cust_year_of_birth between 50 and 59 then '50 to 59'
    when extract(year from sysdate) - cust_year_of_birth between 60 and 69 then '60 to 69'
    when extract(year from sysdate) - cust_year_of_birth between 70 and 79 then '70 to 79'
    when extract(year from sysdate) - cust_year_of_birth between 80 and 89 then '80 to 89'
    when extract(year from sysdate) - cust_year_of_birth between 90 and 99 then '90 to 99'
    else 
        '100 and More'
end as age_gap
from sh.customers;

7. Convert country_id to uppercase and state name to lowercase.

select 
    upper(country_id) as Upper_caps,
    lower(CUST_STATE_PROVINCE) as low_caps
from sh.customers

8. Show customers where credit limit > average of their birth decade.

WITH decade_avg AS (
    SELECT 
        FLOOR(cust_year_of_birth /10) *10 AS birth_decade,
        AVG(cust_credit_limit) AS avg_credit_limit
    FROM sh.CUSTOMERS 
    GROUP BY FLOOR(cust_year_of_birth /10) *10)
SELECT 
    c.cust_id,
    c.cust_year_of_birth,
    c.cust_credit_limit,
    d.birth_decade,
    round(d.avg_credit_limit, 2) as average
FROM sh.CUSTOMERS c
JOIN decade_avg d ON 
    FLOOR(c.cust_year_of_birth /10) *10 = d.birth_decade
    WHERE c.cust_credit_limit > d.avg_credit_limit;

9. Convert all numeric credit limits to currency format $999,999.00.

select
    CUST_CREDIT_LIMIT,
    to_char(cust_credit_limit, '$999,999.00’) as formatted_credit_limit
from sh.customers

10. Find customers whose credit limit was NULL and replace with average (using NVL).

select
    NVL(cust_credit_limit, (select avg(cust_credit_limit) from sh.customers)) as updated_credit_limit
from sh.customers
*/