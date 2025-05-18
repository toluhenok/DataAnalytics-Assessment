
SELECT
    u.id AS customer_id, -- Unique ID for each user
    CONCAT(u.first_name, ' ', u.last_name) AS name,
    TIMESTAMPDIFF(MONTH, u.date_joined, CURDATE()) AS tenure_months,
    COUNT(s.id) AS total_transactions, -- Total inflow transactions for the customer

-- CLV formula is (total_transactions/tenure_months) * 12 * avg_profit_per_transaction
    ROUND(
        CASE
            WHEN TIMESTAMPDIFF(MONTH, u.date_joined, CURDATE()) > 0 THEN
            (COUNT(s.id) / TIMESTAMPDIFF(MONTH, u.date_joined, CURDATE())) * 12 * (0.001 * SUM(s.confirmed_amount) / COUNT(s.id)) -- Monthly average transactions
            ELSE 0 -- Avoid division by zero for users with less than 1 month tenure
        END, 2
    ) AS estimated_clv

FROM users_customuser u

LEFT JOIN savings_savingsaccount s ON s.owner_id = u.id AND s.confirmed_amount > 0 -- Only consider transactions with confirmed inflow

GROUP BY u.id, u.first_name, u.last_name, u.date_joined -- Group by customer identity

ORDER BY estimated_clv DESC; -- Show most valuable customers at the top