# Creates a Windows Server 2022 VM instance in OCI
resource "oci_core_instance" "windows_instance" {
  availability_domain        = "gIaz:US-ASHBURN-AD-1"                                                                   # Availability domain for the VM
  compartment_id             = var.compartment_ocid                                                                     # Compartment for the VM
  shape                      = "VM.Standard.E2.1"                                                                       # VM shape (compute resources)
  display_name               = "${local.windows_name_prefix}001"                                                        # Name of the VM
  source_details {
    source_type              = "image"                                                                                  # Source type for the VM
    source_id                = "ocid1.image.oc1.iad.aaaaaaaab4ql4h3nbubj6sapv526y6cnteiglv7vffesqujwd6uszjwyrzlq"       # Windows Server 2022 image ID
  }
  create_vnic_details {
    subnet_id                = oci_core_subnet.cabbage_subnet.id                                                        # Subnet for the VM's network interface
    assign_public_ip         = true                                                                                     # Assign a public IP for RDP access
  }
  metadata = {
    user_data                = base64encode("powershell.exe -Command \"netsh advfirewall set allprofiles state off\"")  # Disables firewall on boot
  }
}

# Outputs the public IP of the Windows VM for RDP access
output "oci_vm_public_ip" {
  value                      = oci_core_instance.windows_instance.public_ip                                             # Public IP of the VM
  description                = "Public IP of the OCI Windows VM"                                                        # Description of the output
}

# Outputs the private IP of the Windows VM for internal networking
output "oci_vm_private_ip" {
  value                      = oci_core_instance.windows_instance.private_ip                                            # Private IP of the VM
  description                = "Private IP of the OCI Windows VM"                                                       # Description of the output
}