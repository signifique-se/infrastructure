# ses rule set
resource "aws_ses_receipt_rule_set" "ms" {
  rule_set_name = "ms-receive-all"
}

resource "aws_ses_active_receipt_rule_set" "ms" {
  rule_set_name = aws_ses_receipt_rule_set.ms.rule_set_name

  depends_on = [
    aws_ses_receipt_rule.ms,
  ]
}

# lambda catch all
resource "aws_ses_receipt_rule" "ms" {
  name          = "ms"
  rule_set_name = aws_ses_receipt_rule_set.ms.rule_set_name

  recipients = [
    var.domain,
  ]

  enabled      = true
  scan_enabled = true

  s3_action {
    bucket_name = aws_s3_bucket.ms.bucket
    topic_arn   = aws_sns_topic.ms2.arn
    position    = 1
  }

  stop_action {
    scope    = "RuleSet"
    position = 2
  }

  depends_on = [aws_s3_bucket.ms, aws_s3_bucket_policy.ms_ses]
}
