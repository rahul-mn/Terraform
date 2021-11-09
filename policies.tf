#Generating a s3 bucket policy - Secure_Bucket_Policy

resource "aws_s3_bucket_policy" "Secure_Bucket_Policy" {
  bucket = aws_s3_bucket.lambda_bucket.id

  policy = data.aws_iam_policy_document.secure_bucket_policy_document.json
}

#Data for Secure_Bucket_Policy

data "aws_iam_policy_document" "secure_bucket_policy_document" {
  statement {
    actions   = [
      "s3:*"
    ]
    condition {
      test      = "Bool"
      values    = [
        "false"
      ]
      variable  = "aws:SecureTransport"
    }
    effect    = "Deny"
    principals {
      identifiers = [
        "*"
      ]
      type        = "AWS"
    }
    resources = [
      "arn:aws:s3:::${aws_s3_bucket.lambda_bucket.id}/*"
    ]
    sid       = "DenyUnsecuredTransport"
  }
  statement {
    actions   = [
      "s3:PutObject"
    ]
    condition {
      test      = "StringNotEquals"
      values    = [
        "${aws_kms_key.kms-key.arn}"
      ]
      variable  = "s3:x-amz-server-side-encryption-aws-kms-key-id"
    }
    effect    = "Deny"
    principals {
      identifiers = [
        "*"
      ]
      type        = "AWS"
    }
    resources = [
      "arn:aws:s3:::${aws_s3_bucket.lambda_bucket.id}/*"
    ]
    sid       = "DenyIncorrectEncryptionHeader"
  }
  statement {
    actions   = [
      "s3:PutObject"
    ]
    condition {
      test      = "Null"
      values    = [
        "true"
      ]
      variable  = "s3:x-amz-server-side-encryption"
    }
    effect    = "Deny"
    principals {
      identifiers = [
        "*"
      ]
      type        = "AWS"
    }
    resources = [
      "arn:aws:s3:::${aws_s3_bucket.lambda_bucket.id}/*"
    ]
    sid       = "DenyUnencryptedObjectUploads"
  }
}

#Generating a iam policy for cross_account_assume_role - cross_account_iam_policy

resource "aws_iam_policy" "cross_account_iam_policy" {
  name = "cross_account_iam_policy"
    
  policy = data.aws_iam_policy_document.cross_account_iam_policy_document.json
}

#Data for cross_account_iam_policy

data "aws_iam_policy_document" "cross_account_iam_policy_document" {
  statement {
    actions   = [
        "s3:GetObject",
        "s3:ListBucket"
    ]
    effect    = "Allow"
    resources = [
      "arn:aws:s3:::${aws_s3_bucket.lambda_bucket.id}/*"
    ]
    sid       = "AllowListingAndGettingObject"
  }
}