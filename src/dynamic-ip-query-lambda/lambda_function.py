import boto3
import json

# builds S3 object key from input, fetches object and returns corresponding IP info
def lambda_handler(event, context):
    s3_bucket_name = event['S3_BUCKET_NAME']
    s3_base_file_name = event['S3_BASE_FILE_NAME']
    device_identifier = event['DEVICE_IDENTIFIER']
    
    s3_key = device_identifier + '-' + s3_base_file_name
    s3_client = boto3.client('s3')
    ip_file = s3_client.get_object(Bucket=s3_bucket_name, Key=s3_key)

    return {
        'statusCode': 200,
        'body': json.loads(ip_file['Body'].read().decode('utf-8'))
    }
