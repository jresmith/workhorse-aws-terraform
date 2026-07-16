output "public_zone_id" {
  value = data.aws_route53_zone.public.zone_id
}

output "staging_zone_id" {
  value = data.aws_route53_zone.staging.zone_id
}

output "argocd_certificate_arn" {
  value = aws_acm_certificate.argocd.arn
}