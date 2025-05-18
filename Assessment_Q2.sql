
/*SELECT * FROM users_customuser LIMIT 5;
SELECT * FROM savings_savingsaccount LIMIT 5;
SELECT * FROM plans_plan LIMIT 5;

DESCRIBE users_customuser;
DESCRIBE savings_savingsaccount;
DESCRIBE plans_plan;
*/

-- Calculate how many transactions each user makes per month
WITH user_transactions_per_month AS(
    SELECT
        s.owner_id,
        DATE_FORMAT(s.transaction_date, '%Y-%m') AS transaction_month,
        COUNT(*) AS transaction_count
    FROM savings_savingsaccount s
    GROUP BY s.owner_id, transaction_month
),

-- Calculate average monthly transactions for each user
avg_transactions_per_user AS (
    SELECT
        u.id AS owner_id,
        COALESCE(AVG(t.transaction_count), 0) AS avg_transaction_per_month
    FROM users_customuser u
    LEFT JOIN user_transactions_per_month t ON u.id = t.owner_id
    GROUP BY u.id
)

-- Categorize users based on their average monthly transaction count
    SELECT
        CASE
            WHEN avg_transaction_per_month >=10 THEN 'High Frequency'
            WHEN avg_transaction_per_month BETWEEN 3 AND 9 THEN 'Medium Frequency'
            ELSE 'Low Frequency'
        END AS frequency_category,
        COUNT(*) AS customer_count,
        ROUND(AVG(avg_transaction_per_month), 2) AS avg_transaction_per_month
    FROM avg_transactions_per_user
    GROUP BY frequency_category

-- Order categories logically from High → Low
    ORDER BY FIELD(frequency_category, 'High Frequency', 'Medium Frequency', 'Low Frequency');