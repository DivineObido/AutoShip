resource "aws_ecr_repository" "image_registry" {
  name = "image-registry"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}