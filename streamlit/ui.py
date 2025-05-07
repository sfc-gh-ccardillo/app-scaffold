import streamlit as st
from snowflake.snowpark import Session
import snowflake.permissions as permissions

st.title('Hello Snowflake!')

# Get the current credentials
session = Session.builder.getOrCreate()
current_org = session.sql("SELECT CURRENT_ORGANIZATION_NAME() AS result").collect()[0].RESULT
current_acct = session.sql("SELECT CURRENT_ACCOUNT_NAME() AS result").collect()[0].RESULT
current_db = session.sql("SELECT CURRENT_DATABASE() AS result").collect()[0].RESULT

# Privileges check
st.header("Privileges Check")
app_url_base = f"https://app.snowflake.com/{current_org}/{current_acct}/#/apps/application/{current_db}"
privileges_url = app_url_base + "/security/privileges"

required_account_privileges = ["CREATE COMPUTE POOL", "BIND SERVICE ENDPOINT"]
privileges_check = {
    privilege: len(permissions.get_held_account_privileges([privilege])) > 0
    for privilege in required_account_privileges
}

if all(privileges_check.values()):
    st.text("All required account privileges have been granted.")
else:
    
    st.text("Some privileges required to run this app have not been granted.")
    st.html(f'Please use the <a href="{privileges_url}" target="_blank" >privileges panel</a> to grant the following privileges:')
    [privilege for privilege, granted in privileges_check.items() if not granted]
