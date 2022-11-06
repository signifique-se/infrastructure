resource "aws_s3_bucket" "landing" {
  bucket = var.landing_bucket_name

  force_destroy = true
}

resource "aws_s3_bucket_acl" "landing_acl" {
  bucket = aws_s3_bucket.landing.id
  acl    = "public-read"
}

resource "aws_s3_bucket_policy" "landing_policy" {
  bucket = aws_s3_bucket.landing.id
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
}

resource "aws_s3_bucket_website_configuration" "landing_website" {
  bucket = aws_s3_bucket.landing.id

  index_document {
    suffix = "index.html"
  }
  error_document {
    key = "index.html"
  }
}

resource "aws_s3_bucket" "landing_www" {
  bucket = "${var.landing_bucket_name}-www"

  force_destroy = true
}

resource "aws_s3_bucket_acl" "landing_www_acl" {
  bucket = aws_s3_bucket.landing_www.id
  acl    = "private"
}

resource "aws_s3_bucket_website_configuration" "landing_www_website" {
  bucket = aws_s3_bucket.landing_www.id
  redirect_all_requests_to {
    host_name = "${var.domain}"
    protocol  = "https"
  }
}

data "aws_canonical_user_id" "current_user" {}
locals {
  awslogsdelivery_canonical_user_id = "c4c1ede66af53448b93c283ce9448c4ba468c9432aa01d700d3878632f77d2d0"
}

resource "aws_s3_bucket" "web_logs" {
  bucket = "${var.region}.${var.domain}.web-logs"
}

resource "aws_s3_bucket_acl" "web_logs_acl" {
  bucket = aws_s3_bucket.web_logs.id
  access_control_policy {
    grant {
      grantee {
        id   = data.aws_canonical_user_id.current_user.id
        type = "CanonicalUser"
      }
      permission = "FULL_CONTROL"
    }

    grant {
      grantee {
        id   = local.awslogsdelivery_canonical_user_id
        type = "CanonicalUser"
      }
      permission = "FULL_CONTROL"
    }

    owner {
      id = data.aws_canonical_user_id.current_user.id
    }
  }
}
