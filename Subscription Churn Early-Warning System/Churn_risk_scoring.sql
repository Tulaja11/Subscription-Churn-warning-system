CREATE VIEW churn_risk_scores AS
SELECT
  customer_id,

  (
    CASE WHEN last_30 < prev_30*0.5 THEN 3 ELSE 0 END +
    CASE WHEN failed_payments >= 1 THEN 2 ELSE 0 END +
    CASE WHEN ticket_count >= 3 THEN 2 ELSE 0 END +
    CASE WHEN inactive_days >= 14 THEN 3 ELSE 0 END
  ) AS churn_risk_score,

  CASE
    WHEN (
      CASE WHEN last_30 < prev_30*0.5 THEN 3 ELSE 0 END +
      CASE WHEN failed_payments >= 1 THEN 2 ELSE 0 END +
      CASE WHEN ticket_count >= 3 THEN 2 ELSE 0 END +
      CASE WHEN inactive_days >= 14 THEN 3 ELSE 0 END
    ) >= 6 THEN 'HIGH'
    WHEN (
      CASE WHEN last_30 < prev_30*0.5 THEN 3 ELSE 0 END +
      CASE WHEN failed_payments >= 1 THEN 2 ELSE 0 END +
      CASE WHEN ticket_count >= 3 THEN 2 ELSE 0 END +
      CASE WHEN inactive_days >= 14 THEN 3 ELSE 0 END
    ) BETWEEN 3 AND 5 THEN 'MEDIUM'
    ELSE 'LOW'
  END AS churn_risk_level
FROM churn_features;
