data "aws_iam_policy_document" "awsconfig_assume" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["config.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "awsconfig" {
  name               = "awsconfig"
  assume_role_policy = "${data.aws_iam_policy_document.awsconfig_assume.json}"
}

resource "aws_iam_role_policy_attachment" "awsconfig_readonly" {
  role       = "${aws_iam_role.awsconfig.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSConfigRole"
}

data "aws_iam_policy_document" "awsconfig" {
  statement {
    actions = ["s3:PutObject*"]

    resources = [
      "${aws_s3_bucket.aws_config_logs.arn}/*",
    ]
  }

  statement {
    actions = ["lambda:InvokeFunction"]

    resources = [
      "*",
    ]
  }
}

resource "aws_iam_policy" "awsconfig" {
  name   = "awsconfig"
  path   = "/"
  policy = "${data.aws_iam_policy_document.awsconfig.json}"
}

resource "aws_iam_role_policy_attachment" "awsconfig" {
  role       = "${aws_iam_role.awsconfig.name}"
  policy_arn = "${aws_iam_policy.awsconfig.arn}"
}


resource "aws_s3_bucket" "aws_config_logs" {
  bucket        = "${data.aws_caller_identity.current.account_id}-${data.aws_region.current.name}-aws-config-logs"
  force_destroy = true
}

resource "aws_config_configuration_recorder" "awsconfig" {
  name     = "default"
  role_arn = "${aws_iam_role.awsconfig.arn}"
}

resource "aws_config_delivery_channel" "awsconfig" {
  name           = "default"
  s3_bucket_name = "${aws_s3_bucket.aws_config_logs.bucket}"
  s3_key_prefix  = "awsconfig"
  depends_on     = ["aws_config_configuration_recorder.awsconfig"]
}

resource "aws_config_configuration_recorder_status" "foo" {
  name       = "${aws_config_configuration_recorder.awsconfig.name}"
  is_enabled = true
  depends_on = ["aws_config_delivery_channel.awsconfig"]
}
