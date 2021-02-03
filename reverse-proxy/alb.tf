resource "aws_lb" "example-alb" {
  name               = join("-",["alb-example", terraform.workspace])
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.reverse-proxy.id]
  subnets            = data.aws_subnet_ids.example.ids

  enable_deletion_protection = false

#   access_logs {
#     bucket  = aws_s3_bucket.lb_logs.bucket
#     prefix  = "test-lb"
#     enabled = true
#   }

  tags = {
    Name = join("-",["alb-example", terraform.workspace])
    Environment = terraform.workspace
    CreatedBy = "terraform"
  }
}

resource "aws_lb_target_group" "example-tg" {
  name     = join("-",["tg-example", terraform.workspace])
  port     = 80
  protocol = "HTTP"
  vpc_id   = local.workspace.vpc_id
}

resource "aws_lb_target_group_attachment" "example-alb-tg" {
  target_group_arn = aws_lb_target_group.example-tg.arn
  target_id        = aws_instance.reverse-proxy.id
  port             = 80
}

resource "aws_lb_listener" "example-alb-listener" {
  load_balancer_arn = aws_lb.example-alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = aws_acm_certificate.staging[0].arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.example-tg.arn
  }
}

resource "aws_lb_listener" "example-https-redirect" {
  load_balancer_arn = aws_lb.example-alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}
