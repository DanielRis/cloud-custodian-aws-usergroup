/* IAM Role is asumed by the Lambda functions */
data "aws_iam_policy_document" "cloud_custodian_mailer_assume" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "cloud_custodian_mailer" {
  name               = "cloud_custodian_mailer"
  assume_role_policy = "${data.aws_iam_policy_document.cloud_custodian_mailer_assume.json}"
}

resource "aws_iam_role_policy_attachment" "cloud_custodian_mailer_lambda" {
  role       = "${aws_iam_role.cloud_custodian_mailer.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "cloud_custodian_mailer_sqs" {
  role       = "${aws_iam_role.cloud_custodian_mailer.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaSQSQueueExecutionRole"
}

resource "aws_iam_role_policy_attachment" "cloud_custodian_mailer_ses" {
  role       = "${aws_iam_role.cloud_custodian_mailer.name}"
  policy_arn = "arn:aws:iam::aws:policy/AmazonSESFullAccess"
}
