resource "aws_vpc" "terraform_vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "terraform_public" {
  vpc_id                  = aws_vpc.terraform_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "eu-central-1a"
  map_public_ip_on_launch = true
}

resource "aws_internet_gateway" "terraform-igw" {
  vpc_id = aws_vpc.terraform_vpc.id
}


resource "aws_route_table" "terraform_rt" {
  vpc_id = aws_vpc.terraform_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.terraform-igw.id
  }
}

resource "aws_route_table_association" "public_subnet_association" {
  subnet_id      = aws_subnet.terraform_public.id
  route_table_id = aws_route_table.terraform_rt.id
}
