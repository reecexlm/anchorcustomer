module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 18.0"

  cluster_name    = "${local.cluster_name}"
  cluster_version = "1.22"

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
      desired_capacity = 3
      max_capacity     = 3
      min_capacity     = 3

      instance_type = "t2.nano"
    }
      
    sep = {
      min_size     = 3
      max_size     = 3
      desired_size = 3

      instance_type = "t2.nano"
      capacity_type  = "SPOT"
      tags = {
        app= "sep"
      }
    }
    
    reference = {
      min_size     = 3
      max_size     = 3
      desired_size = 3

      instance_type = "t2.nano"
      capacity_type  = "SPOT"
      tags = {
        app= "reference"
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

data "aws_eks_cluster_auth" "cluster-auth" {
  depends_on = [module.eks.cluster_id]
  name       = module.eks.cluster_id
}