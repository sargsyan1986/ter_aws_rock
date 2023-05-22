# Security group for public subnet
resource "aws_security_group" "imSG" {
  name   = "${var.project}-Public-sg"
  vpc_id = aws_vpc.virtual_anhatakan_amp.id

  dynamic "ingress" {
    for_each = ["80", "443", "3000", "22"]

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
    Name = "${var.project}-Public-sg"
  }
}

# SecGroup for app   ???????????????????
resource "aws_security_group_rule" "app_port" {
  type              = "ingress"
  from_port         = 3000
  to_port           = 3000
  protocol          = "TCP"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_eks_cluster.tang-eks.vpc_config[0].cluster_security_group_id
}
