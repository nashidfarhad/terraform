resource "aws_security_group" "reverse-proxy" {
  name = "reverse-proxy-sg"
  description = "Security Group for reverse proxy"
  vpc_id = data.aws_vpc.selected.id

  tags = {
    CreatedBy = "terraform"
    Name = "reverse-proxy-sg-${terraform.workspace}"
  }
}

resource "aws_security_group_rule" "http-all" {
  type = "ingress"
  from_port = 80 #start port number
  to_port = 80 #end port number
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.reverse-proxy.id
}

resource "aws_security_group_rule" "https-all" {
  type = "ingress"
  from_port = 443 #start port number
  to_port = 443 #end port number
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.reverse-proxy.id
}

resource "aws_security_group_rule" "ssh" {
  type = "ingress"
  from_port = 22 #start port number
  to_port = 22 #end port number
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"] # better to only allow specific IPs
  security_group_id = aws_security_group.reverse-proxy.id
  description = "SSH access"
}

resource "aws_security_group_rule" "outbound-all" {
  type = "egress"
  from_port = 0 #start port number
  to_port = 65535 #end port number
  protocol = "all"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.reverse-proxy.id
  description = "SSH access"
}

resource "aws_instance" "reverse-proxy" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"
  key_name = "reverse-proxy"
  subnet_id = local.workspace["subnet_id"]
  vpc_security_group_ids = [aws_security_group.reverse-proxy.id]
  user_data = file("./resource/script-${terraform.workspace}.sh")
  # adjust volume size
  root_block_device {
    volume_size = 30
  }

  tags = {
    Name = join("-",["reverse-proxy",terraform.workspace])
    CreatedBy = "terraform"
  }

  volume_tags = {
    Name = join("-",["reverse-proxy",terraform.workspace])
    CreatedBy = "terraform"
  }

  lifecycle {
    ignore_changes = [
      user_data,
      ami
    ]
  }
}

resource "aws_eip" "reverse-proxy-staging" {
  vpc = true
  tags = {
    Name = join("-",["reverse-proxy",terraform.workspace])
    CreatedBy = "terraform"
  }
}

resource "aws_eip_association" "staging" {
  instance_id = aws_instance.reverse-proxy.id
  allocation_id = aws_eip.reverse-proxy-staging.id
}