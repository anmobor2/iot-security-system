# Creating S3 Bucket
resource "aws_s3_bucket" "images" {
  bucket = "${var.environment}-iot-security-images"

  tags = {
    Name        = "${var.environment}-IoTSecurityImages"
    Environment = var.environment
  }
}

# Enabling Versioning
resource "aws_s3_bucket_versioning" "images_versioning" {
  bucket = aws_s3_bucket.images.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Enabling Server-Side Encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "images_encryption" {
  bucket = aws_s3_bucket.images.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}