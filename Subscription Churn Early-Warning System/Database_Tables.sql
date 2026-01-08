DROP DATABASE IF EXISTS churn_analysis;
CREATE DATABASE churn_analysis;
USE churn_analysis;

CREATE TABLE customers (
  customer_id INT PRIMARY KEY,
  signup_date DATE,
  plan_type VARCHAR(20),
  country VARCHAR(50)
);

CREATE TABLE usage_activity (
  activity_id INT PRIMARY KEY,
  customer_id INT,
  activity_date DATE,
  minutes_used INT
);

CREATE TABLE payments (
  payment_id INT PRIMARY KEY,
  customer_id INT,
  payment_date DATE,
  amount DECIMAL(10,2),
  payment_status VARCHAR(20)
);

CREATE TABLE support_tickets (
  ticket_id INT PRIMARY KEY,
  customer_id INT,
  ticket_date DATE
);
