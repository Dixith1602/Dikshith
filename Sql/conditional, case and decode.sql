--Categorize customers into income tiers: Platinum, Gold, Silver, Bronze.

SELECT 
    cust_id,
    cust_first_name,
    cust_last_name,
    cust_credit_limit,
    CASE
        WHEN cust_credit_limit < 3000 THEN 'Bronze'
        WHEN cust_credit_limit < 6000 THEN 'Silver'
        WHEN cust_credit_limit < 9000 THEN 'Gold'
        ELSE 'Platinum'
    END AS tier
FROM sh.customers;

--Display “High”, “Medium”, or “Low” income categories based on credit limit.

SELECT 
    cust_id,
    cust_first_name,
    cust_last_name,
    cust_credit_limit,
    CASE
        when CUST_CREDIT_LIMIT < 3000 then 'Low'
        when CUST_CREDIT_LIMIT < 6000 then 'Medium'
        else 'High'
    END AS tier
FROM sh.customers;

--Replace NULL income levels with “Unknown” using NVL.

select 
    cust_id,
    nvl(cust_income_level, 'Unknown') as non_value
from sh.customers;

--Show customer details and mark whether they have above-average credit limit or not.

select
    cust_id,
    cust_credit_limit,
    round(avg(cust_credit_limit) over(), 2) as overall_avg,
    case
        when cust_credit_limit > avg(CUST_CREDIT_LIMIT) over() then 'Above average'
        else 'Below average'
    end as average
from sh.customers

--Use DECODE to convert marital status codes (S/M/D) into full text.

select
    cust_id,
    cust_gender,
    cust_marital_status,
    decode(cust_marital_status,
    'divorced', 'd',
    'single', 's',
    'married', 'm'
    )
from sh.customers

--Use CASE to show age group (≤30, 31–50, >50) from CUST_YEAR_OF_BIRTH.

select
    cust_id,
    cust_year_of_birth,
    case
        when cust_year_of_birth < 30 then 'Young'
        when cust_year_of_birth >=30 and cust_year_of_birth < 50 then 'Middle aged'
        else 'Old aged'
    end as ages
from sh.customers
order by CUST_YEAR_OF_BIRTH desc

--Label customers as “Old Credit Holder” or “New Credit Holder” based on year of birth < 1980.

select 
    cust_id,
    cust_year_of_birth,
    case
        when cust_year_of_birth > 1980 then 'New credit holder'
        else 'Old credit holder'
    end as Credit_holder
from sh.customers
	
--Create a loyalty tag — “Premium” if credit limit > 50,000 and income_level = ‘E’.

select
    cust_id,
    cust_credit_limit,
    cust_income_level,
    case
        when cust_credit_limit > 5000 and cust_income_level = 'E: 90,000 - 109,999' then 'Premium'
        else 'Standard'
    end as tagging
from sh.customers

--Assign grades (A–F) based on credit limit range using CASE.

SELECT
    cust_id,
    cust_first_name,
    cust_credit_limit,
    CASE
        WHEN cust_credit_limit >= 12500 THEN 'A'
        WHEN cust_credit_limit >= 10000 THEN 'B'
        WHEN cust_credit_limit >= 7500 THEN 'C'
        WHEN cust_credit_limit >= 5000 THEN 'D'
        WHEN cust_credit_limit >= 2500 THEN 'E'
        ELSE 'F'
    END AS grade
FROM sh.customers;

--Show country, state, and number of premium customers using conditional aggregation.

SELECT
    country_id,
    cust_state_province,
    COUNT(*) AS total_customers,
    COUNT(CASE 
              WHEN cust_credit_limit > 5000 
                   AND cust_income_level = 'E: 50,000 - 109,999' 
              THEN 1 
          END) AS premium_customers
FROM sh.customers
GROUP BY country_id, cust_state_province
ORDER BY country_id, cust_state_province;
