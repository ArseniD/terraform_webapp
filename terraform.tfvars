billing_code = "XXXXXX"
project      = "webapp"

vpc_cidr_block = {
  default     = "10.0.0.0/16"
  Development = "10.0.0.0/16"
  UAT         = "10.1.0.0/16"
  Production  = "10.2.0.0/16"
}
vpc_subnet_count = {
  default     = 2
  Development = 2
  UAT         = 2
  Production  = 6
}

instance_type = {
  default     = "t2.micro"
  Development = "t2.micro"
  UAT         = "t2.small"
  Production  = "t2.medium"
}

instance_count = {
  default     = 2
  Development = 2
  UAT         = 4
  Production  = 6
}
