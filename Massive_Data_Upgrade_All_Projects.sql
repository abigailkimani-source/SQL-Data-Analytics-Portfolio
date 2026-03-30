-- ============================================================
--   MASSIVE DATA UPGRADE — ALL 4 PORTFOLIO PROJECTS
--   Generates thousands of realistic rows using SQL loops
--   Banking: 1000 customers, 10,000 transactions, 1000 loans
--   Healthcare: 1000 patients, 5000 admissions, 5000 bills
--   Sales: 1000 customers, 5000 orders, 8000 order items
--   Ecommerce: 1000 customers, 5000 orders, 8000 order items
-- ============================================================


-- ============================================================
-- PART 1: BANKING ANALYTICS — MASSIVE DATA
-- ============================================================

USE BankingAnalytics;
GO

-- Clear existing data first
DELETE FROM Loans;
DELETE FROM Transactions;
DELETE FROM Accounts;
DELETE FROM Customers;
DELETE FROM Branches;
GO

-- Re-insert Branches
INSERT INTO Branches VALUES
(1, 'Nairobi Central Branch',    'Nairobi',    'Kenya',     'Urban'),
(2, 'Lagos Main Branch',         'Lagos',      'Nigeria',   'Urban'),
(3, 'London City Branch',        'London',     'UK',        'Urban'),
(4, 'Digital Banking Hub',       'Online',     'Global',    'Digital'),
(5, 'Dubai Financial Branch',    'Dubai',      'UAE',       'Urban'),
(6, 'Accra Community Branch',    'Accra',      'Ghana',     'Rural'),
(7, 'Tokyo Metro Branch',        'Tokyo',      'Japan',     'Urban'),
(8, 'New York Branch',           'New York',   'USA',       'Urban'),
(9, 'Johannesburg Branch',       'Johannesburg','South Africa','Urban'),
(10,'Paris Branch',              'Paris',      'France',    'Urban');
GO

-- Generate 1000 Customers
DECLARE @i INT = 1;
DECLARE @names TABLE (id INT IDENTITY(1,1), name NVARCHAR(100));
INSERT INTO @names VALUES
('James Mwangi'),('Sarah Johnson'),('Carlos Mendes'),('Amina Hassan'),
('Liam Chen'),('Fatima Al-Sayed'),('Noah Williams'),('Grace Osei'),
('Ivan Petrov'),('Mei Tanaka'),('David Kimani'),('Emma Rossi'),
('Omar Farooq'),('Aisha Diallo'),('Lucas Dupont'),('Alice Wanjiku'),
('Brian Otieno'),('Catherine Njeri'),('Daniel Kiprop'),('Elizabeth Auma'),
('Francis Kamau'),('Gloria Adhiambo'),('Henry Mutua'),('Irene Wambui'),
('Joseph Kariuki'),('Karen Nyambura'),('Lawrence Odhiambo'),('Mary Chebet'),
('Nicholas Githinji'),('Olive Akinyi'),('Patrick Njoroge'),('Queen Moraa'),
('Robert Kiprotich'),('Susan Wangari'),('Thomas Onyango'),('Uma Ndungu'),
('Victor Muthoni'),('Winnie Kemunto'),('Xavier Barasa'),('Yvonne Akello');

DECLARE @countries TABLE (id INT IDENTITY(1,1), country NVARCHAR(50));
INSERT INTO @countries VALUES
('Kenya'),('Nigeria'),('UK'),('USA'),('UAE'),
('Ghana'),('Japan'),('South Africa'),('France'),('Brazil'),
('Germany'),('India'),('China'),('Canada'),('Australia');

DECLARE @cities TABLE (id INT IDENTITY(1,1), city NVARCHAR(50));
INSERT INTO @cities VALUES
('Nairobi'),('Lagos'),('London'),('New York'),('Dubai'),
('Accra'),('Tokyo'),('Johannesburg'),('Paris'),('Sao Paulo'),
('Berlin'),('Mumbai'),('Shanghai'),('Toronto'),('Sydney');

DECLARE @occupations TABLE (id INT IDENTITY(1,1), occ NVARCHAR(100));
INSERT INTO @occupations VALUES
('Engineer'),('Doctor'),('Business Owner'),('Accountant'),('Student'),
('Investor'),('Software Developer'),('Teacher'),('Lawyer'),('Analyst'),
('Nurse'),('Trader'),('Consultant'),('Manager'),('Entrepreneur');

WHILE @i <= 1000
BEGIN
    INSERT INTO Customers (customer_id, full_name, gender, date_of_birth, country, city, occupation, annual_income, customer_since)
    VALUES (
        @i,
        (SELECT TOP 1 name FROM @names ORDER BY NEWID()),
        CASE WHEN @i % 2 = 0 THEN 'Male' ELSE 'Female' END,
        DATEADD(DAY, -(ABS(CHECKSUM(NEWID())) % 14600 + 6570), GETDATE()),
        (SELECT TOP 1 country FROM @countries ORDER BY NEWID()),
        (SELECT TOP 1 city FROM @cities ORDER BY NEWID()),
        (SELECT TOP 1 occ FROM @occupations ORDER BY NEWID()),
        ROUND((ABS(CHECKSUM(NEWID())) % 490000 + 10000), -2),
        DATEADD(DAY, -(ABS(CHECKSUM(NEWID())) % 3650 + 365), GETDATE())
    );
    SET @i = @i + 1;
END
GO

-- Generate 1000 Accounts
DECLARE @i INT = 1;
DECLARE @acctypes TABLE (id INT IDENTITY(1,1), typ NVARCHAR(50));
INSERT INTO @acctypes VALUES ('Savings'),('Current'),('Fixed Deposit');
DECLARE @statuses TABLE (id INT IDENTITY(1,1), stat NVARCHAR(20));
INSERT INTO @statuses VALUES ('Active'),('Active'),('Active'),('Active'),('Dormant');

WHILE @i <= 1000
BEGIN
    INSERT INTO Accounts (account_id, customer_id, branch_id, account_type, account_status, open_date, current_balance)
    VALUES (
        1000 + @i,
        @i,
        (ABS(CHECKSUM(NEWID())) % 10) + 1,
        (SELECT TOP 1 typ FROM @acctypes ORDER BY NEWID()),
        (SELECT TOP 1 stat FROM @statuses ORDER BY NEWID()),
        DATEADD(DAY, -(ABS(CHECKSUM(NEWID())) % 3650 + 365), GETDATE()),
        ROUND((ABS(CHECKSUM(NEWID())) % 1990000 + 1000), 2)
    );
    SET @i = @i + 1;
END
GO

-- Generate 10,000 Transactions
DECLARE @i INT = 1;
DECLARE @ttypes TABLE (id INT IDENTITY(1,1), typ NVARCHAR(50));
INSERT INTO @ttypes VALUES ('Deposit'),('Withdrawal'),('Transfer'),('Payment'),('Deposit'),('Deposit');
DECLARE @channels TABLE (id INT IDENTITY(1,1), ch NVARCHAR(50));
INSERT INTO @channels VALUES ('ATM'),('Mobile'),('Branch'),('Online'),('Mobile'),('Online');
DECLARE @locations TABLE (id INT IDENTITY(1,1), loc NVARCHAR(100));
INSERT INTO @locations VALUES ('Nairobi'),('Lagos'),('London'),('New York'),('Dubai'),('Accra'),('Tokyo'),('Unknown'),('Paris'),('Berlin');

WHILE @i <= 10000
BEGIN
    DECLARE @flagged BIT = CASE WHEN ABS(CHECKSUM(NEWID())) % 20 = 0 THEN 1 ELSE 0 END;
    INSERT INTO Transactions (transaction_id, account_id, transaction_date, transaction_type, amount, channel, location, is_flagged)
    VALUES (
        @i,
        (ABS(CHECKSUM(NEWID())) % 1000) + 1001,
        DATEADD(DAY, -(ABS(CHECKSUM(NEWID())) % 730), GETDATE()),
        (SELECT TOP 1 typ FROM @ttypes ORDER BY NEWID()),
        ROUND((ABS(CHECKSUM(NEWID())) % 490000 + 100), 2),
        (SELECT TOP 1 ch FROM @channels ORDER BY NEWID()),
        (SELECT TOP 1 loc FROM @locations ORDER BY NEWID()),
        @flagged
    );
    SET @i = @i + 1;
END
GO

-- Generate 1000 Loans
DECLARE @i INT = 1;
DECLARE @ltypes TABLE (id INT IDENTITY(1,1), typ NVARCHAR(50));
INSERT INTO @ltypes VALUES ('Personal'),('Mortgage'),('Business'),('Auto'),('Personal'),('Business');
DECLARE @lstatus TABLE (id INT IDENTITY(1,1), stat NVARCHAR(50));
INSERT INTO @lstatus VALUES ('Active'),('Active'),('Active'),('Paid Off'),('Defaulted'),('Active');

WHILE @i <= 1000
BEGIN
    DECLARE @lamt DECIMAL(12,2) = ROUND((ABS(CHECKSUM(NEWID())) % 490000 + 5000), -2);
    DECLARE @rate DECIMAL(5,2) = ROUND((ABS(CHECKSUM(NEWID())) % 20 + 5), 1);
    DECLARE @missed INT = ABS(CHECKSUM(NEWID())) % 8;
    INSERT INTO Loans (loan_id, customer_id, branch_id, loan_type, loan_amount, interest_rate, loan_start_date, loan_end_date, monthly_payment, loan_status, missed_payments)
    VALUES (
        200 + @i,
        (ABS(CHECKSUM(NEWID())) % 1000) + 1,
        (ABS(CHECKSUM(NEWID())) % 10) + 1,
        (SELECT TOP 1 typ FROM @ltypes ORDER BY NEWID()),
        @lamt,
        @rate,
        DATEADD(DAY, -(ABS(CHECKSUM(NEWID())) % 1825 + 365), GETDATE()),
        DATEADD(YEAR, (ABS(CHECKSUM(NEWID())) % 10 + 1), DATEADD(DAY, -(ABS(CHECKSUM(NEWID())) % 1825 + 365), GETDATE())),
        ROUND(@lamt * @rate / 100 / 12 + @lamt / 60, 2),
        (SELECT TOP 1 stat FROM @lstatus ORDER BY NEWID()),
        @missed
    );
    SET @i = @i + 1;
END
GO

PRINT 'Banking: 1000 customers, 1000 accounts, 10000 transactions, 1000 loans generated!';
GO


-- ============================================================
-- PART 2: HEALTHCARE ANALYTICS — MASSIVE DATA
-- ============================================================

USE HealthcareAnalytics;
GO

DELETE FROM Billing;
DELETE FROM Admissions;
DELETE FROM Patients;
DELETE FROM Doctors;
DELETE FROM Hospitals;
GO

INSERT INTO Hospitals VALUES
(1,'Nairobi General Hospital',     'Nairobi',    'Kenya',   'Public'),
(2,'Lagos Island Medical Centre',  'Lagos',      'Nigeria', 'Private'),
(3,'St. Thomas Hospital',          'London',     'UK',      'Public'),
(4,'Mayo Clinic',                  'Minnesota',  'USA',     'Private'),
(5,'Tokyo Medical University',     'Tokyo',      'Japan',   'Public'),
(6,'Aga Khan Hospital',            'Nairobi',    'Kenya',   'Private'),
(7,'Kenyatta National Hospital',   'Nairobi',    'Kenya',   'Public'),
(8,'Mombasa Hospital',             'Mombasa',    'Kenya',   'Private'),
(9,'Coast General Hospital',       'Mombasa',    'Kenya',   'Public'),
(10,'MP Shah Hospital',            'Nairobi',    'Kenya',   'Private');

INSERT INTO Doctors VALUES
(1,'Dr. Emily Carter',   'Cardiology',       'Heart & Vascular',    15),
(2,'Dr. John Otieno',    'General Medicine', 'General Ward',         8),
(3,'Dr. Priya Sharma',   'Oncology',         'Cancer Center',       20),
(4,'Dr. Ahmed Malik',    'Neurology',        'Brain & Spine',       12),
(5,'Dr. Sofia Martins',  'Pediatrics',       'Childrens Ward',       6),
(6,'Dr. James Nkosi',    'Emergency',        'Emergency Unit',      10),
(7,'Dr. Laura Schmidt',  'Orthopedics',      'Bone & Joint',         9),
(8,'Dr. Raj Patel',      'Endocrinology',    'Diabetes & Hormones', 14),
(9,'Dr. Amina Wanjiru',  'Obstetrics',       'Maternity Ward',      11),
(10,'Dr. Peter Kamau',   'Psychiatry',       'Mental Health',        7);
GO

-- Generate 1000 Patients
DECLARE @i INT = 1;
DECLARE @pnames TABLE (id INT IDENTITY(1,1), name NVARCHAR(100));
INSERT INTO @pnames VALUES
('James Mwangi'),('Sarah Johnson'),('Carlos Mendes'),('Amina Hassan'),
('Grace Osei'),('Ivan Petrov'),('Mei Tanaka'),('David Kimani'),
('Emma Rossi'),('Omar Farooq'),('Alice Wanjiku'),('Brian Otieno'),
('Catherine Njeri'),('Daniel Kiprop'),('Elizabeth Auma'),('Francis Kamau'),
('Gloria Adhiambo'),('Henry Mutua'),('Irene Wambui'),('Joseph Kariuki');
DECLARE @btypes TABLE (id INT IDENTITY(1,1), bt NVARCHAR(5));
INSERT INTO @btypes VALUES ('O+'),('A+'),('B+'),('AB+'),('O-'),('A-'),('B-'),('AB-');
DECLARE @pcountries TABLE (id INT IDENTITY(1,1), country NVARCHAR(50));
INSERT INTO @pcountries VALUES ('Kenya'),('Nigeria'),('UK'),('USA'),('Ghana'),('Uganda'),('Tanzania'),('Ethiopia'),('Rwanda'),('Senegal');

WHILE @i <= 1000
BEGIN
    INSERT INTO Patients (patient_id, first_name, last_name, gender, date_of_birth, country, blood_type)
    VALUES (
        @i,
        LEFT((SELECT TOP 1 name FROM @pnames ORDER BY NEWID()), CHARINDEX(' ', (SELECT TOP 1 name FROM @pnames ORDER BY NEWID()) + ' ') - 1),
        'Patient' + CAST(@i AS NVARCHAR),
        CASE WHEN @i % 2 = 0 THEN 'Male' ELSE 'Female' END,
        DATEADD(DAY, -(ABS(CHECKSUM(NEWID())) % 25550 + 6570), GETDATE()),
        (SELECT TOP 1 country FROM @pcountries ORDER BY NEWID()),
        (SELECT TOP 1 bt FROM @btypes ORDER BY NEWID())
    );
    SET @i = @i + 1;
END
GO

-- Generate 5000 Admissions
DECLARE @i INT = 1;
DECLARE @diagnoses TABLE (id INT IDENTITY(1,1), diag NVARCHAR(100));
INSERT INTO @diagnoses VALUES
('Hypertension'),('Diabetes Type 2'),('Malaria'),('Tuberculosis'),
('Heart Attack'),('Stroke'),('Pneumonia'),('Appendicitis'),
('Hip Fracture'),('Asthma'),('Cancer'),('Epilepsy'),
('Heart Failure'),('Kidney Disease'),('HIV/AIDS'),
('Typhoid'),('Anaemia'),('Arthritis'),('Depression'),('Covid-19');
DECLARE @atypes TABLE (id INT IDENTITY(1,1), typ NVARCHAR(50));
INSERT INTO @atypes VALUES ('Emergency'),('Elective'),('Urgent'),('Emergency'),('Urgent');
DECLARE @outcomes TABLE (id INT IDENTITY(1,1), out NVARCHAR(50));
INSERT INTO @outcomes VALUES ('Recovered'),('Recovered'),('Recovered'),('Recovered'),('Referred'),('Deceased');

WHILE @i <= 5000
BEGIN
    DECLARE @admdate DATE = DATEADD(DAY, -(ABS(CHECKSUM(NEWID())) % 730), GETDATE());
    DECLARE @los INT = ABS(CHECKSUM(NEWID())) % 20 + 1;
    INSERT INTO Admissions (admission_id, patient_id, doctor_id, hospital_id, admission_date, discharge_date, diagnosis, admission_type, outcome)
    VALUES (
        100 + @i,
        (ABS(CHECKSUM(NEWID())) % 1000) + 1,
        (ABS(CHECKSUM(NEWID())) % 10) + 1,
        (ABS(CHECKSUM(NEWID())) % 10) + 1,
        @admdate,
        DATEADD(DAY, @los, @admdate),
        (SELECT TOP 1 diag FROM @diagnoses ORDER BY NEWID()),
        (SELECT TOP 1 typ FROM @atypes ORDER BY NEWID()),
        (SELECT TOP 1 out FROM @outcomes ORDER BY NEWID())
    );
    SET @i = @i + 1;
END
GO

-- Generate 5000 Billing records
DECLARE @i INT = 1;
DECLARE @pstatus TABLE (id INT IDENTITY(1,1), stat NVARCHAR(50));
INSERT INTO @pstatus VALUES ('Paid'),('Paid'),('Paid'),('Pending'),('Waived');

WHILE @i <= 5000
BEGIN
    DECLARE @tcost DECIMAL(10,2) = ROUND((ABS(CHECKSUM(NEWID())) % 15000 + 500), 2);
    DECLARE @mcost DECIMAL(10,2) = ROUND(@tcost * 0.3, 2);
    DECLARE @rcost DECIMAL(10,2) = ROUND(@tcost * 0.2, 2);
    DECLARE @ins   DECIMAL(10,2) = ROUND((@tcost + @mcost + @rcost) * (ABS(CHECKSUM(NEWID())) % 90 + 10) / 100, 2);
    INSERT INTO Billing (bill_id, admission_id, treatment_cost, medication_cost, room_cost, insurance_covered, payment_status)
    VALUES (
        @i,
        100 + @i,
        @tcost, @mcost, @rcost, @ins,
        (SELECT TOP 1 stat FROM @pstatus ORDER BY NEWID())
    );
    SET @i = @i + 1;
END
GO

PRINT 'Healthcare: 1000 patients, 5000 admissions, 5000 billing records generated!';
GO


-- ============================================================
-- PART 3: SALES ANALYTICS — MASSIVE DATA
-- ============================================================

USE SalesAnalytics;
GO

DELETE FROM OrderItems;
DELETE FROM Orders;
DELETE FROM Products;
DELETE FROM SalesReps;
DELETE FROM Customers;
GO

-- Re-insert reference data
INSERT INTO SalesReps VALUES
(1,'James Mwangi',  'Africa'),
(2,'Sarah Connor',  'Americas'),
(3,'Liam Chen',     'Asia Pacific'),
(4,'Emma Rossi',    'Europe'),
(5,'Noah Williams', 'Middle East'),
(6,'Grace Osei',    'Africa'),
(7,'Ivan Petrov',   'Europe'),
(8,'Mei Tanaka',    'Asia Pacific'),
(9,'Carlos Mendes', 'Americas'),
(10,'Fatima Al-Sayed','Middle East');

INSERT INTO Products VALUES
(1, 'Laptop Pro 15',        'Electronics',  1200.00),
(2, 'Wireless Mouse',       'Electronics',    25.00),
(3, 'Office Chair',         'Furniture',     350.00),
(4, 'Standing Desk',        'Furniture',     600.00),
(5, 'Notebook Bundle',      'Stationery',     15.00),
(6, 'Monitor 27"',          'Electronics',   450.00),
(7, 'Mechanical Keyboard',  'Electronics',   120.00),
(8, 'Desk Lamp',            'Furniture',      45.00),
(9, 'Headphones Pro',       'Electronics',   200.00),
(10,'Webcam HD',            'Electronics',    85.00),
(11,'Ergonomic Mouse',      'Electronics',    55.00),
(12,'USB Hub 7-Port',       'Electronics',    35.00),
(13,'Filing Cabinet',       'Furniture',     280.00),
(14,'Printer All-in-One',   'Electronics',   320.00),
(15,'Paper Ream 500',       'Stationery',     8.00);
GO

-- Generate 1000 Customers
DECLARE @i INT = 1;
DECLARE @snames TABLE (id INT IDENTITY(1,1), name NVARCHAR(100));
INSERT INTO @snames VALUES
('Alice Johnson'),('Bob Smith'),('Carlos Mendes'),('Diana Prince'),
('Ethan Nkosi'),('Fatima Al-Sayed'),('George Tan'),('Hannah Muller'),
('Ivan Petrov'),('Jane Osei'),('James Mwangi'),('Sarah Connor'),
('Grace Osei'),('David Kimani'),('Emma Rossi'),('Omar Farooq'),
('Aisha Diallo'),('Lucas Dupont'),('Mei Tanaka'),('Noah Williams');
DECLARE @scountries TABLE (id INT IDENTITY(1,1), country NVARCHAR(50));
INSERT INTO @scountries VALUES ('USA'),('UK'),('Brazil'),('Kenya'),('Nigeria'),('UAE'),('Singapore'),('Germany'),('Russia'),('Ghana'),('Japan'),('France'),('India'),('Canada'),('Australia');
DECLARE @segments TABLE (id INT IDENTITY(1,1), seg NVARCHAR(50));
INSERT INTO @segments VALUES ('Corporate'),('Consumer'),('Small Business'),('Corporate'),('Consumer');

WHILE @i <= 1000
BEGIN
    INSERT INTO Customers (customer_id, customer_name, country, segment)
    VALUES (
        @i,
        (SELECT TOP 1 name FROM @snames ORDER BY NEWID()),
        (SELECT TOP 1 country FROM @scountries ORDER BY NEWID()),
        (SELECT TOP 1 seg FROM @segments ORDER BY NEWID())
    );
    SET @i = @i + 1;
END
GO

-- Generate 5000 Orders
DECLARE @i INT = 1;
DECLARE @ostatus TABLE (id INT IDENTITY(1,1), stat NVARCHAR(50));
INSERT INTO @ostatus VALUES ('Completed'),('Completed'),('Completed'),('Completed'),('Returned'),('Pending');

WHILE @i <= 5000
BEGIN
    DECLARE @odate DATE = DATEADD(DAY, -(ABS(CHECKSUM(NEWID())) % 730), GETDATE());
    INSERT INTO Orders (order_id, customer_id, rep_id, order_date, ship_date, status)
    VALUES (
        1000 + @i,
        (ABS(CHECKSUM(NEWID())) % 1000) + 1,
        (ABS(CHECKSUM(NEWID())) % 10) + 1,
        @odate,
        DATEADD(DAY, ABS(CHECKSUM(NEWID())) % 10 + 1, @odate),
        (SELECT TOP 1 stat FROM @ostatus ORDER BY NEWID())
    );
    SET @i = @i + 1;
END
GO

-- Generate 8000 Order Items
DECLARE @i INT = 1;
WHILE @i <= 8000
BEGIN
    DECLARE @qty INT = ABS(CHECKSUM(NEWID())) % 10 + 1;
    DECLARE @pid INT = (ABS(CHECKSUM(NEWID())) % 15) + 1;
    DECLARE @disc DECIMAL(4,2) = ROUND((ABS(CHECKSUM(NEWID())) % 30) / 100.0, 2);
    DECLARE @uprice DECIMAL(10,2);
    SELECT @uprice = unit_price FROM Products WHERE product_id = @pid;
    INSERT INTO OrderItems (item_id, order_id, product_id, quantity, discount, revenue)
    VALUES (
        @i,
        1000 + (ABS(CHECKSUM(NEWID())) % 5000) + 1,
        @pid,
        @qty,
        @disc,
        ROUND(@qty * @uprice * (1 - @disc), 2)
    );
    SET @i = @i + 1;
END
GO

PRINT 'Sales: 1000 customers, 5000 orders, 8000 order items generated!';
GO


-- ============================================================
-- PART 4: ECOMMERCE ANALYTICS — MASSIVE DATA
-- ============================================================

USE EcommerceAnalytics;
GO

DELETE FROM Reviews;
DELETE FROM OrderItems;
DELETE FROM Orders;
DELETE FROM Products;
DELETE FROM Sellers;
DELETE FROM Customers;
GO

INSERT INTO Sellers VALUES
(1,'TechWorld Store',     'USA',         4.8,'2018-01-15'),
(2,'Fashion Hub',         'Italy',       4.5,'2019-03-22'),
(3,'Sports Elite',        'UK',          4.7,'2017-06-10'),
(4,'Home Essentials',     'Germany',     4.3,'2020-02-28'),
(5,'African Marketplace', 'Kenya',       4.6,'2021-01-05'),
(6,'Global Gadgets',      'China',       4.2,'2018-09-14'),
(7,'Beauty Palace',       'France',      4.4,'2019-07-01'),
(8,'Book World',          'USA',         4.9,'2016-03-15'),
(9,'Sports Kenya',        'Kenya',       4.5,'2020-06-01'),
(10,'Electronics Hub',    'Japan',       4.7,'2017-11-20');

INSERT INTO Products VALUES
(1, 'iPhone 15 Pro',         'Electronics',   'Apple',      1099.00,  780.00, 150),
(2, 'Samsung 4K TV 55"',     'Electronics',   'Samsung',     799.00,  520.00,  80),
(3, 'Nike Air Max 270',      'Footwear',      'Nike',        149.00,   65.00, 500),
(4, 'Adidas Ultraboost',     'Footwear',      'Adidas',      179.00,   75.00, 350),
(5, 'Coffee Maker Pro',      'Home & Kitchen','Breville',     89.00,   38.00, 200),
(6, 'Dyson V15 Vacuum',      'Home & Kitchen','Dyson',       599.00,  380.00,  60),
(7, 'Harry Potter Box Set',  'Books',         'Bloomsbury',   45.00,   18.00,1000),
(8, 'Yoga Mat Premium',      'Sports',        'Lululemon',    68.00,   25.00, 400),
(9, 'MacBook Air M2',        'Electronics',   'Apple',      1299.00,  950.00,  75),
(10,'Levi 501 Jeans',        'Clothing',      'Levis',        89.00,   32.00, 600),
(11,'PlayStation 5',         'Electronics',   'Sony',        499.00,  380.00,  40),
(12,'KitchenAid Mixer',      'Home & Kitchen','KitchenAid',  399.00,  220.00,  90),
(13,'Kindle Paperwhite',     'Electronics',   'Amazon',      139.00,   70.00, 300),
(14,'Zara Summer Dress',     'Clothing',      'Zara',         59.00,   18.00, 800),
(15,'Protein Powder 2kg',    'Sports',        'Optimum',      55.00,   22.00, 700),
(16,'Samsung Galaxy S24',    'Electronics',   'Samsung',     999.00,  680.00, 120),
(17,'Running Shoes Pro',     'Footwear',      'Asics',       159.00,   70.00, 250),
(18,'Blender Pro 1200W',     'Home & Kitchen','Kenwood',     129.00,   55.00, 180),
(19,'The Alchemist Novel',   'Books',         'Harper',       15.00,    6.00,2000),
(20,'Resistance Bands Set',  'Sports',        'GymPro',       35.00,   12.00, 900);
GO

-- Generate 1000 Customers
DECLARE @i INT = 1;
DECLARE @enames TABLE (id INT IDENTITY(1,1), name NVARCHAR(100));
INSERT INTO @enames VALUES
('James Mwangi'),('Sarah Johnson'),('Carlos Mendes'),('Amina Hassan'),
('Liam Chen'),('Fatima Al-Sayed'),('Noah Williams'),('Grace Osei'),
('Ivan Petrov'),('Mei Tanaka'),('Alice Wanjiku'),('Brian Otieno'),
('Catherine Njeri'),('Daniel Kiprop'),('Elizabeth Auma'),
('Francis Kamau'),('Gloria Adhiambo'),('Henry Mutua'),('Irene Wambui'),('Joseph Kariuki');
DECLARE @ecountries TABLE (id INT IDENTITY(1,1), country NVARCHAR(50));
INSERT INTO @ecountries VALUES ('Kenya'),('Nigeria'),('USA'),('UK'),('UAE'),('Ghana'),('Japan'),('Germany'),('France'),('Brazil'),('India'),('China'),('South Africa'),('Canada'),('Australia');
DECLARE @ecities TABLE (id INT IDENTITY(1,1), city NVARCHAR(50));
INSERT INTO @ecities VALUES ('Nairobi'),('Lagos'),('New York'),('London'),('Dubai'),('Accra'),('Tokyo'),('Berlin'),('Paris'),('Sao Paulo'),('Mumbai'),('Shanghai'),('Johannesburg'),('Toronto'),('Sydney');
DECLARE @ctypes TABLE (id INT IDENTITY(1,1), ct NVARCHAR(20));
INSERT INTO @ctypes VALUES ('New'),('Returning'),('Returning'),('VIP'),('Returning');

WHILE @i <= 1000
BEGIN
    INSERT INTO Customers (customer_id, full_name, gender, date_of_birth, email, country, city, signup_date, customer_type)
    VALUES (
        @i,
        (SELECT TOP 1 name FROM @enames ORDER BY NEWID()),
        CASE WHEN @i % 2 = 0 THEN 'Male' ELSE 'Female' END,
        DATEADD(DAY, -(ABS(CHECKSUM(NEWID())) % 14600 + 6570), GETDATE()),
        'customer' + CAST(@i AS NVARCHAR) + '@email.com',
        (SELECT TOP 1 country FROM @ecountries ORDER BY NEWID()),
        (SELECT TOP 1 city FROM @ecities ORDER BY NEWID()),
        DATEADD(DAY, -(ABS(CHECKSUM(NEWID())) % 1825 + 30), GETDATE()),
        (SELECT TOP 1 ct FROM @ctypes ORDER BY NEWID())
    );
    SET @i = @i + 1;
END
GO

-- Generate 5000 Orders
DECLARE @i INT = 1;
DECLARE @eostatus TABLE (id INT IDENTITY(1,1), stat NVARCHAR(50));
INSERT INTO @eostatus VALUES ('Delivered'),('Delivered'),('Delivered'),('Returned'),('Cancelled'),('Delivered');
DECLARE @pmethods TABLE (id INT IDENTITY(1,1), pm NVARCHAR(50));
INSERT INTO @pmethods VALUES ('Credit Card'),('Mobile Money'),('PayPal'),('Credit Card'),('Credit Card'),('Cash');

WHILE @i <= 5000
BEGIN
    DECLARE @odate2 DATE = DATEADD(DAY, -(ABS(CHECKSUM(NEWID())) % 730), GETDATE());
    INSERT INTO Orders (order_id, customer_id, seller_id, order_date, delivery_date, order_status, payment_method, shipping_cost)
    VALUES (
        3000 + @i,
        (ABS(CHECKSUM(NEWID())) % 1000) + 1,
        (ABS(CHECKSUM(NEWID())) % 10) + 1,
        @odate2,
        DATEADD(DAY, ABS(CHECKSUM(NEWID())) % 12 + 2, @odate2),
        (SELECT TOP 1 stat FROM @eostatus ORDER BY NEWID()),
        (SELECT TOP 1 pm FROM @pmethods ORDER BY NEWID()),
        ROUND((ABS(CHECKSUM(NEWID())) % 40 + 5), 2)
    );
    SET @i = @i + 1;
END
GO

-- Generate 8000 Order Items
DECLARE @i INT = 1;
WHILE @i <= 8000
BEGIN
    DECLARE @epid INT = (ABS(CHECKSUM(NEWID())) % 20) + 1;
    DECLARE @eqty INT = ABS(CHECKSUM(NEWID())) % 5 + 1;
    DECLARE @edisc DECIMAL(4,2) = ROUND((ABS(CHECKSUM(NEWID())) % 25) / 100.0, 2);
    DECLARE @euprice DECIMAL(10,2);
    SELECT @euprice = unit_price FROM Products WHERE product_id = @epid;
    INSERT INTO OrderItems (item_id, order_id, product_id, quantity, unit_price, discount_pct, revenue)
    VALUES (
        @i,
        3000 + (ABS(CHECKSUM(NEWID())) % 5000) + 1,
        @epid,
        @eqty,
        @euprice,
        @edisc,
        ROUND(@eqty * @euprice * (1 - @edisc), 2)
    );
    SET @i = @i + 1;
END
GO

-- Generate 3000 Reviews
DECLARE @i INT = 1;
WHILE @i <= 3000
BEGIN
    INSERT INTO Reviews (review_id, product_id, customer_id, rating, review_date, verified_purchase)
    VALUES (
        @i,
        (ABS(CHECKSUM(NEWID())) % 20) + 1,
        (ABS(CHECKSUM(NEWID())) % 1000) + 1,
        ABS(CHECKSUM(NEWID())) % 5 + 1,
        DATEADD(DAY, -(ABS(CHECKSUM(NEWID())) % 700), GETDATE()),
        CASE WHEN ABS(CHECKSUM(NEWID())) % 5 > 0 THEN 1 ELSE 0 END
    );
    SET @i = @i + 1;
END
GO

PRINT 'Ecommerce: 1000 customers, 5000 orders, 8000 order items, 3000 reviews generated!';
GO

-- ============================================================
-- FINAL SUMMARY — Row Counts Across All Projects
-- ============================================================

PRINT '========================================';
PRINT 'PORTFOLIO DATA UPGRADE COMPLETE!';
PRINT '========================================';

USE BankingAnalytics;
SELECT 'BankingAnalytics' AS Database_Name, 'Customers' AS Table_Name, COUNT(*) AS Row_Count FROM Customers UNION ALL
SELECT 'BankingAnalytics','Accounts', COUNT(*) FROM Accounts UNION ALL
SELECT 'BankingAnalytics','Transactions', COUNT(*) FROM Transactions UNION ALL
SELECT 'BankingAnalytics','Loans', COUNT(*) FROM Loans;

USE HealthcareAnalytics;
SELECT 'HealthcareAnalytics','Patients', COUNT(*) FROM Patients UNION ALL
SELECT 'HealthcareAnalytics','Admissions', COUNT(*) FROM Admissions UNION ALL
SELECT 'HealthcareAnalytics','Billing', COUNT(*) FROM Billing;

USE SalesAnalytics;
SELECT 'SalesAnalytics','Customers', COUNT(*) FROM Customers UNION ALL
SELECT 'SalesAnalytics','Orders', COUNT(*) FROM Orders UNION ALL
SELECT 'SalesAnalytics','OrderItems', COUNT(*) FROM OrderItems;

USE EcommerceAnalytics;
SELECT 'EcommerceAnalytics','Customers', COUNT(*) FROM Customers UNION ALL
SELECT 'EcommerceAnalytics','Orders', COUNT(*) FROM Orders UNION ALL
SELECT 'EcommerceAnalytics','OrderItems', COUNT(*) FROM OrderItems UNION ALL
SELECT 'EcommerceAnalytics','Reviews', COUNT(*) FROM Reviews;
GO
