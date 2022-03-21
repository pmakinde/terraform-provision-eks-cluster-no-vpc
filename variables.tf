variable "region" {
  type        = string
  description = "AWS region"
}

variable "environment" {
  type        = string
  description = "DWP environment"
}

variable "app_name" {
  type        = string
  description = "DWP application name"
}

variable "instance_name" {
  type        = string
  description = "EC2 Instance name"
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type"
}


variable "autoScaling_grp1_min_node" {
  type        = number
  description = "EC2 instance type"
}

variable "autoScaling_grp2_min_node" {
  type        = number
  description = "EC2 instance type"
}

variable "app_namespace" {
  type        = string
  description = "DWP environment"
}
