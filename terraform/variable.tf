# To expose ecr repo url for github actiions to use
output "image_registry_repository-url" {
  value = aws_ecr_repository.image_registry.repository_url
}