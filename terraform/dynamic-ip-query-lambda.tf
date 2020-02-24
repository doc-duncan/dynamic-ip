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
