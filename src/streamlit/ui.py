import pandas as pd
import streamlit as st
from snowflake.snowpark.functions import call_udf, col
from snowflake.snowpark import Session

st.title('Hello Snowflake!')

# Get the current credentials
session = Session.builder.getOrCreate()

st.text(str(session))
