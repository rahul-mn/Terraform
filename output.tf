output "s3_bucket_id" {
    value = aws_s3_bucket.lambda_bucket.id
}
output "s3_bucket_arn" {
    value = aws_s3_bucket.lambda_bucket.arn
}
output "kms_arn" {
    value = aws_kms_key.kms-key.arn
}