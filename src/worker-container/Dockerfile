FROM python:3

WORKDIR /usr/apps/dynamic-ip
COPY . .
RUN pip install -r requirements.txt

CMD ["python", "request-ip.py"]
