resource "aws_route53_record" "example_stage_sub" {
  count = terraform.workspace == "staging" ? 1 : 0  # add only for staging workspace
  zone_id = data.aws_route53_zone.example.zone_id
  # name = data.aws_route53_zone.example.name
  name = "sub.example.com.au"
  type = "A"
  ttl = "3600"

  records = [aws_eip.reverse-proxy-staging.public_ip]
}

resource "aws_route53_record" "example_stage" {
  count = terraform.workspace == "staging" ? 1 : 0  # add only for staging workspace
  zone_id = data.aws_route53_zone.example.zone_id
  name = data.aws_route53_zone.example.name
  type = "A"
  # ttl = "3600"

  alias {
    name = aws_lb.example-alb.dns_name
    zone_id = aws_lb.example-alb.zone_id
    evaluate_target_health = false
  }
}

# Sub-domains
resource "aws_route53_record" "example_stage_subdomains" {
  count = length(local.workspace.subdomains)
  zone_id = data.aws_route53_zone.example.zone_id
  name = "${local.workspace.subdomains[count.index]}.${data.aws_route53_zone.example.name}"
  type = "A"
  # ttl = "3600"

  alias {
    name = data.aws_route53_zone.example.name
    zone_id = data.aws_route53_zone.example.zone_id
    evaluate_target_health = false
  }
}
