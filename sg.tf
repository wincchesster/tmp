resource "aws_security_group" "allow_ssh" {
  vpc_id      = aws_vpc.lesson46-vpc.id
  name        = "allow-ssh"
  description = "Security group that allows SSH traffic from all IPs and allows all outbound traffic"

  ingress {
    description = "SSH from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "All outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.tags, { Name = "${var.name}-sg" })
}
