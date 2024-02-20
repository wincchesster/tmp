resource "aws_security_group" "macedonsky-sg" {
  for_each = var.instances
  name     = "macedonsky-sg-${each.key}"
  vpc_id   = aws_vpc.terraform_vpc.id

  ingress {
    description = "Custom SSH"
    from_port   = each.value.ssh_listen_port
    to_port     = each.value.ssh_listen_port
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
