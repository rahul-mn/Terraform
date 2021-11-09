resource "aws_kms_key" "kms-key" {
  description = "KMS key for ${var.bucket_prefix}-lambda-functions S3 bucket"
}

resource "aws_kms_alias" "KMS-key_alias" {
  name          = "alias/S3-kms-key"
  target_key_id = aws_kms_key.kms-key.id
}

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
#  lifecycle {  
#    prevent_destroy = true
#  }
}

resource "aws_iam_role_policy_attachment" "test-attach" {
  role       = aws_iam_role.LambdatoS3Role.name
  policy_arn = aws_iam_role.LambdatoS3Role.arn
}