<img align="right" width="150" src="https://github.com/2plus2cabbage/2plus2cabbage/blob/main/images/2plus2cabbage.png">

<img src="https://github.com/2plus2cabbage/2plus2cabbage/blob/main/images/oci-to-aws.png" alt="oci-to-aws" width="300" align="left">
<br clear="left">

# OCI-to-AWS Cross-Cloud Terraform Deployment

Deploys a Windows Server 2022 VM in Oracle Cloud Infrastructure (OCI) with RDP, internet access, and an IPSEC VPN tunnel to a corresponding Windows VM in AWS for cross-cloud communication.

## Files
The project is split into multiple files to illustrate modularity and keep separate constructs distinct, making it easier to manage and understand.
- `main.tf`: Terraform provider block (`hashicorp/oci`).
- `ociprovider.tf`: OCI provider config with `tenancy_ocid`, `user_ocid`, etc.
- `variables.tf`: Variables for tenancy, compartment, region, etc.
- `terraform.tfvars.template`: Template for sensitive/custom values; rename to `terraform.tfvars` and add your credentials.
- `locals.tf`: Local variables for naming conventions.
- `oci-networking.tf`: VCN, subnet, internet gateway.
- `aws-networking.tf`: AWS networking values (`aws_vpn_ip`, `aws_subnet_cidr`) for IPSEC.
- `securitylist.tf`: Security list for RDP (TCP 3389), ICMP, and outbound traffic.
- `routing-static.tf`: Route table for internet access and AWS subnet routing.
- `ipsec-general.tf`: Shared IPSEC infrastructure (DRG, outputs for VPN IPs).
- `ipsec-aws.tf`: AWS-specific IPSEC resources (CPE, IPSEC connection).
- `windows.tf`: Windows VM, outputs public/private IPs.

## How It Works
- **Networking**: VCN and subnet provide connectivity. Route table enables inbound/outbound traffic and routes to AWS subnet via the IPSEC tunnel.
- **Security**: Allows RDP from your IP, ICMP from the AWS subnet, and all outbound traffic.
- **Instance**: Windows Server 2022 VM with public IP, firewall disabled via `user_data`.
- **IPSEC Tunnel**: Establishes a VPN connection to an AWS project, allowing communication between the OCI and AWS Windows VMs.

## Prerequisites
- An OCI account with a compartment.
- An API key pair with noted `tenancy_ocid`, `user_ocid`, `fingerprint`, `private_key_path`, `region`.
- A corresponding AWS project with IPSEC support, providing the `aws_vpn_ip_tunnel1` output.
- Terraform installed on your machine.
- Examples are demonstrated using Visual Studio Code (VSCode).
- **Note**: Cloud providers regularly change their console interfaces without notice. Steps outlined today may not apply exactly tomorrow.

## Procedural Note
The AWS project must be deployed first to obtain the VPN IP that will be added to the OCI project configuration.

## Deployment Steps
1. Update `terraform.tfvars` with OCI credentials, your public IP in `my_public_ip`, and the AWS VPN Gateway IP in `aws_vpn_ip`.
2. Run `terraform init`, then (optionally) `terraform plan` to preview changes, then `terraform apply` (type `yes`).
3. Get the public IP from the `oci_vm_public_ip` output on the screen, or run `terraform output oci_vm_public_ip`, or check in the OCI Console under **Compute > Instances**.
4. Retrieve the initial password in the OCI Console under **Compute > Instances > [select instance] > Resources > Instance Access > Click Show next to Initial Password**.
5. Use Remote Desktop to log in with the `opc` user and the retrieved initial password, using the public IP from the `oci_vm_public_ip` output.
6. In the AWS project, update `terraform.tfvars` with the OCI VPN Gateway IP (`oci_vpn_ip_tunnel1` output) in `oci_vpn_ip_tunnel1`, run `terraform apply`, and follow additional steps in the AWS project to switch the Customer Gateway and sync the Terraform state.
7. Verify the tunnel in the OCI Console under **Networking > Customer Connectivity > Site-to-Site VPN** (should show "Up" for IPSEC status).
8. Use Remote Desktop to log in to the AWS VM with the `Administrator` user and the retrieved initial password, using the public IP from the `aws_vm_public_ip` output (see AWS project README for details).
9. From the OCI VM, ping the AWS VM’s private IP (`aws_vm_private_ip` output) to confirm connectivity; then from the AWS VM, ping the OCI VM’s private IP (`oci_vm_private_ip` output) to confirm bidirectional connectivity.
10. To remove all resources, run `terraform destroy` (type `yes`).

## Potential costs and licensing
- The resources deployed using this Terraform configuration should generally incur minimal to no costs, provided they are terminated promptly after creation.
- It is important to fully understand your cloud provider's billing structure, trial periods, and any potential costs associated with the deployment of resources in public cloud environments.
- You are also responsible for any applicable software licensing or other charges that may arise from the deployment and usage of these resources.