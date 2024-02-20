terraform {
  backend "s3" {
    bucket         = "terraform-states-s3"
    key            = "lesson-45/terraform.tfstate"
    encrypt        = true
    dynamodb_table = "lesson-45-terraform-lock"
    region         = "eu-central-1"
    profile        = "default"
  }
}
