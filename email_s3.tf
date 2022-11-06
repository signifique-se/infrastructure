resource "aws_s3_bucket" "ms" {
  bucket = "ms-ses-destination"

  lifecycle {
    ignore_changes = [
      grant
    ]
  }
}

resource "aws_s3_bucket_acl" "ms_acl" {
  bucket = aws_s3_bucket.ms.id
  acl    = "private"
}

resource "aws_s3_bucket_policy" "ms_ses" {
  bucket = aws_s3_bucket.ms.id

  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Id": "ms-ses-bucket-policy",
    "Statement": [{
        "Sid": "AllowSESPuts",
        "Effect": "Allow",
        "Principal": {
            "Service": "ses.amazonaws.com"
        },
        "Action": "s3:PutObject",
        "Resource": "arn:aws:s3:::${aws_s3_bucket.ms.bucket}/*",
        "Condition": {
            "StringEquals": {
                "aws:Referer": "${var.account_id}"
            }
        }
    }]
}
POLICY
}
