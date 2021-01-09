resource "aws_sns_topic" "ms2" {
  name = "ms2-receipt-sns"
}

resource "aws_sns_topic" "ms2_ses_error" {
  name = "ms2-ses-error"
}
