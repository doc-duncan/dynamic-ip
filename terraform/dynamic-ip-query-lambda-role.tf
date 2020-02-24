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