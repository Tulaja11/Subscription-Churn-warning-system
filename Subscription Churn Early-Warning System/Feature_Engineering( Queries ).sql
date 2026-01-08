DROP VIEW IF EXISTS churn_features;


CREATE VIEW churn_features AS
SELECT
  c.customer_id,

  -- usage in last 30 days
  SUM(CASE WHEN u.activity_date >= CURDATE()-INTERVAL 30 DAY
           THEN u.minutes_used ELSE 0 END) AS last_30,

  -- usage in previous 30 days
  SUM(CASE WHEN u.activity_date BETWEEN CURDATE()-INTERVAL 60 DAY
           AND CURDATE()-INTERVAL 31 DAY
           THEN u.minutes_used ELSE 0 END) AS prev_30,

  -- failed payments
  COUNT(DISTINCT CASE WHEN p.payment_status='FAILED'
                      THEN p.payment_id END) AS failed_payments,

  -- support tickets
  COUNT(DISTINCT s.ticket_id) AS ticket_count,

  -- inactivity days
  DATEDIFF(CURDATE(), MAX(u.activity_date)) AS inactive_days

FROM customers c
LEFT JOIN usage_activity u ON c.customer_id=u.customer_id
LEFT JOIN payments p ON c.customer_id=p.customer_id
LEFT JOIN support_tickets s ON c.customer_id=s.customer_id
GROUP BY c.customer_id;
