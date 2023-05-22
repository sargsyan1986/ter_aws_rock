output "cluster_name" {
  value = aws_eks_cluster.tang-eks.name
}

output "cluster_endpoint" {
  value = aws_eks_cluster.tang-eks.endpoint
}

output "cluster_ca_certificate" {
  value = aws_eks_cluster.tang-eks.certificate_authority[0].data
}
