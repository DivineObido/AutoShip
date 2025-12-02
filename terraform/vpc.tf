resource "aws_vpc" "autoship" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "AutoShip"
    Environment = "Dev"
  }
}

resource "aws_subnet" "public_subnet1" {
  cidr_block = "10.0.0.0/24"
  availability_zone = "us-east-1a"
  vpc_id = aws_vpc.autoship.id

   tags = {
    Name = "AutoShip Public Subnet 1"
    Environment = "Dev"
  }
}

resource "aws_subnet" "public_subnet2" {
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1b"
  vpc_id = aws_vpc.autoship.id

   tags = {
    Name = "AutoShip Public Subnet 2"
    Environment = "Dev"
  }
}

resource "aws_route_table" "route_table" {
  vpc_id = aws_vpc.autoship.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }
}

resource "aws_route_table_association" "public_route_table1" {
  route_table_id = aws_route_table.route_table.id
  subnet_id = aws_subnet.public_subnet1.id
}

resource "aws_route_table_association" "public_route_table2" {
  route_table_id = aws_route_table.route_table.id
  subnet_id = aws_subnet.public_subnet2.id
}

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.autoship.id

  tags = {
    Name = "autoship internet gateway"
    Environment = "Dev"
  }
}
