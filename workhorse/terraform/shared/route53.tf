data "aws_route53_zone" "public" {
  name         = "jresmith.com"
  private_zone = false
}

data "aws_route53_zone" "staging" {
  name         = "staging.jresmith.com"
  private_zone = true
}