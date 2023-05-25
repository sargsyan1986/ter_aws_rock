# Create Security Group
resource "aws_security_group" "my_1stsg" {
  name   = "my_ec2_sg"
  vpc_id = aws_vpc.virtual_anhatakan_amp.id

  dynamic "ingress" {
    for_each = ["80", "443", "9090", "3000", "8000", "8080", "22", "30111"]

    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "mi-SG"
  }

}

