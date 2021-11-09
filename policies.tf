resource "aws_iam_role_policy" "test_policy" {
  name = "LambdatoS3Role_Policy"
  role = aws_iam_role.LambdatoS3Role.id
    
    policy  = jsonencode( {
      "Version": "2012-10-17",
      "Statement": [
        {
          "Sid": "IAM Role for Lambda Execution",
          "Action": [
            "s3:GetObject"
          ],
          "Effect": "Allow",
          "Resource": "arn:aws:s3:::${aws_s3_bucket.lambda_bucket.id}/*"
        }
      ]
    }
  )
}

resource "aws_s3_bucket_policy" "Bucket_Policy" {
  bucket = aws_s3_bucket.lambda_bucket.id

  policy = <<POLICY
{
  "Id": "Policy1636453630855",
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "Stmt1636453411644",
      "Action": [
        "s3:GetObject",
        "s3:ListBucket"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:s3:::${aws_s3_bucket.lambda_bucket.id}/*",
      "Principal": {
        "AWS": [
          "arn:aws:iam::${var.account_id}:root"
        ]
      }
    }
  ]
}
POLICY
}