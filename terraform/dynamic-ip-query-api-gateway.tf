resource "aws_api_gateway_rest_api" "dyanmic-ip-query-api" {
  name        = "dynamic-ip-query-api"
  description = "gateway for dynamic ip info"
}

resource "aws_api_gateway_resource" "dynamic-ip-query-api-resource" {
  rest_api_id = "${aws_api_gateway_rest_api.dyanmic-ip-query-api.id}"
  parent_id   = "${aws_api_gateway_rest_api.dyanmic-ip-query-api.root_resource_id}"
  path_part   = "dynamic-ip-query"
}

resource "aws_api_gateway_method" "dynamic-ip-query-api-get-method" {
  rest_api_id   = "${aws_api_gateway_rest_api.dyanmic-ip-query-api.id}"
  resource_id   = "${aws_api_gateway_resource.dynamic-ip-query-api-resource.id}"
  http_method   = "GET"
  authorization = "AWS_IAM"
  request_parameters = {"method.request.querystring.deviceIdentifier" = true}
}

resource "aws_api_gateway_integration" "dynamic-ip-query-api-get-method-integration" {
  rest_api_id = "${aws_api_gateway_rest_api.dyanmic-ip-query-api.id}"
  resource_id = "${aws_api_gateway_resource.dynamic-ip-query-api-resource.id}"
  http_method = "${aws_api_gateway_method.dynamic-ip-query-api-get-method.http_method}"
  integration_http_method = "POST"
  type        = "AWS"
  uri         = "${aws_lambda_function.dynamic-ip-query.invoke_arn}"     
  request_templates = {
    "application/json" = <<REQUEST_TEMPLATE
    {
        "DEVICE_IDENTIFIER": "$input.params().querystring.get('deviceIdentifier')"  
    }
    REQUEST_TEMPLATE
  }
}

resource "aws_api_gateway_method_response" "dynamic-ip-query-api-get-method-response_200" {
  rest_api_id = "${aws_api_gateway_rest_api.dyanmic-ip-query-api.id}"
  resource_id = "${aws_api_gateway_resource.dynamic-ip-query-api-resource.id}"
  http_method = "${aws_api_gateway_method.dynamic-ip-query-api-get-method.http_method}"
  status_code = "200"
}

resource "aws_api_gateway_integration_response" "dynamic-ip-query-api-get-integration-response" {
  rest_api_id = "${aws_api_gateway_rest_api.dyanmic-ip-query-api.id}"
  resource_id = "${aws_api_gateway_resource.dynamic-ip-query-api-resource.id}"
  http_method = "${aws_api_gateway_method.dynamic-ip-query-api-get-method.http_method}"
  status_code = "${aws_api_gateway_method_response.dynamic-ip-query-api-get-method-response_200.status_code}"
}