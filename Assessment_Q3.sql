-- Get the last confirmed inflow date for each plan

WITH last_inflow_plan AS (SELECT plan_id,
        MAX(transaction_date) AS last_transaction_date
    FROM savings_savingsaccount
    WHERE confirmed_amount > 0
    GROUP BY plan_id
),

-- Build the inactivity view by joining plans with last inflows
inactivity_plan AS (SELECT p.id AS plan_id,
    p.owner_id,
    CASE 
        WHEN p.is_regular_savings = TRUE THEN 'Savings'
        WHEN p.is_a_fund = TRUE THEN 'Investment'
        ELSE 'Unknown'
    END AS plan_type,
    lt.last_transaction_date,

-- Calculate number of days since last transaction
    DATEDIFF(CURDATE(), lt.last_transaction_date) AS inactivity_days
    FROM plans_plan p
    LEFT JOIN last_inflow_plan lt ON p.id = lt.plan_id
)

-- Select only plans that are inactive for over a year or never had a transaction
SELECT *
FROM inactivity_plan
WHERE last_transaction_date IS NULL OR inactivity_days > 365
ORDER BY inactivity_days DESC; -- Show longest inactive plans first