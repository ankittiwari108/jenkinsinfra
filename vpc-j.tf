resource "aws_vpc" "vpcj" {
  cidr_block = var.vpc_cidr
  tags       = local.common

}

resource "aws_internet_gateway" "igw_j" {
  vpc_id = aws_vpc.vpcj.id
  tags   = local.common

}

resource "aws_subnet" "subnetj" {
  vpc_id            = aws_vpc.vpcj.id
  cidr_block        = var.subnet_cidr
  depends_on        = [aws_vpc.vpcj]
  tags              = local.common
  availability_zone = "ap-south-1c"
}

resource "aws_route_table" "rt_j" {
  vpc_id = aws_vpc.vpcj.id
  tags   = local.common

}

resource "aws_route" "route_j" {
  route_table_id         = aws_route_table.rt_j.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw_j.id
  depends_on             = [aws_route_table.rt_j]

}

resource "aws_route_table_association" "rtj_ass" {
  route_table_id = aws_route_table.rt_j.id
  subnet_id      = aws_subnet.subnetj.id

}

resource "aws_instance" "inst_j" {
  ami                    = "ami-02b8269d5e85954ef"
  instance_type          = "t3.small"
  key_name               = "key1"
  subnet_id              = aws_subnet.subnetj.id
  vpc_security_group_ids = [aws_security_group.sec_grpj.id]
  depends_on             = [aws_subnet.subnetj, ]
  tags                   = local.common
  user_data              = file("jenkinsserver.sh")
  associate_public_ip_address = true

}

resource "aws_security_group" "sec_grpj" {
  vpc_id = aws_vpc.vpcj.id
  name   = "securitygrp_jenkins"
  tags   = local.common

}

resource "aws_vpc_security_group_ingress_rule" "ingress_j" {
  security_group_id = aws_security_group.sec_grpj.id
  ip_protocol       = "tcp"
  from_port         = 22
  to_port           = 22
  cidr_ipv4         = "0.0.0.0/0"

}

resource "aws_vpc_security_group_ingress_rule" "ingress_j1" {
  security_group_id = aws_security_group.sec_grpj.id
  ip_protocol       = "tcp"
  from_port         = 8080
  to_port           = 8080
  cidr_ipv4         = "0.0.0.0/0"

}

resource "aws_vpc_security_group_egress_rule" "egress_j" {
  security_group_id = aws_security_group.sec_grpj.id
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"

}
