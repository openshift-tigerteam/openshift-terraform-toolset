data "aws_route53_zone" "selected" {
  name = "${var.domain}"
}

resource "aws_route53_record" "master" {
  count   = "${var.master["count"]}"
  zone_id = "${data.aws_route53_zone.selected.zone_id}"
  name    = "${var.subdomain}.${data.aws_route53_zone.selected.name}"
  type    = "A"
  ttl     = "300"
  records = ["${aws_eip.master.public_ip}"]
}

resource "aws_route53_record" "apps" {
  count   = "${var.master["count"]}"
  zone_id = "${data.aws_route53_zone.selected.zone_id}"
  name    = "*.apps.${var.subdomain}.${data.aws_route53_zone.selected.name}"
  type    = "A"
  ttl     = "300"
  records = ["${aws_eip.master.public_ip}"]
}
