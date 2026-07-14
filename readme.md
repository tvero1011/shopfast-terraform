# ShopFast Infrastructure on AWS with Terraform

![Terraform](https://img.shields.io/badge/Terraform-IaC-623CE4?logo=terraform)
![AWS](https://img.shields.io/badge/AWS-Cloud-FF9900?logo=amazonaws)
![Amazon ECS](https://img.shields.io/badge/Amazon-ECS-orange)
![Docker](https://img.shields.io/badge/Docker-Container-2496ED?logo=docker)
![License](https://img.shields.io/badge/License-MIT-green)

Production-style AWS infrastructure project demonstrating Infrastructure as Code (IaC) using Terraform to provision a secure, modular cloud environment for a containerized web application.

---

# Overview

ShopFast is a hands-on cloud engineering project designed to demonstrate how AWS infrastructure can be provisioned, managed, and version-controlled using Terraform.

The project provisions networking, security, container orchestration, image repositories, database resources, and supporting AWS services using reusable Terraform modules instead of manual configuration.

This project was built to strengthen practical cloud engineering skills and apply AWS architectural best practices through Infrastructure as Code.

---

# Solution Architecture

```
                           Internet
                               │
                               ▼
                 Application Load Balancer
                               │
                               ▼
                     Amazon ECS Service
                               │
                               ▼
                      Amazon ECS Tasks
                     │                │
                     │                ▼
                     │        CloudWatch Logs
                     │
                     ▼
                Amazon RDS Database

──────────────────────────────────────────────────────

                     Amazon VPC

           Public Subnets
                │
                └── Application Load Balancer

           Private Subnets
                ├── Amazon ECS Tasks
                └── Amazon RDS Database

──────────────────────────────────────────────────────

Amazon ECR ───────────────► ECS Tasks

AWS Secrets Manager ──────► ECS Task Definition

IAM Roles & Policies ─────► ECS Tasks
```

*A visual AWS architecture diagram will be added in a future update.*

---

# AWS Services Used

- Amazon ECS (Fargate)
- Amazon ECR
- Amazon VPC
- Public & Private Subnets
- Internet Gateway
- Route Tables
- Security Groups
- Application Load Balancer (ALB)
- IAM Roles & Policies
- Amazon CloudWatch Logs
- Amazon RDS
- VPC Endpoints

---

# Technologies

- Terraform
- AWS
- Docker
- Git
- GitHub

---

# Key Features

- Infrastructure provisioned entirely with Terraform
- Modular Infrastructure as Code (IaC) architecture
- Containerized application deployment using Amazon ECS Fargate
- Secure VPC networking with public and private subnets
- Application Load Balancer for incoming traffic
- Amazon ECR for container image management
- IAM roles following least-privilege principles
- CloudWatch Log Groups for centralized logging
- Amazon RDS database provisioning
---

# Repository Structure

```
shopfast-terraform
│
├── app/
│   ├── Dockerfile
│   └── Application source code
│
├── terraform/
│   ├── modules/
│   │   ├── alb/
│   │   ├── ecs/
│   │   ├── ecr/
│   │   ├── rds/
│   │   └── vpc/
│   │
│   ├── main.tf
│   ├── provider.tf
│   ├── variables.tf
│   └── outputs.tf
│
└── README.md
```

---

# Skills Demonstrated

- Infrastructure as Code (IaC)
- Terraform
- AWS Cloud Architecture
- Amazon ECS
- Amazon ECR
- Amazon VPC
- Amazon RDS
- AWS Secrets Manager
- IAM
- Docker
- Cloud Networking
- Modular Terraform Design
- Version Control
- Cloud Automation

---

# Project Status

This project was developed as a hands-on cloud engineering exercise to strengthen practical AWS and Terraform skills.

The repository focuses on designing reusable infrastructure, organizing Terraform modules, and implementing Infrastructure as Code principles rather than operating a continuously running production environment.

---

# Lessons Learned

Through this project I gained practical experience with:

- Designing AWS infrastructure using Terraform
- Building reusable Terraform modules
- Deploying containerized workloads using Amazon ECS Fargate
- Creating secure VPC networking architectures
- Managing IAM permissions following least-privilege principles
- Integrating Amazon RDS and AWS Secrets Manager
- Managing infrastructure using Git and GitHub

---

# Future Enhancements

- GitHub Actions CI/CD pipeline
- Professional AWS architecture diagram
- Infrastructure validation with Terraform linting
- Automated deployment workflow
- Monitoring dashboards and alarms

---

# Author

**Rovert Pangan**

AWS Certified Solutions Architect – Associate

Cloud Engineer | Automation Engineer

---

## License

This project is licensed under the MIT License.
