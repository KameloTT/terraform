data "aws_eks_cluster" "cluster" {
  name = module.cluster.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.cluster.cluster_id
}

provider "kubernetes" {
#  alias                  = "primary"
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.cluster.token
  config_path            = module.cluster.kubeconfig_filename
  config_context = data.aws_eks_cluster.cluster.arn
  load_config_file = false
}


#locals {
#    ebs_block_device = {
#        block_device_name = "/dev/sdc",
#        volume_type = "gp2"
#        volume_size = "20"
#    }
#}


module "cluster" {
#  providers = {
#    kubernetes = kubernetes.primary
#  }
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = var.clustername
  cluster_version = var.eks_version
  subnets         = var.private-subnets
  vpc_id          = var.vpc-id
  kubeconfig_name = var.clustername
  write_kubeconfig   = true
  manage_aws_auth = true
  wait_for_cluster_timeout = 900
  worker_groups = [
    {
#      name = "primary"
      instance_type = var.instance-type
      asg_max_size  = 3
      asg_desired_capacity = 3
      asg_min_size = 3
      key_name = var.key_name
      asg_recreate_on_change = true
      additional_security_group_ids = var.vpc_security_group_ids
#      kubelet_extra_args            = "--node-labels=node-role.kubernetes.io/worker="
#      additional_ebs_volumes = [local.ebs_block_device]
    }
  ]
}


