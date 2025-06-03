provider "aws" {
  region = var.awsRegion
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "19.15.3"  # Latest stable version as of June 2023

  cluster_name    = var.clusterName
  cluster_version = "1.27"  # Latest stable EKS version

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  cluster_endpoint_public_access = true

  eks_managed_node_groups = {
    default = {
      instance_types = ["t3.medium"]  # More cost-effective than t2.small
      min_size       = 1
      max_size       = 3
      desired_size   = 2
    }
  }
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.0.0"  # Latest stable version

  name = "${var.clusterName}-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["${var.awsRegion}a", "${var.awsRegion}b", "${var.awsRegion}c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true

  tags = {
    "kubernetes.io/cluster/${var.clusterName}" = "shared"
  }

  public_subnet_tags = {
    "kubernetes.io/cluster/${var.clusterName}" = "shared"
    "kubernetes.io/role/elb"                   = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${var.clusterName}" = "shared"
    "kubernetes.io/role/internal-elb"          = "1"
  }
}

variable "clusterName" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "awsRegion" {
  description = "AWS region to deploy the cluster"
  type        = string
}

output "cluster_endpoint" {
  description = "Endpoint for EKS control plane"
  value       = module.eks.cluster_endpoint
}

output "cluster_name" {
  description = "Name of the EKS cluster"
  value       = module.eks.cluster_name
}

output "region" {
  description = "AWS region"
  value       = var.awsRegion
}
