# TODO: Region
# DONE: AZ sorting
# DONE: IGW
# DONE: NAT gateway
# DONE: Subnets
# TODO: Do we need network ACLs?
# DONE: Route tables
# WIP: Add EIPs
# TODO: Do we need ENIs?
# TODO: Do we need ENAs?

resource "aws_vpc" "ocp" {
  cidr_block = "${var.vpc_cidr}"
}

resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc.ocp.id}"
}

resource "aws_eip" "nat" {
  vpc        = true
  depends_on = ["aws_internet_gateway.gw"]
}

resource "aws_nat_gateway" "gw" {
  allocation_id = "${aws_eip.nat.id}"
  subnet_id     = "${aws_subnet.public.id}"
}

data "aws_availability_zones" "available" {}

resource "aws_subnet" "public" {
  vpc_id     = "${aws_vpc.ocp.id}"
  cidr_block = "${cidrsubnet(var.vpc_cidr, 8, 255)}"
}

resource "aws_subnet" "ocp" {
  count             = "${var.subnet_count}"
  vpc_id            = "${aws_vpc.ocp.id}"
  availability_zone = "${data.aws_availability_zones.available.names[count.index]}"
  cidr_block        = "${cidrsubnet(var.vpc_cidr, 8, count.index)}"
}

resource "aws_route_table" "public" {
  vpc_id = "${aws_vpc.ocp.id}"
}

resource "aws_route_table_association" "public" {
  subnet_id      = "${aws_subnet.public.id}"
  route_table_id = "${aws_route_table.public.id}"
}

resource "aws_route" "public" {
  route_table_id         = "${aws_route_table.public}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.gw}"
}

resource "aws_route_table" "private" {
  vpc_id = "${aws_vpc.ocp.id}"
}

resource "aws_route_table_association" "private" {
  count          = "${var.subnet_count}"
  subnet_id      = "${aws_subnet.ocp.*.id[count.index]}"
  route_table_id = "${aws_route_table.private.id}"
}

resource "aws_route" "private" {
  route_table_id         = "${aws_route_table.private}"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = "${aws_nat_gateway.gw}"
}
