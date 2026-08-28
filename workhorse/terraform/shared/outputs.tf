output "public_zone_id" {
  value = data.aws_route53_zone.public.zone_id
}

output "staging_certificate_arn" {
  value = aws_acm_certificate.staging.arn
}

output "prod_zone_id" {
  value = data.aws_route53_zone.public.zone_id
}

output "prod_certificate_arn" {
  value = aws_acm_certificate.prod.arn
}