## Simplified Kubernetes Initiator in AWS

This repository is copied from opencredo/k8s-terraform-ansible-sample

> https://github.com/opencredo/k8s-terraform-ansible-sample



## What should I change to create kubernetes cluster?

- Environment Variables
  - export **ACCESS_KEY**=...
  - export **SECRET_KEY**=...
- variables.tf
  - **default_keypair_public_key** (as existing or new public key)
  - **region** and **amis** (optional)
- directory **keys**
  - Put your **Public / Private key** here. Keys are refered by **variables.tf**



## Initializing Infrastructure in AWS

#### Terraform

1. ``` $ cd terraform ``` 
2. ```$ terraform init```
3. ```$ terraform apply ```

#### Ansible

1. ``` cd ../ansible ```
2. ``` ansible-playbook --private-key ../keys/${PRIVATE_KEY_FILE_NAME} infra.yaml```
