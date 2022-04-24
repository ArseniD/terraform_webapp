resource "aws_s3_bucket" "web_bucket" {
  bucket        = var.bucket_name
  force_destroy = true

  tags = var.common_tags
}

resource "aws_s3_bucket_acl" "web_bucket_acl" {
  bucket = aws_s3_bucket.web_bucket.id
  acl    = "public-read"
}

resource "aws_s3_bucket_policy" "web_bucket_policy" {
  bucket = aws_s3_bucket.web_bucket.id
  policy = templatefile("${path.module}/policies/s3-policy.json", { bucket_name = aws_s3_bucket.web_bucket.id, elb_service_account_arn = var.elb_service_account_arn })

  /* depends_on = [ */
  /*   aws_s3_bucket.web_bucket, */
  /* ] */
}

resource "aws_iam_role" "allow_instance_s3" {
  name = "${aws_s3_bucket.web_bucket.id}-allow_nginx_s3"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version : "2012-10-17"
    Statement : [
      {
        Action : "sts:AssumeRole"
        Effect : "Allow"
        Sid : ""
        Principal : {
          Service : "ec2.amazonaws.com"
        }
      },
    ]
  })

  tags = var.common_tags
}

resource "aws_iam_role_policy" "allow_s3_all" {
  name = "${aws_s3_bucket.web_bucket.id}-allow_s3_all"
  role = aws_iam_role.allow_instance_s3.name

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version : "2012-10-17"
    Statement : [
      {
        Action = [
          "s3:*"
        ]
        Effect : "Allow",
        Resource : [
          "arn:aws:s3:::${aws_s3_bucket.web_bucket.id}",
          "arn:aws:s3:::${aws_s3_bucket.web_bucket.id}/*"
        ]
      },
    ]
  })
}

resource "aws_iam_instance_profile" "instance_profile" {
  name = "${aws_s3_bucket.web_bucket.id}-instance_profile"
  role = aws_iam_role.allow_instance_s3.name

  tags = var.common_tags
}
