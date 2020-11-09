# terraform 実行時に tfstate をロックするための DynamoDB Table
resource aws_dynamodb_table tfstate_lock {
  name         = var.lock_table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  tags         = var.tags

  attribute {
    name = "LockID"
    type = "S"
  }
}
