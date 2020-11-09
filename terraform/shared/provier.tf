provider aws {
  region  = var.aws_region
  version = "~> 3.14.0"
}

provider "aws" {
  region = "us-east-1"
  alias  = "cloudfront"
}
