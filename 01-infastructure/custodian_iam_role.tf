/* IAM Role is asumed by the Lambda functions */
data "aws_iam_policy_document" "cloud_custodian_assume" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "cloud_custodian" {
  name               = "cloud_custodian"
  assume_role_policy = "${data.aws_iam_policy_document.cloud_custodian_assume.json}"
}

resource "aws_iam_role_policy_attachment" "cloud_custodian_lambda" {
  role       = "${aws_iam_role.cloud_custodian.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "cloud_custodian_admin" {
  role       = "${aws_iam_role.cloud_custodian.name}"
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}
