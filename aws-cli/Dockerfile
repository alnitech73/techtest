FROM python:alpine3.17

RUN pip install boto3
WORKDIR /app
COPY aws-cli.py .
ENTRYPOINT ["python"]
