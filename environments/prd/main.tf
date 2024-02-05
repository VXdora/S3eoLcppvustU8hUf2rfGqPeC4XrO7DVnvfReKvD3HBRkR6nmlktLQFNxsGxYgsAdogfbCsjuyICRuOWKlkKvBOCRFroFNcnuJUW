module "resource-prd" {
  source = "../../modules/"

  pj_name = var.pj_name
  env = var.prd_env

  providers = {
    aws = aws.prd
  }
}

module "resource-prdonly-prd" {
  source = "../prdonly/prd/"

  pj_name = var.pj_name
  codecommit_repository_name = var.codecommit_repository_name
  dev_env = var.dev_env
  prd_env = var.prd_env
  dev_account_id = var.dev_account_id
  prd_branch_name = var.prd_branch_name
  prd_account_id = var.prd_account_id

  codecommit_role_for_prd_arn = module.resource-prdonly-dev.codecommit_role_for_prd_arn

  providers = {
    aws = aws.prd
  }
}

module "resource-prdonly-dev" {
  source = "../prdonly/dev/"

  pj_name = var.pj_name
  codecommit_repository_name = var.codecommit_repository_name
  dev_env = var.dev_env
  prd_env = var.prd_env
  dev_account_id = var.dev_account_id
  prd_branch_name = var.prd_branch_name
  prd_account_id = var.prd_account_id

  s3_artifact_output_bucket_arn = module.resource-prdonly-prd.s3_artifact_output_bucket_arn
  kms_key_arn = module.resource-prdonly-prd.kms_key_arn

  providers = {
    aws = aws.dev
  }
}