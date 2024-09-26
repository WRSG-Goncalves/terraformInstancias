variable "AWS_ACCESS_KEY_ID" {}
variable "AWS_SECRET_ACCESS_KEY" {}
variable "AWS_REGION" {}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 2.0"
    }
  }
}

provider "aws" {
  region     = var.AWS_REGION
  access_key = var.AWS_ACCESS_KEY_ID
  secret_key = var.AWS_SECRET_ACCESS_KEY
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "main-vpc"
  }
}

resource "aws_subnet" "main" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "main-subnet"
  }
}

resource "aws_security_group" "k8s_sg" {
  name_prefix = "k8s-sg"
  description = "Security for the Kubernetes cluster"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.cdirs_acesso_remoto
  }

  ingress {
    from_port   = 6443
    to_port     = 6443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "k8s_nodes" {
  count                      = 1
  ami                        = "ami-0e86e20dae9224db8"
  instance_type              = "t2.micro"
  key_name                   = "terraforma-aws"
  vpc_security_group_ids      = [aws_security_group.k8s_sg.id]
  subnet_id                  = aws_subnet.main.id
  associate_public_ip_address = true

  tags = {
    Name = "k8s-node-${count.index}"
  }

  user_data = <<-EOF
  #!/bin/bash
  curl -sfL https://get.k3s.io | sh -
  EOF
}

output "k8s_endpoint" {
  value = aws_instance.k8s_nodes[0].public_ip
}
