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



# ec2 resources. --------------------------------------------------|
resource "aws_instance" "macedonsky_public" {
  for_each = var.instances

  ami                    = data.aws_ami.ubuntu.id
  instance_type          = each.value.instance_type
  vpc_security_group_ids = [aws_security_group.macedonsky-sg[each.key].id]
  subnet_id              = aws_subnet.terraform_public.id
  key_name               = "macedonsky-tmp"
  user_data              = local.user_data[each.key]

  root_block_device {
    volume_size           = each.value.disk_size
    volume_type           = "gp2"
    encrypted             = true
    delete_on_termination = true
  }
  associate_public_ip_address = true
  tags = {
    Owner = "macedonsky777"
    Name  = "macedonsky777"
  }
}


# Output resources. ------------------------------------------------|
output "instance_public_ip" {
  description = "Public IP of EC2 instance"
  value       = [for instance in aws_instance.macedonsky_public : instance.public_ip]
}


