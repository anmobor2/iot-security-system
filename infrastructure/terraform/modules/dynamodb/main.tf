# Devices Table
resource "aws_dynamodb_table" "devices" {
  name           = "${var.environment}-Devices"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "deviceId"

  attribute {
    name = "deviceId"
    type = "S"
  }
}

# Events Table
resource "aws_dynamodb_table" "events" {
  name           = "${var.environment}-Events"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "deviceId"
  range_key      = "timestamp"

  attribute {
    name = "deviceId"
    type = "S"
  }

  attribute {
    name = "timestamp"
    type = "S"
  }
}