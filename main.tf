#Generating a KMS Key
resource "aws_kms_key" "kms-key" {
  description = "KMS key for ${var.bucket_prefix}-lambda-functions S3 bucket"
}

#Assigning an Alias

resource "aws_kms_alias" "KMS-key_alias" {
  name          = "alias/S3-kms-key"
  target_key_id = aws_kms_key.kms-key.id
}

#Creating the Bucket with versioning, logging and encryption enabled

resource "aws_s3_bucket" "lambda_bucket" {
  bucket = "${var.bucket_prefix}-lambda-functions"
  acl    = "private"

  versioning {
      enabled = true
  }
  lifecycle_rule {
      prefix  = "config/"
      enabled = true
      
      tags = {
        rule      = "versions"
        autoclean = "true"
      }
      noncurrent_version_expiration {
      days = 180
      }
    }
  logging {
    target_bucket = "${var.log_bucket_name}"
    target_prefix = "log/"
  }
  server_side_encryption_configuration {
  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.kms-key.arn
      sse_algorithm     = "aws:kms"
        }
      }
    }
  lifecycle {  
    prevent_destroy = true
  }
}