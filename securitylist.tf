# Creates a security list to control traffic to and from the subnet
resource "oci_core_security_list" "rdp_security_list" {
  compartment_id           = var.compartment_ocid                       # Compartment for the security list
  vcn_id                   = oci_core_vcn.cabbage_vcn.id                # VCN ID for the security list
  display_name             = "${local.security_list_name_prefix}rdp"    # Name of the security list
  ingress_security_rules {
    protocol               = "6"                                        # TCP protocol
    source                 = var.my_public_ip                           # Source IP for RDP access
    tcp_options {
      min                  = 3389                                       # Minimum port (RDP)
      max                  = 3389                                       # Maximum port (RDP)
    }
    description            = "RDP from your IP"                         # Description of the rule
  }
  ingress_security_rules {
    protocol               = "1"                                        # ICMP protocol
    source                 = local.aws_subnet_cidr                      # Source subnet (AWS) for ICMP traffic
    icmp_options {
      type                 = 8                                          # ICMP type for Echo Request (ping)
      code                 = 0                                          # ICMP code for Echo Request
    }
    description            = "ICMP from AWS subnet"                     # Description of the rule
  }
  egress_security_rules {
    protocol               = "all"                                      # All protocols for outbound traffic
    destination            = "0.0.0.0/0"                                # Allow all outbound destinations
    description            = "Allow all outbound traffic"               # Description of the rule
  }
}