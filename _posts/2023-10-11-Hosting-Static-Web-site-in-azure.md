---
layout: post
title: "Hosting and deploying a static website to Azure. Using azure storage account and github actions"
date:   2023-08-04 
categories: azure hosting static websites blogging
---
Before going into details of how to configure static web site in azure let's list why static web sites might be an option for your project.

Benefits and Key Scenarios of Using Static Websites:

**Benefits:**

1. **Cost-Efficiency:** Static websites are extremely cost-effective to host and maintain. They don't require server-side processing, which reduces hosting expenses.

2. **High Performance:** Static sites load quickly since there's no server-side processing. This results in faster page load times and a better user experience.

3. **Security:** With no server-side components or databases, the attack surface is reduced, making static websites less vulnerable to security threats.

4. **Scalability:** Static sites can easily handle high traffic loads because content is served from a content delivery network (CDN), distributing it globally.

5. **Simplicity:** Creating and maintaining static websites is straightforward. There's no need for complex databases or server setups.

6. **Version Control:** You can manage static site content with version control systems like Git, enabling easy collaboration and rollbacks.

7. **SEO-Friendly:** Search engines can crawl static sites efficiently, leading to better search engine optimization (SEO) potential.


Static websites offer a wide range of benefits and are particularly well-suited for scenarios where content is relatively stable and the focus is on fast loading times, simplicity, and cost savings. They're a versatile solution for various web projects, from personal blogs to documentation portals and marketing pages.


Hosting and deploying a static website in an Azure Storage Account and integrating it with GitHub Actions involves several steps. Below is a step-by-step tutorial to help you achieve this:

**Prerequisites:**
1. An Azure account. If you don't have one, you can create a free account at [Azure Portal](https://azure.com/free).
2. A GitHub account and a repository containing your static website code.
3. [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli) installed on your local machine.
4. [GitHub Actions](https://github.com/features/actions) enabled for your GitHub repository.

**Step 1: Create an Azure Storage Account**
1. Log in to your Azure portal.
2. Click on "Create a resource" and search for "Storage Account."
3. Click on "Storage account - blob, file, table, queue."
4. Fill in the required information, including the subscription, resource group, storage account name, and region. Leave the other settings as default.
5. Click "Review + create," and then click "Create" to create the storage account.

**Step 2: Enable Static Website Hosting in Azure Storage**
1. After the storage account is created, go to its settings.
2. In the left sidebar, under "Settings," click on "Static website."
3. Toggle the "Static website" switch to "Enabled."
4. Set the "Index document name" (e.g., `index.html`) and optionally, the "Error document path."
5. Click "Save."

**Step 3: Configure Azure Storage Account for Static Website Deployment**
1. In the storage account settings, go to "Access keys" and note down one of the connection strings (either key1 or key2).

**Step 4: Set up GitHub Repository**
1. Push your static website code to a GitHub repository if you haven't already.
2. Create a `.github/workflows` directory in your repository if it doesn't exist.
3. Inside the `.github/workflows` directory, create a YAML file (e.g., `deploy.yml`) to define your GitHub Actions workflow. Here's an example workflow file:

```yaml
name: Deploy to Azure Storage

on:
  push:
    branches:
      - main

jobs:
  build-and-deploy:
    runs-on: ubuntu-latest

    steps:
    - name: Checkout code
      uses: actions/checkout@v2

    - name: Set up Node.js
      uses: actions/setup-node@v2
      with:
        node-version: '14'

    - name: Install dependencies
      run: npm install

    - name: Build
      run: npm run build # Replace with your build command

    - name: Deploy to Azure Storage
      env:
        AZURE_STORAGE_CONNECTION_STRING: ${{ secrets.AZURE_STORAGE_CONNECTION_STRING }}
      run: |
        az storage blob upload-batch --destination '$web' --source ./build --connection-string $AZURE_STORAGE_CONNECTION_STRING
```

**Step 5: Set GitHub Secrets**
1. In your GitHub repository, go to "Settings" > "Secrets."
2. Click on "New repository secret" and create a secret named `AZURE_STORAGE_CONNECTION_STRING`. Set its value to the Azure Storage Account connection string you noted down in Step 3.

**Step 6: Deploy via GitHub Actions**
1. Commit and push the `deploy.yml` file to your GitHub repository.
2. GitHub Actions will automatically run when you push changes to the main branch, build your website, and deploy it to the Azure Storage Account.

**Step 7: Access Your Deployed Website**
1. Once the GitHub Actions workflow completes successfully, your static website will be deployed to Azure Storage.
2. You can access it using the Azure Storage Account's static website endpoint, which you can find in the "Static website" section of the storage account settings.

That's it! You've successfully hosted and deployed your static website in an Azure Storage Account and integrated the deployment process with GitHub Actions. Any future pushes to your main branch will trigger automatic deployments.