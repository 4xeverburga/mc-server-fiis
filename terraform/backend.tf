terraform {
  backend "s3" {
    bucket = "<BUCKET_NAME>"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}
