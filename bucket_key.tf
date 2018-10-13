# This generates a KMS Key for server-side encryption of the S3 buckets
# https://www.terraform.io/docs/providers/aws/r/s3_bucket.html
# https://www.terraform.io/docs/providers/aws/r/kms_key.html

resource "aws_kms_key" "bucket_key" {
  description = "!!! DO NOT DELETE !!! Key for encrypting S3 buckets used for tracking Terraform state & logs"
  # enable automatic yeaarly key rotation
  # ref: https://docs.aws.amazon.com/kms/latest/developerguide/rotate-keys.html
  enable_key_rotation = true
  tags                = "${var.tags}"
}

