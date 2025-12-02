resource "aws_alb" "autoship_alb" {
  name = "autoshiip_alb"
  load_balancer_type = "application"
  subnets = [aws_subnet.public_subnet1, aws_subnet.public_subnet2]
  security_groups = [aws_security_group.alb_sg.id]
}

resource "aws_security_group" "alb_sg" {
    name = "alb_sg"
    vpc_id = aws_vpc.autoship.id

  ingress {
    to_port = 80
    from_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow http traffic from internet"
  }
  
  egress {
    to_port = 0
    from_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow outbound traffic"
  }
}