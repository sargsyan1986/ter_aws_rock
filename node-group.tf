resource "aws_eks_node_group" "public-noder" {
  cluster_name    = aws_eks_cluster.im-cluster.name
  node_group_name = "public-noder"
  node_role_arn   = aws_iam_role.eks_nodegroup_role.arn

  subnet_ids = [
    aws_subnet.public-us-east-1a.id,
    aws_subnet.public-us-east-1b.id,
  ]
  capacity_type  = "ON_DEMAND"
  instance_types = ["t2.medium"]

  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 1
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.eks-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.eks-AmazonEC2ContainerRegistryReadOnly
  ]
}
