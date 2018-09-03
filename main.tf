
# Set provider to AWS
# https://www.terraform.io/docs/providers/aws/index.html
provider aws {
  # tell aws provider to look for AWS_PROFILE environment variable
  # set environment variable AWS_PROFILE to the profile to use from your ~/.aws/credentials file
  region = "${var.primary_state_region}"
}

# Need a second provider for setting up the replication destination bucket
provider aws {
  alias = "replica_provider"
  region = "${var.backup_state_region}"
}

# bucket for logging tfstate activity
resource "aws_s3_bucket" "terraform_log_bucket" {
  bucket = "${var.s3_log_bucket}"
  acl = "log-delivery-write"

  tags = "${var.tags}"
}

# bucket for tfstate
resource "aws_s3_bucket" "terraform_tf_bucket" {
  bucket = "${var.s3_state_bucket}"
  acl = "private"

  tags = "${var.tags}"

  versioning {
    enabled = true
  }

  logging {
    target_bucket = "${aws_s3_bucket.terraform_log_bucket.id}"
    target_prefix = "${var.terraform_state_log_prefix}/"
  }

  replication_configuration {
    role = "${aws_iam_role.replication.arn}"

    rules {
        id  = "replicate_tfstate"
        prefix  = ""
        status  = "Enabled"

        destination {
            bucket = "${aws_s3_bucket.destination.arn}"
            storage_class = "STANDARD"
        }
    }

    
 }
}

# This defines the dynamodb table used for locking
# http://www.terrafoundry.net/blog/2017/03/30/terraform-state-lock/
# https://www.terraform.io/docs/backends/types/s3.html#dynamodb_table

resource "aws_dynamodb_table" "terraform_state_lock" {
  name           = "${var.lock_table_name}"
  read_capacity  = 20
  write_capacity = 20
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = "${var.tags}"
}


