## Overview

This project was originally created to monitor the ever-changing public IP of a home router. The dynamic allocation of IPs by ISPs causes issues if you want to set up port forwarding to a machine behind this public IP (assuming you don't already have DNS set up or a static IP). This project aims to give the user the ability to always know the public IP of the machine the source is running on and provide services that would enable a dynamic DNS environment. 

All AWS infrastructure is created using Terraform (terraform dir)

The components of this project are described in detail below.

## Components

1. worker-container
    - The container running the dynamic-ip application that fetches the public IP and pushes it to S3
    - Fetches public IP using Python requests and the endpoint https://api.ipify.org
    - Pushes public IP to an AWS S3 bucket with a file name that represents the given device identifier

    - Example output: {"public-ip-address": "0.0.0.0", "device-identifier": "my-pc"}

    **Required Environment Vars**
    
    | ENV Var Name      | Description                                                           |
    | ----------------- | --------------------------------------------------------------------- |
    | DEVICE_IDENTIFIER | Unique identifier of the machine corresponding to the public IP, this will be the name of the output file  | 

2. dynamic-ip-query-lambda
    - The lambda function used to query IP output in S3 that was pushed by the worker-container
    - All input parms should match the environment variables set at runtime to retrieve the corresponding IP info.

    **Required Input Parms**
    
    | Parm name         | Description                                                                         |
    | ----------------- | ----------------------------------------------------------------------------------- |
    | DEVICE_IDENTIFIER | Unique identifier of the machine corresponding to the desired public IP | 

## Terraform

The following services are all created using the terraform in the terraform dir.

1. lambdas: 
    - dynamic-ip-query
2. roles:
    - dynamic-ip-query-lambda
3. policies:
    - dynamic-ip-query-lambda-policy
4. policy_attachments (policy -> role):
    - dyanmci-ip-query-lambda-policy -> dynamic-ip-query-lambda
5. api_gateway (and corresponding resources)
    - dynamic-ip-query-api

## Key Points
1. AWS credentials must be mounted in the running container with access to the output bucket for execution to succeed
2. Environment vars. must be set in worker-container
3. Lambda Parms must be supplied to the lambda function
