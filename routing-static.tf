# Creates a route table to direct traffic from the subnet to the internet and AWS
resource "oci_core_route_table" "cabbage_route_table" {
  compartment_id           = var.compartment_ocid                      # Compartment for the route table
  vcn_id                   = oci_core_vcn.cabbage_vcn.id               # VCN ID for the route table
  display_name             = "${local.route_table_name_prefix}001"     # Name of the route table
  route_rules {
    destination            = "0.0.0.0/0"                               # Route all traffic
    network_entity_id      = oci_core_internet_gateway.cabbage_igw.id  # Direct to internet gateway
  }
  route_rules {
    destination            = local.aws_subnet_cidr                     # Route to AWS subnet
    network_entity_id      = oci_core_drg.cabbage_drg.id               # Direct to DRG
  }
}