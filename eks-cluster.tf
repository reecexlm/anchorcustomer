module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 18.0"

  cluster_name    = "${local.cluster_name}"
  cluster_version = "1.22.6"

  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true

  cluster_addons = {
    coredns = {
      resolve_conflicts = "OVERWRITE"
    }
    kube-proxy = {}
    vpc-cni = {
      resolve_conflicts = "OVERWRITE"
    }

  }
  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  # EKS Managed Node Group(s)
  eks_managed_node_group_defaults = {
  }

  eks_managed_node_groups = {
    
    second = {
      desired_capacity = 4
      max_capacity     = 5
      min_capacity     = 3

      instance_type = "t2.medium"
    }
  
    
    sep = {
      min_size     = 1
      max_size     = 3
      desired_size = 2

      instance_type = "t2.medium"
      capacity_type  = "SPOT"
      tags = {
        app= "sep"
      }
    }
    
    reference = {
      min_size     = 1
      max_size     = 1
      desired_size = 1

      instance_type = "t2.medium"
      capacity_type  = "SPOT"
      tags = {
        app= "anchor-platform-reference-server-preview-id"
      }
    }
  }
}

data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}

