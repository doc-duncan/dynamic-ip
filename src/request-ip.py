import boto3
import json
import os
from requests import get

# TODO pass in s3 properties : DONE
# TODO run on cron or continuously
# TODO perform retry if no internet connection
# TODO run operation under stricter AWS permissions : DONE
# TODO run as api through api gateway
# TODO put machine id on payload : DONE

# env vars set in input env_file with docker run
s3_bucket_name = os.getenv('S3_BUCKET_NAME')
s3_base_file_name = os.getenv('S3_BASE_FILE_NAME')
device_identifier = os.getenv('DEVICE_IDENTIFIER')

s3_client = boto3.client('s3')
ip_output_object = {}

# get public ip and encode for s3 put
public_ip = get('https://api.ipify.org').text
ip_output_object['public-ip-address'] = public_ip
ip_output_object['device-identifier'] = device_identifier
ip_output_object_bytes = str.encode(json.dumps(ip_output_object))

s3_key = device_identifier + '-' + s3_base_file_name
s3_client.put_object(Body=ip_output_object_bytes, Bucket=s3_bucket_name, Key=s3_key)
