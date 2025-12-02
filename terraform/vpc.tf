resource "aws_vpc" "autoship" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "AutoShip"
    Environment = "Dev"
  }
}

resource "aws_subnet" "public_subnet1" {
  cidr_block = "10.0.1.0/24"
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
