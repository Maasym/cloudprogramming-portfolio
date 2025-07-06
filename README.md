# Terraform AWS Static Website for GreenLeaf Analytics

This repository contains the Terraform code to deploy a highly available, scalable, and secure static website on AWS. The infrastructure is managed as code and deployed via a GitOps workflow using Terraform Cloud and GitHub.

This project was created as part of the "Cloud Programming" course portfolio and is based on a fictional case study for a startup named "GreenLeaf Analytics".

---

## Architecture Overview

The architecture is fully **serverless**, designed for high performance, security, and low operational overhead. The main components are:

* **AWS S3:** Hosts the static website files (HTML, CSS, JavaScript) generated from a React build. The bucket is configured to be completely private.
* **AWS CloudFront:** Acts as the global Content Delivery Network (CDN). It caches content close to users for low latency, enforces HTTPS, and serves as the single point of entry.
* **CloudFront Origin Access Control (OAC):** Provides CloudFront with secure access to the private S3 bucket, ensuring the bucket's contents are not publicly exposed.
* **AWS WAF:** A Web Application Firewall associated with CloudFront to protect against common web threats (OWASP Top 10) and Layer-7 DDoS attacks using managed rules and rate limiting.

---

## Tech Stack

* **Cloud Provider:** AWS
* **Infrastructure as Code:** Terraform
* **CI/CD & State Management:** Terraform Cloud
* **Version Control:** GitHub
* **Website Framework:** React (Vite)

---

## Prerequisites

Before you begin, ensure you have the following:

* An **AWS Account**.
* An **AWS IAM User** with programmatic access (Access Key ID and Secret Access Key).
* A **Terraform Cloud** account.
* A **GitHub** account.
* **Terraform CLI** installed locally (for initial setup and testing).

---

## Deployment Instructions

You can choose one of two methods to deploy this infrastructure.

### Method 1: GitOps with Terraform Cloud (Recommended)

This method uses a GitOps workflow. The infrastructure is deployed automatically when changes are pushed to the `main` branch.

### 1. Initial Setup

1.  **Clone the Repository:**
    ```bash
    git clone <your-repository-url>
    cd <your-repository-name>
    ```

2.  **Configure Terraform Cloud:**
    * Create a new **Workspace** in your Terraform Cloud organization.
    * Choose the **"Version control workflow"** option.
    * Connect it to your forked/cloned **GitHub repository**.
    * In the workspace settings, go to **"Variables"**. Add your AWS credentials as **"Environment Variables"**:
        * `AWS_ACCESS_KEY_ID` (Mark as **sensitive**)
        * `AWS_SECRET_ACCESS_KEY` (Mark as **sensitive**)

### 2. Deploy the Infrastructure

1.  **Commit and Push:** Commit all your Terraform files (`*.tf`) to the `main` branch of your repository and push the changes to GitHub.
    ```bash
    git add .
    git commit -m "feat: Initial infrastructure setup"
    git push origin main
    ```

2.  **Review and Apply in Terraform Cloud:**
    * The push to `main` will automatically trigger a **"plan"** in your Terraform Cloud workspace.
    * Review the execution plan in the UI to see what resources will be created.
    * If the plan is correct, click **"Confirm & Apply"** to deploy the infrastructure.

### Method 2: Local Deployment (Standard CLI)

This method uses the Terraform CLI directly on your local machine.

1.  **Clone the Repository:**
    ```bash
    git clone <your-repository-url>
    cd <your-repository-name>
    ```

2.  **Configure AWS Credentials Locally:**
    * Terraform needs to authenticate with your AWS account. The most secure way to do this is by setting environment variables in your terminal session. **Do not hardcode them in your `.tf` files.**
    * **On Linux/macOS:**
        ```bash
        export AWS_ACCESS_KEY_ID="YOUR_ACCESS_KEY"
        export AWS_SECRET_ACCESS_KEY="YOUR_SECRET_KEY"
        ```
    * **On Windows (Command Prompt):**
        ```cmd
        set AWS_ACCESS_KEY_ID="YOUR_ACCESS_KEY"
        set AWS_SECRET_ACCESS_KEY="YOUR_SECRET_KEY"
        ```

3.  **Run Terraform Commands:**
    * Initialize the project. This downloads the necessary AWS provider plugins.
        ```bash
        terraform init
        ```
    * Review the execution plan.
        ```bash
        terraform plan
        ```
    * Apply the configuration to create the resources in AWS.
        ```bash
        terraform apply
        ```
---

## Usage

Once the infrastructure is deployed, you need to upload your website's content.

1.  **Upload Website Files:**
    * Navigate to the **S3** service in your AWS Console.
    * Find the bucket named `greenleaf-web-...`.
    * If your build process created a `dist` folder, upload the **contents** of the `dist` folder into the bucket. Ensure `index.html` is at the root of the bucket (or at the root of the `origin_path` you defined).

---

## Destroying the Infrastructure

To avoid ongoing costs, you can destroy all managed resources after you are finished.

* **If you used Terraform Cloud:**
    * Navigate to your workspace in Terraform Cloud.
    * Go to **"Settings" -> "Destruction and Deletion"**.
    * Click the **"Queue destroy plan"** button and follow the prompts.

* **If you used the local CLI:**
    * From your project directory in your terminal, run the destroy command:
        ```bash
        terraform destroy
        ```