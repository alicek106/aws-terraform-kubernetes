## Kubernetes Setup using AWS and Terraform

<img src="https://github.com/alicek106/aws-terraform-kubernetes/blob/master/pictures/kube.png?raw=true">

This repository is copied from opencredo/k8s-terraform-ansible-sample, but it didn't consider kubespray.

> https://github.com/opencredo/k8s-terraform-ansible-sample

Also, This repository will create 3 workers, 3 master, and 3 etcd Kubernetes cluster by default. You can adjust the number of each node by changing below **Variables**. 



## Step 1. Install Terraform

1. All steps will be conducted under Docker container for beginners.

   ```
   # docker run -it --name terraform-aws-kube -h terraform-aws-kube ubuntu:16.04
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

7. Create all objects in AWS. It will trigger to create VPC, Subnet, etc.

   ```
   $ terraform apply
   ```



## Step 2. Set Variables in variables.tf 

You can change configuration of file ```variables.tf```, such as the number of each node.

- **number_of_controller** : The number of master nodes that act only as a master role. 
- **number_of_etcd** : The number of etcd nodes that act only as a etcd role. 
- **number_of_controller_etcd** : The number of nodes that run etcd and master **at the same time**.
- **number_of_worker** : The number of workers. 

It is recommended that the number of **[etcd + controller_etcd]**, **[controller + controller_etcd]** to be odd. For example, below setting is desirable and can be converted into inventory as shown below. Note that below inventory and setting is just example, not really written configuration.

```
number_of_controller = 2

number_of_etcd = 2

number_of_controller_etcd = 1
```

.. is same to

```
[kube-master]
Instnace-A # (1st master)
Instnace-B # (2nd master)
Instnace-C # (3rd master)  (1st etcd)

[etcd]
Instnace-C # (3rd master)  (1st etcd)
Instnace-D #               (2nd etcd)
Instnace-E #               (3rd etcd)

[kube-worker]
...

```

[Optional] if you want to change ClusterID, set ```cluster_id_tag``` to another value, not ```alice```.

## Step 3. Ansible and Kubespray

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
   $ ansible-playbook -b --private-key \
     ../keys/tf-kube kubespray-2.8.1/cluster.yml
   ```

## Test

SSH to your master instance, and get nodes.

```
root@aws-kube:/aws-terraform-kubernetes/ansible# ssh -i ../keys/tf-kube ubuntu@<Master IP>
...
Last login: Mon Mar 25 10:03:32 2019 from 13.124.49.60
ubuntu@ip-10-43-0-40:~$ sudo su
root@ip-10-43-0-40:/home/ubuntu# kubectl get nodes
NAME                                            STATUS   ROLES    AGE     VERSION
ip-10-43-0-20.ap-northeast-2.compute.internal   Ready    master   5m2s    v1.12.3
ip-10-43-0-21.ap-northeast-2.compute.internal   Ready    master   6m16s   v1.12.3
ip-10-43-0-30.ap-northeast-2.compute.internal   Ready    node     4m9s    v1.12.3
ip-10-43-0-31.ap-northeast-2.compute.internal   Ready    node     4m4s    v1.12.3
ip-10-43-0-32.ap-northeast-2.compute.internal   Ready    node     4m4s    v1.12.3
ip-10-43-0-40.ap-northeast-2.compute.internal   Ready    master   5m2s    v1.12.3
```



<p align="center"><img src="https://github.com/alicek106/aws-terraform-kubernetes/blob/master/pictures/kube2.png?raw=true" width="570" height="350"></p>

## Cleanup

In terraform directory, use below command. It will destroy all objects, including EC2 Instances

```
$ terraform destroy
```

## Limitations

- It assumes that **master** acts as an **etcd** node. It should be modified to separate **etcd** and **master** role.(solved)
- Health check of master node is impossible using https:6443 in ELB. 
- Node IP range is limited beacuse node IP is allocated between VPC CIDR + 10, 20, 30... etc.  It should be changed if you want to use in production environment.
- Punctuation (.) is compatible with DNS 1123 rule, but it seems it cannot be used in hostname (ignored..)
