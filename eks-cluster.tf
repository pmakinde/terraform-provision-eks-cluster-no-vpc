provider "aws" {
  region = var.region
}

locals {
  cluster_name = "${var.app_name}-${var.environment}-${random_string.suffix.result}"
}

resource "random_string" "suffix" {
  length  = 8
  special = false
}


# data "aws_availability_zones" "available" {}

data "aws_subnets" "cluster_subnet_ids" {


}

data "aws_subnets" "private" {

  tags = {
    Tier = "Private"
  }
}



data "aws_vpc" "cluster_vpc" {

  tags = {
    Tier = "dwp_vpc"
  }
}


module "eks" {
#  source          = "terraform-aws-modules/eks/aws"
   source        = "./base_modules"
  version         = "17.24.0"
  cluster_name    = local.cluster_name
  cluster_version = "1.20"
# subnets         = module.vpc.private_subnets
  subnets         = data.aws_subnets.private.ids

#  vpc_id = module.vpc.vpc_id
  vpc_id = data.aws_vpc.cluster_vpc.id

  workers_group_defaults = {
    root_volume_type = "gp2"
  }

  worker_groups = [
    {
      name                          = "worker-group-1"
      instance_type                 = var.instance_type
      additional_userdata           = "echo DWP CC"
      additional_security_group_ids = [aws_security_group.worker_group_mgmt_one.id]
      asg_desired_capacity          = var.autoScaling_grp1_min_node
      asg_min_size                  = var.autoScaling_grp1_min_node
      asg_max_size                  = 3
    },
    {
      name                          = "worker-group-2"
      instance_type                 = var.instance_type
      additional_userdata           = "echo DWP CC"
      additional_security_group_ids = [aws_security_group.worker_group_mgmt_two.id]
      asg_desired_capacity          = var.autoScaling_grp2_min_node
      asg_min_size                  = var.autoScaling_grp2_min_node
      asg_max_size                  = 1
    },
  ]
}

data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}

resource "null_resource" "Create-DWP-Namespace" {
 provisioner "local-exec" {
command = <<-EOT
      chmod u+x namespace.sh
      ./namespace.sh
    EOT
    interpreter = ["/bin/bash", "-c"]
  }
depends_on = [module.eks]
}

