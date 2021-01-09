resource "aws_ses_configuration_set" "ms" {
  name = "ms-ses-configuration-set"
}

resource "aws_ses_event_destination" "ses_errors" {
  name                   = "ses-error-sns-destination"
  configuration_set_name = aws_ses_configuration_set.ms.name
  enabled                = true

  matching_types = [
    "reject",
    "reject",
    "send",
  ]

  sns_destination {
    topic_arn = aws_sns_topic.ms2_ses_error.arn
  }
}

resource "aws_ses_event_destination" "ses_cloudwatch" {
  name                   = "event-destination-cloudwatch"
  configuration_set_name = aws_ses_configuration_set.ms.name
  enabled                = true

  matching_types = [
    "reject",
    "reject",
    "send",
  ]

  cloudwatch_destination {
    default_value  = "default"
    dimension_name = "dimension"
    value_source   = "emailHeader"
  }
}
