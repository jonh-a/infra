# Infrastructure
This mess of a repo contains some scripts and tools useful for spinning up a MicroK8s cluster using a web server and exposing the various services over HTTPS using Nginx. This is a slightly more cost-effective way to mess around with Kubernetes when compared to managed Kubernetes. 

## Prerequisites
Requires nothing more than an EC2 instance (t2.small running Ubuntu seems to be sufficient) and a domain name. A static IP is recommended.

## Instructions
- [Spin up an EC2 instance](https://github.com/jonh-a/infra/blob/main/readmes/bootstrap_new_server.md)
- [Add a new service](https://github.com/jonh-a/infra/blob/main/readmes/new_service.md)