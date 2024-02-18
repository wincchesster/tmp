# Data resources. -------------------------------------------------|
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}


# Security resources. ---------------------------------------------|
resource "tls_private_key" "terraform" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "terraform" {
  key_name   = "terraform-key"
  public_key = tls_private_key.terraform.public_key_openssh
}


# ec2 resources. --------------------------------------------------|
resource "aws_instance" "ubuntu_ec2" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.lesson46-public_subnet.id
  key_name               = aws_key_pair.terraform.key_name
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]
  tags                   = merge(local.tags, { Name = "${var.name}-public-ec2" })
}





# Output resources. ------------------------------------------------|
resource "local_file" "terraform-private-key" {
  content         = tls_private_key.terraform.private_key_pem
  filename        = "${path.module}/terraform.pem"
  file_permission = "0600"

}


