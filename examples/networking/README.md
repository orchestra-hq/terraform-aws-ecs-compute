# Networking Example

This example shows how to create a secure VPC setup for the Orchestra ECS Compute module, with private subnets for workloads and NAT Gateways for outbound internet access.

Note this example creates a VPC with both public and private subnets. The public subnets are used for NAT Gateways, which are required for outbound internet access from the private subnets.

## Network Architecture

- VPC with DNS support (but no public DNS hostnames)
- Private subnets across multiple availability zones
- Public subnets (used only for NAT Gateways)
- NAT Gateways for outbound internet access from private subnets
- Security group allowing all internal VPC traffic and outbound internet access

## Usage

Be sure to get your Orchestra account ID from the [Account Settings](https://app.getorchestra.io/settings/account) page in Orchestra.
