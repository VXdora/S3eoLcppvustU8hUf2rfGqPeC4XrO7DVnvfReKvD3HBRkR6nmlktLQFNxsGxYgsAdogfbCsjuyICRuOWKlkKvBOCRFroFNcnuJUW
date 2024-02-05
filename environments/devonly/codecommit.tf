#########################################
#   CodeCommit
#########################################
resource "aws_codecommit_repository" "codecommit_repository" {
    repository_name = "${var.env}-${var.pj_name}-codecommit-repository"
}
