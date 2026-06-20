vpc_name = "workhorse-staging-vpc"

vpc_cidr = "10.99.0.0/16"

public_subnet_cidrs = [
  "10.99.0.0/24",
  "10.99.1.0/24",
  "10.99.2.0/24"
]

private_subnet_cidrs = [
  "10.0.0.0/19",
  "10.0.32.0/19",
  "10.0.64.0/19"
]

azs = [
  "us-west-2a",
  "us-west-2b",
  "us-west-2c"
]

enable_nat_gateway = true
single_nat_gateway = true

tags = {
  Environment = "staging"
  ManagedBy = "terraform"
}