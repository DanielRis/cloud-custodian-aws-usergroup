resource "aws_s3_bucket" "no_default_encryption_1" {
  bucket_prefix = "cc-demo-1"
  force_destroy = true
}

resource "aws_s3_bucket" "no_default_encryption_2" {
  bucket_prefix = "cc-demo-2"
  force_destroy = true
}

resource "aws_s3_bucket" "no_default_encryption_3" {
  bucket_prefix = "cc-demo-3"
  force_destroy = true
}


resource "aws_s3_bucket" "no_default_encryption_4" {
  bucket_prefix = "cc-demo-4"
  force_destroy = true
}


resource "aws_s3_bucket" "no_default_encryption_5" {
  bucket_prefix = "cc-demo-5"
  force_destroy = true
}
