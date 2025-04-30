# Detailed Deployment Guide: OCI-to-AWS Cross-Cloud Terraform Deployment

This guide provides step-by-step instructions to deploy a Windows Server 2022 VM in Oracle Cloud Infrastructure (OCI) with RDP, internet access, and an IPSEC VPN tunnel to a corresponding Windows VM in AWS for cross-cloud communication.

## Prerequisites
Before starting, ensure you have the following:
- An OCI account with a compartment.
- An API key pair with noted `tenancy_ocid`, `user_ocid`, `fingerprint`, and `private_key_path` (found in OCI Console under **Profile > API Keys**).
- OCI region (e.g., `us-ashburn-1`).
- A corresponding AWS project with IPSEC support, providing the `aws_vpn_ip_tunnel1` output.
- Terraform installed on your machine.
- Visual Studio Code (VSCode) or another editor for modifying files.
- Your public IP address for RDP access (e.g., `203.0.113.5/32`; find it using a service like `whatismyipaddress.com`).
- **Note**: Cloud providers regularly change their console interfaces without notice. Steps outlined today may not apply exactly tomorrow.

## Deployment Steps

### Step 1: Update `terraform.tfvars` with OCI Credentials and Configuration
1. Open the `terraform.tfvars` file in your editor (e.g., VSCode).
2. Update the following fields with your information:
   - `tenancy_ocid`: Replace `"<your-tenancy-ocid>"` with your OCI tenancy OCID (e.g., `ocid1.tenancy...`).
   - `user_ocid`: Replace `"<your-user-ocid>"` with your OCI user OCID (e.g., `ocid1.user...`).
   - `fingerprint`: Replace `"<your-fingerprint>"` with the fingerprint of your API key (e.g., `12:34:56...`).
   - `private_key_path`: Replace `"<path-to-private-key>"` with the local path to your private key file (e.g., `/path/to/private-key.pem`).
   - `compartment_ocid`: Replace `"<your-compartment-id>"` with your OCI compartment OCID (e.g., `ocid1.compartment...`).
   - `region`: Replace `"<your-region>"` with your OCI region (e.g., `us-ashburn-1`).
   - `environment_name`: Replace `"<your-environment-name>"` with your environment name (e.g., `cabbage`).
   - `location`: Replace `"<your-location>"` with your location identifier (e.g., `usashburn`).
   - `my_public_ip`: Replace `"<your-public-ip>"` with your public IP for RDP access (e.g., `203.0.113.5/32`).
   - `aws_vpn_ip`: Replace `"<aws-vpn-ip>"` with the AWS VPN Gateway IP (e.g., `52.86.55.82`).
3. Save the file.

### Step 2: Initialize and Deploy the OCI Project
1. Open a terminal in the OCI project directory.
2. Run `terraform init` to initialize the Terraform working directory and download providers. This should take about 30 seconds.
3. (Optional) Run `terraform plan` to preview the changes Terraform will make. Review the output to ensure it looks correct (should take 15-30 seconds).
4. Run `terraform apply` to deploy the OCI resources. Type `yes` when prompted to confirm. This will create the VCN, subnet, VM, and VPN resources (takes about 2-5 minutes).

### Step 3: Retrieve the OCI VM Public IP
1. After deployment, Terraform will output several values. Note the `oci_vm_public_ip` value (e.g., `129.213.45.67`) for RDP access.
2. Alternatively, find the public IP in the OCI Console:
   - Go to **Compute > Instances**.
   - Locate the instance named `vm-<environment_name>-<location>-windows-001` (e.g., `vm-cabbage-usashburn-windows-001`).
   - Note the "Public IP" in the details pane.

### Step 4: Retrieve the OCI VM Initial Password
1. Go to the OCI Console: **Compute > Instances**.
2. Select the instance named `vm-<environment_name>-<location>-windows-001`.
3. Go to **Resources > Instance Access**.
4. Click **Show** next to "Initial Password" to retrieve the initial password for the `opc` user. Note this password for RDP access.

### Step 5: Connect to the OCI VM via RDP
1. Open your Remote Desktop client (e.g., Microsoft Remote Desktop).
2. Enter the public IP of the OCI VM from the `oci_vm_public_ip` output (e.g., `129.213.45.67`).
3. Use the username `opc` and the password retrieved in step 4.
4. Connect to the VM.

### Step 6: Update and Redeploy the AWS Project with the OCI VPN IP
1. In the AWS project directory, open the `terraform.tfvars` file in your editor.
2. Update the `oci_vpn_ip_tunnel1` field with the `oci_vpn_ip_tunnel1` value output from step 2 (e.g., `150.136.200.108`).
3. Save the file.
4. Follow the AWS project’s deployment guide to update the `terraform.tfvars` file with the shared secret and redeploy with `terraform apply`.

### Step 7: Verify the Tunnel
1. Go to the OCI Console: **Networking > Customer Connectivity > Site-to-Site VPN**.
2. Select the connection named `ipsec-<environment_name>-<location>-to-aws-001`.
3. Confirm the IPSEC status is "Up".

### Step 8: Connect to the AWS VM via RDP
1. Open your Remote Desktop client (e.g., Microsoft Remote Desktop).
2. Enter the public IP of the AWS VM from the `aws_vm_public_ip` output (e.g., `54.123.45.67`).
3. Use the username `Administrator` and the retrieved initial password (see AWS project deployment guide for details).
4. Connect to the VM.

### Step 9: Verify Connectivity Between OCI and AWS VMs
1. From the OCI VM, open Command Prompt or PowerShell.
2. Ping the AWS VM’s private IP (e.g., `terraform output aws_vm_private_ip` in the AWS project, such as `10.3.1.10`).
3. From the AWS VM, ping the OCI VM’s private IP (e.g., `terraform output oci_vm_private_ip` in the OCI project, such as `10.1.1.10`).
4. Confirm bidirectional connectivity is successful.

### Step 10: Clean Up Resources
1. In the terminal, run `terraform destroy` to remove all resources. Type `yes` to confirm (takes about 1-2 minutes).
2. Repeat this step in the AWS project to clean up its resources.

## Potential Costs and Licensing
- The resources deployed using this Terraform configuration should generally incur minimal to no costs, provided they are terminated promptly after creation.
- It is important to understand your cloud provider's billing structure, trial periods, and any potential costs associated with the deployment of resources in public cloud environments.
- You are also responsible for any applicable software licensing or other charges that may arise from the deployment and usage of these resources.