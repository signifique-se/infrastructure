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
