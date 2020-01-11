FROM python:3

WORKDIR /home
RUN mkdir .aws
ENV AWS_SHARED_CREDENTIALS_FILE /home/.aws/credentials

WORKDIR /usr/apps/dynamic-ip
COPY . .
RUN pip install -r requirements.txt

CMD ["python", "./src/request-ip.py"]
