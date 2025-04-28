FROM python:3.10
EXPOSE 8080
WORKDIR /app
RUN pip3 install flask requests
COPY app.py .
COPY entrypoint.sh .
RUN chmod +x ./entrypoint.sh
ENTRYPOINT [ "./entrypoint.sh" ]
