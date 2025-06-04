resource "aws_s3_bucket" "secret_store" {
  bucket = "${var.name_prefix}-orchestra-secrets-${random_id.random_suffix.hex}"
  tags   = local.tags
}

resource "aws_s3_bucket_lifecycle_configuration" "secret_store_lifecycle_config" {
  bucket = aws_s3_bucket.secret_store.id

  rule {
    id     = "rule-expire-1-day"
    status = "Enabled"

    filter {
      prefix = ""
    }

    expiration {
      days = 1
    }

    noncurrent_version_expiration {
      noncurrent_days = 1
    }
  }
}

resource "aws_s3_bucket" "artifact_store" {
  bucket = "${var.name_prefix}-orchestra-artifacts-${random_id.random_suffix.hex}"
  tags   = local.tags
}

resource "aws_s3_bucket_lifecycle_configuration" "artifact_store_lifecycle_config" {
  bucket = aws_s3_bucket.artifact_store.id

  rule {
    id     = "rule-expire-7-days"
    status = "Enabled"

    filter {
      prefix = ""
    }

    expiration {
      days = 7
    }

    noncurrent_version_expiration {
      noncurrent_days = 7
    }
  }
}
