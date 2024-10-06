variable "vpc_cider" {
  default     = "172.30.0.0/16"
  description = "VPC cider"
}

resource "aws_vpc" "main" {
  cidr_block = var.vpc_cider

  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    "Name" = "minecraft-vpc"
  }
}

output "vpc_id" {
  value       = aws_vpc.main.id
  description = "VPC id"
}
