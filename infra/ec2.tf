data "aws_ami" "ubuntu_22_04" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-*-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "minecraft" {
  ami = data.aws_ami.ubuntu_22_04.id

  instance_type = "t3a.small"

  tags = {
    Name = "Minecraft server"
  }
}

resource "aws_security_group" "allow_ports_for_minecraft_server" {
  description = "Allow ports for minecraft server"
  name        = "allow_ports_for_minecraft_server"
  vpc_id      = aws_vpc.main.id

  tags = {
    "Name" = "For minecraft server"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_ports_for_minecraft_server_into_ipv4_udp_25565" {
  security_group_id = aws_security_group.allow_ports_for_minecraft_server.id
  ip_protocol       = "udp"
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 25565
  to_port           = 25565
}

resource "aws_vpc_security_group_ingress_rule" "allow_ports_for_minecraft_server_into_ipv6_udp_25565" {
  security_group_id = aws_security_group.allow_ports_for_minecraft_server.id
  ip_protocol       = "udp"
  cidr_ipv6         = "::/0"
  from_port         = 25565
  to_port           = 25565
}

resource "aws_vpc_security_group_ingress_rule" "allow_ports_for_minecraft_server_into_ipv4_tcp_25565" {
  security_group_id = aws_security_group.allow_ports_for_minecraft_server.id
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 25565
  to_port           = 25565
}

resource "aws_vpc_security_group_ingress_rule" "allow_ports_for_minecraft_server_into_ipv6_tcp_25565" {
  security_group_id = aws_security_group.allow_ports_for_minecraft_server.id
  ip_protocol       = "tcp"
  cidr_ipv6         = "::/0"
  from_port         = 25565
  to_port           = 25565
}

resource "aws_vpc_security_group_ingress_rule" "allow_ports_for_minecraft_server_into_ipv4_udp_19132_19133" {
  security_group_id = aws_security_group.allow_ports_for_minecraft_server.id
  ip_protocol       = "udp"
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 19132
  to_port           = 19133
}

resource "aws_vpc_security_group_ingress_rule" "allow_ports_for_minecraft_server_into_ipv6_udp_19132_19133" {
  security_group_id = aws_security_group.allow_ports_for_minecraft_server.id
  ip_protocol       = "udp"
  cidr_ipv6         = "::/0"
  from_port         = 19132
  to_port           = 19133
}

resource "aws_vpc_security_group_egress_rule" "allow_ports_for_minecraft_server_from_another_ipv4" {
  security_group_id = aws_security_group.allow_ports_for_minecraft_server.id
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_egress_rule" "allow_ports_for_minecraft_server_from_another_ipv6" {
  security_group_id = aws_security_group.allow_ports_for_minecraft_server.id
  ip_protocol       = "-1"
  cidr_ipv6         = "::/0"
}
