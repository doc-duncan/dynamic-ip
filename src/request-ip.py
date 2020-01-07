import boto3
import json
from requests import get

s3_client = boto3.client('s3')
ip_output_object = {}

# get public ip and encode for s3 put
public_ip = get('https://api.ipify.org').text
ip_output_object['public-ip-address'] = public_ip
ip_output_object_bytes = str.encode(json.dumps(ip_output_object))

s3_client.put_object(Body=ip_output_object_bytes, Bucket='dynamic-ip', Key='current-public-ip.json')

