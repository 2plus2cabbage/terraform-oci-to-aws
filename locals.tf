# Defines local variables for naming conventions in OCI
locals {
  vcn_name                     = "vcn-${var.environment_name}-${var.location}-"                    # Prefix for VCN name
  subnet_name_prefix           = "snet-${var.environment_name}-${var.location}-"                   # Prefix for subnet name
  windows_name_prefix          = "vm-${var.environment_name}-${var.location}-windows-"             # Prefix for Windows VM name
  security_list_name_prefix    = "slist-${var.environment_name}-${var.location}-"                  # Prefix for security list name
  internet_gateway_name_prefix = "igw-${var.environment_name}-${var.location}-"                    # Prefix for internet gateway name
  route_table_name_prefix      = "rt-${var.environment_name}-${var.location}-"                     # Prefix for route table name
  cpe_name_prefix              = "cpe-${var.environment_name}-${var.location}-"                    # Prefix for CPE name
  cpe_temp_name_prefix         = "cpe-${var.environment_name}-${var.location}-"                    # Prefix for temporary CPE name
  drg_name_prefix              = "drg-${var.environment_name}-${var.location}-"                    # Prefix for DRG name
  ipsec_name_prefix            = "ipsec-${var.environment_name}-${var.location}-"                  # Prefix for IPSEC connection name
}