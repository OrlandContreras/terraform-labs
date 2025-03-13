terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.90.1"
    }
  }
  required_version = "1.11.2"
}

provider "aws" {
  # Configuration options
  region = "us-east-1"
}

resource "aws_s3_bucket" "documents" {
  bucket        = "ai-basic-bucket"
  force_destroy = true

  tags = {
    Name        = "ai-basic-bucket"
    Environment = "Dev"
  }
}

resource "aws_s3_object" "transcribe" {
  bucket = aws_s3_bucket.documents.bucket
  key    = "transcribe/"
}

data "aws_iam_policy_document" "transcribe_policy_doc" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["transcribe.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "transcribe_role" {
  name               = "transcribe_role"
  assume_role_policy = data.aws_iam_policy_document.transcribe_policy_doc.json
}

resource "aws_iam_role_policy" "transcribe_policy" {
  name = "ai-basic-transcribe-policy"
  role = aws_iam_role.transcribe_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "s3:GetObject",
          "s3:ListObject"
        ],
        Resource = ["*"]
      }
    ]
  })
}

