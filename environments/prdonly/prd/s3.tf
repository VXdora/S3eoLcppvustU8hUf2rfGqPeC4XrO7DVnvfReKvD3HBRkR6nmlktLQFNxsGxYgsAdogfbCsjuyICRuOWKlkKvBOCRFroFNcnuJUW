#########################################
#   S3
#########################################
resource "aws_s3_bucket" "s3_artifact_output_bucket" {
    bucket = "${var.prd_env}-${var.pj_name}-artifact-output-bucket"
    # acl = "private"

    server_side_encryption_configuration {
      rule {
        apply_server_side_encryption_by_default {
          kms_master_key_id = aws_kms_key.kms_key.arn
          sse_algorithm = "aws:kms"
        }
      }
    }
}

resource "aws_s3_bucket_public_access_block" "s3_artifact_output_bucket_access_block" {
    bucket = aws_s3_bucket.s3_artifact_output_bucket.id
    block_public_acls = true
    block_public_policy = true
    ignore_public_acls = true
    restrict_public_buckets = true
}

resource "aws_s3_bucket_policy" "s3_artifact_output_bucket_policy" {
    bucket = aws_s3_bucket.s3_artifact_output_bucket.id
    policy = <<EOP
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "AWS": "${var.codecommit_role_for_prd_arn}"
            },
            "Action": "s3:*",
            "Resource": [
                "${aws_s3_bucket.s3_artifact_output_bucket.arn}",
                "${aws_s3_bucket.s3_artifact_output_bucket.arn}/*"
            ]
        }
    ]
}

EOP
  
}
