resource "aws_vpc" "virtual_anhatakan_amp" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "im_amp"
  }
}

resource "aws_subnet" "public-us-east-1a" {
  vpc_id                  = aws_vpc.virtual_anhatakan_amp.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    "Name"                             = "public-us-east-1a"
    "kubernetes.io/cluster/im-cluster" = "owned"
    "kubernetes.io/role/elb"           = 1
  }
}

resource "aws_subnet" "public-us-east-1b" {
  vpc_id                  = aws_vpc.virtual_anhatakan_amp.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true

  tags = {
    "Name"                             = "public-us-east-1b"
    "kubernetes.io/cluster/im-cluster" = "owned"
    "kubernetes.io/role/elb"           = 1
  }
}

resource "aws_internet_gateway" "im_igw" {
  vpc_id = aws_vpc.virtual_anhatakan_amp.id

  tags = {
    Name = "im_igw"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.virtual_anhatakan_amp.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.im_igw.id
  }

  tags = {
    Name = "public_rt"
  }
  # depends_on = [
  #   aws_internet_gateway.im_igw
  # ]
}

resource "aws_route_table_association" "public-us-east-1a" {
  subnet_id      = aws_subnet.public-us-east-1a.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public-us-east-1b" {
  subnet_id      = aws_subnet.public-us-east-1b.id
  route_table_id = aws_route_table.public_rt.id
}


