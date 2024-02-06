#########################################
#   EventBridge
#########################################
resource "aws_cloudwatch_event_bus" "event_bus" {
  name = "${var.prd_env}-${var.pj_name}-event-bus"
}

resource "aws_cloudwatch_event_bus_policy" "event_bus_policy" {
    event_bus_name = aws_cloudwatch_event_bus.event_bus.name
    policy = <<EOP
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "GrantPermissionEventBus",
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::${var.dev_account_id}:root"
            },
            "Action": "events:PutEvents",
            "Resource": "${aws_cloudwatch_event_bus.event_bus.arn}"
        }
    ]
}
EOP
}

resource "aws_cloudwatch_event_rule" "codepipeline_event_rule" {
    name = "${var.prd_env}-${var.pj_name}-event-rule"
    event_bus_name = aws_cloudwatch_event_bus.event_bus.name
    event_pattern = <<EOEP
{
    "account": ["${var.dev_account_id}"]
}
EOEP
}