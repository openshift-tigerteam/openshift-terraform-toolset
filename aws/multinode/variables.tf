# TODO: Sanitize defaults
variable "key_name" {
  description = "AWS Keyname"
  default     = "sandoval-aws"
}

variable "ami" {
  description = "ami image"
  default     = "ami-03291866"
}

variable "private_key_path" {
  description = "AWS Keyname"
  default     = "/root/aws/sandoval-aws.pem"
}

variable "security_group" {
  description = "Security Group"
  default     = "sandoval-sg"
}

variable "rhn_username" {
  description = "RHN username"
  default     = "rsandova@redhat.com"
}

variable "rhn_password" {
  description = "RHN password"
}

variable "rhn_pool" {
  description = "Pool ID to attach to"
}

variable "domain" {
  description = "Route53 hosted domain"
  default     = "demo.osecloud.com"
}

variable "subdomain" {
  description = "Subdomain to use for this event"
  default     = "ocp"
}

variable "create_nfs" {
  description = "Create NFS server"
  default     = false
}

variable "master" {
  description = "Master configurations"

  default = {
    count              = 1
    instance_type      = "m4.xlarge"
    root_volume_size   = 30
    docker_volume_size = 50
    nfs_volume_size    = 100
  }
}

variable "infra" {
  description = "Infra configurations"

  default = {
    count              = 0
    root_volume_size   = 30
    docker_volume_size = 50
    instance-type      = "m4.xlarge"
  }
}

variable "node" {
  description = "Node configurations"

  default = {
    count              = 3
    instance_type      = "m4.xlarge"
    root_volume_size   = 30
    docker_volume_size = 50
    cns_volume_size    = 100
  }
}

variable "nfs" {
  description = "NFS configurations"

  default = {
    count              = 0
    instance_type      = "m4.xlarge"
    root_volume_size   = 30
    docker_volume_size = 50
    nfs_volume_size    = 100
  }
}

variable "vpc_cidr" {
  default = "172.16.0.0/16"
}
