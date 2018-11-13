# Using Cloud Custodian for fun and profit

https://www.capitalone.io/docs/index.html

## Requirements

### Install terraform, python and virtualenv

```Bash
# Windows (Elevated command promt)
choco install terraform
choco install python2

# Linux
sudo <random-package-manager> install python2

# MacOS
sudo brew install python@2

pip install virtualenv
```

### Create and enable a new virtualenv

```Bash
virtualenv env -p python2

# Windows
.\env\Scripts\activate.ps1

# Linux / MacOS
source env/bin/activate
```

### Install Cloud Custodian

```Bash
pip install -r requirements.txt
```

## Usage

### Run

```Bash
# In $AWS_DEFAULT_REGION region
custodian run -s <output directory or S3 URL> -l <CloudWatch Logs Group> policy.yml
# In a specific region
custodian run -s <output directory or S3 URL> -l <CloudWatch Logs Group> -r us-east-1 policy.yml
# In multiple regions
custodian run -s <output directory or S3 URL> -l <CloudWatch Logs Group> -r us-east-1 -r eu-west-1 policy.yml
# In all regions
custodian run -s <output directory or S3 URL> -l <CloudWatch Logs Group> -r all policy.yml
```

### Report

You have to specify a region if you have specified a region during the run command. This is a know _limitation_.

```Bash
# Report of resources in $AWS_DEFAULT_REGION region
custodian report -s <output directory or S3 URL> policy.yml
# In a specific region
custodian report -s <output directory or S3 URL> -r eu-west-1 policy.yml
# In multiple regions
custodian report -s <output directory or S3 URL> -r eu-west-1 -r us-east-1 policy.yml
# In all regions
custodian report -s <output directory or S3 URL> -r all policy.yml

# Reformat the output
custodian report -s .custodian policy.yml --format csv
custodian report -s .custodian policy.yml --format grid
custodian report -s .custodian policy.yml --format simple

# Add additional fields (JMESPath)
custodian report -s .custodian 00_s3_list.yml -r eu-west-1 -r us-east-1 --format simple --field Environment=tag:Environment --field LoggingTargetBucket=Logging.TargetBucket --field LoggingTargetPrefix=Logging.TargetPrefix
```

### Additional documentation

https://www.capitalone.io/docs/quickstart/index.html#run-your-policy

https://www.capitalone.io/docs/quickstart/advanced.html

## Create required infrastructure resources

`./01-infrastructure`

Cloud Custodian requires a IAM role to be able to read/modify AWS resources.

- Minimum
  - IAM role for Cloud Custodian running as Lambda `custodian_iam_role.tf`
- Additional
  - S3 logging destination bucket `logging.tf`
  - LB logging destination bucket `logging.tf`
  - CloudWatch Logs Group `custodian_cloudwatch_logs.tf`
  - IAM role for Cloud Custodian mailer running as Lambda `mailer_iam_role.tf`
  - SQS queue for Cloud Custodian `custodian_sqs_queue.tf`
  - AWS Config basic setup `aws_config.tf`
- Examples
  - Example S3 and LB resources `zzz_example_resources_alb.tf` and `zzz_example_resources_s3.tf`


## First policies

`./02-first_policies`

- S3 Buckets without default encryption enabled - No Action `01_s3_no_default_encryption_report.yml`
- S3 Buckets without default encryption enabled - Manual remediation `02_s3_no_default_encryption_manual_remediate.yml`
- S3 Buckets without default encryption enabled - Periodic remedation `03_s3_no_default_encryption_auto_remediate.yml`

## Setup mailer component

`./03-mailer`

Using a existing docker container (https://hub.docker.com/r/troylar/c7n-mailer/) to avoid development installation.

Notification Methods:

- Email
- DataDog
- Slack
- SendGrid (Azure only)

https://github.com/capitalone/cloud-custodian/tree/master/tools/c7n_mailer

## Add notification to a policy

`./04-notification`

- S3 Buckets without default encryption enabled - Periodic remedation including notification `01_s3_no_default_encryption_auto_remediate_notify.yml`

## More policies

`./05-more_policies`

- Enforcing S3 bucket standards using AWS CloudTrail `01_s3_standards_cloudtrail.yml`
- Enforcing S3 bucket standards using AWS CloudTrail on custom events `01_s3_standards_full.yml`
- Configure ALB logging using AWS Config `03_lb_logging_awsconfig.yml`

## Advanced Topics

### AWS CloudTrail Supported Services

https://docs.aws.amazon.com/awscloudtrail/latest/userguide/cloudtrail-aws-service-specific-topics.html

### Using Cloud Custodian in an multi-account environment

https://github.com/capitalone/cloud-custodian/tree/master/tools/c7n_org

### Using Cloud Custodian Notifications

https://github.com/capitalone/cloud-custodian/tree/master/tools/c7n_mailer

### Using Cloud Custodian with Azure

https://github.com/capitalone/cloud-custodian/tree/master/tools/c7n_azure

### Using Cloud Custodian with GCP (Alpha)

https://github.com/capitalone/cloud-custodian/tree/master/tools/c7n_gcp
