# Data Analyst Assessment (CowryWise)

This assessment contains a series of SQL queries used to analyze customer behavior and financial activity from the adashi_staging dataset consisting of `users_customuser`, `savings_savingsaccount`, `plans_plan` and `withdrawals_withdrawal` tables.

## 📁 Three tables were used in this Assessment

- `users_customuser`: This table contains customer demographic and contact information
- `savings_savingsaccount`: This table contains records of deposit transactions
- `plans_plan`: records of plans created by customers

---

## ✅ Per-Question Explanations

### 1. High-Value Customers with Multiple Products

**Goal**: Identify customers with both a funded savings and a funded investment plan, sorted by total deposits.

**Approach**:
- This shows high-value customers who have engaged with multiple products. The customer details from the users_customuser table was selected, combining their first and last names for readability. It then joins with the plans_plan table to count how many distinct savings plans and investment plans each customer holds. Additionally, it joins with the savings_savingsaccount table to sum the total confirmed deposits (confirmed_amount) made by each customer. The use of COALESCE ensures that customers with no deposits are shown with a zero value rather than null. The query filters results to include only those customers who have at least one savings plan and one investment plan, making them eligible for cross-selling opportunities. Finally, the results are ordered by total deposits in descending order.
---

### 2. Transaction Frequency Analysis

**Goal**: Categorize users by how frequently they transact per month.

**Approach**:
- This was approached by calculating the number of transactions per user per month using the savings_savingsaccount table. Then, it computes the average monthly transactions per user. Based on this average, users are categorized into frequency groups: "High Frequency" for those with 10 or more transactions per month, "Medium Frequency" for 3 to 9, and "Low Frequency" for 2 or fewer. The final output groups these categories and shows how many customers fall into each group along with their average transaction volume.
---

### 3. Account Inactivity Alert

**Goal**: Find all active accounts with no transactions in the last 1 year (365 days).

**Approach**:
- The approach begins by selecting the most recent inflow transaction date for each plan using the savings_savingsaccount table. It then joins this data with the plans_plan table to classify the plan as either a "Savings" or "Investment" based on plan attributes. The number of inactive days is calculated using the current date and the last transaction date. Finally, plans that either have never had a deposit or have not had one in over a year were filtered.

---

### 4. Customer Lifetime Value (CLV) Estimation

**Goal**: Estimate each customer’s lifetime value using transaction volume and tenure.

**Approach**:
- The number of months since the customer joined (account tenure) using the date_joined field was first calculated, after which the number of inflow transactions from the savings_savingsaccount table was counted. For each customer, CLV is estimated using the simplified formula:

    CLV = (total_transactions / tenure_months) * 12 * avg_profit_per_transaction
    (Assuming avg_profit_per_transaction = 0.1% of transaction value)

LEFT JOIN was used to ensure customers with zero transactions are still included, and handled cases where tenure is zero to avoid division by zero. Results are sorted in descending order of estimated CLV to identify high-value customers.
