#-----------------------
# EKS Cluster Definition
#-----------------------

resource "aws_eks_cluster" "aliu_eks" {
  source = "terraform-aws-modules/aws/eks"
  version = "19.13.0"

  cluster_name = var.aws_eks_cluster
  role_arn = aws_iam_role.eks_role.arn

  vpc_config {
    subnets = [ aws_subnet.public_subnet_1.id , aws_subnet.public_subnet_2.id , aws_subnet.private_subnet_1.id ]
  }
  
  depends_on = [aws_iam_role_policy_attachment.eks-role]
  
  tags = {
    Terraform = "true"
    Environment = "dev"
  }

}


#-------------------------
# IAM Role For Eks Cluster
#-------------------------

resource "aws_iam_role" "eks-role" {
  name = "aliu-eks-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eks-role" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role = aws_iam_role.eks-role.name
}




#---------------------------
# Eks Node Group Definition
#---------------------------

resource "aws_eks_node_group" "eks-node" {
  cluster_name = var.aws_eks_cluster
  node_group_name = "aliu_eks_node_group"
  node_role_arn = aws_iam_role.eks-node.arn
  subnet_ids = [ aws_subnet.public_subnet_1.id , aws_subnet.public_subnet_2.id , aws_subnet.private_subnet_1.id ]

  workers_group_launch_template = {
    name = "worker_launch_template"
    version = "$latest"
  }

  scaling_config {
  workers_desired_capacity = 3
  workers_minimum_capacity = 3
  workers_maximum_capacity = 3
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks-node-role-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.eks-node-role-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.eks-node-role-AmazonEC2ContainerRegistryReadOnly,
  ]

}

#----------------------------
# IAM Role For Eks Node Group
#----------------------------

resource "aws_iam_role" "eks-node" {
  name = "aliu-eks-node-role"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy_attachment" "eks-node-role-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks-node.name
}

resource "aws_iam_role_policy_attachment" "eks-node-role-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks-node.name
}

resource "aws_iam_role_policy_attachment" "eks-node-role-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks-node.name
}