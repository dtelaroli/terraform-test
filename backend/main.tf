resource "aws_s3_bucket" "this" {
  # checkov:skip=CKV_AWS_18:Skip for simple configuration
  # checkov:skip=CKV_AWS_52:Skip for simple configuration
  bucket = local.bucket_name
  acl    = "private"

  force_destroy = true

  policy = templatefile("${path.module}/templates/bucket-policy.json", {
    name       = local.bucket_name
    account_id = local.account_id
  })

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.this.id
        sse_algorithm     = "aws:kms"
      }
    }
  }

  tags = local.tags
}

resource "aws_s3_bucket_public_access_block" "this" {
  bucket = aws_s3_bucket.this.id

  ignore_public_acls      = true
  restrict_public_buckets = true
  block_public_acls       = true
  block_public_policy     = true
}

resource "aws_dynamodb_table" "this" {
  # checkov:skip=CKV_AWS_28:Skip for save money
  name         = "${local.project}-devops-lock"
  hash_key     = "LockID"
  billing_mode = "PAY_PER_REQUEST"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = local.tags
}

resource "aws_kms_key" "this" {
  description         = "${local.project} master key"
  enable_key_rotation = true

  policy = jsonencode({
    Version = "2008-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${local.account_id}:root"
        }
        Action   = "kms:*"
        Resource = "*"
      },
      {
        Effect = "Allow"
        Principal = {
          Service = "s3.amazonaws.com"
        }
        Action = [
          "kms:Encrypt*",
          "kms:Decrypt*",
          "kms:ReEncrypt*",
          "kms:GenerateDataKey*",
          "kms:Describe*"
        ],
        Resource = "*"
      }
    ]
  })

  tags = local.tags
}

