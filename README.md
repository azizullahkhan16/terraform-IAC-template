# AWS Infrastructure with Terraform

This project provisions a scalable, production-ready AWS infrastructure using Terraform. It includes VPC subnets, security groups, EC2 Auto Scaling, RDS databases, an Application Load Balancer (ALB), Route53 DNS records, and ACM certificates for HTTPS.

---

## Table of Contents

- [Project Structure](#project-structure)
- [Infrastructure Overview](#infrastructure-overview)
- [Modules](#modules)
  - [Subnet](#subnet)
  - [Security Groups](#security-groups)
  - [RDS](#rds)
  - [EC2 Auto Scaling](#ec2-auto-scaling)
  - [ALB (Application Load Balancer)](#alb-application-load-balancer)
  - [Route53](#route53)
- [User Data Scripts](#user-data-scripts)
- [How to Deploy](#how-to-deploy)
- [Outputs](#outputs)
- [Notes](#notes)

---

## Project Structure

```
.
├── main.tf
├── variables.tf
├── terraform.tfstate
├── terraform.tfstate.backup
├── .terraform/
├── modules/
│   ├── alb/
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   ├── ec2-asg/
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   ├── variables.tf
│   │   └── scripts/
│   │       ├── al_userdata.sh
│   │       └── al_metabase.sh
│   ├── rds/
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   ├── route53/
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   ├── security-groups/
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   └── subnet/
│       ├── main.tf
│       ├── outputs.tf
│       └── variables.tf
```

---

## Infrastructure Overview

- **VPC Subnets:** Two private subnets for RDS and EC2 instances.
- **Security Groups:** Separate groups for EC2, RDS, and ALB with least-privilege rules.
- **RDS:** MySQL and PostgreSQL instances in private subnets.
- **EC2 Auto Scaling:** Launches Amazon Linux 2023 instances, runs Dockerized frontend/backend, and Metabase.
- **ALB:** Public-facing Application Load Balancer with HTTP/HTTPS listeners and ACM certificate.
- **Route53:** DNS records for the application and Metabase.
- **User Data:** Automated provisioning of application and Metabase via shell scripts.

---

## Modules

### Subnet

- Provisions two private subnets in different AZs.
- Associates them with a private route table.
- Creates an RDS subnet group for high availability.

See [`modules/subnet/main.tf`](modules/subnet/main.tf).

### Security Groups

- **amazon_linux_sg:** Allows SSH, HTTP, HTTPS for EC2.
- **rds_sg:** Allows MySQL (3306) and PostgreSQL (5432) from EC2 only.
- **alb_sg:** Allows HTTP/HTTPS from anywhere.

See [`modules/security-groups/main.tf`](modules/security-groups/main.tf).

### RDS

- Provisions MySQL and PostgreSQL instances in private subnets.
- Credentials and subnet group are passed as variables.
- Not publicly accessible.

See [`modules/rds/main.tf`](modules/rds/main.tf).

### EC2 Auto Scaling

- Launch Template and Auto Scaling Group for application servers.
- User data script installs Docker, Node.js, clones frontend/backend, builds and runs them in Docker.
- Separate EC2 instance for Metabase analytics, also provisioned via user data.

See [`modules/ec2-asg/main.tf`](modules/ec2-asg/main.tf).

### ALB (Application Load Balancer)

- Public ALB with HTTP and HTTPS listeners.
- ACM certificate for HTTPS, validated via DNS.
- Target group forwards traffic to EC2 ASG.

See [`modules/alb/main.tf`](modules/alb/main.tf).

### Route53

- DNS A record for the application (`shoppinglist.azizullahkhan.tech`) pointing to ALB.
- DNS A record for Metabase (`mb.azizullahkhan.tech`) pointing to Metabase EC2 instance.

See [`modules/route53/main.tf`](modules/route53/main.tf).

---

## User Data Scripts

- [`al_userdata.sh`](modules/ec2-asg/scripts/al_userdata.sh): Provisions EC2 with Docker, Node.js, clones and runs frontend/backend, configures Nginx as a reverse proxy.
- [`al_metabase.sh`](modules/ec2-asg/scripts/al_metabase.sh): Provisions Metabase in Docker, configures Nginx for Metabase.

---

## How to Deploy

1. **Initialize Terraform:**

   ```sh
   terraform init
   ```

2. **Set Variables:**

   - Edit `variables.tf` or provide a `.tfvars` file with required values (e.g., VPC ID, DB credentials, AMI ID, etc.).

3. **Plan:**

   ```sh
   terraform plan
   ```

4. **Apply:**
   ```sh
   terraform apply
   ```

---

## Outputs

- ALB DNS name
- RDS endpoints
- EC2 public IPs
- Route53 record names

(See each module's `outputs.tf` for details.)

---

## Notes

- **Sensitive Data:** Do not commit `.tfstate`, `.tfvars`, or any files with secrets.
- **ACM Certificate:** DNS validation is automated via Route53.
- **Networking:** All databases are in private subnets; only app servers can access them.
- **Scaling:** The ASG can be configured for desired/min/max capacity.
- **Custom Domains:** Ensure your Route53 zone matches your domain.

---

## License

This project uses the [Mozilla Public License 2.0](https://www.mozilla.org/en-US/MPL/2.0/) via the AWS provider.

---

## References

- [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [Amazon EC2 Auto Scaling](https://docs.aws.amazon.com/autoscaling/ec2/userguide/what-is-amazon-ec2-auto-scaling.html)
- [Amazon RDS](https://docs.aws.amazon.com/rds/)
- [Amazon Route53](https://docs.aws.amazon.com/route53/)
- [Amazon ACM](https://docs.aws.amazon.com/acm/)

---

For any issues or questions, please open an issue in
