# Apply changes to a service

After the new image is pushed to Docker Hub, the deployment needs to be restarted. As long as `imagePullPolicy` is set to `Always` for the given container, the latest image will be pulled.

To restart a specific service, run the `restart_deployments.yml` playbook with the `--extra-vars` flag set for `service`. For example:
```
$ cd ansible
$ ansible-playbook playbooks/restart_deployments.yml -i inventory --private-key=~/path/to/key -e "service=service_name"
```

To restart all services, run the `restart_deployments.yml` playbook with no extra vars.
```
$ cd ansible
$ ansible-playbook playbooks/restart_deployments.yml -i inventory --private-key=~/path/to/key
```
