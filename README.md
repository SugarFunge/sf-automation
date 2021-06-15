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
2. This guide has only been tested locally.
3. Compatible with: Ubuntu (focal).

## Terraform

1. [Install Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli)
2. [Install Docker](https://docs.docker.com/get-docker)
3. Run the LocalStack docker-compose
```
$ cd localstack
$ docker-compose up
```
4. Edit terraform/ec2.tf to include your public key. It should be like the text below. Replace **(valid ssh-rsa key)** with your key.
```
resource "aws_key_pair" "user1" {
  key_name   = "user1"
  public_key = "(valid ssh-rsa key)"
}
```
5. Install the dependencies and apply the Terraform infrastructure
```
$ cd terraform
$ terraform init
$ terraform apply
```
5. After Terraform finishes you will see a new inventory.ini in your ansible directory with the IPs from the new EC2 instances. The instances created by LocalStack are only for testing purpouses so you can't ssh/interact with them.

**WARNING:**
1. This guide works locally with LocalStack and it was tested only with it. If you want to configure for AWS, edit the provider.tf

## TO-DO

- [ ] Integrate the database configuration from Terraform to Ansible for the Hasura API (0%)
- [ ] Create: AWS IaC with Terraform (80%)
- [ ] Test: AWS with Terraform (0%)
- [ ] Test: AWS with Ansible (0%)
- [ ] Create: Azure IaC with Terraform (0%)
- [ ] Test: Azure with Terraform (0%)
- [ ] Test: Azure with Ansible (0%)
- [ ] Create: GCP IaC with Terraform (0%)
- [ ] Test: GCP with Terraform (0%)
- [ ] Test: GCP with Ansible (0%)
- [ ] Include more distro support for the Ansible playbooks (0%)