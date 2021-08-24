data "aws_eks_cluster" "secondary" {
  name = module.secondary-cluster.cluster_id
}

data "aws_eks_cluster_auth" "secondary" {
  name = module.secondary-cluster.cluster_id
}

provider "kubernetes" {
  alias                  = "secondary"
  host                   = data.aws_eks_cluster.secondary.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.secondary.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.secondary.token
  config_path            = module.secondary-cluster.kubeconfig_filename
  config_context = data.aws_eks_cluster.secondary.arn
  load_config_file = false
}
#locals {
#    ebs_block_device = {
#        block_device_name = "/dev/sdc",
#        volume_type = "gp2"
#        volume_size = "20"
#    }
#}


module "secondary-cluster" {
  providers = {
    kubernetes = kubernetes.secondary
  }
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = "secondary-cluster"
  cluster_version = "1.19"
  subnets         = var.private-subnets
  vpc_id          = var.vpc-id
  kubeconfig_name = "secondary-cluster"
  write_kubeconfig    = true
  manage_aws_auth = true

  worker_groups = [
    {
#      name = "secondary"
      instance_type = var.instance-type
      asg_max_size  = 3
      asg_desired_capacity = 3
      asg_min_size = 3
      key_name = var.key_name
      asg_recreate_on_change = true
      additional_security_group_ids = var.vpc_security_group_ids
#      kubelet_extra_args            = "--node-labels=node-role.kubernetes.io/worker="
      additional_ebs_volumes = [local.ebs_block_device]
    }
  ]
}
