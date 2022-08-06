module "remote-state-s3-backend" {
  source  = "nozaq/remote-state-s3-backend/aws"
  version = "1.3.2"
  
  providers = {
    aws         = aws
    aws.replica = aws.replica
  }
  terraform_iam_policy_create = false
  override_s3_bucket_name     = true
  s3_bucket_force_destroy     = true
  s3_bucket_name              = "miguel-poc-serverless-tfstate"
  s3_bucket_name_replica      = "miguel-poc-serverless-tfstate-bk"
  dynamodb_table_name         = "miguel-poc-serverless-tfstate-lock"
}