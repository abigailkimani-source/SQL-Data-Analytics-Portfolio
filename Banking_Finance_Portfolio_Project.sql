-- ============================================================
--   BANKING & FINANCE ANALYTICS PORTFOLIO PROJECT
--   Author: Abigail Kimani
--   Tools: SQL Server (SSMS)
--   Skills: SELECT, Filtering, JOINs, CTEs, Subqueries, CASE
--   Description: Analysing customer transactions, detecting fraud,
--                scoring loan risk & measuring branch performance
-- ============================================================


-- ============================================================
-- SECTION 1: DATABASE & TABLE SETUP 
-- ============================================================

CREATE DATABASE BankingAnalytics;
GO

USE BankingAnalytics;
GO

-- Customers Table
CREATE TABLE Customers (
    customer_id       INT PRIMARY KEY,
    full_name         NVARCHAR(100),
    gender            NVARCHAR(10),
    date_of_birth     DATE,
    country           NVARCHAR(50),
    city              NVARCHAR(50),
    occupation        NVARCHAR(100),
    annual_income     DECIMAL(12,2),
    customer_since    DATE
);

-- Branches Table
CREATE TABLE Branches (
    branch_id         INT PRIMARY KEY,
    branch_name       NVARCHAR(100),
    city              NVARCHAR(50),
    country           NVARCHAR(50),
    branch_type       NVARCHAR(50)   -- Urban, Rural, Digital
);

-- Accounts Table
CREATE TABLE Accounts (
    account_id        INT PRIMARY KEY,
    customer_id       INT FOREIGN KEY REFERENCES Customers(customer_id),
    branch_id         INT FOREIGN KEY REFERENCES Branches(branch_id),
    account_type      NVARCHAR(50),  -- Savings, Current, Fixed Deposit
    account_status    NVARCHAR(20),  -- Active, Dormant, Closed
    open_date         DATE,
    current_balance   DECIMAL(12,2)
);

-- Transactions Table
CREATE TABLE Transactions (
    transaction_id    INT PRIMARY KEY,
    account_id        INT FOREIGN KEY REFERENCES Accounts(account_id),
    transaction_date  DATE,
    transaction_type  NVARCHAR(50),  -- Deposit, Withdrawal, Transfer, Payment
    amount            DECIMAL(12,2),
    channel           NVARCHAR(50),  -- ATM, Mobile, Branch, Online
    location          NVARCHAR(100),
    is_flagged        BIT            -- 1 = Suspicious, 0 = Normal
);

-- Loans Table
CREATE TABLE Loans (
    loan_id           INT PRIMARY KEY,
    customer_id       INT FOREIGN KEY REFERENCES Customers(customer_id),
    branch_id         INT FOREIGN KEY REFERENCES Branches(branch_id),
    loan_type         NVARCHAR(50),  -- Personal, Mortgage, Business, Auto
    loan_amount       DECIMAL(12,2),
    interest_rate     DECIMAL(5,2),
    loan_start_date   DATE,
    loan_end_date     DATE,
    monthly_payment   DECIMAL(10,2),
    loan_status       NVARCHAR(50),  -- Active, Paid Off, Defaulted
    missed_payments   INT
);
GO


-- ============================================================
-- SECTION 2: INSERT SAMPLE DATA
-- ============================================================

INSERT INTO Customers VALUES
(1,  'James Mwangi',      'Male',   '1980-03-15', 'Kenya',     'Nairobi',    'Engineer',         85000.00,  '2015-06-01'),
(2,  'Sarah Johnson',     'Female', '1992-07-22', 'USA',       'New York',   'Doctor',          120000.00,  '2018-03-15'),
(3,  'Carlos Mendes',     'Male',   '1975-11-08', 'Brazil',    'Sao Paulo',  'Business Owner',  200000.00,  '2010-01-20'),
(4,  'Amina Hassan',      'Female', '1988-05-30', 'Nigeria',   'Lagos',      'Accountant',       65000.00,  '2019-07-10'),
(5,  'Liam Chen',         'Male',   '2001-01-14', 'China',     'Shanghai',   'Student',           8000.00,  '2022-09-01'),
(6,  'Fatima Al-Sayed',   'Female', '1965-09-25', 'UAE',       'Dubai',      'Investor',        500000.00,  '2008-04-15'),
(7,  'Noah Williams',     'Male',   '1995-04-18', 'UK',        'London',     'Software Dev',     95000.00,  '2020-11-30'),
(8,  'Grace Osei',        'Female', '1970-12-03', 'Ghana',     'Accra',      'Teacher',          25000.00,  '2012-08-22'),
(9,  'Ivan Petrov',       'Male',   '1983-06-27', 'Russia',    'Moscow',     'Lawyer',           110000.00, '2016-02-14'),
(10, 'Mei Tanaka',        'Female', '1999-08-11', 'Japan',     'Tokyo',      'Analyst',          55000.00,  '2021-05-07'),
(11, 'David Kimani',      'Male',   '1955-02-19', 'Kenya',     'Mombasa',    'Retired',          18000.00,  '2005-03-10'),
(12, 'Emma Rossi',        'Female', '1978-10-07', 'Italy',     'Milan',      'Fashion Designer', 75000.00,  '2014-09-25'),
(13, 'Omar Farooq',       'Male',   '1990-03-23', 'Pakistan',  'Karachi',    'Trader',           90000.00,  '2017-12-05'),
(14, 'Aisha Diallo',      'Female', '1968-07-14', 'Senegal',   'Dakar',      'Nurse',            30000.00,  '2011-06-18'),
(15, 'Lucas Dupont',      'Male',   '1985-11-30', 'France',    'Paris',      'Chef',             48000.00,  '2016-07-22');

INSERT INTO Branches VALUES
(1, 'Nairobi Central Branch',  'Nairobi',   'Kenya',   'Urban'),
(2, 'Lagos Main Branch',       'Lagos',     'Nigeria', 'Urban'),
(3, 'London City Branch',      'London',    'UK',      'Urban'),
(4, 'Digital Banking Hub',     'Online',    'Global',  'Digital'),
(5, 'Dubai Financial Branch',  'Dubai',     'UAE',     'Urban'),
(6, 'Accra Community Branch',  'Accra',     'Ghana',   'Rural'),
(7, 'Tokyo Metro Branch',      'Tokyo',     'Japan',   'Urban');

INSERT INTO Accounts VALUES
(1001, 1,  1, 'Savings',        'Active',  '2015-06-01', 45000.00),
(1002, 2,  3, 'Current',        'Active',  '2018-03-15', 120000.00),
(1003, 3,  4, 'Fixed Deposit',  'Active',  '2010-01-20', 500000.00),
(1004, 4,  2, 'Savings',        'Active',  '2019-07-10', 12000.00),
(1005, 5,  7, 'Savings',        'Active',  '2022-09-01', 3500.00),
(1006, 6,  5, 'Fixed Deposit',  'Active',  '2008-04-15', 1500000.00),
(1007, 7,  3, 'Current',        'Active',  '2020-11-30', 85000.00),
(1008, 8,  6, 'Savings',        'Dormant', '2012-08-22', 800.00),
(1009, 9,  4, 'Current',        'Active',  '2016-02-14', 220000.00),
(1010, 10, 7, 'Savings',        'Active',  '2021-05-07', 28000.00),
(1011, 11, 1, 'Savings',        'Dormant', '2005-03-10', 200.00),
(1012, 12, 4, 'Current',        'Active',  '2014-09-25', 67000.00),
(1013, 13, 4, 'Current',        'Active',  '2017-12-05', 95000.00),
(1014, 14, 6, 'Savings',        'Active',  '2011-06-18', 4500.00),
(1015, 15, 4, 'Savings',        'Active',  '2016-07-22', 22000.00);

INSERT INTO Transactions VALUES
(1,  1001, '2023-01-05', 'Deposit',    5000.00,  'Branch',  'Nairobi',    0),
(2,  1001, '2023-01-15', 'Withdrawal', 1200.00,  'ATM',     'Nairobi',    0),
(3,  1002, '2023-01-20', 'Deposit',    15000.00, 'Online',  'New York',   0),
(4,  1003, '2023-02-01', 'Transfer',   50000.00, 'Online',  'Sao Paulo',  0),
(5,  1004, '2023-02-10', 'Deposit',    2000.00,  'Mobile',  'Lagos',      0),
(6,  1005, '2023-02-14', 'Withdrawal', 500.00,   'ATM',     'Shanghai',   0),
(7,  1006, '2023-03-01', 'Deposit',    200000.00,'Branch',  'Dubai',      0),
(8,  1006, '2023-03-05', 'Transfer',   150000.00,'Online',  'Dubai',      1), -- Flagged
(9,  1007, '2023-03-10', 'Payment',    3200.00,  'Online',  'London',     0),
(10, 1008, '2023-03-15', 'Withdrawal', 800.00,   'ATM',     'Accra',      0),
(11, 1009, '2023-04-01', 'Deposit',    30000.00, 'Branch',  'Moscow',     0),
(12, 1009, '2023-04-03', 'Transfer',   25000.00, 'Online',  'Unknown',    1), -- Flagged
(13, 1010, '2023-04-15', 'Deposit',    4000.00,  'Mobile',  'Tokyo',      0),
(14, 1011, '2023-05-01', 'Withdrawal', 200.00,   'ATM',     'Mombasa',    0),
(15, 1012, '2023-05-10', 'Deposit',    10000.00, 'Branch',  'Milan',      0),
(16, 1013, '2023-05-20', 'Transfer',   45000.00, 'Online',  'Karachi',    1), -- Flagged
(17, 1013, '2023-05-21', 'Withdrawal', 20000.00, 'ATM',     'Unknown',    1), -- Flagged
(18, 1014, '2023-06-05', 'Deposit',    1500.00,  'Mobile',  'Dakar',      0),
(19, 1015, '2023-06-15', 'Payment',    2000.00,  'Online',  'Paris',      0),
(20, 1001, '2023-06-20', 'Deposit',    8000.00,  'Branch',  'Nairobi',    0),
(21, 1002, '2023-07-01', 'Withdrawal', 5000.00,  'ATM',     'New York',   0),
(22, 1006, '2023-07-10', 'Transfer',   300000.00,'Online',  'Unknown',    1), -- Flagged
(23, 1007, '2023-07-15', 'Deposit',    12000.00, 'Branch',  'London',     0),
(24, 1009, '2023-08-01', 'Withdrawal', 15000.00, 'ATM',     'Unknown',    1), -- Flagged
(25, 1010, '2023-08-10', 'Deposit',    6000.00,  'Mobile',  'Tokyo',      0);

INSERT INTO Loans VALUES
(201, 1,  1, 'Personal',  50000.00,  12.5, '2022-01-01', '2025-01-01', 1500.00, 'Active',    0),
(202, 2,  3, 'Mortgage',  350000.00,  6.8, '2020-06-01', '2040-06-01', 2200.00, 'Active',    0),
(203, 3,  4, 'Business',  200000.00,  9.5, '2021-03-15', '2026-03-15', 3800.00, 'Active',    0),
(204, 4,  2, 'Personal',  15000.00,  18.0, '2022-09-01', '2024-09-01',  750.00, 'Active',    2),
(205, 5,  7, 'Personal',   5000.00,  20.0, '2023-01-01', '2024-01-01',  460.00, 'Defaulted', 5),
(206, 6,  5, 'Business',  500000.00,  7.5, '2019-01-01', '2029-01-01', 5900.00, 'Active',    0),
(207, 7,  3, 'Auto',       35000.00, 10.0, '2021-08-01', '2025-08-01',  750.00, 'Active',    0),
(208, 8,  6, 'Personal',    8000.00, 22.0, '2021-05-01', '2023-05-01',  410.00, 'Defaulted', 8),
(209, 9,  4, 'Business',  150000.00,  8.5, '2020-11-01', '2025-11-01', 3000.00, 'Active',    1),
(210, 10, 7, 'Auto',       25000.00, 11.0, '2022-03-01', '2026-03-01',  580.00, 'Active',    0),
(211, 11, 1, 'Personal',   10000.00, 24.0, '2020-01-01', '2022-01-01',  530.00, 'Defaulted', 12),
(212, 12, 4, 'Mortgage',  180000.00,  7.2, '2018-06-01', '2038-06-01', 1300.00, 'Active',    0),
(213, 13, 4, 'Business',   75000.00, 13.0, '2021-07-01', '2024-07-01', 2500.00, 'Active',    3),
(214, 14, 6, 'Personal',    6000.00, 21.0, '2022-02-01', '2024-02-01',  320.00, 'Paid Off',  0),
(215, 15, 4, 'Auto',       20000.00, 10.5, '2022-10-01', '2025-10-01',  480.00, 'Active',    0);
GO


-- ============================================================
-- SECTION 3: ANALYSIS QUERIES
-- ============================================================


-- ============================================================
-- QUERY 1: Customer Wealth Segmentation
-- Skill: SELECT + CASE + Aggregation
-- Business Question: How do we classify our customers by wealth?
-- ============================================================

SELECT 
    c.full_name,
    c.occupation,
    c.country,
    c.annual_income,
    a.account_type,
    a.current_balance,
    CASE 
        WHEN a.current_balance >= 500000  THEN 'Platinum 💎'
        WHEN a.current_balance >= 100000  THEN 'Gold 🥇'
        WHEN a.current_balance >= 20000   THEN 'Silver 🥈'
        ELSE                                   'Standard 🥉'
    END AS wealth_segment,
    DATEDIFF(YEAR, c.customer_since, GETDATE()) AS years_as_customer
FROM Customers c
JOIN Accounts a ON c.customer_id = a.customer_id
WHERE a.account_status = 'Active'
ORDER BY a.current_balance DESC;


-- ============================================================
-- QUERY 2: Branch Performance Analysis
-- Skill: JOIN + Aggregation
-- Business Question: Which branches hold the most deposits & customers?
-- ============================================================

SELECT 
    b.branch_name,
    b.country,
    b.branch_type,
    COUNT(DISTINCT a.customer_id)       AS total_customers,
    COUNT(a.account_id)                 AS total_accounts,
    SUM(a.current_balance)              AS total_deposits,
    ROUND(AVG(a.current_balance), 2)    AS avg_account_balance,
    COUNT(CASE WHEN a.account_status = 'Dormant' THEN 1 END) AS dormant_accounts
FROM Branches b
JOIN Accounts a ON b.branch_id = a.branch_id
GROUP BY b.branch_name, b.country, b.branch_type
ORDER BY total_deposits DESC;


-- ============================================================
-- QUERY 3: Transaction Volume by Channel
-- Skill: JOIN + Aggregation + CASE
-- Business Question: Which channels do customers prefer for banking?
-- ============================================================

SELECT 
    t.channel,
    COUNT(t.transaction_id)             AS total_transactions,
    SUM(t.amount)                       AS total_amount,
    ROUND(AVG(t.amount), 2)             AS avg_transaction_amount,
    COUNT(CASE WHEN t.is_flagged = 1 
               THEN 1 END)              AS flagged_transactions
FROM Transactions t
GROUP BY t.channel
ORDER BY total_transactions DESC;


-- ============================================================
-- QUERY 4: 🚨 FRAUD DETECTION — Flagged Transactions
-- Skill: JOIN + Filtering + CASE
-- Business Question: Which customers have suspicious transactions?
-- ============================================================

SELECT 
    c.full_name,
    c.country,
    c.occupation,
    a.account_type,
    t.transaction_date,
    t.transaction_type,
    t.amount,
    t.channel,
    t.location,
    CASE 
        WHEN t.amount > 100000          THEN 'Large Amount 🚨'
        WHEN t.location = 'Unknown'     THEN 'Unknown Location 🚨'
        ELSE                                 'Review Needed ⚠️'
    END AS fraud_reason
FROM Transactions t
JOIN Accounts a     ON t.account_id  = a.account_id
JOIN Customers c    ON a.customer_id = c.customer_id
WHERE t.is_flagged = 1
ORDER BY t.amount DESC;


-- ============================================================
-- QUERY 5: Loan Default Risk Scoring
-- Skill: JOIN + CASE + Aggregation
-- Business Question: Which customers are at risk of defaulting?
-- ============================================================

SELECT 
    c.full_name,
    c.country,
    c.annual_income,
    l.loan_type,
    l.loan_amount,
    l.interest_rate,
    l.monthly_payment,
    l.missed_payments,
    l.loan_status,
    ROUND(l.loan_amount / NULLIF(c.annual_income, 0) * 100, 1) AS debt_to_income_pct,
    CASE 
        WHEN l.loan_status = 'Defaulted'                        THEN 'Defaulted 🔴'
        WHEN l.missed_payments >= 3                             THEN 'High Risk 🚨'
        WHEN l.missed_payments BETWEEN 1 AND 2                  THEN 'Medium Risk ⚠️'
        ELSE                                                         'Low Risk ✅'
    END AS risk_level
FROM Loans l
JOIN Customers c ON l.customer_id = c.customer_id
ORDER BY l.missed_payments DESC, debt_to_income_pct DESC;


-- ============================================================
-- QUERY 6: Monthly Transaction Trends
-- Skill: Date Functions + Aggregation
-- Business Question: How is transaction volume trending month over month?
-- ============================================================

SELECT 
    YEAR(t.transaction_date)                    AS year,
    MONTH(t.transaction_date)                   AS month_number,
    DATENAME(MONTH, t.transaction_date)         AS month_name,
    COUNT(t.transaction_id)                     AS total_transactions,
    SUM(t.amount)                               AS total_volume,
    COUNT(CASE WHEN t.is_flagged = 1 THEN 1 END) AS fraud_alerts,
    ROUND(AVG(t.amount), 2)                     AS avg_transaction
FROM Transactions t
GROUP BY YEAR(t.transaction_date), MONTH(t.transaction_date), 
         DATENAME(MONTH, t.transaction_date)
ORDER BY year, month_number;


-- ============================================================
-- QUERY 7: CTE — High Value Customers at Risk
-- Skill: CTE + JOIN + Subquery
-- Business Question: Which wealthy customers also have risky loans?
-- ============================================================

WITH WealthyCustomers AS (
    SELECT 
        c.customer_id,
        c.full_name,
        c.annual_income,
        c.country,
        a.current_balance,
        CASE 
            WHEN a.current_balance >= 500000 THEN 'Platinum 💎'
            WHEN a.current_balance >= 100000 THEN 'Gold 🥇'
            ELSE                                  'Silver 🥈'
        END AS wealth_tier
    FROM Customers c
    JOIN Accounts a ON c.customer_id = a.customer_id
    WHERE a.current_balance >= 20000
),
RiskyLoans AS (
    SELECT 
        customer_id,
        loan_type,
        loan_amount,
        missed_payments,
        loan_status
    FROM Loans
    WHERE missed_payments > 0 OR loan_status = 'Defaulted'
)
SELECT 
    wc.full_name,
    wc.country,
    wc.wealth_tier,
    wc.current_balance,
    rl.loan_type,
    rl.loan_amount,
    rl.missed_payments,
    rl.loan_status,
    'Immediate Attention Required ⚠️' AS action_needed
FROM WealthyCustomers wc
JOIN RiskyLoans rl ON wc.customer_id = rl.customer_id
ORDER BY wc.current_balance DESC;


-- ============================================================
-- QUERY 8: CTE — Customer Loyalty & Lifetime Value
-- Skill: CTE + Date Functions + Aggregation
-- Business Question: Who are our most loyal & valuable customers?
-- ============================================================

WITH CustomerValue AS (
    SELECT 
        c.customer_id,
        c.full_name,
        c.country,
        c.occupation,
        DATEDIFF(YEAR, c.customer_since, GETDATE())     AS years_with_bank,
        a.current_balance,
        COUNT(t.transaction_id)                         AS total_transactions,
        SUM(t.amount)                                   AS total_transaction_volume,
        COUNT(l.loan_id)                                AS total_loans,
        SUM(l.loan_amount)                              AS total_loan_value
    FROM Customers c
    JOIN Accounts a      ON c.customer_id  = a.customer_id
    LEFT JOIN Transactions t ON a.account_id = t.account_id
    LEFT JOIN Loans l    ON c.customer_id  = l.customer_id
    GROUP BY c.customer_id, c.full_name, c.country, c.occupation,
             c.customer_since, a.current_balance
)
SELECT 
    full_name,
    country,
    occupation,
    years_with_bank,
    current_balance,
    total_transactions,
    total_loans,
    ISNULL(total_loan_value, 0)     AS total_loan_value,
    CASE 
        WHEN years_with_bank >= 10 
             AND current_balance >= 50000   THEN 'VIP Customer 👑'
        WHEN years_with_bank >= 5  
             AND current_balance >= 10000   THEN 'Loyal Customer ⭐'
        ELSE                                     'Regular Customer'
    END AS customer_category
FROM CustomerValue
ORDER BY years_with_bank DESC, current_balance DESC;


-- ============================================================
-- QUERY 9: Loan Portfolio Analysis by Type
-- Skill: Aggregation + Subquery
-- Business Question: What is the bank's loan exposure by type?
-- ============================================================

SELECT 
    l.loan_type,
    COUNT(l.loan_id)                                            AS total_loans,
    SUM(l.loan_amount)                                          AS total_exposure,
    ROUND(AVG(l.interest_rate), 2)                              AS avg_interest_rate,
    COUNT(CASE WHEN l.loan_status = 'Defaulted'  THEN 1 END)   AS defaults,
    COUNT(CASE WHEN l.loan_status = 'Active'     THEN 1 END)   AS active_loans,
    COUNT(CASE WHEN l.loan_status = 'Paid Off'   THEN 1 END)   AS paid_off,
    ROUND(COUNT(CASE WHEN l.loan_status = 'Defaulted' THEN 1 END) * 100.0
          / COUNT(l.loan_id), 1)                                AS default_rate_pct,
    ROUND(SUM(l.loan_amount) 
          / (SELECT SUM(loan_amount) FROM Loans) * 100, 2)     AS portfolio_share_pct
FROM Loans l
GROUP BY l.loan_type
ORDER BY total_exposure DESC;


-- ============================================================
-- QUERY 10: EXECUTIVE DASHBOARD — Full Bank Summary
-- Skill: Multiple CTEs chained together
-- Business Question: Give the CEO a complete bank overview
-- ============================================================

WITH
TotalCustomers AS (
    SELECT COUNT(*) AS total FROM Customers
),
TotalDeposits AS (
    SELECT SUM(current_balance) AS total FROM Accounts 
    WHERE account_status = 'Active'
),
TotalLoanBook AS (
    SELECT SUM(loan_amount) AS total FROM Loans 
    WHERE loan_status = 'Active'
),
DefaultedLoans AS (
    SELECT COUNT(*) AS total FROM Loans 
    WHERE loan_status = 'Defaulted'
),
FraudAlerts AS (
    SELECT COUNT(*) AS total FROM Transactions 
    WHERE is_flagged = 1
),
TopBranch AS (
    SELECT TOP 1 b.branch_name, SUM(a.current_balance) AS deposits
    FROM Branches b
    JOIN Accounts a ON b.branch_id = a.branch_id
    GROUP BY b.branch_name
    ORDER BY deposits DESC
),
DormantAccounts AS (
    SELECT COUNT(*) AS total FROM Accounts 
    WHERE account_status = 'Dormant'
)
SELECT 
    tc.total                AS total_customers,
    td.total                AS total_deposits,
    tl.total                AS active_loan_book,
    ROUND(tl.total / NULLIF(td.total,0) * 100, 1) AS loan_to_deposit_ratio_pct,
    dl.total                AS defaulted_loans,
    fa.total                AS fraud_alerts,
    tb.branch_name          AS top_branch_by_deposits,
    da.total                AS dormant_accounts
FROM TotalCustomers tc, TotalDeposits td, TotalLoanBook tl,
     DefaultedLoans dl, FraudAlerts fa, TopBranch tb, DormantAccounts da;
