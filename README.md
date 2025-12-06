# AutoShip
## Automated CI/CD Pipeline for Containerized Applications on AWS
AutoShip is a fully automated CI/CD pipeline for deploying a containerized application on **AWS ECS Fargate**.  
The infrastructure is provisioned with **Terraform**, secured with **ACM SSL certificates**, and deployed automatically using **GitHub Actions**.  
Deployment notifications are sent to **Slack**.

### This project demonstrates how to:
- Build and containerize an application
- Push Docker images automatically to Amazon ECR
- Deploy updated tasks to Amazon ECS Fargate
- Route traffic using Application Load Balancer (ALB)
- Enable Auto Scaling for cost efficiency and resilience
- Send deployment status updates to Slack
- Ensure seamless deployments without downtime

## Architecture Diagram
<img width="812" height="650" alt="Screenshot 2025-12-06 083614" src="https://github.com/user-attachments/assets/e6d75716-7d67-4829-bfa7-fb52b6066b30" />


## Infrastructure Stack (Terraform)

This project provisions the following resources using **Terraform**:
### Networking
- VPC  
- Public & private subnets  
- Internet Gateway  
- NAT Gateway  
- Route tables  

### Compute
- ECS Cluster (Fargate)  
- ECS Task Definition  
- ECS Service with autoscaling  
- Application Load Balancer  

### Storage
- Amazon ECR repository

### Security
- Security Groups  
- IAM roles  
- ECS Task Execution Role  

### SSL Certificate (ACM)
- Domain from **freedomin.one**  
- SSL certificate validated using **DNS validation**  
- ALB listener on port **443**, forwarding to Fargate tasks  

## SSL / HTTPS Setup (ACM + ALB)

The SSL certificate was created using Terraform:
- Certificate issued through **AWS Certificate Manager (ACM)**  
- Validated using DNS records from Freedomin.one  
- Attached to the **Application Load Balancer (HTTPS listener)**  
- ALB now serves **HTTPS securely** with auto-renewing certificate  

## Docker Setup (Nginx Static Hosting)

The application uses NGINX to serve static website files inside the container.
**Why NGINX?**
- Static files (HTML, CSS, JS) do not run on their own  
- Containers need a **web server** to expose them  
- NGINX is lightweight, production-ready, and ideal for Fargate  
- Fargate does *not* expose local files unless served by a web server  
This makes scaling on ECS seamless.

## CI/CD Pipeline (GitHub Actions)
The pipeline performs:
### **1. Checkout repository**
### **2. Configure AWS credentials**
### **3. Login to Amazon ECR**
### **4. Build & push Docker image**
### **5. Render task definition JSON**
### **6. Deploy ECS service (rolling update, zero downtime)**
### **7. Send Slack notification**

### Full GitHub Actions Workflow: `.github/workflows/deploy.yml`
