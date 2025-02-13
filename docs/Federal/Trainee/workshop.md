---
published: false                        # Optional. Set to true to publish the workshop (default: false)
type: workshop                          # Required.
title: Product Hands-on Lab - Platform Engineering for Federal with BackStage # Required. Full title of the workshop
short_title: Platform Engineering for Federal with BackStage      # Optional. Short title displayed in the header
description: This workshop will cover the...  # Required.
level: intermediate                     # Required. Can be 'beginner', 'intermediate' or 'advanced'
authors:                                # Required. You can add as many authors as needed      
  - John Spinella, Steve St Jean, John Scott, Matthew Ross
contacts:                               # Required. Must match the number of authors
  - "@jrspinella"
duration_minutes: 150    # Required. Estimated duration in minutes
navigation_numbering: false                
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
navigation_levels: 3
---

# Product Hands-on Lab - Platform engineering with BackStage

Welcome to this Platform engineering for Federal Workshop. At its core, platform engineering is about constructing a solid and adaptable groundwork that simplifies and accelerates the development, deployment, and operation of software applications. The goal is to abstract the complexity inherent in managing infrastructure and operational concerns, enabling dev teams to focus on crafting code that adds direct value to the mission.

In order to comprehend real-world situations, you will be testing with serveral different toos and services in several labs. You will be able to learn how to deploy and manage Azure resources, as well as how to use Azure services to build and deploy applications with the help of AKS, GitHub and Backstage. Don't worry; you will be walked through the entire procedure in this step-by-step lab.

You will receive guidance on how to do each step throughout this workshop. You will be able to test your knowledge and skills by completing the labs.
Before seeing the solutions listed under the provided resources and links, it is advised to look at the solutions placed under the '📚 Toggle solution' panel.

This lab leverages the [GitOps Bridge Pattern](https://github.com/gitops-bridge-dev/gitops-bridge?tab=readme-ov-file). The following diagram shows the high-level architecture of the solution from [platformengineering.org](https://platformengineering.org/):
![GitOps Bridge Pattern](./assets/lab0-prerequisites/gitops-bridge-pattern.png)

The tools in this lab to build out your Integrated Development Platform (IDP) include:

- [GitHub]() (as your Git repo)
- [Backstage](https://backstage.io/) (as your self-service portal)
- [ArgoCD](https://argoproj.github.io/cd/) (as your Platform Orchestrator)
- [Argo Workflows](https://argoproj.github.io/workflows/) (to trigger post deployment tasks)
- [Crossplane]() (to provision Azure/GitHub resources)
- [Azure Kubernetes Service (AKS)]() (as your Control Plane cluster)
- [Azure Key Vault]() (to store secrets)
- [Azure Container Registry]() (to store container images)

<div class="tip" data-title="Tip">

> All tools in this lab are opinionated and used to show how to build out an IDP. You can use other tools to build out your IDP.

</div>

If you follow all instructions, you should have your own IDP running by the end of this lab!

## Pre-requisites

Before starting this lab, be sure to set your Azure environment :

- An Azure Subscription with the **Owner** role to create and manage the labs' resources and deploy the infrastructure as code
- Register the Azure providers on your Azure Subscription if not done yet: `Microsoft.ContainerService`,
`Microsoft.Network`,
`Microsoft.Storage`,
`Microsoft.Compute`,
`Microsoft.AppPlatform`,
`Microsoft.App`,
`Microsoft.KeyVault`,
- Install the `Azure CLI` on your local machine or use the Azure Cloud Shell
- Install `Terraform` on your local machine
- A `GitHub account` to create a GitHub App and use the GitHub integration in Backstage

To be able to do the lab content you will also need:

- Basic understanding of Azure resources which includes Azure Kubernetes Service (AKS), Azure Container Registry (ACR), Azure Key Vault.
- Basic understanding of Terraform and how to deploy resources using Terraform.
- Basic understanding of GitHub and how to create a GitHub App.
- Basic understanding of Backstage and how to deploy and configure Backstage.
- Basic understanding of Docker and how to create a Docker image.
- Basic understanding of Kubernetes and how to deploy applications to Kubernetes with ArgoCD and Crossplane.
- A Github account (Free, Team or Enterprise)
- Create a [fork](https://github.com/azurenoops/pe-backstage-azure-workshop) of the repository from the **main** branch to help you keep track of your potential changes.

3 development options are available:
  - 🥇 **Preferred method** : Pre-configured GitHub Codespace 
  - 🥈 Local Devcontainer
  - 🥉 Local Dev Environment with all the prerequisites detailed below

<div class="tip" data-title="Tips">

> To focus on the main purpose of the lab, we encourage the usage of devcontainers/codespace as they abstract the dev environment configuration, and avoid potential local dependencies conflict.
> You could decide to run everything without relying on a devcontainer : To do so, make sure you install all the prerequisites detailed below.

</div>

### 🥇 : Pre-configured GitHub Codespace

To use a Github Codespace, you will need :
- [A GitHub Account](https://github.com/join)

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

- [Git client](https://git-scm.com/downloads)
- [Docker Desktop](https://www.docker.com/products/docker-desktop/) running
- [Visual Studio Code](https://code.visualstudio.com/) installed

Start by cloning the Hands-on Lab Platform engineering for Federal repo you just forked on your local Machine and open the local folder in Visual Studio Code.
Once you have cloned the repository locally, make sure Docker Desktop is up and running and open the cloned repository in Visual Studio Code.  

You will be prompted to open the project in a Dev Container. Click on `Reopen in Container`.

If you are not prompted by Visual Studio Code, you can open the command palette (`Ctrl + Shift + P`) and search for `Reopen in Container` and select it: 

![devcontainer-reopen](./assets/lab0-prerequisites/devcontainer-reopen.png)

### 🥉 : Using your own local environment

The following tools and access will be necessary to run the lab in good conditions on a local environment :  

- [Git client](https://git-scm.com/downloads)
- [Visual Studio Code](https://code.visualstudio.com/) installed (you will use Dev Containers)
- [Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli) installed on your machine
- [Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli) installed, this will be used for deploying the resources on Azure

Once you have set up your local environment, you can clone the Hands-on Lab Platform engineering for Federal repo you just forked on your machine, and open the local folder in Visual Studio Code and head to the next step.

## 🔑 Sign in to Azure

<div class="task" data-title="Task">

> - Log into your Azure subscription in your environment using Azure CLI and on the [Azure Portal](https://portal.azure.com/) using your credentials.

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

# Azure Key Vault
az provider register --namespace 'Microsoft.KeyVault'
# Azure Container Registry
az provider register --namespace 'Microsoft.ContainerRegistry'
# Azure Kubernetes Service
az provider register --namespace 'Microsoft.ContainerService'
# Azure App Service
az provider register --namespace 'Microsoft.App'
# Azure App Service Environment
az provider register --namespace 'Microsoft.AppPlatform'
# Azure Storage
az provider register --namespace 'Microsoft.Storage'
# Azure Network
az provider register --namespace 'Microsoft.Network'
```

</details>

# Module 2 - Lab 1 - Install Backstage as your IDP

In this lab, we will initialize the standalone app for the moment. In the later labs, we will add an external database to it and deploy it to Azure on the Control Plane cluster. As well as, do some configurarion to make it work with Azure and GitHub.

## Validate Prereqs and Fork Repository

To get started, you will need to validate you have the following tools:

- [Node.js](https://nodejs.org/en/download/) (LTS version)
- [Yarn](https://yarnpkg.com/getting-started/install)
- [Docker](https://www.docker.com/get-started)
- [Git](https://git-scm.com/downloads)

Then, fork the repository from GitHub:

![Repo Fork](./assets/lab1-installbackstage/repo-fork.png)

Then clone the repository to your local machine:

```shell
git clone
```

<details>
<summary>📚 Toggle solution</summary>

```shell
git clone
```
</details>

Now that you cloned the repo, we can set up quickly with your own Backstage project you can create a Backstage App. We will run Backstage locally and configure the app.

A Backstage App is a monorepo setup with `lerna` that includes everything you need to run Backstage in your own environment.

## Create a Backstage App

Backstage provides a utility for creating new apps. It guides you through the initial setup of selecting the name of the app and a database for the backend.

To create a new app, run the following command from the root directory of your Backstage folder in the terminal:

```shell
cd backstage
```

Then run the following command:

```shell
npx @backstage/create-app@latest
```

<details>
<summary>📚 Toggle solution</summary>

```shell
npx @backstage/create-app@latest
```

If prompted, enter a name for the app. This will be the name of the directory that is created. We suggest to use `backstage`

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

![backstage-home](./assets/lab1-installbackstage/backstage-home.png)

First we change the name of our organization in the `app-config.yaml` file. Open the file and change the organization name to a name of your choice.

```yaml
organization:
  name: <your organization name>
```

Because we are still in the development mode, any changes to the `app-config.yaml` file will be reflected in the app as soon as you save the file. You can see the changes in the browser window.

<div class="warning" data-title="Warning">

> If you do not see the changes in the browser window, try to refresh the page.

</div>

## Update your Azure Entra Organization

In order to use the full potential of Backstage,  you will need to setup the Microsoft Entra ID plugin. This plugin allows you to authenticate users using Microsoft Entra ID.

### Configure App Registration on Azure

To add Microsoft Entra ID authentication to Backstage, you must create an App Registration in Azure Active Directory. This App Registration will be used to authenticate users using Microsoft Entra ID.

Depending on how locked down your company is, you may need a directory administrator to do some or all of these instructions.

Go to [Azure Portal > App registrations](https://portal.azure.com/#view/Microsoft_AAD_RegisteredApps/ApplicationsListBlade) and find your existing app registration, or create a new one. If you have an existing App Registration for Backstage, use that rather than create a new one.

On your app registration's overview page, add a new Web platform configuration, with the configuration:

- Redirect URI: https://your-backstage.com/api/auth/microsoft/handler/frame (for local dev, typically http://localhost:7007/api/auth/microsoft/handler/frame)
- Front-channel logout Url: blank
- Implicit grant and hybrid flows: All unchecked

On the API permissions tab, click on Add Permission, then add the following Delegated permission for the Microsoft Graph API.

- email
- offline_access
- openid
- profile
- User.Read

Optional custom scopes of the Microsoft Graph API defined in the app-config.yaml file.
Your company may require you to grant admin consent for these permissions. Even if your company doesn't require admin consent, you may wish to do so as it means users don't need to individually consent the first time they access backstage. To grant admin consent, a directory admin will need to come to this page and click on the Grant admin consent for COMPANY NAME button.

<div class="tip" data-title="Tips">

> If you're using an existing app registration, and backstage already has a client secret, you can re-use that. If not, go to the Certificates & Secrets page, then the Client secrets tab and create a new client secret. Make a note of this value as you'll need it in the next section.

</div>

## Add Entra Configuration as Code

Backstage allows you to define configuration as code using the `app-config.yaml` file. This file contains all the configuration settings for your Backstage app, including the organization name, the app title, and the backend URL.

To add configuration settings to your Backstage app, open the `app-config.yaml` file in the root directory of your app and add the following configuration settings:

```yaml
auth:
  environment: development
  providers:
    microsoft:
      development:
        clientId: ${AZURE_CLIENT_ID}
        clientSecret: ${AZURE_CLIENT_SECRET}
        tenantId: ${AZURE_TENANT_ID}
        domainHint: ${AZURE_TENANT_ID}
        signIn:
          resolvers:
            # See https://backstage.io/docs/auth/microsoft/provider#resolvers for more resolvers
            - resolver: userIdMatchingUserEntityAnnotation
```

<div class="tip" data-title="Tips">

> You can define configuration settings for different environments by creating separate configuration files for each environment. For example, you can create an `app-config.local.yaml` file for local development and an `app-config.production.yaml` file for production.

</div>

The Microsoft provider is a structure with three mandatory configuration keys:

- **clientId:** Application (client) ID, found on App Registration > Overview
- **clientSecret:** Secret, found on App Registration > Certificates & secrets
- **tenantId:** Directory (tenant) ID, found on App Registration > Overview
- **domainHint (optional):** Typically the same as tenantId. Leave blank if your app - registration is multi tenant. When specified, this reduces login friction for - users with accounts in multiple tenants by automatically filtering away accounts from other tenants. For more details, see Home Realm Discovery
- **additionalScopes (optional):** List of scopes for the App Registration, to be requested in addition to the required ones.
- **skipUserProfile (optional):** If true, skips loading the user profile even if the User.Read scope is present. This is a performance optimization during login and can be used with resolvers that only needs the email address in spec.profile.email obtained when the email OAuth2 scope is present.

### Resolvers

This provider includes several resolvers out of the box that you can use:

- emailMatchingUserEntityProfileEmail: Matches the email address from the auth provider with the User entity that has a matching spec.profile.email. If no match is found it will throw a NotFoundError.
- emailLocalPartMatchingUserEntityName: Matches the local part of the email address from the auth provider with the User entity that has a matching name. If no match is found it will throw a NotFoundError.
- emailMatchingUserEntityAnnotation: Matches the email address from the auth provider with the User entity where the value of the microsoft.com/email annotation matches. If no match is found it will throw a NotFoundError.
- userIdMatchingUserEntityAnnotation: Matches the user profile ID from the auth provider with the User entity where the value of the graph.microsoft.com/user-id annotation matches. This resolver is recommended to resolve users without an email in their profile. If no match is found it will throw a NotFoundError.

## Add Backend Integration

To add the backend integration to the Backstage app, you will need to install the `@backstage/plugin-auth-backend-module-microsoft-provider` package. This package provides the backend integration for Microsoft Entra ID.

To install the package, run the following command from the root directory of your Backstage app:

```shell
yarn --cwd packages/backend add @backstage/plugin-auth-backend-module-microsoft-provider
```
Then we will need to this line in **packages/backend/src/index.ts**:

```typescript
backend.add(import('@backstage/plugin-auth-backend-module-microsoft-provider'));
```

## Add Frontend Integration

To add the frontend integration to the Backstage app, you will need to add a Signin Page. This page will allow users to sign in to the app using Microsoft Entra ID.

Sign-in is configured by providing a custom SignInPage app component. It will be rendered before any other routes in the app and is responsible for providing the identity of the current user. The SignInPage can render any number of pages and components, or just blank space with logic running in the background.

In the end, however, it must provide a valid Backstage user identity through the onSignInSuccess callback prop, at which point the rest of the app is rendered.

We will need to add this line in **packages/app/src/App.tsx**:

```typescript
import { microsoftAuthApiRef } from '@backstage/core-plugin-api';
import { SignInPage } from '@backstage/core-components';

const app = createApp({
 components: {
    SignInPage: props => (
      <SignInPage
        {...props}
        auto
        provider={{
          id: 'microsoft-auth-provider',
          title: 'Microsoft',
          message: 'Sign in using Microsoft',
          apiRef: microsoftAuthApiRef,
        }}
      />
    ),
  },
  // ..
});
```

## Adding Entra ID Organizational Data

The Azure provider can also be configured to fetch organizational data from GitHub. This data can be used to filter the users that are allowed to sign in to Backstage.

This can be done by adding the **@backstage/plugin-catalog-backend-module-msgraph** package to your backend.

## Backend Installation

The package is not installed by default, therefore you have to add **@backstage/plugin-catalog-backend-module-msgraph** to your backend package.

Run the following command from your **Backstage root directory**:

```typescript
yarn --cwd packages/backend add @backstage/plugin-catalog-backend-module-msgraph
```

Next add the basic configuration to the **app-config.yaml** file:

```yaml
catalog:
  providers:
    microsoftGraphOrg:
      default:
        tenantId: ${AZURE_TENANT_ID}
        user:
          filter: accountEnabled eq true and userType eq 'member'
        group:
          filter: >
            securityEnabled eq false
            and mailEnabled eq true
            and groupTypes/any(c:c+eq+'Unified')
        schedule:
          frequency: PT1H
          timeout: PT50M
```

<div class="tip" data-title="Tips">

> For large organizations, this plugin can take a long time, so be careful setting low frequency / timeouts and importing a large amount of users / groups for the first try.

<div>

Finally, update your backend by adding to **packages/backend/src/index.ts**  following line:

```typescript
backend.add(import('@backstage/plugin-catalog-backend-module-msgraph'));
```

You have completed the first lab. You have created a new Backstage app and explored the app.

# Module 3 - Lab 2 - Deploy Control Plane cluster - Azure Kubernetes Service(AKS) on Azure

In this lab, we will deploy the Control Plane cluster on Azure Kubernetes Service (AKS). We will use Terraform to define the infrastructure as code for the deployment of Backstage on Azure.

## Validate you Pre-requisites

## Provision the Control Plane Cluster

With the repository that you cloned in Lab 1, it comes with a pre-defined Terraform code and configuration. The code is located in the `terraform/aks` folder.

To provision the Control Plane cluster, run the following command from your **Backstage root directory**:

```shell
cd terraform/aks
```

Then run the following command to initialize Terraform:

```shell
terraform init
```

Then run the following command to validate the Terraform configuration:

```shell
terraform validate
```

Then run the following command to plan the Terraform configuration:

```shell
terraform plan -var gitops_addons_org=https://github.com/azurenoops -var infrastructure_provider=crossplane 
```

Then run the following command to apply the Terraform configuration:

```shell
terraform apply --auto-approve
```

<div class="tip" data-title="Tips">

>Note: You can ignore the warnings related to deprecated attributes and invalid kubeconfig path.

</div>

Terraform completed installing the AKS cluster, installing ArgoCD, and configuring ArgoCD to install applications under the gitops/bootstrap/control-plane/addons directory from the git repo.

<details>
<summary>📚 Toggle solution</summary>

```shell
cd terraform/aks
terraform init
terraform validate
terraform plan -var gitops_addons_org=
terraform apply --auto-approve
```

</details>

Now that the AKS cluster is provisioned, you can access the ArgoCD UI to manage the applications deployed on the cluster. This will show you the status of the applications deployed on the cluster and allow you to manage the applications.

## Validate the Cluster is working

To access the AKS cluster, you need to set the KUBECONFIG environment variable to point to the kubeconfig file generated by Terraform.

You can do this by running the following command:

```shell
export KUBECONFIG=<your_path_to_this_repo>/pe-backstage-azure-workshop/terraform//aks/kubeconfig
echo $KUBECONFIG
```

<div class="task" data-title="Task">

> To run the following commands, you will need to have the a bash shell installed on your machine. If you are using Windows, you can use the Windows Subsystem for Linux (WSL) to run the commands.

</div>

To validate that the cluster is working, you can run the following command to get the list of pods running on the cluster:

```shell
kubectl get pods --all-namespaces
```
You should see the following pods running on the cluster:

```shell
NAMESPACE           NAME                                                              READY   STATUS    RESTARTS          AGE
argo-events         argo-events-controller-manager-654f58ccbb-r6z4p                   1/1     Running   0                 46h
argo-rollouts       argo-rollouts-69566b6478-ljn89                                    1/1     Running   0                 46h
argo-rollouts       argo-rollouts-69566b6478-sxr96                                    1/1     Running   0                 46h
argo-workflows      argo-workflows-server-c7cdc656c-ccg5w                             1/1     Running   0                 46h
argo-workflows      argo-workflows-workflow-controller-98d946f85-4vmzg                1/1     Running   0                 46h
argocd              argo-cd-argocd-application-controller-0                           1/1     Running   0                 46h
argocd              argo-cd-argocd-applicationset-controller-677fd74987-7rxw7         1/1     Running   0                 46h
argocd              argo-cd-argocd-dex-server-85f5db5458-sldwc                        1/1     Running   0                 46h
argocd              argo-cd-argocd-notifications-controller-6cf884fb7f-g4j4s          1/1     Running   0                 46h
argocd              argo-cd-argocd-redis-6c766746d8-s8smm                             1/1     Running   0                 46h
argocd              argo-cd-argocd-repo-server-7c96b84946-c9t7d                       1/1     Running   0                 46h
argocd              argo-cd-argocd-server-78498f46f6-f8944                            1/1     Running   0                 46h
crossplane-system   crossplane-6b5b8f9549-pf2qd                                       1/1     Running   0                 20h
crossplane-system   crossplane-rbac-manager-bcddfb7-ljzqj                             1/1     Running   0                 20h
crossplane-system   helm-provider-b4cc4c2c8db3-5764597587-vzkjj                       1/1     Running   0                 46h
crossplane-system   kubernetes-provider-63506a3443e0-555885778d-2mdfm                 1/1     Running   0                 46h
crossplane-system   provider-azure-authorization-f895924437f1-79d9475b6c-69l4j        1/1     Running   0                 46h
crossplane-system   provider-azure-compute-7e421911713b-f89ff4bcd-z4sg6               1/1     Running   0                 46h
crossplane-system   provider-azure-containerregistry-cc0ea28bc72c-5bc6c598df-rcv5v    1/1     Running   0                 46h
crossplane-system   provider-azure-containerservice-ff556ea47e39-6d7c5d5496-vkzll     1/1     Running   0                 46h
crossplane-system   provider-azure-insights-fccb10339123-8578d6b4cf-qkn7b             1/1     Running   0                 46h
crossplane-system   provider-azure-keyvault-ecb17f6d99ee-df474c649-g6rmv              1/1     Running   0                 46h
crossplane-system   provider-azure-managedidentity-2eb78f1d31af-78df94999-7l4nh       1/1     Running   0                 46h
crossplane-system   provider-azure-network-f8cbea533640-5555858556-dfn8k              1/1     Running   0                 46h
crossplane-system   provider-azure-operationalinsights-93f88e54a392-5766bc9754r7wwn   1/1     Running   0                 46h
crossplane-system   provider-azure-resources-b3fb49bf7242-566d5796d6-hbr5w            1/1     Running   0                 46h
crossplane-system   provider-azure-storage-054d1eea44b0-7c9bb4f8d8-gj7ft              1/1     Running   0                 46h
crossplane-system   upbound-provider-family-azure-dde405d96fb8-69b848f6ff-dzsdd       1/1     Running   0                 46h
kube-system         ama-metrics-7c58b86db7-htqmt                                      2/2     Running   160 (8m17s ago)   46h
kube-system         ama-metrics-7c58b86db7-zw6fq                                      2/2     Running   160 (8m17s ago)   46h
kube-system         ama-metrics-ksm-5bd68b9c-5tdpv                                    1/1     Running   0                 46h
kube-system         ama-metrics-node-4mtvs                                            2/2     Running   158 (3m32s ago)   46h
kube-system         ama-metrics-operator-targets-78794c6db8-w8hpt                     2/2     Running   2 (46h ago)       46h
kube-system         azure-ip-masq-agent-mknql                                         1/1     Running   0                 20h
kube-system         azure-npm-hg4jf                                                   1/1     Running   0                 46h
kube-system         azure-wi-webhook-controller-manager-566c779d5c-5ghf5              1/1     Running   0                 46h
kube-system         azure-wi-webhook-controller-manager-566c779d5c-hb8sc              1/1     Running   0                 46h
kube-system         cloud-node-manager-rxg9c                                          1/1     Running   0                 46h
kube-system         coredns-659fcb469c-mbp82                                          1/1     Running   0                 20h
kube-system         coredns-659fcb469c-pqk4p                                          1/1     Running   0                 20h
kube-system         coredns-autoscaler-5d468f7bb5-ppvk2                               1/1     Running   0                 46h
kube-system         csi-azuredisk-node-dfw7s                                          3/3     Running   0                 20h
kube-system         csi-azurefile-node-w84ph                                          3/3     Running   0                 20h
kube-system         konnectivity-agent-698c9ffbb8-r672k                               1/1     Running   0                 46h
kube-system         konnectivity-agent-698c9ffbb8-sxgmp                               1/1     Running   0                 46h
kube-system         kube-proxy-z6ldd                                                  1/1     Running   0                 46h
kube-system         metrics-server-5dfc656944-m5pqd                                   2/2     Running   0                 46h
kube-system         metrics-server-5dfc656944-rm2md                                   2/2     Running   0                 46h
kube-system         retina-agent-pw88n                                                1/1     Running   0                 46h
```

## Accessing the Control Plane Cluster and ArgoCD UI

To access the Control Plane cluster, you will need to configure the kubectl context to point to the AKS cluster.

Then you can run the following command to get the initial admin password and the IP address of the ArgoCD web interface:

```shell
kubectl get secrets argocd-initial-admin-secret -n argocd --template="{{index .data.password | base64decode}}"
```

<div class="tips" data-title="Tips">

> Make sure you copy the password and save it somewhere. You will need it to log in to the ArgoCD UI.

</div>

When you run the above command, you will get the initial admin password for the ArgoCD UI. You can use this password to log in to the ArgoCD UI.

![ArgoCD-login](./assets/lab2-controlplane/argocd-login.png)

Then run the following command to get the IP address of the ArgoCD web interface:

```shell
kubectl get svc -n argocd argo-cd-argocd-server
```

It may take a few minutes for the LoadBalancer to create a public IP for the ArgoCD UI after the Terraform apply. In case something goes wrong and you don't find a public IP, connect to the ArgoCD server doing a port forward with kubectl and access the UI on https://localhost:8080.

```shell
kubectl port-forward svc/argocd-server -n argocd 8080:443
```

You can now access the ArgoCD UI using the IP address and the initial admin password.

![ArgoCD-dashboard](./assets/lab2-controlplane/argocd-dashboard.png)



<div class="tip" data-title="Tips">

>Note: You can ignore the warnings related to deprecated attributes and invalid kubeconfig path.

</div>

<details>
<summary>📚 Toggle solution</summary>

```shell
az aks get-credentials --resource-group <your resource group> --name <your aks cluster name>
az aks browse --resource-group <your resource group> --name <your aks cluster name>
```

</details>

Now that you have access to the ArgoCD UI, you can manage the applications deployed on the cluster. Next, let's build out paved path templates to be used in Backstage.

# Module 4 - Lab 3 - Building Paved Paths with Backstage

In this lab, we will discuss how to implement paved paths in Backstage. Paved paths are predefined paths that provide a set of best practices and configurations for specific types of applications.

Paved paths can be used to create new projects based on predefined templates. These templates can include configuration files, code snippets, and other resources that help developers get started quickly with a new project.

## Add GitHub Catalog Integration

The GitHub integration has a discovery provider for discovering catalog entities within a GitHub organization. The provider will crawl the GitHub organization and register entities matching the configured path. This can be useful as an alternative to static locations or manually adding things to the catalog. This is the preferred method for ingesting entities into the catalog.

 This can be done by adding the **@backstage/plugin-catalog-backend-module-github** package to your backend.

### Installation

The package is not installed by default, therefore you have to add **@backstage/plugin-catalog-backend-module-github** to your backend package.

Run the following command from your **Backstage root directory**:

```typescript
yarn --cwd packages/backend add @backstage/plugin-catalog-backend-module-github
```

Next add the basic configuration to the **app-config.yaml** file:

```yaml
catalog:
  providers:
    github:
      # the provider ID can be any camelCase string
      providerId:
        organization: '<Your Org Name>' # string
        catalogPath: '/catalog-info.yaml' # string
        filters:
          branch: 'main' # string
          repository: '.*' # Regex
        schedule: # same options as in SchedulerServiceTaskScheduleDefinition
          # supports cron, ISO duration, "human duration" as used in code
          frequency: { minutes: 30 }
          # supports ISO duration, "human duration" as used in code
          timeout: { minutes: 3 }
      customProviderId:
        organization: 'new-org' # string
        catalogPath: '/custom/path/catalog-info.yaml' # string
        filters: # optional filters
          branch: 'develop' # optional string
          repository: '.*' # optional Regex
      wildcardProviderId:
        organization: 'new-org' # string
        catalogPath: '/groups/**/*.yaml' # this will search all folders for files that end in .yaml
        filters: # optional filters
          branch: 'develop' # optional string
          repository: '.*' # optional Regex
      topicProviderId:
        organization: 'backstage' # string
        catalogPath: '/catalog-info.yaml' # string
        filters:
          branch: 'main' # string
          repository: '.*' # Regex
          topic: 'backstage-exclude' # optional string
      topicFilterProviderId:
        organization: 'backstage' # string
        catalogPath: '/catalog-info.yaml' # string
        filters:
          branch: 'main' # string
          repository: '.*' # Regex
          topic:
            include: ['backstage-include'] # optional array of strings
            exclude: ['experiments'] # optional array of strings
      validateLocationsExist:
        organization: 'backstage' # string
        catalogPath: '/catalog-info.yaml' # string
        filters:
          branch: 'main' # string
          repository: '.*' # Regex
        validateLocationsExist: true # optional boolean
      visibilityProviderId:
        organization: 'backstage' # string
        catalogPath: '/catalog-info.yaml' # string
        filters:
          visibility:
            - public
            - internal
      enterpriseProviderId:
        host: ghe.example.net
        organization: 'backstage' # string
        catalogPath: '/catalog-info.yaml' # string
```

<div class="task" data-title="Task">

> For large organizations, this plugin can take a long time, so be careful setting low frequency / timeouts and importing a large amount of users / groups for the first try.

> The configuration above is a basic configuration for the Microsoft Graph API. You can find more information about the configuration in the [Backstage documentation](https://backstage.io/docs/features/software-catalog/catalog-integrations#microsoft-graph).

</div>

Finally, updated your backend by adding the following line in **packages/backend/src/index.ts**:

```typescript
backend.add(import('@backstage/plugin-catalog-backend-module-github'));
```

## Step 2 - Add GitHub Integration to Backstage

 


## Implementing Paved Paths in Backstage

In Backstage, paved paths can be implemented using the scaffolder plugin. The scaffolder plugin allows you to create templates for different types of applications and generate new projects based on those templates.

To implement paved paths in Backstage, you can create a new template in the `examples/template` directory. The template should include all the necessary configuration and best practices for a specific type of application.

You can then use the scaffolder plugin to generate new projects based on the template. The scaffolder plugin will create a new project in the `packages` directory with all the necessary configuration and best practices.

# Module 5 - Lab 4 - Everything as Code

In this lab, we will show you how to use Everything as Code in Backstage. **Everything as Code** is a concept that allows you to define your infrastructure, configuration, and application code in a declarative way using code.

We will be doing a couple of things in this lab:

1. Define Infrastructure as Code for deployment of Backstage on Azure
2. Define Configuration as Code for the management of Backstage configuration
3. Define Documentation as Code for the management of Backstage documentation

## Step 1 - Deploying Backstage to AKS with Infrastructure as Code

In this step, we will define the infrastructure as code for the deployment of Backstage on Azure. We will use Terraform to define the infrastructure as code.

We will use the docker file that comes with the Backstage app to create a Docker image and deploy it to Azure. We will then create a Kubernetes cluster on Azure and deploy the Docker image to the cluster.

### Create a New VS Code Project

Create a new VS Code project in the root directory of your Backstage project.

Add the following files to the project to start defining the infrastructure as code:

- `main.tf`: The main Terraform configuration file
- `variables.tf`: The Terraform variables file
- `outputs.tf`: The Terraform outputs file

### Create a Terraform Configuration File

Create a new Terraform configuration file named `main.tf` in the root directory of your Backstage project. Add the following code to the file:

```hcl
provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "example" {
  name     = "example-resources"
  location = "East US"
}
```

This code defines an Azure resource group named `example-resources` in the `East US` region.



# Module 6 - Lab 5 - Self-Service Infrastructure

# Closing the workshop

Once you're done with this lab you can delete the resource group you created at the beginning.

To do so, click on `delete resource group` in the Azure Portal to delete all the resources and audio content at once. The following Az-Cli command can also be used to delete the resource group :

```bash
# Delete the resource group with all the resources
az group delete --name <resource-group>
```

Also, for security purpose, remove the unused GitHub PAT token in your GitHub account.
