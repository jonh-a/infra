# Starting a new web server

## Spin up a new EC2 instance
- Instance type: t2.small
- Associated with an Elastic IP
- Security group should expose 22, 443, 80, and 30000-32000

## DNS
Add an A record for your domain and each relevant subdomain. Without this, we can't generate TLS certificates.

## Bootstrap server using Ansible (recommended)
```
cd ansible
ansible-playbook playbooks/bootstrap.yml -i inventory --private-key=path/to/key
ansible-playbook playbooks/start_services.yml -i inventory --private-key=path/to/key
ansible-playbook playbooks/generate_certs.yml -i inventory --private-key=path/to/key
```