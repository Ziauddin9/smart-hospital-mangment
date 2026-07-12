terraform {
  backend "s3" {
    bucket = "smart-hospital-terraform-ziauddin"
    key    = "terraform.tfstate"
    region = "ap-south-2"
  }
}