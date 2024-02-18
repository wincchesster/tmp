resource "aws_vpc" "lesson46-vpc" {
  cidr_block = "10.0.0.0/16"
  tags       = merge(local.tags, { Name = "lesson46-vpc" })
}

resource "aws_subnet" "lesson46-public_subnet" {
  vpc_id                  = aws_vpc.lesson46-vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "eu-central-1a"
  map_public_ip_on_launch = true
  tags                    = merge(local.tags, { Name = "lesson46-public-subnet" })
}

resource "aws_subnet" "lesson46-private_subnet" {
  vpc_id            = aws_vpc.lesson46-vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "eu-central-1a"
  tags              = merge(local.tags, { Name = "lesson46-private-subnet" })

}

resource "aws_internet_gateway" "lesson46-igw" {
  vpc_id = aws_vpc.lesson46-vpc.id
  tags   = merge(local.tags, { Name = "lesson46-igw" })
}

resource "aws_route_table" "lesson46-public_route_table" {
  vpc_id = aws_vpc.lesson46-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.lesson46-igw.id
  }
}

resource "aws_route_table_association" "public_subnet_association" {
  subnet_id      = aws_subnet.lesson46-public_subnet.id
  route_table_id = aws_route_table.lesson46-public_route_table.id
}

resource "aws_eip" "lesson46-nat_eip" {
  tags = merge(local.tags, { Name = "lesson46-nat-eip" })
}

resource "aws_nat_gateway" "lesson46-nat_gateway" {
  allocation_id = aws_eip.lesson46-nat_eip.id
  subnet_id     = aws_subnet.lesson46-public_subnet.id
  tags          = merge(local.tags, { Name = "lesson46-nat-gateway" })

}

resource "aws_route_table" "lesson46_private_route_table" {
  vpc_id = aws_vpc.lesson46-vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.lesson46-nat_gateway.id

  }
}

resource "aws_route_table_association" "private_subnet_association" {
  subnet_id      = aws_subnet.lesson46-private_subnet.id
  route_table_id = aws_route_table.lesson46_private_route_table.id

}
