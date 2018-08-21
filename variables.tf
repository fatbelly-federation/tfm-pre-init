variable "primary_state_region" {
  description = "region for the state bucket"
  default = "us-east-1"
}

variable "s3_log_bucket" {
  description = "S3 Bucket for logs"
}

variable "s3_state_bucket" {
  description = "S3 Bucket for Terraform state tracking"
}

variable "lock_table_name" {
  description = "The name of the dynamodb lock table"
}

variable "terraform_state_log_prefix" {
  description = "Prefix for terraform state logs"
  default = "tfstate"
}

variable "s3_replica_bucket" {
  description = "destination bucket for replicating s3_state_bucket"
}

variable "backup_state_region" {
  description = "region for the backup bucket to reside in"
  default = "us-west-2"
}

variable "s3_replica_log_bucket" {
  description = "bucket for logging activity for the backup bucket"
}
