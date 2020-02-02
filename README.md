## Overview

This service fetches and reports the current public IP of the machine it is running on. It keeps an updated IP record in a given S3 bucket. This assists with use cases such as dynamic DNS. The project includes a lambda function that can be used to query the IP output. 

## Components

1. worker-container
    - The container running the dynamic-ip application
    - Fetches public IP using Python requests with https://api.ipify.org
    - Pushes public IP to a given AWS S3 bucket with a file name that is composed of the given device identifier and base file name
    - Example output: {"public-ip-address": "0.0.0.0", "device-identifier": "my-pc"}

    **Required Environment Vars**
    | ENV Var Name      | Description                                                                              |
    | ----------------- | ---------------------------------------------------------------------------------------- |
    | S3_BUCKET_NAME    | Target AWS S3 bucket name for public IP file to land                                     |
    | S3_BASE_FILE_NAME | Base file name that is concatenated with DEVICE_IDENTIFIER to create S3 output file name |
    | DEVICE_IDENTIFIER | Identifier of the machine that is running the container                                  | 

2. dynamic-ip-query-lambda
    - The lambda function used to query the IP output from the worker-container
    - All input parms should match the environment variables set at runtime to retrieve the corresponding IP info.

    **Required Input Parms**
    | Parm name         | Description |
    | ----------------- | ---------------------------------------------------------------------------------------- |
    | S3_BUCKET_NAME    | Target AWS S3 bucket name holding the IP file                                            |
    | S3_BASE_FILE_NAME | Base file name that is concatenated with DEVICE_IDENTIFIER to create S3 target file name |
    | DEVICE_IDENTIFIER | Identifier of the corresponding machine pushing the IP info.                             |

## Key Points
1. AWS credentials must be mounted in the running container with access to the output bucket for execution to succeed
2. Environment vars. must be set in worker-container
3. Lambda Parms must be supplied to the lambda function