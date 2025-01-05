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

resource "aws_vpc_endpoint" "s3" {
  vpc_id       = aws_vpc.main.id
  service_name = "com.amazonaws.${var.availability_zone}.s3"
  vpc_endpoint_type = "Gateway"

  tags = {
    Name = "minecraft-vpce-s3"
  }
}

resource "aws_vpc_endpoint" "ec2" {
  vpc_id            = aws_vpc.main.id
  service_name      = "com.amazonaws.${var.availability_zone}.ec2"
  vpc_endpoint_type = "Interface"

  security_group_ids = [
    aws_security_group.allow_for_minecraft_server_vpce.id,
  ]

  tags = {
    Name = "minecraft-vpce-ec2"
  }
}

resource "aws_security_group" "allow_for_minecraft_server_vpce" {
  description = "Allow ports for minecraft server VPC endpoints"
  name        = "allow_ports_for_minecraft_server_vpc_endpoints"
  vpc_id      = aws_vpc.main.id

  tags = {
    "Name" = "For minecraft server VPC endpoints"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_all_ports_for_endpoint_ipv4" {
  security_group_id = aws_security_group.allow_for_minecraft_server_vpce.id
  referenced_security_group_id = aws_security_group.allow_for_minecraft_server_vpce.id
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_ingress_rule" "allow_all_ports_for_endpoint_ipv6" {
  security_group_id = aws_security_group.allow_for_minecraft_server_vpce.id
  referenced_security_group_id = aws_security_group.allow_for_minecraft_server_vpce.id
  ip_protocol       = "-1"
  cidr_ipv6         = "::/0"
}

resource "aws_vpc_security_group_egress_rule" "allow_all_ports_for_endpoint_ipv4" {
  security_group_id = aws_security_group.allow_for_minecraft_server_vpce.id
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_egress_rule" "allow_all_ports_for_endpoint_ipv6" {
  security_group_id = aws_security_group.allow_for_minecraft_server_vpce.id
  ip_protocol       = "-1"
  cidr_ipv6         = "::/0"
}

###################
# outputs
###################

output "vpc_id" {
  value       = aws_vpc.main.id
  description = "VPC id"
}
