# GCP Lab - Terraform & GitLab CI/CD

This project demonstrates infrastructure as code (IaC) using Terraform and automated deployment with GitLab CI/CD on Google Cloud Platform.

## Project Structure

```
.
├── app/                    # Web application files
│   └── index.html         # Random places viewer app
├── terraform/             # Terraform configuration
│   ├── main.tf           # Main infrastructure definition
│   ├── variables.tf      # Input variables
│   └── outputs.tf        # Output values
└── .gitlab-ci.yml        # CI/CD pipeline configuration
```

## Infrastructure

The Terraform configuration creates:
- **VPC Network**: Custom network with manual subnet configuration
- **Subnet**: 10.0.1.0/24 IP range in us-central1
- **Firewall Rule**: Allows HTTP (80) and SSH (22) traffic
- **Compute Instance**: e2-micro VM running Debian 11 with nginx

## CI/CD Pipeline

The GitLab pipeline has 4 stages:

1. **Validate**: Checks Terraform syntax and configuration
2. **Plan**: Creates execution plan for infrastructure changes
3. **Apply**: Applies infrastructure changes (requires manual approval)
4. **Deploy**: Deploys the web app to the VM

## Prerequisites

- GCP Project with billing enabled
- Service account with appropriate permissions
- GitLab repository with CI/CD enabled
- GCS bucket for Terraform state storage

## Required GitLab CI/CD Variables

Set these in GitLab Settings → CI/CD → Variables:

- `GCP_SERVICE_KEY`: Service account JSON key
- `GCP_PROJECT_ID`: Your GCP project ID
- `GCP_ZONE`: Deployment zone (e.g., us-central1-a)

## Local Development

### Setup

1. Install Terraform and gcloud CLI
2. Authenticate with GCP:
   ```bash
   gcloud auth application-default login
   ```

### Deploy Infrastructure

```bash
cd terraform
terraform init
terraform plan -var="project_id=YOUR_PROJECT_ID"
terraform apply -var="project_id=YOUR_PROJECT_ID"
```

### Destroy Infrastructure

```bash
terraform destroy -var="project_id=YOUR_PROJECT_ID"
```

## Features

- Infrastructure as Code with Terraform
- Automated CI/CD pipeline with GitLab
- Remote state management in GCS
- OS Login enabled for secure SSH access
- Free tier eligible resources

## License

MIT
