module "resource-dev" {
  source = "../../modules/"

  pj_name = var.pj_name
  env = var.dev_env

  providers = {
    aws = aws.dev
  }
}

module "resource-devonly" {
  source = "../devonly/"

  pj_name = var.pj_name
  env = var.dev_env
  dev_branch_name = var.dev_branch_name

  providers = {
    aws = aws.dev
  }
}