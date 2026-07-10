# ─── S3 buckets ───────────────────────────────────────────────────────────────
# Add a bucket by appending an entry to this map (key = globally-unique bucket name).
#   Optional : versioning (default false)
locals {
  s3_buckets = {
    # "mvaldes-example" = { versioning = true }
  }
}

resource "aws_s3_bucket" "this" {
  for_each = local.s3_buckets

  bucket = each.key
}

# Block all public access on every bucket (secure default).
resource "aws_s3_bucket_public_access_block" "this" {
  for_each = aws_s3_bucket.this

  bucket                  = each.value.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Enable versioning only on buckets that opt in.
resource "aws_s3_bucket_versioning" "this" {
  for_each = { for name, cfg in local.s3_buckets : name => cfg if try(cfg.versioning, false) }

  bucket = aws_s3_bucket.this[each.key].id

  versioning_configuration {
    status = "Enabled"
  }
}
