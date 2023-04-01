#!/bin/bash

# get directory of script
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

domains=$(cat "$DIR/../files/domains.txt")

generate_certificate() {
  snap install --classic certbot
  ln -s /snap/bin/certbot /usr/bin/certbot
  sudo certbot --nginx -d $domains --non-interactive --agree-tos -m admin@usingthe.computer
}

restart_nginx() {
  if ! nginx -t; then
    echo "nginx config invalid"
    exit 1
  fi

  systemctl restart nginx
}

generate_certificate
restart_nginx