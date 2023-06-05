module "network" {
  source = "git@github.com:ernestomedina17/tf-modules.git//aws/4/eks-vpc"

  name               = "unicron"
  cidr_block         = "10.0.0.0/16"
  region             = var.aws_region
  availability_zones = data.aws_availability_zones.available.names
  az_counts          = length(data.aws_availability_zones.available.names)
}

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
