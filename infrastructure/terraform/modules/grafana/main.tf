# Creating Grafana Workspace
resource "aws_grafana_workspace" "iot_security" {
  name                     = "${var.environment}-iot-security-grafana"
  account_access_type      = "CURRENT_ACCOUNT"
  authentication_providers = ["AWS_SSO"]
  permission_type          = "SERVICE_MANAGED"
  data_sources             = ["CLOUDWATCH"]
  role_arn                = var.grafana_role_arn
}

# IAM Role for Grafana
resource "aws_iam_role" "grafana_role" {
  name = "${var.environment}-GrafanaRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "grafana.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "grafana_policy" {
  role = aws_iam_role.grafana_role.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "cloudwatch:Describe*",
          "cloudwatch:Get*",
          "cloudwatch:List*"
        ]
        Resource = "*"
      }
    ]
  })
}

# Grafana Dashboard
resource "aws_grafana_dashboard" "iot_security_dashboard" {
  workspace_id = aws_grafana_workspace.iot_security.id
  dashboard = jsonencode({
    version = 1
    panels = [
      {
        id     = 1
        type   = "graph"
        title  = "IoT Connected Devices"
        datasource = "CloudWatch"
        targets = [
          {
            namespace = "AWS/IoT"
            metricName = "ConnectedDevices"
            statistics = ["Average"]
            period     = "300"
          }
        ]
        yaxes = [
          {
            format = "none"
            label  = "Devices"
          }
        ]
      },
      {
        id     = 2
        type   = "graph"
        title  = "Lambda Errors"
        datasource = "CloudWatch"
        targets = [
          {
            namespace = "AWS/Lambda"
            metricName = "Errors"
            statistics = ["Sum"]
            period     = "300"
            dimensions = {
              FunctionName = "${var.environment}-alert-processor"
            }
          },
          {
            namespace = "AWS/Lambda"
            metricName = "Errors"
            statistics = ["Sum"]
            period     = "300"
            dimensions = {
              FunctionName = "${var.environment}-image-processor"
            }
          }
        ]
        yaxes = [
          {
            format = "none"
            label  = "Errors"
          }
        ]
      }
    ]
    layout = {
      type = "grid"
      settings = {
        isDefault = true
      }
    }
  })
}