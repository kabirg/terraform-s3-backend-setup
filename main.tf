# AWS provider needed.
# Assumes you've set your AWS credentials in the ~/.aws/credentials & config file (via aws configure), and are using the default profile
provider "aws" {
  region  = "us-east-1"
  profile = "default"
}

variable "bucket_name" {
  type = string
}

# S3 Backend for stage storage
resource "aws_s3_bucket" "state-bucket" {
  bucket = var.bucket_name

  versioning {
    enabled = true
  }
}

# DynamoDB table for state locking
resource "aws_dynamodb_table" "terraform-lock" {
  name           = "terraform_lock"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}
