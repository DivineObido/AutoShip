resource "aws_alb" "autoship_alb" {
  name = "autoshipAlb"
  load_balancer_type = "application"
  subnets = [aws_subnet.public_subnet1.id, aws_subnet.public_subnet2.id]
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

  ingress {
    to_port = 443
    from_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow https traffic from internet"
  }
  
  egress {
    to_port = 0
    from_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow outbound traffic"
  }
}

resource "aws_alb_target_group" "autoship_tg" {
  name = "autoshipAlbTarget"
  port = 80
  protocol = "HTTP"
  vpc_id = aws_vpc.autoship.id
  target_type = "ip"

  health_check {
    path = "/"
  }
}

resource "aws_alb_listener" "https_listener" {
   load_balancer_arn = aws_alb.autoship_alb.arn
  port = 443
  protocol = "HTTPS"
  ssl_policy = "ELBSecurityPolicy-2016-08"

  certificate_arn = aws_acm_certificate.cert.arn

  default_action {
    type = "forward"
    target_group_arn = aws_alb_target_group.autoship_tg.arn
  }
}

resource "aws_alb_listener" "http_listener" {
  load_balancer_arn = aws_alb.autoship_alb.arn
  port = 80
  protocol = "HTTP"

  default_action {
    type = "redirect"
    redirect {
      port = 443
      protocol = "HTTPS"
      status_code = "HTTP_301"
    }
  }

}
