# resource "aws_security_group" "acesso-ssh" {
#   name        = "acesso-ssh"
#   description = "acesso-ssh"

#   ingress {
#     from_port = 22
#     to_port = 22
#     protocol = "tcp"
#     cidr_blocks = var.cdirs_acesso_remoto
#   }

#   tags = {
#     Name = "ssh"
#   }
# }


# resource "aws_security_group" "sg-08dd1deae745677c4" {
#   provider = aws.us-east-1
#   name        = "acesso-ssh"
#   description = "acesso-ssh"

#   ingress {
#     from_port = 22
#     to_port = 22
#     protocol = "tcp"
#     cidr_blocks = var.cdirs_acesso_remoto
#   }

#   tags = {
#     Name = "ssh"
#   }
# }