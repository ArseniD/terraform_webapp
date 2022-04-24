# Import S3 module
module "web_app_s3" {
  source = "./modules/webapp_s3"

  # Input variables for the S3 module
  bucket_name             = local.s3_bucket_name
  elb_service_account_arn = data.aws_elb_service_account.root.arn
  common_tags             = local.common_tags
}

# Copy website content to the S3 bucket
resource "aws_s3_object" "website_content" {
  for_each = {
    website = "/static/index.html"
    logo    = "/static/web_logo.png"
  }

  bucket       = module.web_app_s3.web_bucket.id
  key          = each.value
  source       = ".${each.value}"
  content_type = "text/html"

  tags = local.common_tags
}

# S3 bucket config
resource "aws_s3_bucket_website_configuration" "website_configuration" {
  bucket = module.web_app_s3.web_bucket.id

  index_document {
    suffix = "index.html"
  }
}
