resource "aws_route53_record" "github-challenge-record" {
  zone_id = var.zone_id
  name    = "_github-challenge-${var.github_org_name}.${var.domain}"
  type    = "TXT"
  ttl     = "600"

  records = [
    "1e448b86fe",
  ]
}
