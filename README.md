# DANGER: WIP - SugarFunge Automation

## Ansible

1. [Install Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)
2. Config the playbook variables.
3. Create the inventory file (inventory.ini) and config them in each playbook linked to the main playbook (main.yml). If the file is missing, it will use localhost.
4. Run the main playbook using the inventory file. (--ask-become-pass will ask for the sudo password in order to execute the playbooks without issues)
```
$ ansible-playbook -i ansible/inventory.ini  ansible/playbooks/main.yml --ask-become-pass 
```

**WARNING:**
1. It is recommended to run the playbooks individually if you want to test them locally since they're designed to be run in different hosts so the ports and nginx sites configuration might collide.
2. Compatible with: Ubuntu (focal).

## Terraform

**WARNING:** Running terraform will overwrite the files: ansible/inventory.ini and ansible/playbooks/vars/nginx_main.yml

### LocalStack

1. [Install Docker](https://docs.docker.com/get-docker)
2. Run the LocalStack docker-compose
```
$ cd localstack
$ docker-compose up
```
4. Create a **keys.tf** file with the following contents:
```
resource "aws_key_pair" "sugarfunge_key" {
  key_name   = "sugarfunge_key"
  public_key = "valid OpenSSH public key here"
}
```
3. Install the dependencies and apply the Terraform infrastructure.
```
$ cd terraform
$ docker-compose run --rm tf init
$ docker-compose run --rm tf apply
```
6. After Terraform finishes you will see a new inventory.ini in your ansible directory with the IPs from the new EC2 instances. The instances created by LocalStack are only for testing purpouses so you can not interact with them.

### AWS

1. [Install Docker](https://docs.docker.com/get-docker)
2. Edit the file provider.tf:
```
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = "YOUR-REGION-HERE"
}
```
3. (Optional) Create an AWS Key Pair for the EC2 instances.
4. Install the dependencies and apply the Terraform infrastructure to AWS. If your key name is different than **sugarfunge_key**, change that with your AWS Key Pair name.
```
$ cd terraform
$ docker-compose run --rm tf init
$ docker-compose run --rm tf apply -var="key_name=sugarfunge_key"
```
6. After Terraform finishes you will see a new inventory.ini in your ansible directory with the IPs from the new EC2 instances.

## TO-DO

- [ ] Integrate the database configuration from Terraform to Ansible for the Hasura API (0%)
- [ ] Create: AWS IaC with Terraform (90%)
- [ ] Test: AWS with Terraform (50%)
- [ ] Test: AWS with Ansible (50%)
- [ ] Create: Azure IaC with Terraform (0%)
- [ ] Test: Azure with Terraform (0%)
- [ ] Test: Azure with Ansible (50%)
- [ ] Create: GCP IaC with Terraform (0%)
- [ ] Test: GCP with Terraform (0%)
- [ ] Test: GCP with Ansible (0%)
- [ ] Include more distro support for the Ansible playbooks (0%)