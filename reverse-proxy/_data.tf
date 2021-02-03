data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

data "aws_vpc" "selected" {
    id = local.workspace["vpc_id"]
}

data "aws_route53_zone" "example" {
  name = "example.com.au"
}

data "aws_subnet_ids" "example" {
  vpc_id = local.workspace["vpc_id"]
}

data "aws_route53_zone" "staging" {
  name         = "example.com.au"
  private_zone = false
}