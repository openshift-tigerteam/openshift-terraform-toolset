# TODO: Convert to ASG
resource "aws_instance" "nodes" {
  count                = "${var.node["count"]}"
  ami                  = "ami-0b1e356e"
  instance_type        = "m4.2xlarge"
  key_name             = "${var.key_name}"
  security_groups      = ["${var.security_group}"]
  iam_instance_profile = "${aws_iam_role.node.id}"

  root_block_device {
    volume_size           = "${var.node["root_volume_size"]}"
    volume_type           = "gp2"
    delete_on_termination = true
  }

  ebs_block_device {
    device_name           = "/dev/sdb"
    volume_size           = "${var.node["docker_volume_size"]}"
    volume_type           = "gp2"
    delete_on_termination = true
  }

  ebs_block_device {
    device_name           = "/dev/sdc"
    volume_size           = "${var.node["cns_volume_size"]}"
    volume_type           = "gp2"
    delete_on_termination = true
  }

  provisioner "remote-exec" {
    inline = [
      "sudo /usr/sbin/subscription-manager register --username ${var.rhn_username} --password ${var.rhn_password}",
      "sudo /usr/sbin/subscription-manager attach --pool=${var.rhn_pool}",
      "sudo /usr/sbin/subscription-manager repos --disable=\"*\"",
      "sudo /usr/sbin/subscription-manager repos --enable=\"rhel-7-server-rpms\" --enable=\"rhel-7-server-extras-rpms\" --enable=\"rhel-7-server-ose-3.9-rpms\" --enable=\"rhel-7-fast-datapath-rpms\" --enable=\"rhel-7-server-ansible-2.4-rpms\"",
      "sudo /usr/bin/yum install -y wget git net-tools bind-utils iptables-services bridge-utils bash-completion kexec-tools sos psacct atomic-openshift-utils  docker-1.13.1",
    ]
  }

  provisioner "file" {
    source      = "../../files/docker-storage-setup"
    destination = "/home/ec2-user/docker-storage-setup"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo cp /home/ec2-user/docker-storage-setup /etc/sysconfig/docker-storage-setup",
      "sudo /usr/bin/docker-storage-setup",
    ]
  }

  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = "${file(var.private_key_path)}"
  }

  # TODO: Add tag for clusterid e.g., `kubernetes.io/cluster/<name>,Value=<clusterid>`
  tags {
    Name = "${var.subdomain}-node-${count.index + 1 }"
  }
}
