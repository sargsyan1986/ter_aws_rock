# Creating role for cluster
resource "aws_iam_role" "eks-iam-role" {
  name = "tang-eks-iam-role"

  path = "/"

  assume_role_policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
  {
   "Effect": "Allow",
   "Principal": {
    "Service": "eks.amazonaws.com"
   },
   "Action": "sts:AssumeRole"
  }
 ]
}
EOF
}

#Attaching policy to role
resource "aws_iam_role_policy_attachment" "AmazonEksClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks-iam-role.name
}



# Creating EKS cluster
resource "aws_eks_cluster" "tang-eks" {
  name     = "talan-cluster"
  role_arn = aws_iam_role.eks-iam-role.arn

  vpc_config {
    subnet_ids = ["subnet-007382170996f6ccc", "subnet-02dd970a5ac5ac486"]
  }

  depends_on = [
    aws_iam_role_policy_attachment.AmazonEksClusterPolicy,
  ]
}

# EKS Cluster Security Group
resource "aws_security_group" "eks_cluster" {
  name        = "${var.project}-cluster-sg"
  description = "Cluster communication with worker nodes"
  vpc_id      = aws_vpc.virtual_anhatakan_amp.id

  tags = {
    Name = "${var.project}-cluster-sg"
  }
}

# For worker nodes communication
resource "aws_security_group_rule" "cluster_inbound" {
  description              = "Allow worker nodes to communicate with the cluster API Server"
  from_port                = 443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.eks_cluster.id
  source_security_group_id = aws_security_group.eks_nodes.id
  to_port                  = 443
  type                     = "ingress"
}

# For worker nodes communication
resource "aws_security_group_rule" "cluster_outbound" {
  description              = "Allow cluster API Server to communicate with the worker nodes"
  from_port                = 1024
  protocol                 = "tcp"
  security_group_id        = aws_security_group.eks_cluster.id
  source_security_group_id = aws_security_group.eks_nodes.id
  to_port                  = 65535
  type                     = "egress"
}

# Creatin worker nodes group
resource "aws_eks_node_group" "worker-node-group" {
  cluster_name    = aws_eks_cluster.tang-eks.name
  node_group_name = "andznakan-workernodes"
  node_role_arn   = aws_iam_role.workernodes.arn
  subnet_ids      = ["subnet-007382170996f6ccc", "subnet-02dd970a5ac5ac486"]
  instance_types  = ["t2.micro"]
  # ami_type       = "AL2_x86_64" # AL2_x86_64, AL2_x86_64_GPU, AL2_ARM_64, CUSTOM
  # capacity_type  = "ON_DEMAND"  # ON_DEMAND, SPOT
  # disk_size      = 20

  scaling_config {
    desired_size = 2
    max_size     = 1
    min_size     = 3
  }

  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly,
  ]
}
