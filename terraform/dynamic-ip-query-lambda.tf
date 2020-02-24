resource "aws_lambda_permission" "dynamic-ip-query-api-to-lambda-bridge" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.dynamic-ip-query.function_name}"
  principal     = "apigateway.amazonaws.com"

  # More: http://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-control-access-using-iam-policies-to-invoke-api.html
  source_arn = "${aws_api_gateway_rest_api.dyanmic-ip-query-api.execution_arn}/*/${aws_api_gateway_method.dynamic-ip-query-api-get-method.http_method}${aws_api_gateway_resource.dynamic-ip-query-api-resource.path}"
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
