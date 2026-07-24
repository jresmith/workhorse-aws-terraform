terraform {
  backend "s3" {
    bucket       = "workhorse-terraform-state"
    key          = "prod/terraform.tfstate"
    region       = "us-west-2"
    profile      = "workhorse"
    use_lockfile = true
    encrypt      = true
  }
}