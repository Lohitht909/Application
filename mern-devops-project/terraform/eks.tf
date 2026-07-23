module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "19.15.1"

  manage_aws_auth_configmap = false

  cluster_name                   = local.name
  cluster_endpoint_public_access = true
  enable_irsa = true
  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
    aws-ebs-csi-driver = {
      most_recent = true
  }
  }

  vpc_id                   = module.vpc.vpc_id
  subnet_ids               = module.vpc.private_subnets

  eks_managed_node_groups = {
    mern-node = {
      min_size     = 2
      max_size     = 4
      desired_size = 2

      instance_types = ["m7i-flex.large"]
      capacity_type  = "SPOT"

      tags = {
        ExtraTag = "mern_Node"
      }
    }
  }

  tags = local.tags
}


output "cluster_name" {
  value = module.eks.cluster_name
}

output "cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "cluster_security_group_id" {
  value = module.eks.cluster_security_group_id
}

output "vpc_id" {
  value = module.vpc.vpc_id
}