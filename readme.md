# ShopFast: Enterprise-Grade Cloud Native Infrastructure

This repository contains the **Infrastructure as Code (IaC)** for ShopFast, a high-performance 3-tier API environment. The project demonstrates a production-standard deployment using AWS Fargate, managed databases, and a fully automated CI/CD lifecycle.



## 🏗️ Architecture Design
The architecture follows the principle of **Defense in Depth**, ensuring that application logic and data remain isolated from the public internet.

* **Public Tier:** Application Load Balancer (ALB) managing ingress traffic.
* **Application Tier:** ECS Fargate tasks running in private subnets, scaling horizontally.
* **Data Tier:** Amazon RDS (Managed Database) isolated in a dedicated private subnet group.
* **Networking:** Custom VPC with isolated routing, Security Group chaining, and Interface Endpoints for secure AWS service communication.

## 🛠️ Project Milestones (The Roadmap)

### Phase 1: Containerization & Local Artifacts
* Dockerized the Node.js API with a multi-stage build to minimize image size.
* Verified local runtime consistency before cloud migration.

### Phase 2: Modular Networking & Registry
* Engineered a modular VPC with distinct Public and Private subnets.
* Deployed Amazon ECR (Elastic Container Registry) via Terraform for secure image hosting.

### Phase 3: Identity (IAM) & Task Orchestration
* Implemented **Least-Privilege** IAM Execution Roles for container logging and image pulling.
* Defined ECS Task Definitions including CPU/Memory limits and environment variable mapping.

### Phase 4: Compute Engine & CI/CD Automation
* Deployed the ECS Fargate Service into Private Subnets to eliminate direct internet exposure.
* Integrated **GitHub Actions** to automate the build-tag-push-deploy lifecycle.

### Phase 5: Managed Data Tier & Observability
* Deployed a managed RDS instance via Terraform.
* Configured **CloudWatch** for centralized logging and performance monitoring.
* Standardized the environment for enterprise-level scalability.

## 🛡️ Core Skills Demonstrated

| Skill | Implementation |
| :--- | :--- |
| **Infrastructure as Code** | 100% Terraform (Modular & Reusable Design) |
| **Compute** | AWS ECS Fargate (Serverless Containers) |
| **Networking** | VPC, Private Subnets, Interface Endpoints |
| **Security** | IAM Role Chaining, Secrets Management, Security Group Hardening |
| **DevOps** | GitHub Actions CI/CD Pipeline |
| **Observability** | Amazon CloudWatch Logs & Metrics |

## 🚀 Deployment Guide

1.  **Initialize & Registry Setup:**
    ```bash
    terraform init
    terraform apply -target=module.ecr
    ```
2.  **Push Docker Image:**
    Login to ECR, tag your local image, and push it to the repository URL provided in the Terraform outputs.
3.  **Deploy Infrastructure:**
    ```bash
    terraform apply
    ```

## 🧠 Key Architectural Decisions
* **Security Groups:** I implemented "Security Group Chaining" where the Database only accepts traffic from the ECS Task SG, and the ECS Task SG only accepts traffic from the ALB SG. 
* **Private Isolation:** By setting `assign_public_ip = false`, I ensured the application is inaccessible except through the Load Balancer.
* **Modularization:** Every component (VPC, RDS, ECS) is a standalone module, allowing for easy updates and multi-environment (Dev/Prod) replication.

---
*Developed as a demonstration of modern Cloud Engineering and DevOps practices.*