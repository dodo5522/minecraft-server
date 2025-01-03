locals {
  url_repo_minecraft_user_monitor = "https://gist.github.com/57fd09ada3cb8bb09c11f992dafeca91.git"
  path_minecraft_server           = "/var/tmp/minecraft"
  path_minecraft_user_monitor     = "/var/tmp/minecraft_user_monitor"
}

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

resource "aws_key_pair" "minecraft" {
  key_name   = "minecraft"
  public_key = file("keys/aws-minecraft.pub")
}

resource "aws_eip" "minecraft" {
  instance = aws_instance.minecraft.id
  domain   = "vpc"
}

resource "aws_instance" "minecraft" {
  ami           = data.aws_ami.ubuntu_22_04.id
  instance_type = "t3a.small"

  availability_zone                    = "ap-northeast-1a"
  disable_api_stop                     = false
  disable_api_termination              = false
  iam_instance_profile                 = "aws-minecraft-instance-role"
  instance_initiated_shutdown_behavior = "stop"
  key_name                             = aws_key_pair.minecraft.key_name

  user_data = templatefile("user_data/init.sh.tftpl", {
    url_repo_minecraft_user_monitor : local.url_repo_minecraft_user_monitor,
    path_minecraft_server : local.path_minecraft_server,
    path_minecraft_user_monitor : local.path_minecraft_user_monitor,
    minecraft_service : templatefile("user_data/minecraft.service.tftpl", {
      path_minecraft_server : local.path_minecraft_server,
    }),
    minecraft_user_monitor_service : templatefile("user_data/minecraft-user-monitor.service.tftpl", {
      path_minecraft_user_monitor : local.path_minecraft_user_monitor,
    }),
  })

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
