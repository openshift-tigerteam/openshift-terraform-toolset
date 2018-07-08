resource "aws_vpc" "ocp" {
  cidr_block = "${var.vpc_cidr}"
}

resource "aws_eip" "master" {
  instance = "${aws_instance.master.id}"
  vpc      = true
}

# TODO: Region
# TODO: AZ sorting
# TODO: IGW
# TODO: NAT gateway
# TODO: Subnets
# TODO: Do we need network ACLs?
# TODO: Route tables
# TODO: Add EIPs
# TODO: Do we need ENIs?
# TODO: Do we need ENAs?

