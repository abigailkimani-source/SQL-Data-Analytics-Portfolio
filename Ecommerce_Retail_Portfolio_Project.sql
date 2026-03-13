-- ============================================================
--   E-COMMERCE & RETAIL ANALYTICS PORTFOLIO PROJECT
--   Author: Abigail Kimani
--   Tools: SQL Server (SSMS)
--   Skills: SELECT, Filtering, JOINs, CTEs, Subqueries, CASE
--   Description: Analysing online store performance, customer
--                behaviour, product trends & delivery efficiency
-- ============================================================


-- ============================================================
-- SECTION 1: DATABASE & TABLE SETUP 
-- ============================================================

CREATE DATABASE EcommerceAnalytics;
GO

USE EcommerceAnalytics;
GO

-- Customers Table
CREATE TABLE Customers (
    customer_id       INT PRIMARY KEY,
    full_name         NVARCHAR(100),
    gender            NVARCHAR(10),
    date_of_birth     DATE,
    email             NVARCHAR(100),
    country           NVARCHAR(50),
    city              NVARCHAR(50),
    signup_date       DATE,
    customer_type     NVARCHAR(20)   -- New, Returning, VIP
);

-- Products Table
CREATE TABLE Products (
    product_id        INT PRIMARY KEY,
    product_name      NVARCHAR(100),
    category          NVARCHAR(50),
    brand             NVARCHAR(50),
    unit_price        DECIMAL(10,2),
    cost_price        DECIMAL(10,2),
    stock_quantity    INT
);

-- Sellers Table
CREATE TABLE Sellers (
    seller_id         INT PRIMARY KEY,
    seller_name       NVARCHAR(100),
    country           NVARCHAR(50),
    rating            DECIMAL(3,1),
    joined_date       DATE
);

-- Orders Table
CREATE TABLE Orders (
    order_id          INT PRIMARY KEY,
    customer_id       INT FOREIGN KEY REFERENCES Customers(customer_id),
    seller_id         INT FOREIGN KEY REFERENCES Sellers(seller_id),
    order_date        DATE,
    delivery_date     DATE,
    order_status      NVARCHAR(50),  -- Delivered, Returned, Cancelled, Pending
    payment_method    NVARCHAR(50),  -- Credit Card, Mobile Money, PayPal, Cash
    shipping_cost     DECIMAL(8,2)
);

-- Order Items Table
CREATE TABLE OrderItems (
    item_id           INT PRIMARY KEY,
    order_id          INT FOREIGN KEY REFERENCES Orders(order_id),
    product_id        INT FOREIGN KEY REFERENCES Products(product_id),
    quantity          INT,
    unit_price        DECIMAL(10,2),
    discount_pct      DECIMAL(4,2),
    revenue           DECIMAL(10,2)
);

-- Product Reviews Table
CREATE TABLE Reviews (
    review_id         INT PRIMARY KEY,
    product_id        INT FOREIGN KEY REFERENCES Products(product_id),
    customer_id       INT FOREIGN KEY REFERENCES Customers(customer_id),
    rating            INT,           -- 1 to 5
    review_date       DATE,
    verified_purchase BIT            -- 1 = Yes, 0 = No
);
GO


-- ============================================================
-- SECTION 2: INSERT SAMPLE DATA
-- ============================================================

INSERT INTO Customers VALUES
(1,  'James Mwangi',     'Male',   '1990-03-15', 'james@email.com',   'Kenya',       'Nairobi',    '2020-01-10', 'VIP'),
(2,  'Sarah Johnson',    'Female', '1992-07-22', 'sarah@email.com',   'USA',         'New York',   '2021-03-15', 'Returning'),
(3,  'Carlos Mendes',    'Male',   '1985-11-08', 'carlos@email.com',  'Brazil',      'Sao Paulo',  '2019-06-20', 'VIP'),
(4,  'Amina Hassan',     'Female', '1995-05-30', 'amina@email.com',   'Nigeria',     'Lagos',      '2022-01-05', 'New'),
(5,  'Liam Chen',        'Male',   '2000-01-14', 'liam@email.com',    'China',       'Shanghai',   '2022-08-12', 'New'),
(6,  'Fatima Al-Sayed',  'Female', '1988-09-25', 'fatima@email.com',  'UAE',         'Dubai',      '2018-11-30', 'VIP'),
(7,  'Noah Williams',    'Male',   '1993-04-18', 'noah@email.com',    'UK',          'London',     '2021-07-22', 'Returning'),
(8,  'Grace Osei',       'Female', '1987-12-03', 'grace@email.com',   'Ghana',       'Accra',      '2020-09-14', 'Returning'),
(9,  'Ivan Petrov',      'Male',   '1982-06-27', 'ivan@email.com',    'Russia',      'Moscow',     '2019-04-08', 'VIP'),
(10, 'Mei Tanaka',       'Female', '1998-08-11', 'mei@email.com',     'Japan',       'Tokyo',      '2022-02-28', 'New'),
(11, 'David Kimani',     'Male',   '1975-02-19', 'david@email.com',   'Kenya',       'Mombasa',    '2020-05-17', 'Returning'),
(12, 'Emma Rossi',       'Female', '1991-10-07', 'emma@email.com',    'Italy',       'Milan',      '2021-12-01', 'Returning'),
(13, 'Omar Farooq',      'Male',   '1989-03-23', 'omar@email.com',    'Pakistan',    'Karachi',    '2022-03-10', 'New'),
(14, 'Aisha Diallo',     'Female', '1994-07-14', 'aisha@email.com',   'Senegal',     'Dakar',      '2021-09-25', 'Returning'),
(15, 'Lucas Dupont',     'Male',   '1986-11-30', 'lucas@email.com',   'France',      'Paris',      '2020-07-04', 'VIP');

INSERT INTO Products VALUES
(1,  'iPhone 15 Pro',        'Electronics',  'Apple',    1099.00,  780.00,  150),
(2,  'Samsung 4K TV 55"',    'Electronics',  'Samsung',   799.00,  520.00,   80),
(3,  'Nike Air Max 270',     'Footwear',     'Nike',      149.00,   65.00,  500),
(4,  'Adidas Ultraboost',    'Footwear',     'Adidas',    179.00,   75.00,  350),
(5,  'Coffee Maker Pro',     'Home & Kitchen','Breville',  89.00,   38.00,  200),
(6,  'Dyson V15 Vacuum',     'Home & Kitchen','Dyson',    599.00,  380.00,   60),
(7,  'Harry Potter Box Set', 'Books',        'Bloomsbury', 45.00,   18.00, 1000),
(8,  'Yoga Mat Premium',     'Sports',       'Lululemon',  68.00,   25.00,  400),
(9,  'MacBook Air M2',       'Electronics',  'Apple',    1299.00,  950.00,   75),
(10, 'Levi 501 Jeans',       'Clothing',     'Levis',      89.00,   32.00,  600),
(11, 'PlayStation 5',        'Electronics',  'Sony',      499.00,  380.00,   40),
(12, 'KitchenAid Mixer',     'Home & Kitchen','KitchenAid',399.00, 220.00,   90),
(13, 'Kindle Paperwhite',    'Electronics',  'Amazon',    139.00,   70.00,  300),
(14, 'Zara Summer Dress',    'Clothing',     'Zara',       59.00,   18.00,  800),
(15, 'Protein Powder 2kg',   'Sports',       'Optimum',    55.00,   22.00,  700);

INSERT INTO Sellers VALUES
(1, 'TechWorld Store',      'USA',         4.8, '2018-01-15'),
(2, 'Fashion Hub',          'Italy',       4.5, '2019-03-22'),
(3, 'Sports Elite',         'UK',          4.7, '2017-06-10'),
(4, 'Home Essentials',      'Germany',     4.3, '2020-02-28'),
(5, 'African Marketplace',  'Kenya',       4.6, '2021-01-05'),
(6, 'Global Gadgets',       'China',       4.2, '2018-09-14');

INSERT INTO Orders VALUES
(3001, 1,  1, '2023-01-05', '2023-01-10', 'Delivered',  'Credit Card',   12.00),
(3002, 2,  2, '2023-01-15', '2023-01-22', 'Delivered',  'PayPal',        15.00),
(3003, 3,  1, '2023-02-01', '2023-02-07', 'Delivered',  'Credit Card',   20.00),
(3004, 4,  5, '2023-02-14', '2023-02-20', 'Returned',   'Mobile Money',   8.00),
(3005, 5,  6, '2023-02-28', '2023-03-06', 'Delivered',  'Credit Card',   18.00),
(3006, 6,  1, '2023-03-10', '2023-03-15', 'Delivered',  'Credit Card',   25.00),
(3007, 7,  3, '2023-03-20', '2023-03-28', 'Delivered',  'PayPal',        10.00),
(3008, 8,  5, '2023-04-05', '2023-04-12', 'Delivered',  'Mobile Money',   5.00),
(3009, 9,  1, '2023-04-18', '2023-04-23', 'Delivered',  'Credit Card',   30.00),
(3010, 10, 6, '2023-05-01', '2023-05-08', 'Returned',   'Credit Card',   12.00),
(3011, 11, 5, '2023-05-15', '2023-05-20', 'Delivered',  'Mobile Money',   7.00),
(3012, 12, 2, '2023-06-01', '2023-06-09', 'Delivered',  'PayPal',        14.00),
(3013, 13, 4, '2023-06-20', '2023-06-27', 'Cancelled',  'Credit Card',   10.00),
(3014, 14, 5, '2023-07-04', '2023-07-11', 'Delivered',  'Mobile Money',   6.00),
(3015, 15, 1, '2023-07-15', '2023-07-20', 'Delivered',  'Credit Card',   22.00),
(3016, 1,  1, '2023-08-01', '2023-08-06', 'Delivered',  'Credit Card',   12.00),
(3017, 6,  1, '2023-08-20', '2023-08-25', 'Delivered',  'Credit Card',   25.00),
(3018, 9,  6, '2023-09-05', '2023-09-12', 'Delivered',  'PayPal',        18.00),
(3019, 3,  3, '2023-09-20', '2023-09-27', 'Returned',   'Credit Card',   15.00),
(3020, 15, 2, '2023-10-10', '2023-10-17', 'Delivered',  'Credit Card',   20.00);

INSERT INTO OrderItems VALUES
(1,  3001, 9,  1, 1299.00, 0.00,  1299.00),
(2,  3002, 14, 2,   59.00, 0.10,   106.20),
(3,  3003, 1,  1, 1099.00, 0.05,  1044.05),
(4,  3004, 10, 1,   89.00, 0.00,    89.00),
(5,  3005, 2,  1,  799.00, 0.10,   719.10),
(6,  3006, 1,  2, 1099.00, 0.00,  2198.00),
(7,  3007, 3,  2,  149.00, 0.15,   253.30),
(8,  3008, 8,  3,   68.00, 0.00,   204.00),
(9,  3009, 9,  1, 1299.00, 0.00,  1299.00),
(10, 3010, 13, 1,  139.00, 0.00,   139.00),
(11, 3011, 7,  2,   45.00, 0.00,    90.00),
(12, 3012, 6,  1,  599.00, 0.10,   539.10),
(13, 3013, 5,  1,   89.00, 0.00,    89.00),
(14, 3014, 15, 2,   55.00, 0.05,   104.50),
(15, 3015, 11, 1,  499.00, 0.00,   499.00),
(16, 3016, 3,  1,  149.00, 0.10,   134.10),
(17, 3017, 9,  1, 1299.00, 0.05,  1234.05),
(18, 3018, 2,  1,  799.00, 0.00,   799.00),
(19, 3019, 4,  2,  179.00, 0.00,   358.00),
(20, 3020, 12, 1,  399.00, 0.10,   359.10);

INSERT INTO Reviews VALUES
(1,  9,  1,  5, '2023-01-12', 1),
(2,  14, 2,  4, '2023-01-25', 1),
(3,  1,  3,  5, '2023-02-09', 1),
(4,  10, 4,  3, '2023-02-22', 1),
(5,  2,  5,  4, '2023-03-08', 1),
(6,  1,  6,  5, '2023-03-17', 1),
(7,  3,  7,  4, '2023-03-30', 1),
(8,  8,  8,  5, '2023-04-14', 1),
(9,  9,  9,  5, '2023-04-25', 1),
(10, 13, 10, 2, '2023-05-10', 1),
(11, 7,  11, 4, '2023-05-22', 1),
(12, 6,  12, 5, '2023-06-11', 1),
(13, 15, 14, 4, '2023-07-13', 1),
(14, 11, 15, 5, '2023-07-22', 1),
(15, 12, 15, 4, '2023-10-19', 1);
GO


-- ============================================================
-- SECTION 3: ANALYSIS QUERIES
-- ============================================================


-- ============================================================
-- QUERY 1: Revenue & Profit by Product Category
-- Skill: JOIN + Aggregation
-- Business Question: Which categories make the most profit?
-- ============================================================

SELECT 
    p.category,
    COUNT(DISTINCT oi.order_id)                         AS total_orders,
    SUM(oi.quantity)                                    AS units_sold,
    SUM(oi.revenue)                                     AS total_revenue,
    SUM(oi.quantity * p.cost_price)                     AS total_cost,
    SUM(oi.revenue) - SUM(oi.quantity * p.cost_price)   AS total_profit,
    ROUND((SUM(oi.revenue) - SUM(oi.quantity * p.cost_price))
          / NULLIF(SUM(oi.revenue), 0) * 100, 1)        AS profit_margin_pct
FROM Products p
JOIN OrderItems oi   ON p.product_id  = oi.product_id
JOIN Orders o        ON oi.order_id   = o.order_id
WHERE o.order_status = 'Delivered'
GROUP BY p.category
ORDER BY total_profit DESC;


-- ============================================================
-- QUERY 2: Top 5 Best Selling Products
-- Skill: JOIN + Aggregation + Filtering
-- Business Question: What are our top selling products?
-- ============================================================

SELECT TOP 5
    p.product_name,
    p.category,
    p.brand,
    SUM(oi.quantity)        AS units_sold,
    SUM(oi.revenue)         AS total_revenue,
    ROUND(AVG(r.rating),1)  AS avg_review_rating
FROM Products p
JOIN OrderItems oi   ON p.product_id  = oi.product_id
JOIN Orders o        ON oi.order_id   = o.order_id
LEFT JOIN Reviews r  ON p.product_id  = r.product_id
WHERE o.order_status = 'Delivered'
GROUP BY p.product_name, p.category, p.brand
ORDER BY total_revenue DESC;


-- ============================================================
-- QUERY 3: Customer Purchase Behaviour by Country
-- Skill: JOIN + Aggregation
-- Business Question: Which countries generate the most revenue?
-- ============================================================

SELECT 
    c.country,
    COUNT(DISTINCT c.customer_id)       AS total_customers,
    COUNT(DISTINCT o.order_id)          AS total_orders,
    SUM(oi.revenue)                     AS total_revenue,
    ROUND(AVG(oi.revenue), 2)           AS avg_order_value,
    COUNT(CASE WHEN o.order_status = 'Returned'  
               THEN 1 END)              AS total_returns
FROM Customers c
JOIN Orders o       ON c.customer_id = o.customer_id
JOIN OrderItems oi  ON o.order_id    = oi.order_id
GROUP BY c.country
ORDER BY total_revenue DESC;


-- ============================================================
-- QUERY 4: Seller Performance Scorecard
-- Skill: JOIN + Aggregation + CASE
-- Business Question: Which sellers are performing best?
-- ============================================================

SELECT 
    s.seller_name,
    s.country,
    s.rating                                            AS platform_rating,
    COUNT(DISTINCT o.order_id)                          AS total_orders,
    SUM(oi.revenue)                                     AS total_revenue,
    COUNT(CASE WHEN o.order_status = 'Returned'  
               THEN 1 END)                              AS returns,
    COUNT(CASE WHEN o.order_status = 'Cancelled' 
               THEN 1 END)                              AS cancellations,
    ROUND(COUNT(CASE WHEN o.order_status = 'Delivered' 
                     THEN 1 END) * 100.0 
          / COUNT(o.order_id), 1)                       AS delivery_success_pct,
    CASE 
        WHEN s.rating >= 4.7 THEN 'Top Seller 🏆'
        WHEN s.rating >= 4.4 THEN 'Good Seller ⭐'
        ELSE                      'Needs Improvement ⚠️'
    END AS seller_grade
FROM Sellers s
JOIN Orders o       ON s.seller_id   = o.seller_id
JOIN OrderItems oi  ON o.order_id    = oi.order_id
GROUP BY s.seller_name, s.country, s.rating
ORDER BY total_revenue DESC;


-- ============================================================
-- QUERY 5: Payment Method Analysis
-- Skill: Aggregation + CASE
-- Business Question: Which payment methods are most popular?
-- ============================================================

SELECT 
    o.payment_method,
    COUNT(o.order_id)                   AS total_orders,
    SUM(oi.revenue)                     AS total_revenue,
    ROUND(AVG(oi.revenue), 2)           AS avg_order_value,
    COUNT(CASE WHEN o.order_status = 'Returned'  
               THEN 1 END)              AS returns,
    ROUND(COUNT(o.order_id) * 100.0 
          / (SELECT COUNT(*) FROM Orders), 1) AS usage_pct
FROM Orders o
JOIN OrderItems oi ON o.order_id = oi.order_id
GROUP BY o.payment_method
ORDER BY total_orders DESC;


-- ============================================================
-- QUERY 6: Delivery Speed Analysis
-- Skill: Date Functions + CASE + Aggregation
-- Business Question: How fast are we delivering & who gets fastest service?
-- ============================================================

SELECT 
    c.country,
    COUNT(o.order_id)                                           AS total_orders,
    ROUND(AVG(DATEDIFF(DAY, o.order_date, o.delivery_date)),1)  AS avg_delivery_days,
    MIN(DATEDIFF(DAY, o.order_date, o.delivery_date))           AS fastest_delivery,
    MAX(DATEDIFF(DAY, o.order_date, o.delivery_date))           AS slowest_delivery,
    CASE 
        WHEN AVG(DATEDIFF(DAY, o.order_date, o.delivery_date)) <= 5  
             THEN 'Fast Delivery 🚀'
        WHEN AVG(DATEDIFF(DAY, o.order_date, o.delivery_date)) <= 8  
             THEN 'Standard Delivery 📦'
        ELSE      'Slow Delivery 🐢'
    END AS delivery_speed
FROM Orders o
JOIN Customers c ON o.customer_id = c.customer_id
WHERE o.order_status = 'Delivered'
GROUP BY c.country
ORDER BY avg_delivery_days ASC;


-- ============================================================
-- QUERY 7: CTE — VIP Customer Spending Analysis
-- Skill: CTE + JOIN + CASE
-- Business Question: How much are our VIP customers worth?
-- ============================================================

WITH VIPSpending AS (
    SELECT 
        c.customer_id,
        c.full_name,
        c.country,
        c.customer_type,
        COUNT(DISTINCT o.order_id)          AS total_orders,
        SUM(oi.revenue)                     AS total_spent,
        ROUND(AVG(oi.revenue), 2)           AS avg_order_value,
        MAX(o.order_date)                   AS last_order_date,
        SUM(o.shipping_cost)                AS total_shipping_paid
    FROM Customers c
    JOIN Orders o       ON c.customer_id = o.customer_id
    JOIN OrderItems oi  ON o.order_id    = oi.order_id
    WHERE o.order_status = 'Delivered'
    GROUP BY c.customer_id, c.full_name, c.country, c.customer_type
)
SELECT 
    full_name,
    country,
    customer_type,
    total_orders,
    total_spent,
    avg_order_value,
    last_order_date,
    DATEDIFF(DAY, last_order_date, GETDATE())   AS days_since_last_order,
    CASE 
        WHEN total_spent >= 2000 THEN 'Champion 🏆'
        WHEN total_spent >= 1000 THEN 'Loyal 💛'
        WHEN total_spent >= 500  THEN 'Potential 🌱'
        ELSE                          'New 👋'
    END AS customer_value_tier
FROM VIPSpending
ORDER BY total_spent DESC;


-- ============================================================
-- QUERY 8: CTE — Product Profitability vs Review Score
-- Skill: CTE + LEFT JOIN + Aggregation
-- Business Question: Do higher rated products make more profit?
-- ============================================================

WITH ProductStats AS (
    SELECT 
        p.product_id,
        p.product_name,
        p.category,
        p.brand,
        SUM(oi.quantity)                                    AS units_sold,
        SUM(oi.revenue)                                     AS total_revenue,
        SUM(oi.quantity * p.cost_price)                     AS total_cost,
        SUM(oi.revenue) - SUM(oi.quantity * p.cost_price)   AS profit,
        p.stock_quantity                                     AS remaining_stock
    FROM Products p
    JOIN OrderItems oi ON p.product_id = oi.product_id
    JOIN Orders o      ON oi.order_id  = o.order_id
    WHERE o.order_status = 'Delivered'
    GROUP BY p.product_id, p.product_name, p.category, p.brand, p.stock_quantity
),
ProductRatings AS (
    SELECT 
        product_id,
        ROUND(AVG(CAST(rating AS FLOAT)), 1)    AS avg_rating,
        COUNT(review_id)                         AS total_reviews
    FROM Reviews
    GROUP BY product_id
)
SELECT 
    ps.product_name,
    ps.category,
    ps.brand,
    ps.units_sold,
    ps.total_revenue,
    ps.profit,
    ROUND(ps.profit / NULLIF(ps.total_revenue,0) * 100, 1)  AS margin_pct,
    pr.avg_rating,
    pr.total_reviews,
    CASE 
        WHEN pr.avg_rating >= 4.5 AND ps.profit > 500 THEN 'Star Product ⭐'
        WHEN pr.avg_rating >= 4.0                     THEN 'Good Product ✅'
        WHEN pr.avg_rating < 3.0                      THEN 'Needs Review 🔴'
        ELSE                                               'Average Product'
    END AS product_status
FROM ProductStats ps
LEFT JOIN ProductRatings pr ON ps.product_id = pr.product_id
ORDER BY ps.profit DESC;


-- ============================================================
-- QUERY 9: Monthly Sales & Returns Trend
-- Skill: Date Functions + CASE + Subquery
-- Business Question: How are sales & returns trending each month?
-- ============================================================

SELECT 
    YEAR(o.order_date)                      AS year,
    MONTH(o.order_date)                     AS month_number,
    DATENAME(MONTH, o.order_date)           AS month_name,
    COUNT(o.order_id)                       AS total_orders,
    SUM(oi.revenue)                         AS gross_revenue,
    COUNT(CASE WHEN o.order_status = 'Returned'  
               THEN 1 END)                  AS returns,
    COUNT(CASE WHEN o.order_status = 'Cancelled' 
               THEN 1 END)                  AS cancellations,
    ROUND(COUNT(CASE WHEN o.order_status = 'Returned' THEN 1 END) * 100.0
          / NULLIF(COUNT(o.order_id), 0), 1) AS return_rate_pct
FROM Orders o
JOIN OrderItems oi ON o.order_id = oi.order_id
GROUP BY YEAR(o.order_date), MONTH(o.order_date), DATENAME(MONTH, o.order_date)
ORDER BY year, month_number;


-- ============================================================
-- QUERY 10: EXECUTIVE DASHBOARD — Full E-commerce Summary
-- Skill: Multiple CTEs chained together
-- Business Question: Give the CEO a complete store overview
-- ============================================================

WITH
TotalRevenue AS (
    SELECT SUM(oi.revenue) AS total
    FROM OrderItems oi
    JOIN Orders o ON oi.order_id = o.order_id
    WHERE o.order_status = 'Delivered'
),
TotalOrders AS (
    SELECT COUNT(*) AS total FROM Orders
),
TotalCustomers AS (
    SELECT COUNT(DISTINCT customer_id) AS total FROM Orders
),
ReturnRate AS (
    SELECT 
        COUNT(CASE WHEN order_status = 'Returned'  THEN 1 END) AS returns,
        COUNT(*) AS total
    FROM Orders
),
TopProduct AS (
    SELECT TOP 1 p.product_name, SUM(oi.revenue) AS rev
    FROM Products p
    JOIN OrderItems oi ON p.product_id = oi.product_id
    JOIN Orders o ON oi.order_id = o.order_id
    WHERE o.order_status = 'Delivered'
    GROUP BY p.product_name ORDER BY rev DESC
),
TopCountry AS (
    SELECT TOP 1 c.country, SUM(oi.revenue) AS rev
    FROM Customers c
    JOIN Orders o ON c.customer_id = o.customer_id
    JOIN OrderItems oi ON o.order_id = oi.order_id
    WHERE o.order_status = 'Delivered'
    GROUP BY c.country ORDER BY rev DESC
),
AvgDelivery AS (
    SELECT ROUND(AVG(DATEDIFF(DAY, order_date, delivery_date)),1) AS avg_days
    FROM Orders WHERE order_status = 'Delivered'
)
SELECT 
    tr.total                                            AS total_revenue,
    to2.total                                           AS total_orders,
    tc.total                                            AS unique_customers,
    ROUND(rr.returns * 100.0 / rr.total, 1)            AS return_rate_pct,
    tp.product_name                                     AS best_selling_product,
    tco.country                                         AS top_revenue_country,
    ad.avg_days                                         AS avg_delivery_days
FROM TotalRevenue tr, TotalOrders to2, TotalCustomers tc,
     ReturnRate rr, TopProduct tp, TopCountry tco, AvgDelivery ad;
