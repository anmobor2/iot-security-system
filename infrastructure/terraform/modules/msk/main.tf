# Creating MSK Serverless Cluster
resource "aws_msk_serverless_cluster" "msk_cluster" {
  cluster_name = "${var.environment}-iot-security-msk"

  vpc_config {
    subnet_ids         = var.subnet_ids
    security_groups    = [aws_security_group.msk_sg.id]
  }

  client_authentication {
    sasl {
      iam {
        enabled = true
      }
    }
  }
}

# Security Group for MSK
resource "aws_security_group" "msk_sg" {
  name        = "${var.environment}-msk-sg"
  description = "Security group for MSK Serverless"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 9098
    to_port     = 9098
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Restrict in production
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}