resource "aws_subnet" "private_subnet_a" {
  vpc_id                  = var.vpc_id
  cidr_block              = "172.31.144.0/20"       # Choose a CIDR within your VPC
  availability_zone       = "us-east-1a"        # Adjust to your region/zone
  map_public_ip_on_launch = false               # Critical for making it private

  tags = {
    Name = "my-private-subnet_a"
  }
}
resource "aws_subnet" "private_subnet_b" {
  vpc_id                  = var.vpc_id
  cidr_block              = "172.31.128.0/20"       # Choose a CIDR within your VPC
  availability_zone       = "us-east-1b"        # Adjust to your region/zone
  map_public_ip_on_launch = false               # Critical for making it private

  tags = {
    Name = "my-private-subnet_b"
  }
}


resource "aws_route_table" "private_rt" {
  vpc_id = var.vpc_id

  tags = {
    Name = "private-route-table"
  }
}

resource "aws_route_table_association" "private_rta_a" {
  subnet_id      = aws_subnet.private_subnet_a.id
  route_table_id = aws_route_table.private_rt.id
}
resource "aws_route_table_association" "private_rta_b" {
  subnet_id      = aws_subnet.private_subnet_b.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "rds-private-subnet-group"
  subnet_ids = [
    aws_subnet.private_subnet_a.id,
    aws_subnet.private_subnet_b.id
  ]

  tags = {
    Name = "RDS Private Subnet Group"
  }
}