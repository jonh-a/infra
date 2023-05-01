# Adding a new service

## Pushing the image to Docker Hub
Create a new image in Docker Hub and push the build using the `latest` tag.

```
docker push username/service:latest
```

## Writing the deployment and service file
Use `scripts/new_service.sh` to generate the relevant Kubernetes file.

Services can be exposed on Kubernetes using ports 30000-32000.

For example, if a service "test" is exposed on port 5000 and will be exposed on port 30020 through Kubernetes, the script can be executed as:
```
scripts/new_service.sh test 5000 30020
```

This will write a new config file to `services/` and append the service and port to `files/services.txt`. This will also update the list of domains in `files/domains.txt`. 

The script will exit if there is a port overlap.


## Running the new service with Ansible (recommended)
With the relevant files updated, commit your changes and push to main. 

If your service requires secrets, you should have your secrets defined as a .env file in `secrets/`. This should match the name of the service (for instance, `services/my-service.yml` and `secrets/my-service.env`). If secrets are used, run the following playbook:
```
ansible-playbook playbooks/copy_secrets.yml -i inventory --private-key=path/to/key
```

Start the services and generate the certs using the two corresponding playbooks.

```
cd ansible
ansible-playbook playbooks/start_services.yml -i inventory --private-key=path/to/key
ansible-playbook playbooks/generate_certs.yml -i inventory --private-key=path/to/key
```


## Running the new service using bash (not recommended)
When SSH'd into the server, use `kc apply -f services/test.yml`, in the case of the service being named test. This will expose the service through the relevant port.

Add a TLS certificate with Certbot like so:
```
sudo certbot --nginx -d test.usingthe.computer --non-interactive --agree-tos -m email@example.com
```

This should update the `/etc/nginx/nginx.conf` and the `/etc/nginx/conf.d/www.usingthe.computer.conf`. 

Reload nginx with `sudo systemctl restart nginx`.