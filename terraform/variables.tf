output public_key {
  description = "Public key value"
  value = "${file("../keys/tf-kube.pub")}"
}

variable control_cidr {
  description = "CIDR for maintenance: inbound traffic will be allowed from this IPs"
  default = "0.0.0.0/0"
}

variable default_keypair_public_key {
  description = "Public Key of the default keypair"
  default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDD9oi+EFxLGNTjfvKH2zppeZy8T5cGg9IuSPh6rtcDHQL+/vG0Hv1dKCZEU/Lm/s3JujR7+LmKgrQeV5Hkp+buTyh5/lSVa8jN6psjgvWJzkyhDRi7lwl/CYU+dacyJUel53m9u4YHeGfBYv8cuoI/DoNm1YlCBS8537v/yuhBeXyL/rCfwVFqKaYp1qNeXnlJCL8Nu8Isvb16TjFL7tWgnrnxbcFyZsJ0YEwlm+mfywH0U+ezpVsPqOBSX6sWtREfds+baLFGifYwV3nDCJJlOynfyobwAnOyY4jWXgtWnDEaTDXO0880c2N5nyc3eR6f+N8WfP8zMSSzhIAxwgxz"
}

variable default_keypair_name {
  description = "Name of the KeyPair used for all nodes"
  default = "tf-kube"
}


variable vpc_name {
  description = "Name of the VPC"
  default = "kubernetes"
}

variable elb_name {
  description = "Name of the ELB for Kubernetes API"
  default = "kubernetes"
}

variable owner {
  default = "alicek106"
}

variable ansibleFilter {
  description = "`ansibleFilter` tag value added to all instances, to enable instance filtering in Ansible dynamic inventory"
  default = "Kubernetes01" # IF YOU CHANGE THIS YOU HAVE TO CHANGE instance_filters = tag:ansibleFilter=Kubernetes01 in ./ansible/hosts/ec2.ini
}

# Networking setup
variable region {
  default = "ap-northeast-2"
}

variable zone {
  default = "ap-northeast-2a"
}

### VARIABLES BELOW MUST NOT BE CHANGED ###

variable vpc_cidr {
  default = "10.43.0.0/16"
}

variable kubernetes_pod_cidr {
  default = "10.200.0.0/16"
}


# Instances Setup
variable amis {
  description = "Default AMIs to use for nodes depending on the region"
  type = "map"
  default = {
    ap-northeast-2 = "ami-067c32f3d5b9ace91"
    ap-northeast-1 = "ami-0567c164"
    ap-southeast-1 = "ami-a1288ec2"
    cn-north-1 = "ami-d9f226b4"
    eu-central-1 = "ami-8504fdea"
    eu-west-1 = "ami-0d77397e"
    sa-east-1 = "ami-e93da085"
    us-east-1 = "ami-40d28157"
    us-west-1 = "ami-6e165d0e"
    us-west-2 = "ami-a9d276c9"
  }
}
variable default_instance_user {
  default = "ubuntu"
}

variable etcd_instance_type {
  default = "t2.small"
}
variable controller_instance_type {
  default = "t2.small"
}
variable worker_instance_type {
  default = "t2.small"
}


variable kubernetes_cluster_dns {
  default = "10.31.0.1"
}
