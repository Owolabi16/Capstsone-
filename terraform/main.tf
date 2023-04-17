module "ec2_instances" {
  source = "./modules/instance"

  region = var.region
  instance_count = 5
}

module "eks_cluster" {
  source = "./modules/eks"

  region = var.region

  vpc_subnet_cidr_blocks = [
    "10.0.1.0/24",
    "10.0.2.0/24",
    "10.0.3.0/24",
  ]
}