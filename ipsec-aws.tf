# Creates a temporary CPE object with a dummy AWS VPN IP
resource "oci_core_cpe" "aws_cpe_temp" {
  compartment_id = var.compartment_ocid                                 # Compartment for the CPE
  ip_address     = local.aws_vpn_ip                                     # Dummy AWS VPN IP
  display_name   = "${local.cpe_temp_name_prefix}aws-temp-001"          # Name of the temporary CPE
}

# Creates the final CPE object to be updated with the real AWS VPN IP
resource "oci_core_cpe" "aws_cpe" {
  compartment_id = var.compartment_ocid                                 # Compartment for the CPE
  ip_address     = local.aws_vpn_ip                                     # To be updated with real AWS VPN IP
  display_name   = "${local.cpe_name_prefix}aws-001"                    # Name of the CPE
}

# Creates the IPSEC connection between OCI and AWS (single tunnel)
resource "oci_core_ipsec" "oci_to_aws" {
  compartment_id = var.compartment_ocid                                 # Compartment for the IPSEC connection
  cpe_id         = oci_core_cpe.aws_cpe_temp.id                         # CPE ID for the connection (initially temp, updated after import)
  drg_id         = oci_core_drg.cabbage_drg.id                          # DRG ID for the connection
  static_routes  = [local.aws_subnet_cidr]                              # AWS subnet CIDR for traffic
  display_name   = "${local.ipsec_name_prefix}to-aws-001"               # Name of the IPSEC connection
}