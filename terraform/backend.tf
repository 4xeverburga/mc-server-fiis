terraform {
  backend "s3" {
    bucket = "terraform-state-logs"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}
