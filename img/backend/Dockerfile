FROM python:3.10
EXPOSE 8081
WORKDIR /app
RUN pip3 install flask snowflake-connector-python
COPY app.py .
COPY entrypoint.sh .
RUN chmod +x ./entrypoint.sh
ENTRYPOINT [ "./entrypoint.sh" ]
