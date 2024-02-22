# TOS-Terraform-VM


##  Objectif

L'objectif de ce TOS est de déployer via Terraform une machine virtuelle dans le cloud Azure de Microsoft.

# Azure CLI

## 1) Installation d'Azure CLI

Dans un premier temps, nous devons installer Azure CLI afin de pouvoir communiquer avec Azure.

- Windows: `Invoke-WebRequest -Uri https://aka.ms/installazurecliwindows -OutFile .\AzureCLI.msi; Start-Process msiexec.exe -Wait -ArgumentList '/I AzureCLI.msi /quiet'; rm .\AzureCLI.msi`
- MacOS: `brew update && brew install azure-cli`

## 2) Configuration d'Azure CLI

Nous devons nous authentifier dans Azure CLI: `az login`

Ensuite, nous devons spécifier à AzureCLI sur quel abonnement, nous souhaitons travailler : `az account set --subscription "35akss-subscription-id"`

## 3) Création d'un principal de service

Nous tapons cette commande : `az ad sp create-for-rbac --role="Contributor" --scopes="/subscriptions/<SUBSCRIPTION_ID>"`

Cette commande nous retourne différentes choses qu'il faut spécifier en variables d'environnement:

```
export ARM_CLIENT_ID="<APPID_VALUE>"
export ARM_CLIENT_SECRET="<PASSWORD_VALUE>"
export ARM_SUBSCRIPTION_ID="<SUBSCRIPTION_ID>"
export ARM_TENANT_ID="<TENANT_VALUE>"
```
Ce role permettra à Terraform d'accéder à la subscription pour pouvoir déployer des ressources. 

# Terraform

Le fichier main.tf permet de créer les différentes ressources qui sont prérequis avant de créer la machine virtuelle. 

- La 1 ère ressource est un groupe de ressource du nom de test-TG et situé en Europe du Nord
- La 2 ème est un virtual network avec comme cidr 10.0.0.0/16 et un premier subnet 10.0.5.0/24.
- La 3 ème est une ip publique en IPV4
- La 4 ème est une interface réseau utilisant l'adresse IP publique
- La dernière est la machine virtuelle de type Debian 12. Celle-ci contient différentes options comme l'user, le mot de passe et la création 'un disque de 30 gb. 

Etapes pour déployer le fichier:

1 - `terraform init` => pour initialiser terraform
2 - `terraform fmt` => pour valider l'indentation du fichier
3 - `terraform validate` => pour valider la config du fichier
4 - `terraform apply` => pour tout déployer


# Suite


Naviguant sur les vastes mers du cloud, si vous souhaitez découvrir les secrets cachés de votre VM, hissez les voiles et préparez-vous à définir le cap avec le groupe de sécurité réseau (NSG). Ce précieux NSG trace la route vers votre île au trésor, en ouvrant le chemin à travers les vagues tumultueuses du réseau pour permettre l'accès SSH (port 22), tel un équipage bravant les tempêtes pour atteindre des horizons inexplorés.
🏴‍☠️
