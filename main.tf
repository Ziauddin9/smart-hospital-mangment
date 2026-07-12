resource "aws_s3_bucket" "artifacts" {
  bucket = "smart-hospital-terraform-ziauddin"

  tags = {
    Project = "Smart Hospital"
    Owner   = "Ziauddin"
  }
}