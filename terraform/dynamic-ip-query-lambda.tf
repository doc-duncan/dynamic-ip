# actual IAM role, allows lambda to assume
resource "aws_iam_role" "dynamic-ip-query-lambda" {
  name               = "dynamic-ip-query-lambda"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_policy" "dynamic-ip-query-lambda-policy" {
  name        = "dynamic-ip-query-lambda-policy"
  description = "policy that allows lambda to access S3 and logs"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:Get*",
                "s3:List*"
            ],
            "Resource": "*"
        },
        {
            "Action": [
            "logs:CreateLogGroup",
            "logs:CreateLogStream",
            "logs:PutLogEvents"
        ],
            "Resource": "arn:aws:logs:*:*:*",
            "Effect": "Allow"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "dynamic-ip-query-lambda-policy-attatchment" {
  role       = "${aws_iam_role.dynamic-ip-query-lambda.name}"
  policy_arn = "${aws_iam_policy.dynamic-ip-query-lambda-policy.arn}"
}

resource "aws_lambda_function" "dynamic-ip-query" {
  filename      = "../src/dynamic-ip-query-lambda/function.zip"
  function_name = "dynamic-ip-query"
  role          = "${aws_iam_role.dynamic-ip-query-lambda.arn}"
  handler       = "lambda_function.lambda_handler"

  # The filebase64sha256() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the base64sha256() function and the file() function:
  # source_code_hash = "${base64sha256(file("lambda_function_payload.zip"))}"
  source_code_hash = "${filebase64sha256("../src/dynamic-ip-query-lambda/function.zip")}"

  runtime = "python3.7"
}
