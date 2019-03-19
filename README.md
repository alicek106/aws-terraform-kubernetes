## Simplified Kubernetes Initiator in AWS

This repository is copied from opencredo/k8s-terraform-ansible-sample

> https://github.com/opencredo/k8s-terraform-ansible-sample



## What should I change to create kubernetes cluster?

- 0-aws.tf
  - **ACCESS_KEY**
  - **SECRET_KEY**
- variables.tf
  - **default_keypair_public_key** (as existing or new public key)
  - **region** and **amis** (optional)
