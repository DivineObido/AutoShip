resource "aws_ecs_cluster" "image_cluster" {
  name = "imageCluster"
}

resource "aws_iam_role" "ecs_task_execution_role" {
  name = "ecsTaskExecutionRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
            Service = "ecs-tasks.amazonaws.com"
        }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_taskexecution_role_policy" {
    role = aws_iam_role.ecs_task_execution_role.name
    policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_security_group" "ecs_sg" {
    name = "ecs_sg"
    vpc_id = aws_vpc.autoship.id

  ingress {
    to_port = 80
    from_port = 80
    protocol = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
    description = "Allow inboud traffic from alb"
  }
  
  egress {
    to_port = 0
    from_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow outbound traffic"
  }
}

data "aws_ecs_task_definition" "task" {
  task_definition = "autoship_task"
}

resource "aws_ecs_service" "service" {
  name = "autoship_sevice"
  cluster = aws_ecs_cluster.image_cluster.id
  task_definition = data.aws_ecs_task_definition.task.arn
  desired_count = 1
  launch_type = "FARGATE"

  network_configuration {
    subnets = [aws_subnet.public_subnet1.id, aws_subnet.public_subnet2.id]
    security_groups = [aws_security_group.ecs_sg.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.autoship_tg.arn
    container_name = "autoship"
    container_port = 80
  }
}
