#########################################
#   S3
#########################################
resource "aws_s3_bucket" "s3_artifact_output_bucket" {
    bucket = "${var.env}-${var.pj_name}-artifact-output-bucket"
    # acl = "private"
}

resource "aws_s3_bucket_public_access_block" "s3_artifact_output_bucket_access_block" {
    bucket = aws_s3_bucket.s3_artifact_output_bucket.id
    block_public_acls = false
    block_public_policy = true
    ignore_public_acls = true
    restrict_public_buckets = true
}
