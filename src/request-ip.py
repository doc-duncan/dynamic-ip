import boto3
import json
import os
from requests import get

# TODO pass in s3 properties : DONE
# TODO run on cron or continuously
# TODO perform retry if no internet connection
# TODO run operation under stricter AWS permissions
# TODO run as api through api gateway
# TODO put machine id on payload

s3_client = boto3.client('s3')
ip_output_object = {}

# get public ip and encode for s3 put
public_ip = get('https://api.ipify.org').text
ip_output_object['public-ip-address'] = public_ip
ip_output_object_bytes = str.encode(json.dumps(ip_output_object))

s3_bucket_name = os.getenv('S3_BUCKET_NAME')
s3_file_name = os.getenv('S3_FILE_NAME')

s3_client.put_object(Body=ip_output_object_bytes, Bucket=s3_bucket_name, Key=s3_file_name)
