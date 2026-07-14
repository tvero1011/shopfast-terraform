# ShopFast Infrastructure on AWS with Terraform

> Production-style AWS infrastructure built with Terraform using Amazon ECS Fargate, Application Load Balancer, VPC networking, IAM, and CloudWatch.

---

## Project Overview

ShopFast is a cloud infrastructure project demonstrating how to provision and manage a scalable containerized web application on AWS using Infrastructure as Code (IaC).

The project uses Terraform to automate the deployment of networking, security, compute, and load balancing resources following AWS best practices.

This project was built to strengthen practical skills in AWS architecture, Infrastructure as Code, and cloud deployment automation.

---

# Architecture

```
                    Internet
                        │
                        ▼
          Application Load Balancer
                        │
                        ▼
                 ECS Fargate Service
                        │
                        ▼
                  Docker Container
                        │
                        ▼
                 CloudWatch Logs

──────────────────────────────────────

Public Subnets
    │
    └── ALB

Private Subnets
    └── ECS Tasks

VPC
```

---

# AWS Services Used

- Amazon ECS (Fargate)
- Application Load Balancer (ALB)
- Amazon VPC
- Public & Private Subnets
- Internet Gateway
- Route Tables
- Security Groups
- IAM Roles
- Amazon CloudWatch
- Amazon ECR
- Terraform

---

# Features

- Infrastructure provisioned entirely with Terraform
- Containerized application deployment using ECS Fargate
- Secure VPC design with public and private subnets
- Application Load Balancer for traffic distribution
- IAM roles following least-privilege principles
- CloudWatch logging for monitoring
- Modular Terraform configuration
- Infrastructure version-controlled with Git

---

# Repository Structure

```
shopfast-terraform
│
├── app/
│   ├── Dockerfile
│   └── application source
│
├── terraform/
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   ├── provider.tf
│   └── modules/
│
├── diagrams/
│
└── README.md
```

---

# Technologies

- Terraform
- AWS
- Docker
- Amazon ECS
- Amazon ECR
- Amazon VPC
- IAM
- CloudWatch
- Git
- GitHub

---

# Skills Demonstrated

- Infrastructure as Code (IaC)
- AWS Cloud Architecture
- Terraform
- Networking
- IAM
- Container Deployment
- Cloud Security Fundamentals
- Version Control
- Cloud Automation

---

# Screenshots

Add screenshots inside the `diagrams/` folder.

Recommended images:

- AWS Architecture Diagram
- ECS Service
- Application Load Balancer
- CloudWatch Logs
- Terraform Apply Output
- VPC Resources

---

# Lessons Learned

This project provided hands-on experience designing AWS infrastructure with Terraform and deploying containerized workloads using Amazon ECS Fargate. It reinforced best practices for networking, IAM, Infrastructure as Code, and cloud resource organization while highlighting the value of automation and repeatable deployments.

---

# Future Improvements

- GitHub Actions CI/CD pipeline
- HTTPS using AWS Certificate Manager
- Route 53 custom domain
- Auto Scaling
- Amazon RDS integration
- AWS WAF
- Secrets Manager
- Monitoring dashboards

---

# Author

**Rovert Pangan**

AWS Certified Solutions Architect – Associate

Cloud Engineer | Automation Engineer

---

## License

This project is licensed under the MIT License.
