import boto3
import json

# builds S3 object key from input, fetches object and returns corresponding IP info
def lambda_handler(event, context):
    s3_client = boto3.client('s3')

    s3_bucket_name = 'dynamic-ip'
    device_identifier = event['DEVICE_IDENTIFIER']
    s3_key = device_identifier + '.json'
    
    ip_file = s3_client.get_object(Bucket=s3_bucket_name, Key=s3_key)

    return {
        'statusCode': 200,
        'body': json.loads(ip_file['Body'].read().decode('utf-8'))
    }
