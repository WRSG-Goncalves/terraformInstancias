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
  access_key = var.AWS_ACCESS_KEY_ID
  secret_key = var.AWS_SECRET_ACCESS_KEY
  region     = var.AWS_REGION
  skip_credentials_validation = true
}

provider "aws" {
  alias = "us-east-2"
  access_key = var.AWS_ACCESS_KEY_ID
  secret_key = var.AWS_SECRET_ACCESS_KEY
  region     = "us-east-2"
  skip_credentials_validation = true
}

resource "aws_instance" "dev" {
  count         = 1
  ami           = var.amis["us-east-1"]
  instance_type = "t2.micro"
  key_name      = "terraforma-aws"

  tags = {
    Name = "dev-${count.index}"
  }
  vpc_security_group_ids = ["${aws_security_group.acesso-ssh.id}"]
}

resource "aws_s3_bucket" "dev4" {
  bucket = "wstech-dev4"
  acl = private

  tags = {
    Name = "wstech-dev4"
  }
}

