variable "name" {
  default = "macedonsky777"
}

variable "ssh_listen_port" {
  default = 22
}
variable "instances" {
  default = {
    "ec1" = {
      disk_size       = 10
      instance_type   = "t2.micro"
      ssh_listen_port = 22
    },
    "ec2" = {
      disk_size       = 20
      instance_type   = "t2.micro"
      ssh_listen_port = 2222
    }
  }
  type = map(object({
    disk_size       = number
    instance_type   = string
    ssh_listen_port = number
  }))
}


locals {
  user_data = { for instance, values in var.instances : instance => templatefile("${path.module}/user_data.sh", {
    ssh_port = values.ssh_listen_port
    hostname = var.name
  }) }
}
