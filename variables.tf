variable "name" {
  default = "terraform"
}

variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
  default     = "vpc-0baaedc958cb79800"
}

variable "is_public" {
  description = "Associate a public IP address with the instance"
  type        = bool
  default     = true
}



variable "instances" {
  default = {
    "ec1" = {
      "disk"     = 10
      "type"     = "t2.micro"
      "ssh_port" = 22
    }
    "ec2" = {
      "disk"     = 20
      "type"     = "t2.micro"
      "ssh_port" = 223311
    }
  }
}


locals {
  tags = {
    CreateBy    = "Terraform"
    isEducation = "true"
  }
}

