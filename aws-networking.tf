# Defines AWS networking values for IPSEC connection
locals {
  aws_vpn_ip       = var.aws_vpn_ip        # Public IP of the AWS VPN Gateway
  aws_subnet_cidr  = "10.3.1.0/24"         # The private network on the AWS side
}