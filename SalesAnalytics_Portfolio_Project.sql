-- ============================================================
--   SALES ANALYTICS PORTFOLIO PROJECT
--   Author: Abigail Kimani
--   Tools: SQL Server (SSMS)
--   Skills: SELECT, Filtering, JOINs, Aggregations, CTEs, Subqueries
--   Description: Analysing sales performance across regions,
--                products and customers to drive business decisions
-- ============================================================


-- ============================================================
-- SECTION 1: DATABASE & TABLE SETUP 
-- ============================================================

CREATE DATABASE SalesAnalytics;
GO

USE SalesAnalytics;
GO

-- Customers Table
CREATE TABLE Customers (
    customer_id     INT PRIMARY KEY,
    customer_name   NVARCHAR(100),
    country         NVARCHAR(50),
    segment         NVARCHAR(50)   -- Consumer, Corporate, Small Business
);

-- Products Table
CREATE TABLE Products (
    product_id      INT PRIMARY KEY,
    product_name    NVARCHAR(100),
    category        NVARCHAR(50),
    unit_price      DECIMAL(10,2)
);

-- Sales Reps Table
CREATE TABLE SalesReps (
    rep_id          INT PRIMARY KEY,
    rep_name        NVARCHAR(100),
    region          NVARCHAR(50)
);

-- Orders Table
CREATE TABLE Orders (
    order_id        INT PRIMARY KEY,
    customer_id     INT FOREIGN KEY REFERENCES Customers(customer_id),
    rep_id          INT FOREIGN KEY REFERENCES SalesReps(rep_id),
    order_date      DATE,
    ship_date       DATE,
    status          NVARCHAR(50)   -- Completed, Returned, Pending
);

-- Order Items Table
CREATE TABLE OrderItems (
    item_id         INT PRIMARY KEY,
    order_id        INT FOREIGN KEY REFERENCES Orders(order_id),
    product_id      INT FOREIGN KEY REFERENCES Products(product_id),
    quantity        INT,
    discount        DECIMAL(4,2),  -- e.g. 0.10 = 10% discount
    revenue         DECIMAL(10,2)
);
GO


-- ============================================================
-- SECTION 2: INSERT SAMPLE DATA
-- ============================================================

INSERT INTO Customers VALUES
(1,  'Alice Johnson',    'USA',     'Corporate'),
(2,  'Bob Smith',        'UK',      'Consumer'),
(3,  'Carlos Mendes',    'Brazil',  'Small Business'),
(4,  'Diana Prince',     'USA',     'Corporate'),
(5,  'Ethan Nkosi',      'Kenya',   'Small Business'),
(6,  'Fatima Al-Sayed',  'UAE',     'Corporate'),
(7,  'George Tan',       'Singapore','Consumer'),
(8,  'Hannah Müller',    'Germany', 'Consumer'),
(9,  'Ivan Petrov',      'Russia',  'Small Business'),
(10, 'Jane Osei',        'Ghana',   'Corporate');

INSERT INTO Products VALUES
(1,  'Laptop Pro 15',      'Electronics',  1200.00),
(2,  'Wireless Mouse',     'Electronics',    25.00),
(3,  'Office Chair',       'Furniture',     350.00),
(4,  'Standing Desk',      'Furniture',     600.00),
(5,  'Notebook Bundle',    'Stationery',     15.00),
(6,  'Monitor 27"',        'Electronics',   450.00),
(7,  'Mechanical Keyboard','Electronics',   120.00),
(8,  'Desk Lamp',          'Furniture',      45.00),
(9,  'Headphones Pro',     'Electronics',   200.00),
(10, 'Webcam HD',          'Electronics',    85.00);

INSERT INTO SalesReps VALUES
(1, 'James Mwangi',   'Africa'),
(2, 'Sarah Connor',   'Americas'),
(3, 'Liam Chen',      'Asia Pacific'),
(4, 'Emma Rossi',     'Europe'),
(5, 'Noah Williams',  'Middle East');

INSERT INTO Orders VALUES
(1001, 1,  2, '2023-01-15', '2023-01-20', 'Completed'),
(1002, 2,  4, '2023-02-10', '2023-02-15', 'Completed'),
(1003, 3,  1, '2023-02-20', '2023-02-28', 'Returned'),
(1004, 4,  2, '2023-03-05', '2023-03-10', 'Completed'),
(1005, 5,  1, '2023-03-15', '2023-03-22', 'Completed'),
(1006, 6,  5, '2023-04-01', '2023-04-08', 'Completed'),
(1007, 7,  3, '2023-04-20', '2023-04-25', 'Pending'),
(1008, 8,  4, '2023-05-10', '2023-05-15', 'Completed'),
(1009, 9,  1, '2023-06-01', '2023-06-07', 'Completed'),
(1010, 10, 1, '2023-06-15', '2023-06-20', 'Completed'),
(1011, 1,  2, '2023-07-04', '2023-07-09', 'Completed'),
(1012, 4,  2, '2023-07-20', '2023-07-25', 'Returned'),
(1013, 6,  5, '2023-08-05', '2023-08-12', 'Completed'),
(1014, 2,  4, '2023-09-10', '2023-09-15', 'Completed'),
(1015, 10, 1, '2023-10-01', '2023-10-06', 'Completed');

INSERT INTO OrderItems VALUES
(1,  1001, 1,  1, 0.00,  1200.00),
(2,  1001, 2,  2, 0.05,    47.50),
(3,  1002, 3,  1, 0.10,   315.00),
(4,  1003, 4,  1, 0.00,   600.00),
(5,  1004, 6,  2, 0.00,   900.00),
(6,  1005, 5, 10, 0.00,   150.00),
(7,  1006, 1,  3, 0.15,  3060.00),
(8,  1007, 7,  1, 0.00,   120.00),
(9,  1008, 9,  2, 0.10,   360.00),
(10, 1009, 8,  4, 0.00,   180.00),
(11, 1010, 10, 2, 0.05,   161.50),
(12, 1011, 1,  1, 0.00,  1200.00),
(13, 1011, 7,  1, 0.00,   120.00),
(14, 1012, 6,  1, 0.00,   450.00),
(15, 1013, 1,  2, 0.10,  2160.00),
(16, 1014, 3,  1, 0.00,   350.00),
(17, 1015, 4,  1, 0.05,   570.00);
GO


-- ============================================================
-- SECTION 3: ANALYSIS QUERIES
-- ============================================================


-- ============================================================
-- QUERY 1: Total Revenue by Country
-- Skill: JOIN + Aggregation
-- Business Question: Which countries generate the most revenue?
-- ============================================================

SELECT 
    c.country,
    COUNT(DISTINCT o.order_id)          AS total_orders,
    SUM(oi.revenue)                     AS total_revenue,
    ROUND(AVG(oi.revenue), 2)           AS avg_order_value
FROM Customers c
JOIN Orders o       ON c.customer_id = o.customer_id
JOIN OrderItems oi  ON o.order_id    = oi.order_id
WHERE o.status = 'Completed'
GROUP BY c.country
ORDER BY total_revenue DESC;


-- ============================================================
-- QUERY 2: Top Performing Sales Reps
-- Skill: JOIN + Aggregation + Filtering
-- Business Question: Who are the top 3 sales reps by revenue?
-- ============================================================

SELECT TOP 3
    sr.rep_name,
    sr.region,
    COUNT(DISTINCT o.order_id)  AS total_orders,
    SUM(oi.revenue)             AS total_revenue
FROM SalesReps sr
JOIN Orders o       ON sr.rep_id    = o.rep_id
JOIN OrderItems oi  ON o.order_id   = oi.order_id
WHERE o.status = 'Completed'
GROUP BY sr.rep_name, sr.region
ORDER BY total_revenue DESC;


-- ============================================================
-- QUERY 3: Best Selling Products
-- Skill: JOIN + Aggregation
-- Business Question: Which products sell the most by revenue & quantity?
-- ============================================================

SELECT 
    p.product_name,
    p.category,
    SUM(oi.quantity)            AS total_units_sold,
    SUM(oi.revenue)             AS total_revenue,
    ROUND(AVG(oi.discount)*100, 1) AS avg_discount_pct
FROM Products p
JOIN OrderItems oi ON p.product_id = oi.product_id
JOIN Orders o      ON oi.order_id  = o.order_id
WHERE o.status = 'Completed'
GROUP BY p.product_name, p.category
ORDER BY total_revenue DESC;


-- ============================================================
-- QUERY 4: Monthly Revenue Trend
-- Skill: JOIN + Date Functions + Aggregation
-- Business Question: How is revenue trending month over month?
-- ============================================================

SELECT 
    YEAR(o.order_date)                  AS order_year,
    MONTH(o.order_date)                 AS order_month,
    DATENAME(MONTH, o.order_date)       AS month_name,
    COUNT(DISTINCT o.order_id)          AS total_orders,
    SUM(oi.revenue)                     AS monthly_revenue
FROM Orders o
JOIN OrderItems oi ON o.order_id = oi.order_id
WHERE o.status = 'Completed'
GROUP BY YEAR(o.order_date), MONTH(o.order_date), DATENAME(MONTH, o.order_date)
ORDER BY order_year, order_month;


-- ============================================================
-- QUERY 5: Customer Segmentation Analysis
-- Skill: JOIN + GROUP BY + Subquery
-- Business Question: Which customer segment is most valuable?
-- ============================================================

SELECT 
    c.segment,
    COUNT(DISTINCT c.customer_id)   AS total_customers,
    COUNT(DISTINCT o.order_id)      AS total_orders,
    SUM(oi.revenue)                 AS total_revenue,
    ROUND(SUM(oi.revenue) / COUNT(DISTINCT c.customer_id), 2) AS revenue_per_customer
FROM Customers c
JOIN Orders o       ON c.customer_id = o.customer_id
JOIN OrderItems oi  ON o.order_id    = oi.order_id
WHERE o.status = 'Completed'
GROUP BY c.segment
ORDER BY total_revenue DESC;


-- ============================================================
-- QUERY 6: CTE — Customers Above Average Spend
-- Skill: CTE + Subquery
-- Business Question: Which customers spend above average? 
-- ============================================================

WITH CustomerSpend AS (
    SELECT 
        c.customer_id,
        c.customer_name,
        c.country,
        c.segment,
        SUM(oi.revenue) AS total_spent
    FROM Customers c
    JOIN Orders o       ON c.customer_id = o.customer_id
    JOIN OrderItems oi  ON o.order_id    = oi.order_id
    WHERE o.status = 'Completed'
    GROUP BY c.customer_id, c.customer_name, c.country, c.segment
)
SELECT 
    customer_name,
    country,
    segment,
    total_spent,
    ROUND((SELECT AVG(total_spent) FROM CustomerSpend), 2) AS avg_customer_spend,
    CASE 
        WHEN total_spent > (SELECT AVG(total_spent) FROM CustomerSpend)
        THEN 'Above Average 🔼'
        ELSE 'Below Average 🔽'
    END AS spend_category
FROM CustomerSpend
ORDER BY total_spent DESC;


-- ============================================================
-- QUERY 7: CTE — Return Rate by Product Category
-- Skill: CTE + CASE + Aggregation
-- Business Question: Which categories have the highest return rates?
-- ============================================================

WITH OrderSummary AS (
    SELECT 
        p.category,
        COUNT(DISTINCT o.order_id)                                      AS total_orders,
        COUNT(DISTINCT CASE WHEN o.status = 'Returned' 
                            THEN o.order_id END)                        AS returned_orders
    FROM Products p
    JOIN OrderItems oi ON p.product_id  = oi.product_id
    JOIN Orders o      ON oi.order_id   = o.order_id
    GROUP BY p.category
)
SELECT 
    category,
    total_orders,
    returned_orders,
    ROUND(CAST(returned_orders AS FLOAT) / total_orders * 100, 1) AS return_rate_pct
FROM OrderSummary
ORDER BY return_rate_pct DESC;


-- ============================================================
-- QUERY 8: Days to Ship per Sales Rep
-- Skill: JOIN + Date Functions + Aggregation
-- Business Question: Which reps have the fastest delivery times?
-- ============================================================

SELECT 
    sr.rep_name,
    sr.region,
    ROUND(AVG(DATEDIFF(DAY, o.order_date, o.ship_date)), 1) AS avg_days_to_ship,
    MIN(DATEDIFF(DAY, o.order_date, o.ship_date))           AS fastest_ship,
    MAX(DATEDIFF(DAY, o.order_date, o.ship_date))           AS slowest_ship
FROM SalesReps sr
JOIN Orders o ON sr.rep_id = o.rep_id
WHERE o.status = 'Completed'
GROUP BY sr.rep_name, sr.region
ORDER BY avg_days_to_ship ASC;


-- ============================================================
-- QUERY 9: Revenue Contribution % per Product (Subquery)
-- Skill: Subquery + Aggregation
-- Business Question: What % of total revenue does each product contribute?
-- ============================================================

SELECT 
    p.product_name,
    p.category,
    SUM(oi.revenue)     AS product_revenue,
    ROUND(SUM(oi.revenue) / (SELECT SUM(revenue) FROM OrderItems) * 100, 2) AS revenue_contribution_pct
FROM Products p
JOIN OrderItems oi ON p.product_id = oi.product_id
GROUP BY p.product_name, p.category
ORDER BY revenue_contribution_pct DESC;


-- ============================================================
-- QUERY 10: EXECUTIVE SUMMARY — Full Business Dashboard CTE
-- Skill: Multiple CTEs chained together
-- Business Question: Give me a complete business overview
-- ============================================================

WITH 
TotalRevenue AS (
    SELECT SUM(revenue) AS grand_total FROM OrderItems
),
CompletedOrders AS (
    SELECT COUNT(DISTINCT order_id) AS completed 
    FROM Orders WHERE status = 'Completed'
),
ReturnedOrders AS (
    SELECT COUNT(DISTINCT order_id) AS returned 
    FROM Orders WHERE status = 'Returned'
),
TopCountry AS (
    SELECT TOP 1 c.country, SUM(oi.revenue) AS rev
    FROM Customers c
    JOIN Orders o ON c.customer_id = o.customer_id
    JOIN OrderItems oi ON o.order_id = oi.order_id
    WHERE o.status = 'Completed'
    GROUP BY c.country
    ORDER BY rev DESC
),
TopProduct AS (
    SELECT TOP 1 p.product_name, SUM(oi.revenue) AS rev
    FROM Products p
    JOIN OrderItems oi ON p.product_id = oi.product_id
    GROUP BY p.product_name
    ORDER BY rev DESC
)
SELECT 
    tr.grand_total                                              AS total_revenue,
    co.completed                                                AS completed_orders,
    ro.returned                                                 AS returned_orders,
    ROUND(CAST(ro.returned AS FLOAT)/(co.completed + ro.returned)*100,1) AS return_rate_pct,
    tc.country                                                  AS top_country,
    tp.product_name                                             AS top_product
FROM TotalRevenue tr, CompletedOrders co, ReturnedOrders ro, TopCountry tc, TopProduct tp;
