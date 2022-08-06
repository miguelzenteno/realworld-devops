output "cloudfront_domain" {
  description = "FQDN to access the frontend S3 website"
  value       = aws_cloudfront_distribution.frontend.domain_name
}