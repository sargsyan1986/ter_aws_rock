resource "aws_eks_cluster" "im-cluster" {
  name     = "im-cluster"
  role_arn = aws_iam_role.eks_master_role.arn

  vpc_config {
    security_group_ids = [aws_security_group.my_1stsg.id] #(Optional) List of security group IDs for the cross-account elastic network interfaces that Amazon EKS creates to use to allow communication between your worker nodes and the Kubernetes control plane.
    subnet_ids = [
      aws_subnet.public-us-east-1a.id,
      aws_subnet.public-us-east-1b.id,
    ]
  }
  depends_on = [
    aws_iam_role_policy_attachment.eks-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.eks-AmazonEKSVPCResourceController
  ]
}

# resource "null_resource" "kubectl" {
#        depends_on = <CLUSTER_IS_READY>
#        provisioner "local-exec" {
#           command = "aws eks --region us-east-1 update-kubeconfig --name im-cluster"
#           }
#        }
#  }

# resource "null_resource" "kube_config_create" {
#   depends_on = [aws_eks_node_group.public-noder]
#   provisioner "local-exec" {
#     interpreter = ["/bin/bash", "-c"]
#     command     = "aws eks --region us-east-1 update-kubeconfig --name im-cluster && export KUBE_CONFIG_PATH=~/.kube/config && export KUBERNETES_MASTER=~/.kube/config"
#   }
# }

# resource "kubernetes_service" "example" {
#   metadata {
#     name = "example-service"
#   }
#   spec {
#     selector = {
#       "app" = "example"
#     }
#     port {
#       port        = 80
#       target_port = 3000
#     }
#     type = "LoadBalancer"
#   }
# }
