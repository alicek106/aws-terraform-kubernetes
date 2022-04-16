#########################
# etcd cluster instances
#########################
# Delete the below comments to activate etcd.
# But I commented because I'm using kubespray for only 1 master, 1 etcd in 1 instance (default)
resource "aws_instance" "etcd" {
  count         = var.number_of_etcd
  ami           = lookup(var.amis, var.region)
  instance_type = var.etcd_instance_type

  subnet_id                   = aws_subnet.kubernetes.id
  private_ip                  = cidrhost(var.vpc_cidr, 10 + count.index)
  associate_public_ip_address = true # Instances have public, dynamic IP

  availability_zone      = var.zone
  vpc_security_group_ids = ["${aws_security_group.kubernetes.id}"]
  key_name               = var.default_keypair_name
  tags = (merge(
    local.common_tags,
    map(
      "Owner", "${var.owner}",
      "Name", "etcd-${count.index}",
      "ansibleFilter", "${var.ansibleFilter}",
      "ansibleNodeType", "etcd",
      "ansibleNodeName", "etcd.${count.index}"
    )
  ))
}
