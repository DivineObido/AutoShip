resource "aws_appautoscaling_target" "autoscale" {
  max_capacity = 3
  min_capacity = 1
  resource_id = "service/${aws_ecs_cluster.image_cluster.name}/${aws_ecs_service.service.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace = "ecs"
}

resource "aws_appautoscaling_policy" "autoscaling_policy" {
  name = "cpu_scake_up"
  policy_type = "TargetTrackingScaling"
  resource_id = aws_appautoscaling_target.autoscale.resource_id
  scalable_dimension = aws_appautoscaling_target.autoscale.scalable_dimension
  service_namespace = aws_appautoscaling_target.autoscale.service_namespace

  target_tracking_scaling_policy_configuration {
    target_value = 60
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
  }
}
