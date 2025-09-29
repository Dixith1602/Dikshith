/*

# 25 Questions on GROUP BY and HAVING

26. Count the number of customers in each city.

select count(*) as Total_No_of_customers from sh.CUSTOMERS
group by CUST_CITY

27. Find cities with more than 100 customers.

select count(*), CUST_CITY from sh.CUSTOMERS
group by CUST_CITY
having count(*) > 100

28. Count the number of customers in each state.

select count(*), CUST_STATE_PROVINCE from sh.CUSTOMERS
group by CUST_STATE_PROVINCE

29. Find states with fewer than 50 customers.

select count(*), CUST_STATE_PROVINCE from sh.CUSTOMERS
group by CUST_STATE_PROVINCE
having count(*) < 50

30. Calculate the average credit limit of customers in each city.

select round(avg(CUST_CREDIT_LIMIT), 2) from sh.CUSTOMERS
group by CUST_CITY

31. Find cities with average credit limit greater than 8,000.

select cust_city, round(avg(CUST_CREDIT_LIMIT), 2) from sh.CUSTOMERS
group by CUST_CITY
having avg(CUST_CREDIT_LIMIT) > 8000

32. Count customers by marital status.

select count(*), CUST_MARITAL_STATUS from sh.CUSTOMERS
group by CUST_MARITAL_STATUS

33. Find marital statuses with more than 200 customers.

select count(*), CUST_MARITAL_STATUS from sh.CUSTOMERS
group by CUST_MARITAL_STATUS
having count(*) > 200

34. Calculate the average year of birth grouped by gender.

select round(avg(cust_year_of_birth), 2), cust_gender from sh.customers
group by cust_gender

35. Find genders with average year of birth after 1990.


36. Count the number of customers in each country.

select count(*), cust_city from sh.CUSTOMERS
group by cust_city

37. Find countries with more than 1,000 customers.


38. Calculate the total credit limit per state.

select sum(CUST_CREDIT_LIMIT), CUST_STATE_PROVINCE from sh.CUSTOMERS
group by CUST_STATE_PROVINCE

39. Find states where the total credit limit exceeds 100,000.

select sum(CUST_CREDIT_LIMIT), CUST_STATE_PROVINCE from sh.CUSTOMERS
group by CUST_STATE_PROVINCE
having sum(CUST_CREDIT_LIMIT) > 100000

40. Find the maximum credit limit for each income level.

select max(CUST_CREDIT_LIMIT), CUST_INCOME_LEVEL from sh.CUSTOMERS
group by CUST_INCOME_LEVEL

41. Find income levels where the maximum credit limit is greater than 15,000.

select max(CUST_CREDIT_LIMIT), CUST_INCOME_LEVEL from sh.CUSTOMERS
group by CUST_INCOME_LEVEL
having max(CUST_CREDIT_LIMIT) > 15000

42. Count customers by year of birth.

select count(*), cust_year_of_birth from sh.CUSTOMERS
group by CUST_YEAR_OF_BIRTH

43. Find years of birth with more than 50 customers.

select count(*), cust_year_of_birth from sh.CUSTOMERS
group by CUST_YEAR_OF_BIRTH
having count(*) > 50

44. Calculate the average credit limit per marital status.

select avg(cust_credit_limit), CUST_MARITAL_STATUS from sh.CUSTOMERS
group by CUST_MARITAL_STATUS

45. Find marital statuses with average credit limit less than 5,000.

select avg(cust_credit_limit), CUST_MARITAL_STATUS from sh.CUSTOMERS
group by CUST_MARITAL_STATUS
having avg(CUST_CREDIT_LIMIT) < 5000

46. Count the number of customers by email domain (e.g., `company.example.com`).


47. Find email domains with more than 300 customers.


48. Calculate the average credit limit by validity (`CUST_VALID`).

select avg(CUST_CREDIT_LIMIT), cust_valid from sh.CUSTOMERS
group by cust_valid

49. Find validity groups where the average credit limit is greater than 7,000.

select avg(CUST_CREDIT_LIMIT), cust_valid from sh.CUSTOMERS
group by cust_valid
having avg(CUST_CREDIT_LIMIT) > 7000

50. Count the number of customers per state and city combination where there are more than 50 customers.
*/