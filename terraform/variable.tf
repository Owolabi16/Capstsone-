variable "ami" {
  default = "ami-028a5cd4ffd2ee495"
}
variable "instance_type" {
  default = "t2.micro"
}

variable "aws_eks_cluster" {
  default = "aliu_eks_cluster"
}

variable "ec2_profile" {
  default = "default"
}

