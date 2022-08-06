terraform {
  backend "s3" {
    bucket               = "miguel-poc-serverless-tfstate"
    region               = "us-west-2"
    encrypt              = true
    kms_key_id           = "8ee30dee-6e20-4189-9f96-eba34d1fdee1"
    dynamodb_table       = "miguel-poc-serverless-tfstate-lock"
  }
}