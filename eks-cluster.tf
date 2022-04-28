module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "18.20.5"

  cluster_name    = "${local.cluster_name}"
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
    instance_types = ["t3.nano", "t3.micro", "t3.small"]
    update_launch_template_default_version = true
    iam_role_additional_policies = [
      "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
    ]
  }

  eks_managed_node_groups = {
    
    common = {
      
      capacity_type = "SPOT"
      instance_types = ["t3.nano", "t3.micro", "t3.small"]
      desired_size = 6
      min_size     = 6
      max_size     = 7

        tags = {
          Environment = "dev"
          Terraform   = "true"
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