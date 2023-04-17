
terraform {
  backend "s3" {
    bucket = "aliu-bucket"
    key = "my_terraform_state"
    region = "eu-west-2"
    dynamodb_table = "terraform_state_locking"
    encrypt = true
  }
}

resource "aws_dynamodb_table" "aliu_db_table" {
  name = "terraform_state_locking"
  billing_mode = "PAY_PER_REQUEST"
  hash_key = "LockID"
  
  attribute {
    Name = "LockID"
    type = "S"
  }
}

resource "aws_s3_bucket" "aliu_s3" {
 bucket = "aliu-bucket"

 tags = {
    Name = "aliu_s3"
    description = "terraform state"
 } 
}