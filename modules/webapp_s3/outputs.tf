# Because we do not specify an attribute, it will pass the entire bucket object back as output value
output "web_bucket" {
  description = "Bucket object"
  value       = aws_s3_bucket.web_bucket
}

# The same here
output "instance_profile" {
  description = "Instance profile object"
  value       = aws_iam_instance_profile.instance_profile
}
