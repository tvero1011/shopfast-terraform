provider "aws" {
  region  = var.region
  profile = var.aws_profile # null in CI (OIDC credentials); set locally, e.g. "tf-dev"

  default_tags {
    tags = {
      Project   = var.project_name
      ManagedBy = "terraform"
    }
  }
}
