variable "vpc_name" {
  type = string
  description = "Name of the VPC used in the Staging enivironment"
}

variable "vpc_cidr" {
  type = string
  description = "Entire staging environment cidr"
}

variable "public_subnet_cidrs" {
  type = list(string)
  description = "Subnets to be used for Public ranges in staging env - to be used across multiple AZs"
}

variable "private_subnet_cidrs" {
  type = list(string)
  description = "Subnets to be used for Private ranges in staging env - to be used across multiple AZs"
}

variable "azs" {
  type = list(string)
  description = "List of AZs to be used within staging env"
}

variable "enable_nat_gateway" {
  type = bool
  description = "Boolean to enable NAT gateway in VPC"
  default = true
}

variable "single_nat_gateway" {
  type = bool
  description = "Boolean to have a single NAT gateway in VPC"
  default = false
}

variable "tags" {
  type = map(string)
  description = "Tags for Staging environment workoad (VPC Infra)"
  default = {
    ManagedBy = "terraform"
  }
}
