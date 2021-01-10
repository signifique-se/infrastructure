resource "aws_s3_bucket" "landing" {
  bucket = var.landing_bucket_name
  acl    = "public-read"
  policy = <<POLICY
{
  "Version":"2012-10-17",
  "Statement":[{
        "Sid":"PublicReadForGetBucketObjects",
        "Effect":"Allow",
          "Principal": "*",
      "Action":["s3:GetObject"],
      "Resource":["arn:aws:s3:::${var.landing_bucket_name}/*"]
    }
  ]
}
POLICY

  force_destroy = true

  website {
    index_document = "index.html"
    error_document = "index.html"
  }
}

resource "aws_s3_bucket" "landing_www" {
  bucket = "${var.landing_bucket_name}-www"
  acl    = "private"

  force_destroy = true

  website {
    redirect_all_requests_to = "https://${var.domain}"
  }
}

data "aws_canonical_user_id" "current_user" {}
locals {
  awslogsdelivery_canonical_user_id = "c4c1ede66af53448b93c283ce9448c4ba468c9432aa01d700d3878632f77d2d0"
}

resource "aws_s3_bucket" "web_logs" {
  bucket = "${var.region}.${var.domain}.web-logs"

  grant {
    id          = data.aws_canonical_user_id.current_user.id
    permissions = ["FULL_CONTROL"]
    type        = "CanonicalUser"
  }
  grant {
    id          = local.awslogsdelivery_canonical_user_id
    permissions = ["FULL_CONTROL"]
    type        = "CanonicalUser"
  }
}
