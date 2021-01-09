# ses domain
resource "aws_ses_domain_identity" "ms" {
  domain = var.domain
}

resource "aws_route53_record" "ms-domain-identity-records" {
  zone_id = var.zone_id
  name    = "_amazonses.${var.domain}"
  type    = "TXT"
  ttl     = "600"

  records = [
    aws_ses_domain_identity.ms.verification_token,
  ]
}

# ses dkim
resource "aws_ses_domain_dkim" "ms" {
  domain = aws_ses_domain_identity.ms.domain
}

resource "aws_route53_record" "ms-dkim-records" {
  count   = 3
  zone_id = var.zone_id
  name    = "${element(aws_ses_domain_dkim.ms.dkim_tokens, count.index)}._domainkey.${var.domain}"
  type    = "CNAME"
  ttl     = "600"

  records = [
    "${element(aws_ses_domain_dkim.ms.dkim_tokens, count.index)}.dkim.amazonses.com",
  ]
}

# ses mail to records
resource "aws_route53_record" "ms-mx-records" {
  zone_id = var.zone_id
  name    = var.domain
  type    = "MX"
  ttl     = "600"

  records = [
    "10 inbound-smtp.eu-west-1.amazonses.com",
    "10 inbound-smtp.eu-west-1.amazonaws.com",
  ]
}

resource "aws_route53_record" "ms-spf-records" {
  zone_id = var.zone_id
  name    = var.domain
  type    = "TXT"
  ttl     = "600"

  records = [
    "v=spf1 include:amazonses.com -all",
  ]
}
