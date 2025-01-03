variable "vpc_cider" {
  default     = "10.0.0.0/24"
  description = "VPC cider"
}

variable "public_cider" {
  default     = "10.0.10.0/24"
  description = "Public cider"
}

variable "private_cider" {
  default     = "10.0.20.0/24"
  description = "Private cider"
}

variable "availability_zone" {
  default     = "ap-northeast-1a"
  description = "Availability zone"
}

###################
# resources
###################

resource "aws_vpc" "main" {
  cidr_block = var.vpc_cider

  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    "Name" = "minecraft-vpc"
  }
}

resource "aws_subnet" "public" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.public_cider
  availability_zone = var.availability_zone

  tags = {
    Name = "minecraft-public"
  }
}

resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_cider
  availability_zone = var.availability_zone

  tags = {
    Name = "minecraft-private"
  }
}

###################
# outputs
###################

output "vpc_id" {
  value       = aws_vpc.main.id
  description = "VPC id"
}
