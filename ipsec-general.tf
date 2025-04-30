# Creates a dynamic routing gateway (DRG) for IPSEC connections
resource "oci_core_drg" "cabbage_drg" {
  compartment_id = var.compartment_ocid                                                                             # Compartment for the DRG
  display_name   = "${local.drg_name_prefix}001"                                                                    # Name of the DRG
}

# Attaches the DRG to the VCN
resource "oci_core_drg_attachment" "cabbage_drg_attachment" {
  drg_id         = oci_core_drg.cabbage_drg.id                                                                      # DRG ID to attach
  vcn_id         = oci_core_vcn.cabbage_vcn.id                                                                      # VCN ID for the attachment
}

# Retrieves the tunnel information for the IPSEC connection
data "oci_core_ipsec_connection_tunnels" "oci_to_aws_tunnels" {
  ipsec_id       = oci_core_ipsec.oci_to_aws.id                                                                     # IPSEC connection ID
}

# Outputs the OCI VPN Gateway public IP
output "oci_vpn_ip_tunnel1" {
  value          = data.oci_core_ipsec_connection_tunnels.oci_to_aws_tunnels.ip_sec_connection_tunnels[0].vpn_ip    # Public IP of OCI VPN Gateway
  description    = "Public IP of the OCI VPN Gateway"                                                               # Description of the output
}