---
published: false                        # Optional. Set to true to publish the workshop (default: false)
type: workshop                          # Required.
title: Hands-on Lab - Platform Engineering for Federal with BackStage # Required. Full title of the workshop
short_title: Platform Engineering for Federal with BackStage      # Optional. Short title displayed in the header
description: This workshop will cover the...  # Required.
level: intermediate                     # Required. Can be 'beginner', 'intermediate' or 'advanced'
authors:                                # Required. You can add as many authors as needed      
  - John Spinella
contacts:                               # Required. Must match the number of authors
  - Author's email, Twitter...
duration_minutes: 20                    # Required. Estimated duration in minutes
tags: azure policies, azure deployment environment, backstage, github advanced security, microsoft dev box, dev center, azure, github, ops, federal csu          # Required. Tags for filtering and searching
#banner_url: assets/banner.jpg           # Optional. Should be a 1280x640px image
#video_url: https://youtube.com/link     # Optional. Link to a video of the workshop
#audience: students                      # Optional. Audience of the workshop (students, pro devs, etc.)
#wt_id: <cxa_tracking_id>                # Optional. Set advocacy tracking code for supported links
#oc_id: <marketing_tracking_id>          # Optional. Set marketing tracking code for supported links
#navigation_levels: 2                    # Optional. Number of levels displayed in the side menu (default: 2)
#navigation_numbering: true             # Optional. Enable numbering in the side menu (default: true)
#sections_title:                         # Optional. Override titles for each section to be displayed in the side bar
#   - Section 1 title
#   - Section 2 title
---

# Hands-on Lab - Platform engineering for Federal with BackStage

Welcome to this Platform engineering for Federal Workshop. In order to comprehend real-world situations, you will be testing with Azure services in several labs. Don't worry; you will be walked through the entire procedure in this step-by-step lab.

You will receive guidance on how to do each step throughout this workshop. Before seeing the solutions listed under the provided resources and links, it is advised to look at the solutions placed under the '📚 Toggle solution' panel.

<div class="task" data-title="Task">

> You will find the instructions and expected configurations for each Lab step in these yellow **TASK** boxes.
> Inputs and parameters to select will be defined, all the rest can remain as default as it has no impact on the scenario.

</div>

## Pre-requisites

Before starting this lab, be sure to set your Azure environment :

- An Azure Subscription with the **Owner** role to create and manage the labs' resources and deploy the infrastructure as code
- Register the Azure providers on your Azure Subscription if not done yet: `Microsoft.DevCenter`, `Microsoft.KeyVault`, `Microsoft.ApiManagement`, `Microsoft.Web`, `Microsoft.App`.

To be able to do the lab content you will also need:

- Basic understanding of Azure resources.
- A Github account (Free, Team or Enterprise)
- Create a [fork][repo-fork] of the repository from the **main** branch to help you keep track of your potential changes


3 development options are available:
  - 🥇 **Preferred method** : Pre-configured GitHub Codespace 
  - 🥈 Local Devcontainer
  - 🥉 Local Dev Environment with all the prerequisites detailed below

<div class="tip" data-title="Tips">

> To focus on the main purpose of the lab, we encourage the usage of devcontainers/codespace as they abstract the dev environment configuration, and avoid potential local dependencies conflict.
> 
> You could decide to run everything without relying on a devcontainer : To do so, make sure you install all the prerequisites detailed below.

</div>

### 🥇 : Pre-configured GitHub Codespace

To use a Github Codespace, you will need :
- [A GitHub Account][github-account]

Github Codespace offers the ability to run a complete dev environment (Visual Studio Code, Extensions, Tools, Secure port forwarding etc.) on a dedicated virtual machine. 
The configuration for the environment is defined in the `.devcontainer` folder, making sure everyone gets to develop and practice on identical environments : No more conflict on dependencies or missing tools ! 

Every Github account (even the free ones) grants access to 120 vcpu hours per month, _**for free**_. A 2 vcpu dedicated environment is enough for the purpose of the lab, meaning you could run such environment for 60 hours a month at no cost!

To get your codespace ready for the labs, here are a few steps to execute : 
- Start by forking the repository. Click on `Fork` and get a new copy of the repository which is now yours and that you can edit at your will.
- After you forked the repo, click on `<> Code`, `Codespaces` tab and then click on the `+` button:

![codespace-new](./assets/lab0-prerequisites/codespace-new.png)

- You can also provision a beefier configuration by defining creation options and select the **Machine Type** you like: 

![codespace-configure](./assets/lab0-prerequisites/codespace-configure.png)

### 🥈 : Using a local Devcontainer

This repo comes with a Devcontainer configuration that will let you open a fully configured dev environment from your local Visual Studio Code, while still being completely isolated from the rest of your local machine configuration : No more dependency conflict.
Here are the required tools to do so : 

- [Git client][git-client] 
- [Docker Desktop][docker-desktop] running
- [Visual Studio Code][vs-code] installed

Start by cloning the Hands-on Lab Platform engineering for Federal repo you just forked on your local Machine and open the local folder in Visual Studio Code.
Once you have cloned the repository locally, make sure Docker Desktop is up and running and open the cloned repository in Visual Studio Code.  

You will be prompted to open the project in a Dev Container. Click on `Reopen in Container`. 

If you are not prompted by Visual Studio Code, you can open the command palette (`Ctrl + Shift + P`) and search for `Reopen in Container` and select it: 

![devcontainer-reopen](./assets/lab0-prerequisites/devcontainer-reopen.png)

### 🥉 : Using your own local environment

The following tools and access will be necessary to run the lab in good conditions on a local environment :  

- [Git client][git-client] 
- [Visual Studio Code][vs-code] installed (you will use Dev Containers)
- [Azure CLI][az-cli-install] installed on your machine
- [Terraform][terraform-install] installed, this will be used for deploying the resources on Azure

Once you have set up your local environment, you can clone the Hands-on Lab Platform engineering for Federal repo you just forked on your machine, and open the local folder in Visual Studio Code and head to the next step. 

## 🔑 Sign in to Azure

<div class="task" data-title="Task">

> - Log into your Azure subscription in your environment using Azure CLI and on the [Azure Portal][az-portal] using your credentials.

</div>

<details>

<summary>📚 Toggle solution</summary>

```bash
# Login to Azure : 
# --tenant : Optional | In case your Azure account has access to multiple tenants

# Option 1 : Local Environment or Dev Container
az login --tenant <yourtenantid or domain.com>
# Option 2 : Github Codespace : you might need to specify --use-device-code parameter to ease the az cli authentication process
az login --use-device-code --tenant <yourtenantid or domain.com>

# Display your account details
az account show
# Select your Azure subscription
az account set --subscription <subscription-id>

# Register the following Azure providers if they are not already

# Microsoft DevCenter
az provider register --namespace 'Microsoft.DevCenter'
# Azure Key Vault
az provider register --namespace 'Microsoft.KeyVault'
# Azure API Management
az provider register --namespace 'Microsoft.ApiManagement'
# Azure Functions & Azure Web Apps
az provider register --namespace 'Microsoft.Web'
# Azure Container Apps
az provider register --namespace 'Microsoft.App'
```

</details>

# Module 2 - Lab 1 - Install Backstage

In this lab, we will initialize the standalone app for the moment. In the later labs we will add an external database to it and deploy it to Azure. As well as, do some configurarion to make it work with Azure and GitHub.

To get set up quickly with your own Backstage project you can create a Backstage App.

A Backstage App is a monorepo setup with `lerna` that includes everything you need to run Backstage in your own environment.

## Create a Backstage App

Backstage provides a utility for creating new apps. It guides you through the initial setup of selecting the name of the app and a database for the backend. The database options are either `SQLite` or `PostgreSQL`, where the latter requires you to set up a separate database instance.

To create a new app, run the following command:

```shell
npx @backstage/create-app@latest
```

<details>
<summary>📚 Toggle solution</summary>

```shell
npx @backstage/create-app@latest
```

If prompted, enter a name for the app. This will be the name of the directory that is created. I suggest to
use `backstage`

```shell
? Enter a name for the app [required] backstage

Creating the app...

 Checking if the directory is available:
  checking      backstage ✔ 

 Creating a temporary app directory:

 Preparing files:
  copying       .dockerignore ✔ 
  copying       .eslintignore ✔ 
  templating    .eslintrc.js.hbs ✔ 
  templating    .gitignore.hbs ✔ 
  copying       .prettierignore ✔ 
  copying       README.md ✔ 
  copying       app-config.local.yaml ✔ 
  copying       app-config.production.yaml ✔ 
  templating    app-config.yaml.hbs ✔ 
  templating    backstage.json.hbs ✔ 
  templating    catalog-info.yaml.hbs ✔ 
  copying       lerna.json ✔ 
  templating    package.json.hbs ✔ 
  copying       playwright.config.ts ✔ 
  copying       tsconfig.json ✔ 
  copying       yarn.lock ✔ 
  copying       README.md ✔ 
  copying       entities.yaml ✔ 
  copying       org.yaml ✔ 
  copying       template.yaml ✔ 
  copying       catalog-info.yaml ✔ 
  copying       index.js ✔ 
  copying       package.json ✔ 
  copying       README.md ✔ 
  templating    .eslintrc.js.hbs ✔ 
  copying       Dockerfile ✔ 
  copying       README.md ✔ 
  templating    package.json.hbs ✔ 
  copying       index.test.ts ✔ 
  copying       index.ts ✔ 
  copying       types.ts ✔ 
  copying       app.ts ✔ 
  copying       auth.ts ✔ 
  copying       catalog.ts ✔ 
  copying       proxy.ts ✔ 
  copying       scaffolder.ts ✔ 
  templating    search.ts.hbs ✔ 
  copying       techdocs.ts ✔ 
  copying       .eslintignore ✔ 
  templating    .eslintrc.js.hbs ✔ 
  templating    package.json.hbs ✔ 
  copying       android-chrome-192x192.png ✔ 
  copying       apple-touch-icon.png ✔ 
  copying       favicon-16x16.png ✔ 
  copying       favicon-32x32.png ✔ 
  copying       favicon.ico ✔ 
  copying       index.html ✔ 
  copying       manifest.json ✔ 
  copying       robots.txt ✔ 
  copying       safari-pinned-tab.svg ✔ 
  copying       app.test.ts ✔ 
  copying       App.test.tsx ✔ 
  copying       App.tsx ✔ 
  copying       apis.ts ✔ 
  copying       index.tsx ✔ 
  copying       setupTests.ts ✔ 
  copying       LogoFull.tsx ✔ 
  copying       LogoIcon.tsx ✔ 
  copying       Root.tsx ✔ 
  copying       index.ts ✔ 
  copying       EntityPage.tsx ✔ 
  copying       SearchPage.tsx ✔ 

 Moving to final location:
  moving        backstage ✔ 

 Installing dependencies:
  determining   yarn version ✔ 
  executing     yarn install ✔ 
  executing     yarn tsc ✔ 

🥇  Successfully created backstage


 All set! Now you might want to:
  Run the app: cd backstage && yarn dev
  Set up the software catalog: https://backstage.io/docs/features/software-catalog/configuration
  Add authentication: https://backstage.io/docs/auth/
```

</details>

This can take a few minutes to complete. But you should see the current progress in the terminal.

You should now have a new directory called `backstage` in your root directory, which contains following files and
folders:

```shell
backstage/
├── README.md
├── app-config.local.yaml
├── app-config.production.yaml
├── app-config.yaml
├── backstage.json
├── catalog-info.yaml
├── dist-types
│   ├── packages
│   └── tsconfig.tsbuildinfo
├── examples
│   ├── entities.yaml
│   ├── org.yaml
│   └── template
├── lerna.json
├── package.json
├── packages
│   ├── README.md
│   ├── app
│   └── backend
├── playwright.config.ts
├── plugins
│   └── README.md
├── tsconfig.json
└── yarn.lock
```

* **app-config.yaml**: Main configuration file for the app.
* **catalog-info.yaml**: Catalog Entities descriptors.
* **lerna.json**: Contains information about workspaces and other lerna configuration needed for the monorepo setup.
* **package.json**: Root package.json for the project. Note: Be sure that you don't add any npm dependencies here as
  they
  probably should be installed in the intended workspace rather than in the root.
* **packages/**: Lerna leaf packages or "workspaces". Everything here is going to be a separate package, managed by
  lerna.
* **packages/app/**: An fully functioning Backstage frontend app, that acts as a good starting point for you to get to
  know
  Backstage.
* **packages/backend/**: The backend for Backstage. This is where you can add your own backend logic.

## Run the App

As soon as the app is created, you can run it by navigating into the `backstage` directory and running the following command:

```shell
cd backstage
yarn dev
```

The yarn dev command will run both the frontend and backend as separate processes (named [0] and [1]) in the same
window. When the command finishes running, it should open up a browser window displaying your app. If not, you can open
a browser and directly navigate to the frontend at `http://localhost:3000`.

<details>
<summary>📚 Toggle solution</summary>

```shell
cd backstage
yarn dev
```

</details>

## Explore the App

Let's have a look on some of the values in the different files and change them to your needs.

First we change the name of our organization in the `app-config.yaml` file. Open the file and change the organization name to a name of your choice.

```yaml
organization:
  name: <your organization name>
```

Because we are still in the development mode, any changes to the `app-config.yaml` file will be reflected in the app as soon as you save the file. You can see the changes in the browser window.

### Add Microsoft Entra ID Integration

To add the Microsoft Entra ID integration, you need to add the following configuration to the `app-config.yaml` file.

```yaml

auth:
  providers:
    microsoft:
      development:
        clientId: <your client id>
        clientSecret: <your client secret>
        tenantId: <your tenant id>
      production:
        clientId: <your client id>
        clientSecret: <your client secret>
        tenantId: <your tenant id>
```

You can get the `clientId`, `clientSecret` and `tenantId` from the Azure Portal.

### Add GitHub Integration

To add the GitHub integration, you need to add the following configuration to the `app-config.yaml` file.

```yaml

auth:
  providers:
    github:
      development:
        clientId: <your client id>
        clientSecret: <your client secret>
      production:
        clientId: <your client id>
        clientSecret: <your client secret>
```

You can get the `clientId` and `clientSecret` from the GitHub Developer Settings.

# Module 2 - Lab 2 - Infrastructure as Code

In this lab, we will deploy Infrastructure as Code (IaC). We will use Terraform to define the infrastructure and deploy it to Azure.

## Deploy Infrastructure as Code

To deploy the infrastructure, you need to have Terraform installed on your machine.

<div class="tip" data-title="Tips">

> You should have downloaded Terraform, if not please review the [Pre-requisites](#pre-requisites) section.<br>

</div>

Once you have Terraform installed, you can define the infrastructure in a Terraform configuration file. The configuration file should include all the necessary resources and configurations for the infrastructure.

You can then use the `terraform apply` command to deploy the infrastructure to Azure. Terraform will create all the necessary resources and configurations based on the configuration file.

<details>

<summary>📚 Toggle solution</summary>

```shell
# Initialize Terraform
terraform init

# Plan the deployment
terraform plan

# Deploy the infrastructure
terraform apply
```

</details>

# Module 2 - Lab 3 - Path Paths

In this lab, we will discuss the paved paths in Platform Engineering and how they can be used to improve the development process. We will also discuss how to implement paved paths in Backstage.

## Paved Paths

Paved paths are a concept in Platform Engineering that allows developers to follow a set of best practices when developing applications. Paved paths can include things like coding standards, security practices, and deployment processes. By following paved paths, developers can ensure that their applications are secure, reliable, and scalable.

Paved paths can be implemented in a number of ways. For example, you can create templates for common application types that include all the necessary configuration and best practices. You can also create automated pipelines that enforce coding standards and security practices.

## Implementing Paved Paths in Backstage

In Backstage, paved paths can be implemented using the scaffolder plugin. The scaffolder plugin allows you to create templates for different types of applications and generate new projects based on those templates.

To implement paved paths in Backstage, you can create a new template in the `examples/template` directory. The template should include all the necessary configuration and best practices for a specific type of application.

You can then use the scaffolder plugin to generate new projects based on the template. The scaffolder plugin will create a new project in the `packages` directory with all the necessary configuration and best practices.




