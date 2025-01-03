###################
# resources
###################

# public route tables
resource "aws_internet_gateway" "inet_gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "minecraft-inet-gw"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "minecraft-public-route-table"
  }
}

resource "aws_route" "public" {
  destination_cidr_block = "0.0.0.0/0"
  route_table_id         = aws_route_table.public.id
  gateway_id             = aws_internet_gateway.inet_gw.id
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

# private route tables
resource "aws_eip" "nat_gw" {
  domain   = "vpc"

  tags = {
    Name = "minecraft-nat-gw"
  }
}

resource "aws_nat_gateway" "nat_gw" {
  subnet_id     = aws_subnet.public.id
  allocation_id = aws_eip.nat_gw.id

  tags = {
    Name = "minecraft-nat-gw"
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "minecraft-private-route-table"
  }
}

resource "aws_route" "private" {
  destination_cidr_block = "0.0.0.0/0"
  route_table_id         = aws_route_table.private.id
  nat_gateway_id         = aws_nat_gateway.nat_gw.id
}

resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private.id
}

###################
# outputs
###################

output "nat_gw_ip" {
  value       = aws_nat_gateway.nat_gw.public_ip
  description = "Elastic IP address associated with the NAT Gateway"
}
