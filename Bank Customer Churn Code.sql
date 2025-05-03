-- To create a table
CREATE TABLE bank_customer_churn (
	rownumber INTEGER,
	customerid INTEGER,
	surname VARCHAR(255),
	creditscore INTEGER,
	geography VARCHAR(50),
	gender VARCHAR(50),
	age INTEGER,
	tenure INTEGER,
	balance DECIMAL(15, 2),
	numofproducts INTEGER,
	hascrcard BOOLEAN,
	isactivemember BOOLEAN,
	estimatedsalary DECIMAL(15, 2),
	exited BOOLEAN,
	complain BOOLEAN,
	satisfaction_score INTEGER,
	card_type VARCHAR(50),
	point_earned INTEGER
)


-- To load table
COPY bank_customer_churn FROM '/Library/PostgreSQL/17/project_data/Customer-Churn-Records.csv' WITH (FORMAT CSV, HEADER, DELIMITER ',')


-- To test the data loaded into table
SELECT *
FROM bank_customer_churn
LIMIT 10


-- To drop table
DROP TABLE bank_customer_churn


-- What is the overall churn rate within the customer base?
SELECT
    ROUND(CAST(SUM(CASE WHEN exited = TRUE THEN 1 ELSE 0 END) AS DECIMAL(10, 2)) * 100 / COUNT(*), 1) AS overall_churn_rate
FROM
    bank_customer_churn


-- What differences are there in churn rates across different demographic groups (gender, age, and estimated salary)?
-- Churn rate by Gender
SELECT
    gender,
    ROUND(CAST(SUM(CASE WHEN exited = TRUE THEN 1 ELSE 0 END) AS DECIMAL(10, 2)) * 100 / COUNT(*), 1) AS churn_rate
FROM
    bank_customer_churn
GROUP BY
    gender

-- Churn rate by Age Group
SELECT
    CASE
        WHEN age BETWEEN 0 AND 20 THEN '0-20'
        WHEN age BETWEEN 20 AND 40 THEN '20-40'
        WHEN age BETWEEN 40 AND 60 THEN '40-60'
        WHEN age > 60 THEN '60+'
        ELSE 'Unknown'
    END AS age_group,
    ROUND(CAST(SUM(CASE WHEN exited = TRUE THEN 1 ELSE 0 END) AS DECIMAL(10, 2)) * 100 / COUNT(*), 1) AS churn_rate
FROM
    bank_customer_churn
GROUP BY
    age_group
ORDER BY
    age_group

-- Churn rate by Estimated Salary Range
SELECT
    CASE
        WHEN estimatedsalary BETWEEN 0 AND 50000 THEN '0-50000'
        WHEN estimatedsalary BETWEEN 50001 AND 100000 THEN '50001-100000'
        WHEN estimatedsalary BETWEEN 100001 AND 150000 THEN '100001-150000'
        WHEN estimatedsalary > 150000 THEN '150001+'
        ELSE 'Unknown'
    END AS salary_group,
    ROUND(CAST(SUM(CASE WHEN exited = TRUE THEN 1 ELSE 0 END) AS DECIMAL(10, 2)) * 100 / COUNT(*), 1) AS churn_rate
FROM
    bank_customer_churn
GROUP BY
    salary_group
ORDER BY
    salary_group


-- How do customer account behaviors, such as tenure, account balance, and the number of products held, relate to their likelihood of churning?
-- Churn rate by Tenure
SELECT
    tenure,
    ROUND(CAST(SUM(CASE WHEN exited = TRUE THEN 1 ELSE 0 END) AS DECIMAL(10, 2)) * 100 / COUNT(*), 1) AS churn_rate
FROM
    bank_customer_churn
GROUP BY
    tenure
ORDER BY
    tenure

-- Average Balance for Churned vs. Non-Churned Customers
SELECT
    exited,
    ROUND(AVG(balance), 0) AS average_balance
FROM
    bank_customer_churn
GROUP BY
    exited

-- Churn rate by Number of Products Held
SELECT
    numofproducts,
    ROUND(CAST(SUM(CASE WHEN exited = TRUE THEN 1 ELSE 0 END) AS DECIMAL(10, 2)) * 100 / COUNT(*), 1) AS churn_rate
FROM
    bank_customer_churn
GROUP BY
    numofproducts
ORDER BY
    numofproducts

-- How do credit card behaviors, including having a credit card, credit score, card type, and credit points earned, relate to the likelihood of customer churn?
-- Churn rate by Credit Card Ownership
SELECT
    hascrcard,
    ROUND(CAST(SUM(CASE WHEN exited = TRUE THEN 1 ELSE 0 END) AS DECIMAL(10, 2)) * 100 / COUNT(*), 1) AS churn_rate
FROM
    bank_customer_churn
GROUP BY
    hascrcard

-- Average Credit Score for Churned vs. Non-Churned Customers
SELECT
    exited,
    ROUND(AVG(creditscore), 0) AS average_credit_score
FROM
    bank_customer_churn
GROUP BY
    exited

-- Churn rate by Card Type
SELECT
    card_type,
    ROUND(CAST(SUM(CASE WHEN exited = TRUE THEN 1 ELSE 0 END) AS DECIMAL(10, 2)) * 100 / COUNT(*), 1) AS churn_rate
FROM
    bank_customer_churn
GROUP BY
    card_type

-- Average Credit Points Earned for Churned vs. Non-Churned Customers
SELECT
    exited,
    ROUND(AVG(point_earned), 0) AS average_point_earned
FROM
    bank_customer_churn
GROUP BY
    exited


-- What is the relationship between customer complaints, satisfaction scores, and churn levels?
-- Churn rate for customers who filed a complaint vs. those who didn't
SELECT
    complain,
    ROUND(CAST(SUM(CASE WHEN exited = TRUE THEN 1 ELSE 0 END) AS DECIMAL(10, 2)) * 100 / COUNT(*), 1) AS churn_rate
FROM
    bank_customer_churn
GROUP BY
    complain

-- Average Satisfaction Score for Churned vs. Non-Churned Customers
SELECT
    exited,
    ROUND(AVG(satisfaction_score), 1) AS average_satisfaction_score
FROM
    bank_customer_churn
GROUP BY
    exited