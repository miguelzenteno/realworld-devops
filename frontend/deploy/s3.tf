module "log_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "~> 3.0"

  bucket = "logs-cloudfront-poc-serverless"
  acl    = null
  grant = [{
    type       = "CanonicalUser"
    permission = "FULL_CONTROL"
    id         = data.aws_canonical_user_id.current.id
    }, {
    type       = "CanonicalUser"
    permission = "FULL_CONTROL"
    id         = data.aws_cloudfront_log_delivery_canonical_user_id.current.id
  }]
  force_destroy = true
}

resource "aws_s3_bucket" "frontend" {
  bucket        = "miguel-poc-serverless-frontend-${var.environment}"
  force_destroy = true
}

resource "aws_cloudfront_origin_access_identity" "frontend" {
  comment = "Cloudront Origin Access Identity for realworld-frontend-${var.environment}"
}

resource "aws_s3_bucket_policy" "frontend" {
  bucket = aws_s3_bucket.frontend.id
  policy = data.template_file.bucket_policy.rendered
}

resource "aws_s3_bucket_ownership_controls" "frontend" {
  bucket = aws_s3_bucket.frontend.id
  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket_public_access_block" "frontend" {
  bucket                  = aws_s3_bucket.frontend.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "null_resource" "remove_and_upload_to_s3" {
  depends_on = [aws_s3_bucket.frontend]
  triggers = {
    always_run = "${timestamp()}"
  }
  provisioner "local-exec" {
    command = "aws s3 sync ../dist s3://${aws_s3_bucket.frontend.id}"
  }
}