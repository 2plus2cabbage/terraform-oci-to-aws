# Creates a virtual cloud network (VCN) to host the subnet and resources
resource "oci_core_vcn" "cabbage_vcn" {
  compartment_id         = var.compartment_ocid                          # Compartment for the VCN
  display_name           = "${local.vcn_name}1010016"                    # Name of the VCN
  cidr_block             = "10.1.0.0/16"                                 # CIDR block for the VCN
}

# Creates a subnet within the VCN for the Windows VM
resource "oci_core_subnet" "cabbage_subnet" {
  compartment_id         = var.compartment_ocid                          # Compartment for the subnet
  vcn_id                 = oci_core_vcn.cabbage_vcn.id                   # VCN ID for the subnet
  cidr_block             = "10.1.1.0/24"                                 # CIDR block for the subnet
  display_name           = "${local.subnet_name_prefix}1011024"          # Name of the subnet
  prohibit_public_ip_on_vnic = false                                     # Allow public IPs on VNIC
  security_list_ids      = [oci_core_security_list.rdp_security_list.id] # Security list for RDP
  route_table_id         = oci_core_route_table.cabbage_route_table.id   # Route table for static routing 
}

# Creates an internet gateway to allow internet access for the VCN
resource "oci_core_internet_gateway" "cabbage_igw" {
  compartment_id         = var.compartment_ocid                          # Compartment for the internet gateway
  vcn_id                 = oci_core_vcn.cabbage_vcn.id                   # VCN ID for the internet gateway
  display_name           = "${local.internet_gateway_name_prefix}001"    # Name of the internet gateway
}