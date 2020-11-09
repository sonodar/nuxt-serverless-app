# 画像ファイルなどを格納するバケット。CloudFront の Origin になる。
resource "aws_s3_bucket" "assets" {
  bucket = var.bucket_name
  acl    = "private"
  tags   = var.bucket_tags
}
