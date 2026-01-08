SELECT
  customer_id,
  churn_risk_score,
  churn_risk_level
FROM churn_risk_scores
ORDER BY churn_risk_score DESC;
