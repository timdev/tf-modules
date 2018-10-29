// Module specification variables

variable "instance_name" {
  description = "Used to populate the Name tag."
}

variable "instance_profile_name" {
  description = "The IAM Instance profile name (string) to launch this instance with."
  default     = ""
}

variable "subnet_id" {
  description = "The subnet to place the instance in"
}

variable "instance_type" {
  description = "EC2 instance type.  Ex: t2.small"
}

variable "ami_id" {
  description = "The AMI to use.  Must correspond to aws_region"
}

variable "key_name" {
  description = "The name of the EC2 keypair to use (for initial ssh)"
}

variable "vpc_security_group_ids" {
  description = "IDs of VPC Security Groups to apply to the instnace"
  type        = "list"
}

variable "root_block_device" {
  type        = "map"
  description = "Config for root block device.  See aws_instance docs."
  default     = {}
}

variable "tags" {
  type        = "map"
  description = "A map of tag names/values to apply to the instance"
  default     = {}
}

variable "volume_tags" {
  type        = "map"
  description = "A mapping of tags to assign to the devices created by the instance at launch time."
  default     = {}
}

variable "provision_remote_commands" {
  description = "A list of commands to run in a remote-exec provisioner"
  type        = "list"
  default     = []
}

variable "zone_id" {
  description = "The ID of the Route53 zone to add a CNAME to for this host"
}

variable "count" {
  description = "How many of these guys to create"
  default     = "1"
}

variable "aws_region" {}