# VPC
resource "aws_vpc" "virtual_anhatakan_amp" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name                                           = "${var.project}-vpc",
    "kubernetes.io/cluster/${var.project}-cluster" = "shared"
  }
}

# Public Subnets
resource "aws_subnet" "public-us-east-1a" {
  vpc_id                  = aws_vpc.virtual_anhatakan_amp.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    "Name" = "public-us-east-1a"
    #"kubernetes.io/cluster/tang-eks" = "owned"
    "kubernetes.io/role/elb" = 1
  }
}

# Public Subnets
resource "aws_subnet" "public-us-east-1b" {
  vpc_id                  = aws_vpc.virtual_anhatakan_amp.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true

  tags = {
    "Name" = "public-us-east-1b"
    #"kubernetes.io/cluster/tang-eks" = "owned"
    "kubernetes.io/role/elb" = 1
  }
}

# Internet Gateway
resource "aws_internet_gateway" "imIGW" {
  vpc_id = aws_vpc.virtual_anhatakan_amp.id

  tags = {
    "Name" = "${var.project}-igw"
  }

  depends_on = [aws_vpc.virtual_anhatakan_amp]
}

# Route Table(s)
# Route the public subnet traffic through the IGW
resource "aws_route_table" "imRT" {
  vpc_id = aws_vpc.virtual_anhatakan_amp.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.imIGW.id
  }

  tags = {
    Name = "${var.project}-Default-rt"
  }
}

# Route table and subnet associations for us-east-1a
resource "aws_route_table_association" "rtAssoc1a" {
  subnet_id      = aws_subnet.public-us-east-1a.id
  route_table_id = aws_route_table.imRT.id
}

# Route table and subnet associations for us-east-1b
resource "aws_route_table_association" "rtAssoc1b" {
  subnet_id      = aws_subnet.public-us-east-1b.id
  route_table_id = aws_route_table.imRT.id
}

# # Add route to route table
# resource "aws_route" "main" {
#   route_table_id = aws_vpc.virtual_anhatakan_amp.id
#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_internet_gateway.imIGW.id
#   }

#   tags = {
#     Name = "public_rt"
#   }
# }
