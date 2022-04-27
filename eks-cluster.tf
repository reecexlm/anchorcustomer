module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "18.20.5"

  cluster_name    = "${local.cluster_name}"
  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true
  instance_types = ["t3.micro"]

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
    instance_type  = "t3.micro"
    update_launch_template_default_version = true
    iam_role_additional_policies = [
      "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
    ]
  }

  eks_managed_node_groups = {
    
    common = {
      instance_types = ["t3.micro"]
      capacity_type = "SPOT"

      desired_capacity = 4
      max_capacity     = 4
      min_capacity     = 4

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