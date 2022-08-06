#!/bin/sh
set -e
export ENV=dev
export AWS_DEFAULT_REGION=us-east-1
API_ID=`aws apigateway get-rest-apis | jq -r '.items[] | select(.name == "dev-realworld") | .id'`
export API_URL=https://$API_ID.execute-api.$AWS_DEFAULT_REGION.amazonaws.com/$ENV
echo $API_URL >> api_url.txt
API_ARN=arn:aws:apigateway:$AWS_DEFAULT_REGION::/restapis/$API_ID/stages/$ENV
aws wafv2 disassociate-web-acl --resource-arn $API_ARN
sleep 2m