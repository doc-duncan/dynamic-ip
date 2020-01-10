FROM python:3

WORKDIR /home
RUN mkdir .aws
ENV AWS_SHARED_CREDENTIALS_FILE /home/.aws/credentials

WORKDIR /usr/apps/dynamic-ip
COPY . .
RUN pip install -r requirements.txt

ENV S3_BUCKET_NAME dynamic-ip
ENV S3_FILE_NAME current-public-ip.json

CMD ["python", "./src/request-ip.py"]
