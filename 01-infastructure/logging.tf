// Get the current Account ID
data "aws_caller_identity" "current" {}

// Get the current Region
data "aws_region" "current" {}

resource "aws_s3_bucket" "s3_logs" {
  bucket        = "${data.aws_caller_identity.current.account_id}-${data.aws_region.current.name}-s3-logs"
  acl           = "log-delivery-write"
  force_destroy = true
}

locals {
  # AWS ELBs run in AWS managed accounts. To allow log file delivery, a bucket policy is required.
  elb_account_id = {
    "us-east-1"      = "127311923021"
    "us-east-2"      = "033677994240"
    "us-west-1"      = "027434742980"
    "us-west-2"      = "797873946194"
    "ca-central-1"   = "985666609251"
    "eu-central-1"   = "054676820928"
    "eu-west-1"      = "156460612806"
    "eu-west-2"      = "652711504416"
    "eu-west-3"      = "009996457667"
    "ap-northeast-1" = "582318560864"
    "ap-northeast-2" = "600734575887"
    "ap-northeast-3" = "383597477331"
    "ap-southeast-1" = "114774131450"
    "ap-southeast-2" = "783225319266"
    "ap-south-1"     = "718504428378"
    "sa-east-1"      = "507241528517"
    "us-gov-west-1"  = "048591011584"
    "cn-north-1"     = "638102146993"
    "cn-northwest-1" = "037604701340"
  }
}

resource "aws_s3_bucket" "lb_logs" {
  bucket        = "${data.aws_caller_identity.current.account_id}-${data.aws_region.current.name}-lb-logs"
  force_destroy = true
}


resource "aws_s3_bucket_policy" "lb_logs" {
  bucket = "${aws_s3_bucket.lb_logs.id}"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": [
            "${local.elb_account_id[data.aws_region.current.name]}"
        ]
      },
      "Action": "s3:PutObject",
      "Resource": "${aws_s3_bucket.lb_logs.arn}/*"
    } 
  ]
}
POLICY
}
