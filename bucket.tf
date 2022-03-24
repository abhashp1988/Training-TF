provider "aws" {
  profile = "ppclassic"
  region  = "us-east-1"
}
resource "aws_s3_bucket" "trainbucket" {
  bucket = "trainbucket"

  tags = {
    Name        = "trainbucket"
    Environment = "test"
  }
}

resource "aws_s3_bucket_acl" "bucket_acl" {
  bucket = aws_s3_bucket.trainbucket.id
  acl    = "private"
}
