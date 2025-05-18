/*SELECT * FROM users_customuser LIMIT 5;
SELECT * FROM savings_savingsaccount LIMIT 5;
SELECT * FROM plans_plan LIMIT 5;
*/


/*DESCRIBE users_customuser;
DESCRIBE savings_savingsaccount;
DESCRIBE plans_plan;
*/


SELECT
    u.id AS owner_id, -- Unique customer ID

    CONCAT(u.first_name, ' ', u.last_name) AS name, -- Full name for readability
    
    -- Count distinct regular savings plans for each user
    COUNT(DISTINCT CASE WHEN p.is_regular_savings = TRUE THEN p.id END) AS savings_count,
    
     -- Count distinct investment plans for each user
    COUNT(DISTINCT CASE WHEN p.is_a_fund = TRUE THEN p.id END) AS investment_count,
    
     -- Sum of all confirmed deposits by the user
    COALESCE(SUM(s.confirmed_amount), 0) AS total_deposits

FROM users_customuser u
LEFT JOIN plans_plan p ON p.owner_id = u.id
LEFT JOIN savings_savingsaccount s ON s.owner_id = u.id
GROUP BY u.id, u.first_name, u.last_name

-- Only include users who have both at least one savings and one investment product
HAVING savings_count > 0 AND investment_count > 0

-- Prioritize customers with the highest total deposits
ORDER BY total_deposits DESC;