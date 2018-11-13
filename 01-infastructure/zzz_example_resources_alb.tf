resource "aws_alb" "no_logging" {
  name_prefix = "cc1-"

  subnets = [
    "subnet-f421b4be",
    "subnet-20ef2e7c",
  ]
}
