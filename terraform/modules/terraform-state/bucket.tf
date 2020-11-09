# terraform や SAM のソースなどを格納するバケット
# 先に作成してから terraform import する
resource "aws_s3_bucket" "management" {
  bucket = var.bucket_name
  acl    = "private"
  tags   = var.tags

  versioning {
    enabled = true
  }
}
