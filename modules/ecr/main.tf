# ---------------------------------------------------------
# 1. ECR Repository: Your Docker Warehouse
# ---------------------------------------------------------
resource "aws_ecr_repository" "api" {
  name                 = "${var.project_name}-repo"
  image_tag_mutability = "MUTABLE"
  force_delete         = true 

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = { Name = "${var.project_name}-ecr" }
}

# ---------------------------------------------------------
# 2. Lifecycle Policy: Keeping Costs Low
# ---------------------------------------------------------
resource "aws_ecr_lifecycle_policy" "cleanup" {
  repository = aws_ecr_repository.api.name

  policy = jsonencode({
    rules = [{
      rulePriority = 1
      description  = "Keep only the last 5 images to avoid storage bloat"
      selection = {
        tagStatus     = "any"
        countType     = "imageCountMoreThan"
        countNumber   = 5
      }
      action = {
        type = "expire"
      }
    }]
  })
}