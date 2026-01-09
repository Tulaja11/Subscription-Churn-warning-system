import streamlit as st
import pandas as pd
import mysql.connector
from db_config import DB_CONFIG

# ------------------ DB CONNECTION ------------------
def get_data():
    conn = mysql.connector.connect(**DB_CONFIG)
    query = """
    SELECT
        customer_id,
        churn_risk_score,
        churn_risk_level
    FROM churn_risk_scores
    ORDER BY churn_risk_score DESC
    """
    df = pd.read_sql(query, conn)
    conn.close()
    return df

# ------------------ UI ------------------
st.set_page_config(page_title="Churn Early Warning System", layout="wide")

st.title("📉 Subscription Churn Early-Warning System")
st.write("Identify customers likely to churn using behavioral risk signals.")

df = get_data()

# ------------------ METRICS ------------------
col1, col2, col3 = st.columns(3)

col1.metric("🔴 High Risk Customers", df[df["churn_risk_level"]=="HIGH"].shape[0])
col2.metric("🟡 Medium Risk Customers", df[df["churn_risk_level"]=="MEDIUM"].shape[0])
col3.metric("🟢 Low Risk Customers", df[df["churn_risk_level"]=="LOW"].shape[0])

st.divider()

# ------------------ FILTER ------------------
risk_filter = st.selectbox(
    "Filter by Churn Risk Level",
    ["ALL", "HIGH", "MEDIUM", "LOW"]
)

if risk_filter != "ALL":
    df = df[df["churn_risk_level"] == risk_filter]

# ------------------ TABLE ------------------
st.subheader("📊 Customer Churn Risk Table")
st.dataframe(df, use_container_width=True)

st.divider()
st.header("🧪 Live Churn Risk Calculator")

st.write("Enter customer behavior to calculate churn risk instantly.")

last_30 = st.number_input("Usage in last 30 days (minutes)", min_value=0)
prev_30 = st.number_input("Usage in previous 30 days (minutes)", min_value=0)
failed_payments = st.number_input("Failed payments count", min_value=0)
ticket_count = st.number_input("Support tickets (last 30 days)", min_value=0)
inactive_days = st.number_input("Inactive days", min_value=0)

if st.button("Calculate Churn Risk"):
    usage_score = 3 if prev_30 > 0 and last_30 < prev_30 * 0.5 else 0
    payment_score = 2 if failed_payments >= 1 else 0
    support_score = 2 if ticket_count >= 3 else 0
    inactivity_score = 3 if inactive_days >= 14 else 0

    churn_risk_score = usage_score + payment_score + support_score + inactivity_score

    if churn_risk_score >= 6:
        churn_risk_level = "HIGH 🔴"
    elif churn_risk_score >= 3:
        churn_risk_level = "MEDIUM 🟡"
    else:
        churn_risk_level = "LOW 🟢"

    st.success(f"Churn Risk Score: {churn_risk_score}")
    st.warning(f"Churn Risk Level: {churn_risk_level}")


# ------------------ INSIGHTS ------------------
st.divider()
st.subheader("🧠 Business Action Suggestions")

st.markdown("""
- 🔴 **High Risk** → Immediate retention call & discount  
- 🟡 **Medium Risk** → Engagement email / reminder  
- 🟢 **Low Risk** → Regular lifecycle marketing  
""")
