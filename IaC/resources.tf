resource "aws_kms_key" "unicron" {
  description = "unicron's kms key"
}

resource "aws_kms_key_policy" "unicron" {
  key_id = aws_kms_key.unicron.id
  policy = jsonencode({
    Id = "unicron"
    Statement = [
      {
        # Resource policy 
        Action = "kms:*"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${var.aws_account_id}:root"
        }

        Resource = "*"
        Sid      = "Allows IAM policies to allow access to the KMS key."
      },
    ]
    Version = "2012-10-17"
  })
}
