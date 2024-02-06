variable "pj_name" { type = string }
variable "codecommit_repository_name" { type = string }
variable "dev_env" { type = string }
variable "prd_env" { type = string }
variable "dev_account_id" { type = string }
variable "prd_branch_name" { type = string }
variable "prd_account_id" { type = string }

variable "s3_artifact_output_bucket_arn" { type = string }
variable "kms_key_arn" { type = string }
variable "event_bus_arn" { type = string }