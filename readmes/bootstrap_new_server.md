# Starting a new web server

## Prerequisites

### EC2 instance

I recommended using a t2.small. It should be associated with an Elastic IP.

The instance security group should expose 22, 443, 80, and 30000-32000


### DNS records
Add an A record for your domain and each relevant subdomain. Without this, we can't generate TLS certificates.

### Secrets
Add your .env file(s) for each service to the `secrets/` directory (if applicable). The name of the file should match the name of the service (for instance, `services/my-service.yml` and `secrets/my-service.env`).


## Bootstrap server using Ansible (recommended)
```
cd ansible
ansible-playbook playbooks/bootstrap.yml -i inventory --private-key=path/to/key
ansible-playbook playbooks/harden_server.yml -i inventory --private-key=path/to/key
ansible-playbook playbooks/copy_secrets.yml -i inventory --private-key=path/to/key
ansible-playbook playbooks/start_services.yml -i inventory --private-key=path/to/key
ansible-playbook playbooks/generate_certs.yml -i inventory --private-key=path/to/key
```