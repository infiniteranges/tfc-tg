resource "aws_s3_bucket" "b" {
  bucket = "my-tf-test-bucket-04w"
  acl    = "private"

  tags = {
    Name        = "My bucket correct"
    Environment = "Dev"
  }
}