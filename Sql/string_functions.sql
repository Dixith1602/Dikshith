--Show customers whose first and last name start with the same letter.

select
    cust_first_name,
    cust_last_name
from sh.CUSTOMERS
where substr(cust_first_name, 1, 1) = substr(cust_last_name, 1, 1);

--Display full names in “Last, First” format.

select 
    cust_first_name,
    cust_last_name,
    cust_last_name || ', ' || cust_first_name as reverted_name
from sh.customers;

--Find customers whose last name ends with 'SON'.

select
    cust_last_name
from sh.CUSTOMERS
where cust_last_name like '%son';

--Display length of each customer’s full name.

select
    cust_first_name,
    cust_last_name,
    length(cust_first_name || cust_last_name)
from sh.CUSTOMERS

--Replace vowels in customer names with '*'.

select 
    cust_first_name,
    cust_last_name,
    cust_first_name || ' ' || cust_last_name as full_name,
    regexp_replace(cust_first_name || ' ' || cust_last_name, '[aeiouAEIOU]', '*')
from sh.CUSTOMERS

--Show customers whose income level description contains ‘90’.

select
    cust_income_level
from sh.CUSTOMERS
where cust_income_level like '%90%'

--Display initials of each customer (first letters of first and last name).

select
    cust_first_name,
    cust_last_name,
    substr(cust_first_name, 1, 1) || ' ' || substr(cust_last_name, 1, 1) as customer_initials
from sh.customers

--Concatenate city and state to create full address.

select  
    cust_city,
    cust_state_province,
    cust_city || ' ' || cust_state_province as full_address
from sh.customers

--Extract numeric value from income level using REGEXP_SUBSTR.

SELECT 
    cust_income_level,
    REGEXP_SUBSTR(cust_income_level, '\d+') AS numeric_value
FROM sh.customers;

--Count how many customers have a 3-letter first name.

select 
    cust_first_name 
from sh.customers
where CUST_FIRST_NAME like '___';
