provider "aws" {
 region = "us-west-2"
}

provider "aws" {
  alias = "cloudfront"
  region = "us-east-1"
}