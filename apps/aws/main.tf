resource "aws_kms_key" "key" {
  description             = "Key to encrypt and decrypt files in aws"
  deletion_window_in_days = 10
}

output "key_arn" {
  value = aws_kms_key.key.arn
}
