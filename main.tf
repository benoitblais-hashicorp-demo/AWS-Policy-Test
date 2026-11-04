# ==============================================================================
# NETWORKING
# ==============================================================================
# This file provisions a single AWS Virtual Private Cloud (VPC) used to test
# HCP Terraform policies.
# ==============================================================================

resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr

  tags = merge(
    { Name = "${local.resources_prefix}-vpc" },
    local.tags
  )
}




resource "aws_sns_topic" "test" {
  name         = "public-sns-topic"
  display_name = "public-sns-topic"
}

resource "aws_sns_topic_policy" "test" {
  arn = aws_sns_topic.test.arn
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowPublicAccess"
        Effect = "Allow"
        Principal = {
          AWS = "*"
        }
        Action = [
          "sns:Publish",
          "sns:Subscribe",
          "sns:GetTopicAttributes"
        ]
        Resource = aws_sns_topic.test.arn
      }
    ]
  })

}