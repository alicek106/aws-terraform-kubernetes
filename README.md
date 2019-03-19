## Kubernetes Quickstart using AWS and Terraform

This repository is copied from opencredo/k8s-terraform-ansible-sample

> https://github.com/opencredo/k8s-terraform-ansible-sample

Also, This repository will create 3 workers with 1 master Kubernetes cluster, by default.



## Variables 

- **3-workers.tf** : The number of workers. Default is set to 3 in ```count```

- **4-controllers.tf** : The number of master. Default is set to 1 in ```count```



## Step 1. Terraform

1. All steps will be conducted under Docker container for beginners.

   ```
   # docker run -it --name test -h aws-kube ubuntu:16.04
   ```

2. Install required packages.

   ```
   $ apt update && apt install git python python-pip unzip wget vim -y && \
       git clone https://github.com/alicek106/aws-terraform-kubernetes.git && \
       cd aws-terraform-kubernetes/terraform
   ```

3. Download terraform binary.

   ```
   $ wget https://releases.hashicorp.com/terraform/0.11.13/terraform_0.11.13_linux_amd64.zip && \
       unzip terraform_0.11.13_linux_amd64.zip && \
       rm terraform_0.11.13_linux_amd64.zip && \
       mv terraform /usr/bin && chmod +x /usr/bin/terraform
   ```

4. Export your own AWS Access / Secret keys

   ```
   $ export AWS_ACCESS_KEY_ID=<Your Access Key in AWS>
   $ export AWS_SECRET_ACCESS_KEY=<Your Access Key in Secret>
   ```

5. Initialize terraform and generate your SSH key pair for aws_key_pair

6. ```
   $ terraform init && ssh-keygen -t rsa -N "" -f ../keys/tf-kube
   ```

6. Create all objects in AWS. It will trigger to create VPC, Subnet, etc.

   ```
   $ terraform apply
   ```



## Step 2. Ansible and Kubespray

1. In ansible directory, install all dependencies package.

   ```
   $ cd ../ansible && pip install -r requirements.txt
   ```

2. Install python related modules using **raw** ansible module to all EC2 instances.

   ```
   $ ansible-playbook --private-key ../keys/tf-kube infra.yaml
   ```

   To check whether it works, use below ansible **ping** module

   ```
   $ ansible --private-key ../keys/tf-kube -m ping all
   ```

3. Download kubespray. You can adjust proper version, but I used v2.8.1 kubespray :D

   ```
   $ wget https://github.com/kubernetes-sigs/kubespray/archive/v2.8.1.zip && \
       unzip v2.8.1.zip && rm v2.8.1.zip
   ```

4. Install Kubernetes. Thats all.

   ```
   $ ansible-playbook -b --private-key ../keys/tf-kube kubespray-2.8.1/cluster.yml
   ```


## Test

SSH to your master instance, and get nodes.

```
root@aws-kube:/aws-terraform-kubernetes/ansible# ssh -i ../keys/tf-kube ubuntu@<Master IP>
...
Last login: Tue Mar 19 06:16:33 2019 from <Master IP>
ubuntu@controller0:~$ sudo su
root@controller0:/home/ubuntu# kubectl get node
NAME          STATUS   ROLES    AGE     VERSION
controller0   Ready    master   3m56s   v1.12.3
worker0       Ready    node     3m16s   v1.12.3
worker1       Ready    node     3m15s   v1.12.3
worker2       Ready    node     3m16s   v1.12.3
```


## Cleanup

In terraform directory, use below command. It will destroy all objects, including EC2 Instances

```
$ terraform destroy
```


## Limitations

- It assumes that **master** acts as an **etcd** node. It should be modified to separate **etcd** and **master** role.
