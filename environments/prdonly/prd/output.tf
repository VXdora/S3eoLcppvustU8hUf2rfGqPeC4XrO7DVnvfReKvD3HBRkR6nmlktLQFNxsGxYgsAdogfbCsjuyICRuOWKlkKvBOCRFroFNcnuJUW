output "s3_artifact_output_bucket_arn" { value = aws_s3_bucket.s3_artifact_output_bucket.arn }
output "kms_key_arn" { value = aws_kms_key.kms_key.arn }