-- ============================================================
--   HEALTHCARE ANALYTICS PORTFOLIO PROJECT
--   Author: Abigail Kimani
--   Tools: SQL Server (SSMS)
--   Skills: SELECT, Filtering, JOINs, CTEs, Subqueries, CASE
--   Description: Analysing hospital patient data to improve
--                care quality, reduce costs & save lives
-- ============================================================


-- ============================================================
-- SECTION 1: DATABASE & TABLE SETUP 
-- ============================================================

CREATE DATABASE HealthcareAnalytics;
GO

USE HealthcareAnalytics;
GO

-- Patients Table
CREATE TABLE Patients (
    patient_id       INT PRIMARY KEY,
    first_name       NVARCHAR(50),
    last_name        NVARCHAR(50),
    gender           NVARCHAR(10),
    date_of_birth    DATE,
    country          NVARCHAR(50),
    blood_type       NVARCHAR(5)
);

-- Doctors Table
CREATE TABLE Doctors (
    doctor_id        INT PRIMARY KEY,
    doctor_name      NVARCHAR(100),
    specialization   NVARCHAR(100),
    department       NVARCHAR(100),
    years_experience INT
);

-- Hospitals Table
CREATE TABLE Hospitals (
    hospital_id      INT PRIMARY KEY,
    hospital_name    NVARCHAR(100),
    city             NVARCHAR(50),
    country          NVARCHAR(50),
    hospital_type    NVARCHAR(50)  -- Public, Private
);

-- Admissions Table
CREATE TABLE Admissions (
    admission_id     INT PRIMARY KEY,
    patient_id       INT FOREIGN KEY REFERENCES Patients(patient_id),
    doctor_id        INT FOREIGN KEY REFERENCES Doctors(doctor_id),
    hospital_id      INT FOREIGN KEY REFERENCES Hospitals(hospital_id),
    admission_date   DATE,
    discharge_date   DATE,
    diagnosis        NVARCHAR(100),
    admission_type   NVARCHAR(50),  -- Emergency, Elective, Urgent
    outcome          NVARCHAR(50)   -- Recovered, Referred, Deceased
);

-- Billing Table
CREATE TABLE Billing (
    bill_id          INT PRIMARY KEY,
    admission_id     INT FOREIGN KEY REFERENCES Admissions(admission_id),
    treatment_cost   DECIMAL(10,2),
    medication_cost  DECIMAL(10,2),
    room_cost        DECIMAL(10,2),
    insurance_covered DECIMAL(10,2),
    payment_status   NVARCHAR(50)   -- Paid, Pending, Waived
);
GO


-- ============================================================
-- SECTION 2: INSERT SAMPLE DATA
-- ============================================================

INSERT INTO Patients VALUES
(1,  'James',   'Mwangi',    'Male',   '1980-03-15', 'Kenya',     'O+'),
(2,  'Sarah',   'Johnson',   'Female', '1992-07-22', 'USA',       'A+'),
(3,  'Carlos',  'Mendes',    'Male',   '1975-11-08', 'Brazil',    'B+'),
(4,  'Amina',   'Hassan',    'Female', '1988-05-30', 'Nigeria',   'AB+'),
(5,  'Liam',    'Chen',      'Male',   '2001-01-14', 'China',     'O-'),
(6,  'Fatima',  'Al-Sayed',  'Female', '1965-09-25', 'UAE',       'A-'),
(7,  'Noah',    'Williams',  'Male',   '1995-04-18', 'UK',        'B-'),
(8,  'Grace',   'Osei',      'Female', '1970-12-03', 'Ghana',     'O+'),
(9,  'Ivan',    'Petrov',    'Male',   '1983-06-27', 'Russia',    'A+'),
(10, 'Mei',     'Tanaka',    'Female', '1999-08-11', 'Japan',     'AB-'),
(11, 'David',   'Kimani',    'Male',   '1955-02-19', 'Kenya',     'O+'),
(12, 'Emma',    'Rossi',     'Female', '1978-10-07', 'Italy',     'B+'),
(13, 'Omar',    'Farooq',    'Male',   '1990-03-23', 'Pakistan',  'A+'),
(14, 'Aisha',   'Diallo',    'Female', '1968-07-14', 'Senegal',   'O-'),
(15, 'Lucas',   'Dupont',    'Male',   '2005-11-30', 'France',    'A+');

INSERT INTO Doctors VALUES
(1,  'Dr. Emily Carter',    'Cardiology',       'Heart & Vascular',    15),
(2,  'Dr. John Otieno',     'General Medicine', 'General Ward',         8),
(3,  'Dr. Priya Sharma',    'Oncology',         'Cancer Center',       20),
(4,  'Dr. Ahmed Malik',     'Neurology',        'Brain & Spine',       12),
(5,  'Dr. Sofia Martins',   'Pediatrics',       'Childrens Ward',       6),
(6,  'Dr. James Nkosi',     'Emergency',        'Emergency Unit',      10),
(7,  'Dr. Laura Schmidt',   'Orthopedics',      'Bone & Joint',         9),
(8,  'Dr. Raj Patel',       'Endocrinology',    'Diabetes & Hormones', 14);

INSERT INTO Hospitals VALUES
(1, 'Nairobi General Hospital',    'Nairobi',      'Kenya',   'Public'),
(2, 'Lagos Island Medical Centre', 'Lagos',        'Nigeria', 'Private'),
(3, 'St. Thomas Hospital',         'London',       'UK',      'Public'),
(4, 'Mayo Clinic',                 'Minnesota',    'USA',     'Private'),
(5, 'Tokyo Medical University',    'Tokyo',        'Japan',   'Public');

INSERT INTO Admissions VALUES
(101, 1,  6, 1, '2023-01-10', '2023-01-15', 'Heart Attack',          'Emergency', 'Recovered'),
(102, 2,  1, 4, '2023-01-20', '2023-01-28', 'Hypertension',          'Elective',  'Recovered'),
(103, 3,  3, 2, '2023-02-05', '2023-02-20', 'Lung Cancer',           'Urgent',    'Referred'),
(104, 4,  8, 2, '2023-02-14', '2023-02-18', 'Diabetes Type 2',       'Elective',  'Recovered'),
(105, 5,  4, 5, '2023-03-01', '2023-03-10', 'Epilepsy',              'Urgent',    'Recovered'),
(106, 6,  1, 4, '2023-03-15', '2023-03-22', 'Coronary Artery Disease','Elective', 'Recovered'),
(107, 7,  6, 3, '2023-04-02', '2023-04-04', 'Appendicitis',          'Emergency', 'Recovered'),
(108, 8,  2, 1, '2023-04-20', '2023-05-01', 'Pneumonia',             'Urgent',    'Recovered'),
(109, 9,  7, 3, '2023-05-10', '2023-05-18', 'Hip Fracture',          'Emergency', 'Recovered'),
(110, 10, 5, 5, '2023-05-25', '2023-05-30', 'Asthma',                'Urgent',    'Recovered'),
(111, 11, 1, 1, '2023-06-05', '2023-06-08', 'Heart Failure',         'Emergency', 'Deceased'),
(112, 12, 3, 4, '2023-06-15', '2023-07-01', 'Breast Cancer',         'Elective',  'Referred'),
(113, 13, 8, 2, '2023-07-10', '2023-07-14', 'Diabetes Type 1',       'Urgent',    'Recovered'),
(114, 14, 2, 1, '2023-08-01', '2023-08-10', 'Tuberculosis',          'Urgent',    'Recovered'),
(115, 15, 5, 5, '2023-09-05', '2023-09-07', 'Fever & Infection',     'Emergency', 'Recovered'),
(116, 1,  6, 1, '2023-09-20', '2023-09-25', 'Chest Pain',            'Emergency', 'Recovered'),
(117, 4,  8, 2, '2023-10-10', '2023-10-13', 'Diabetes Complication', 'Urgent',    'Recovered'),
(118, 6,  1, 4, '2023-11-01', '2023-11-09', 'Angina',                'Elective',  'Recovered'),
(119, 8,  2, 1, '2023-11-20', '2023-11-25', 'Malaria',               'Urgent',    'Recovered'),
(120, 11, 4, 1, '2023-12-01', '2023-12-15', 'Stroke',                'Emergency', 'Referred');

INSERT INTO Billing VALUES
(1,  101, 2500.00,  800.00,  600.00,  2000.00, 'Paid'),
(2,  102, 1800.00,  500.00,  400.00,  1500.00, 'Paid'),
(3,  103, 8000.00, 3000.00, 1500.00,  5000.00, 'Pending'),
(4,  104, 1200.00,  600.00,  300.00,   900.00, 'Paid'),
(5,  105, 3000.00,  900.00,  700.00,  2000.00, 'Paid'),
(6,  106, 5000.00, 1500.00,  800.00,  4000.00, 'Paid'),
(7,  107, 4000.00,  700.00,  500.00,  3500.00, 'Paid'),
(8,  108, 2200.00,  800.00,  900.00,  1500.00, 'Paid'),
(9,  109, 6000.00, 1200.00,  800.00,  4500.00, 'Pending'),
(10, 110,  800.00,  400.00,  200.00,   600.00, 'Paid'),
(11, 111, 9000.00, 2000.00, 1000.00,  7000.00, 'Waived'),
(12, 112,12000.00, 5000.00, 2000.00,  8000.00, 'Pending'),
(13, 113, 1500.00,  700.00,  300.00,  1000.00, 'Paid'),
(14, 114, 2800.00, 1200.00,  700.00,  1500.00, 'Paid'),
(15, 115,  600.00,  200.00,  150.00,   400.00, 'Paid'),
(16, 116, 3200.00,  900.00,  600.00,  2500.00, 'Paid'),
(17, 117, 1800.00,  800.00,  400.00,  1200.00, 'Paid'),
(18, 118, 4500.00, 1300.00,  700.00,  3500.00, 'Paid'),
(19, 119,  900.00,  350.00,  250.00,   500.00, 'Paid'),
(20, 120, 7500.00, 2500.00, 1200.00,  5000.00, 'Pending');
GO


-- ============================================================
-- SECTION 3: ANALYSIS QUERIES
-- ============================================================


-- ============================================================
-- QUERY 1: Patient Age & Risk Classification
-- Skill: SELECT + CASE + Date Functions
-- Business Question: How old are our patients & what age risk group are they in?
-- ============================================================

SELECT 
    patient_id,
    first_name + ' ' + last_name            AS full_name,
    gender,
    country,
    DATEDIFF(YEAR, date_of_birth, GETDATE()) AS age,
    CASE 
        WHEN DATEDIFF(YEAR, date_of_birth, GETDATE()) < 18  THEN 'Child (0-17)'
        WHEN DATEDIFF(YEAR, date_of_birth, GETDATE()) < 35  THEN 'Young Adult (18-34)'
        WHEN DATEDIFF(YEAR, date_of_birth, GETDATE()) < 60  THEN 'Middle Aged (35-59)'
        ELSE                                                      'Senior (60+)'
    END AS age_group
FROM Patients
ORDER BY age DESC;


-- ============================================================
-- QUERY 2: Hospital Admission Volume & Outcomes
-- Skill: JOIN + Aggregation + CASE
-- Business Question: Which hospitals handle the most patients & what are their outcomes?
-- ============================================================

SELECT 
    h.hospital_name,
    h.country,
    h.hospital_type,
    COUNT(a.admission_id)                                               AS total_admissions,
    COUNT(CASE WHEN a.outcome = 'Recovered' THEN 1 END)                AS recovered,
    COUNT(CASE WHEN a.outcome = 'Referred'  THEN 1 END)                AS referred,
    COUNT(CASE WHEN a.outcome = 'Deceased'  THEN 1 END)                AS deceased,
    ROUND(COUNT(CASE WHEN a.outcome = 'Recovered' THEN 1 END) * 100.0
          / COUNT(a.admission_id), 1)                                   AS recovery_rate_pct
FROM Hospitals h
JOIN Admissions a ON h.hospital_id = a.hospital_id
GROUP BY h.hospital_name, h.country, h.hospital_type
ORDER BY total_admissions DESC;


-- ============================================================
-- QUERY 3: Average Length of Stay by Diagnosis
-- Skill: JOIN + Date Functions + Aggregation
-- Business Question: Which conditions require the longest hospital stays?
-- ============================================================

SELECT 
    a.diagnosis,
    COUNT(a.admission_id)                                           AS total_cases,
    ROUND(AVG(DATEDIFF(DAY, a.admission_date, a.discharge_date)),1) AS avg_days_stay,
    MIN(DATEDIFF(DAY, a.admission_date, a.discharge_date))          AS min_days,
    MAX(DATEDIFF(DAY, a.admission_date, a.discharge_date))          AS max_days
FROM Admissions a
GROUP BY a.diagnosis
ORDER BY avg_days_stay DESC;


-- ============================================================
-- QUERY 4: Doctor Performance Analysis
-- Skill: JOIN + Aggregation
-- Business Question: Which doctors handle the most cases & best recovery rates?
-- ============================================================

SELECT 
    d.doctor_name,
    d.specialization,
    d.department,
    d.years_experience,
    COUNT(a.admission_id)                                               AS total_patients,
    COUNT(CASE WHEN a.outcome = 'Recovered' THEN 1 END)                AS recovered,
    ROUND(COUNT(CASE WHEN a.outcome = 'Recovered' THEN 1 END) * 100.0
          / COUNT(a.admission_id), 1)                                   AS recovery_rate_pct,
    ROUND(AVG(DATEDIFF(DAY, a.admission_date, a.discharge_date)), 1)   AS avg_days_per_patient
FROM Doctors d
JOIN Admissions a ON d.doctor_id = a.doctor_id
GROUP BY d.doctor_name, d.specialization, d.department, d.years_experience
ORDER BY total_patients DESC;


-- ============================================================
-- QUERY 5: Total Cost vs Insurance Coverage Analysis
-- Skill: JOIN + Aggregation + Subquery
-- Business Question: How much are patients paying out of pocket?
-- ============================================================

SELECT 
    p.first_name + ' ' + p.last_name        AS patient_name,
    p.country,
    a.diagnosis,
    (b.treatment_cost + b.medication_cost 
     + b.room_cost)                         AS total_bill,
    b.insurance_covered,
    (b.treatment_cost + b.medication_cost 
     + b.room_cost) - b.insurance_covered   AS out_of_pocket,
    b.payment_status,
    CASE 
        WHEN b.insurance_covered >= (b.treatment_cost + b.medication_cost + b.room_cost) * 0.8
        THEN 'Well Insured ✅'
        WHEN b.insurance_covered >= (b.treatment_cost + b.medication_cost + b.room_cost) * 0.5
        THEN 'Partially Insured ⚠️'
        ELSE 'Under Insured 🚨'
    END AS insurance_status
FROM Patients p
JOIN Admissions a ON p.patient_id   = a.patient_id
JOIN Billing b    ON a.admission_id = b.bill_id
ORDER BY out_of_pocket DESC;


-- ============================================================
-- QUERY 6: Emergency vs Elective Admission Costs
-- Skill: JOIN + GROUP BY + Aggregation
-- Business Question: Do emergency admissions cost more than elective ones?
-- ============================================================

SELECT 
    a.admission_type,
    COUNT(a.admission_id)                                           AS total_admissions,
    ROUND(AVG(b.treatment_cost + b.medication_cost 
              + b.room_cost), 2)                                    AS avg_total_cost,
    ROUND(AVG(DATEDIFF(DAY, a.admission_date, a.discharge_date)),1) AS avg_length_of_stay,
    SUM(b.treatment_cost + b.medication_cost + b.room_cost)         AS total_revenue
FROM Admissions a
JOIN Billing b ON a.admission_id = b.admission_id
GROUP BY a.admission_type
ORDER BY avg_total_cost DESC;


-- ============================================================
-- QUERY 7: CTE — High Risk Patients (Readmissions)
-- Skill: CTE + Aggregation
-- Business Question: Which patients have been admitted more than once? (Readmission Risk)
-- ============================================================

WITH PatientAdmissions AS (
    SELECT 
        p.patient_id,
        p.first_name + ' ' + p.last_name    AS patient_name,
        p.gender,
        DATEDIFF(YEAR, p.date_of_birth, GETDATE()) AS age,
        COUNT(a.admission_id)               AS total_admissions,
        MAX(a.admission_date)               AS last_admission,
        STRING_AGG(a.diagnosis, ', ')       AS diagnoses
    FROM Patients p
    JOIN Admissions a ON p.patient_id = a.patient_id
    GROUP BY p.patient_id, p.first_name, p.last_name, p.gender, p.date_of_birth
)
SELECT 
    patient_name,
    gender,
    age,
    total_admissions,
    last_admission,
    diagnoses,
    CASE 
        WHEN total_admissions >= 3 THEN 'High Risk 🚨'
        WHEN total_admissions = 2  THEN 'Medium Risk ⚠️'
        ELSE                            'Low Risk ✅'
    END AS readmission_risk
FROM PatientAdmissions
ORDER BY total_admissions DESC;


-- ============================================================
-- QUERY 8: CTE — Monthly Admissions Trend
-- Skill: CTE + Date Functions
-- Business Question: Are hospital admissions increasing or decreasing?
-- ============================================================

WITH MonthlyTrend AS (
    SELECT 
        YEAR(admission_date)            AS yr,
        MONTH(admission_date)           AS mth,
        DATENAME(MONTH, admission_date) AS month_name,
        COUNT(admission_id)             AS total_admissions,
        COUNT(CASE WHEN admission_type = 'Emergency' THEN 1 END) AS emergency_count,
        COUNT(CASE WHEN outcome = 'Recovered' THEN 1 END)        AS recovered_count
    FROM Admissions
    GROUP BY YEAR(admission_date), MONTH(admission_date), 
             DATENAME(MONTH, admission_date)
)
SELECT 
    yr,
    month_name,
    total_admissions,
    emergency_count,
    recovered_count,
    ROUND(recovered_count * 100.0 / total_admissions, 1) AS monthly_recovery_rate
FROM MonthlyTrend
ORDER BY yr, mth;


-- ============================================================
-- QUERY 9: Department Revenue & Patient Load
-- Skill: JOIN + Aggregation + Subquery
-- Business Question: Which departments generate the most revenue?
-- ============================================================

SELECT 
    d.department,
    COUNT(DISTINCT d.doctor_id)                                     AS num_doctors,
    COUNT(a.admission_id)                                           AS total_patients,
    SUM(b.treatment_cost + b.medication_cost + b.room_cost)         AS total_revenue,
    ROUND(AVG(b.treatment_cost + b.medication_cost 
              + b.room_cost), 2)                                    AS avg_cost_per_patient,
    ROUND(SUM(b.treatment_cost + b.medication_cost + b.room_cost) 
          / (SELECT SUM(treatment_cost + medication_cost + room_cost) 
             FROM Billing) * 100, 2)                                AS revenue_share_pct
FROM Doctors d
JOIN Admissions a ON d.doctor_id    = a.doctor_id
JOIN Billing b    ON a.admission_id = b.admission_id
GROUP BY d.department
ORDER BY total_revenue DESC;


-- ============================================================
-- QUERY 10: EXECUTIVE SUMMARY — Full Healthcare Dashboard
-- Skill: Multiple CTEs chained together
-- Business Question: Give hospital management a complete overview
-- ============================================================

WITH 
TotalPatients AS (
    SELECT COUNT(DISTINCT patient_id) AS total FROM Patients
),
TotalAdmissions AS (
    SELECT COUNT(*) AS total FROM Admissions
),
OverallRecovery AS (
    SELECT 
        COUNT(CASE WHEN outcome = 'Recovered' THEN 1 END) AS recovered,
        COUNT(*) AS total
    FROM Admissions
),
TotalRevenue AS (
    SELECT SUM(treatment_cost + medication_cost + room_cost) AS total 
    FROM Billing
),
UnpaidBills AS (
    SELECT SUM(treatment_cost + medication_cost + room_cost) AS total
    FROM Billing b
    JOIN Admissions a ON b.admission_id = a.admission_id
    WHERE b.payment_status = 'Pending'
),
BusiestDoctor AS (
    SELECT TOP 1 d.doctor_name, COUNT(a.admission_id) AS seen
    FROM Doctors d
    JOIN Admissions a ON d.doctor_id = a.doctor_id
    GROUP BY d.doctor_name
    ORDER BY seen DESC
),
TopDiagnosis AS (
    SELECT TOP 1 diagnosis, COUNT(*) AS cnt
    FROM Admissions
    GROUP BY diagnosis
    ORDER BY cnt DESC
)
SELECT 
    tp.total                                                AS total_patients,
    ta.total                                                AS total_admissions,
    ROUND(or2.recovered * 100.0 / or2.total, 1)            AS overall_recovery_rate_pct,
    tr.total                                                AS total_revenue,
    ub.total                                                AS unpaid_bills,
    bd.doctor_name                                          AS busiest_doctor,
    td.diagnosis                                            AS most_common_diagnosis
FROM TotalPatients tp, TotalAdmissions ta, OverallRecovery or2,
     TotalRevenue tr, UnpaidBills ub, BusiestDoctor bd, TopDiagnosis td;
