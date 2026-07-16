resource "aws_acm_certificate" "argocd" {
  domain_name       = "argocd.staging.jresmith.com"
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "argocd_validation" {
  for_each = {
    for dvo in aws_acm_certificate.argocd.domain_validation_options :
    dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  zone_id = data.aws_route53_zone.public.zone_id

  allow_overwrite = true
  ttl             = 60

  name    = each.value.name
  type    = each.value.type
  records = [each.value.record]
}

resource "aws_acm_certificate_validation" "argocd" {
  certificate_arn = aws_acm_certificate.argocd.arn

  validation_record_fqdns = [
    for record in aws_route53_record.argocd_validation :
    record.fqdn
  ]
}