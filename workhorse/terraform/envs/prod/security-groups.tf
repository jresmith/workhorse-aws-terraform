resource "aws_security_group" "lambda_promtail" {
  name        = "lambda-promtail"
  description = "Security group for Lambda Promtail"
  vpc_id      = module.vpc.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "lambda-promtail"
  }
}