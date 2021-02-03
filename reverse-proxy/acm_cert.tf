resource "aws_acm_certificate" "staging" {
  count = terraform.workspace == "staging" ? 1 : 0
  domain_name       = local.workspace.domain_name
  validation_method = "DNS"
  subject_alternative_names = local.workspace.domain_alt_names

  tags = {
    Environment = terraform.workspace
    CreatedBy = "terraform"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "staging" {
  for_each = {
    for dvo in aws_acm_certificate.staging[0].domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.staging.zone_id
}

resource "aws_acm_certificate_validation" "staging" {
  certificate_arn         = aws_acm_certificate.staging[0].arn
  validation_record_fqdns = [for record in aws_route53_record.staging : record.fqdn]
}
