output "public_ip" {
  value = aws_instance.aliu_ec2.public_ip
}

output "cluster_endpoint" {
  value = aws_eks_cluster.aliu_eks.endpoint
}

output "cluster_certificate_authority" {
  value = aws_eks_cluster.aliu_eks.certificate_authority_data
}

output "worker_security_group_id" {
  value = aws_eks_cluster.aliu_eks.worker_security_group_id
}