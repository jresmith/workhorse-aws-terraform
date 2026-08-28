data "aws_route53_zone" "public" {
  name         = "jresmith.com"
  private_zone = false
}
