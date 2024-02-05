provider "aws" {
    alias = "dev"
    profile = "vxdora-dev"
    region = "ap-northeast-1"
}

provider "aws" {
    alias = "prd"
    profile = "vxdora-prd"
    region = "ap-northeast-1"
}