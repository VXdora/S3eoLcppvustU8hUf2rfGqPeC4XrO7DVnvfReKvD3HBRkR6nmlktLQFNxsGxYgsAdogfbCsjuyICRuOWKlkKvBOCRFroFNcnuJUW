#########################################
#   EventBridge
#########################################
resource "aws_iam_role" "eventbridge_role_for_prd" {
    name = "${var.dev_env}-${var.pj_name}-eventbridge-role-for-prd"
    assume_role_policy = <<EOR
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "events.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ]
}
EOR
}

resource "aws_iam_role_policy" "eventbridge_role_policy_for_prd" {
  name = "${var.dev_env}-${var.pj_name}-eventbridge-role-policy-for-prd"
  role = aws_iam_role.eventbridge_role_for_prd.name
  policy = <<EOP
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "events:PutEvents",
            "Effect": "Allow",
            "Resource": "${var.event_bus_arn}"
        }
    ]
}
EOP
}

resource "aws_cloudwatch_event_rule" "event_rule_for_prd" {
  name = "${var.dev_env}-${var.pj_name}-event-rule-for-prd"
  event_pattern = <<EOEP
{
    "detail": {
        "event": ["referenceCreated", "referenceUpdated"],
        "referenceName": ["${var.prd_branch_name}"],
        "referenceType": ["branch"]
    },
    "detail-type": [ "CodeCommit Repository State Change" ],
    "resources": ["arn:aws:codecommit:ap-northeast-1:${var.dev_account_id}:${var.codecommit_repository_name}"],
    "source": ["aws.codecommit"]
}
EOEP
}

resource "aws_cloudwatch_event_target" "event_bus_target" {
    rule = aws_cloudwatch_event_rule.event_rule_for_prd.name
    arn = var.event_bus_arn
    role_arn = aws_iam_role.eventbridge_role_for_prd.arn
}