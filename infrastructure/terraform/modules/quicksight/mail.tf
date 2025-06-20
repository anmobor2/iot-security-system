# Athena Workgroup for Queries
resource "aws_athena_workgroup" "iot_security" {
  name = "${var.environment}-iot-security-workgroup"

  configuration {
    result_configuration {
      output_location = "s3://${var.s3_bucket_id}/athena-results/"
    }
  }
}

# QuickSight Data Source (Athena)
resource "aws_quicksight_data_source" "iot_events" {
  data_source_id = "${var.environment}-iot-events"
  name           = "${var.environment}-IoTEvents"
  type           = "ATHENA"

  parameters {
    athena {
      work_group = aws_athena_workgroup.iot_security.name
    }
  }

  credentials {
    credential_pair {
      username = var.quicksight_username
      password = var.quicksight_password
    }
  }
}

# QuickSight Dataset
resource "aws_quicksight_data_set" "iot_events" {
  data_set_id = "${var.environment}-iot-events-dataset"
  name        = "${var.environment}-IoTEventsDataset"

  import_mode = "SPICE"

  physical_table_map {
    physical_table_map_id = "events-table"
    relational_table {
      data_source_arn = aws_quicksight_data_source.iot_events.arn
      catalog         = "AwsDataCatalog"
      schema          = "default"
      name            = "${var.environment}-Events"
      input_columns {
        name = "deviceId"
        type = "STRING"
      }
      input_columns {
        name = "timestamp"
        type = "STRING"
      }
      input_columns {
        name = "eventType"
        type = "STRING"
      }
      input_columns {
        name = "details"
        type = "STRING"
      }
    }
  }
}

# QuickSight Dashboard
resource "aws_quicksight_dashboard" "iot_security_dashboard" {
  dashboard_id = "${var.environment}-iot-security-dashboard"
  name         = "${var.environment}-IoTSecurityDashboard"

  permissions {
    principal = var.quicksight_user_arn
    actions   = [
      "quicksight:DescribeDashboard",
      "quicksight:ListDashboardVersions",
      "quicksight:UpdateDashboardPermissions",
      "quicksight:QueryDashboard",
      "quicksight:UpdateDashboard",
      "quicksight:DeleteDashboard",
      "quicksight:CreateDashboard"
    ]
  }

  source_entity {
    source_template {
      arn = aws_quicksight_template.iot_security_template.arn
    }
  }
}

# QuickSight Template
resource "aws_quicksight_template" "iot_security_template" {
  template_id = "${var.environment}-iot-security-template"
  name        = "${var.environment}-IoTSecurityTemplate"
  version_description = "Initial version"

  source_entity {
    source_analysis {
      arn = aws_quicksight_analysis.iot_security_analysis.arn
      data_set_references {
        data_set_placeholder = "IoTEvents"
        data_set_arn         = aws_quicksight_data_set.iot_events.arn
      }
    }
  }
}

# QuickSight Analysis
resource "aws_quicksight_analysis" "iot_security_analysis" {
  analysis_id = "${var.environment}-iot-security-analysis"
  name        = "${var.environment}-IoTSecurityAnalysis"

  permissions {
    principal = var.quicksight_user_arn
    actions   = [
      "quicksight:DescribeAnalysis",
      "quicksight:QueryAnalysis",
      "quicksight:UpdateAnalysis",
      "quicksight:DeleteAnalysis"
    ]
  }

  definition {
    data_set_identifiers_declarations {
      identifier    = "IoTEvents"
      data_set_arn  = aws_quicksight_data_set.iot_events.arn
    }

    sheets {
      title = "Security Events"
      visuals {
        bar_chart_visual {
          visual_id = "events-by-type"
          title {
            format_text {
              plain_text = "Events by Type"
            }
          }
          chart_configuration {
            field_wells {
              bar_chart_aggregated_field_wells {
                category {
                  categorical_dimension_field {
                    field_id = "eventType"
                    column {
                      column_name = "eventType"
                      data_set_identifier = "IoTEvents"
                    }
                  }
                }
                values {
                  categorical_measure_field {
                    field_id = "count"
                    column {
                      column_name = "eventType"
                      data_set_identifier = "IoTEvents"
                    }
                    aggregation_function {
                      categorical_aggregation_function = "COUNT"
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  }
}