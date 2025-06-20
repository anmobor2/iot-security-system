# Creating EKS Cluster
resource "aws_eks_cluster" "iot_security_cluster" {
  name     = "${var.environment}-iot-security-cluster"
  role_arn = var.eks_role_arn

  vpc_config {
    subnet_ids         = var.subnet_ids
    security_group_ids = [aws_security_group.eks_sg.id]
  }
}

# Creating EKS Node Group
resource "aws_eks_node_group" "node_group" {
  cluster_name    = aws_eks_cluster.iot_security_cluster.name
  node_group_name = "${var.environment}-node-group"
  node_role_arn   = var.eks_node_role_arn
  subnet_ids      = var.subnet_ids

  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 1
  }

  instance_types = ["t3.medium"]
}

# Security Group for EKS
resource "aws_security_group" "eks_sg" {
  name        = "${var.environment}-eks-sg"
  description = "Security group for EKS cluster"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 443
    to_port     = 443
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

# Namespace for IoT Security
resource "kubernetes_namespace" "iot_security" {
  metadata {
    name = "iot-security"
  }
}