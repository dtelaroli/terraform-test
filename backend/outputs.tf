output "bucket_name" {
  description = "Backend versioned bucket name"
  value       = aws_s3_bucket.this.id
}

output "dynamodb_table_name" {
  description = "Backend lock table name"
  value       = aws_dynamodb_table.this.id
}
