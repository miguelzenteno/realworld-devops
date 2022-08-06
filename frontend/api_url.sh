#!/bin/sh
set -e
export ENV=dev
export AWS_DEFAULT_REGION=us-east-1
API_ID=`aws apigateway get-rest-apis | jq -r '.items[] | select(.name == "dev-realworld") | .id'`
API_URL=$API_ID.execute-api.$AWS_DEFAULT_REGION.amazonaws.com/$ENV
cd source
if [[ $ENV == "dev" ]]; then
  sed -i "s|api.realworld.io|$API_URL|g" Api.mint
elif [[ $ENV == "prod" ]]; then
  sed -i "s|api.realworld.io|$API_URL|g" Api.mint
fi