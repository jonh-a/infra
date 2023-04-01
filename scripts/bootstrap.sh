#!/bin/bash

domains=agn.usingthe.computer,color-guesser.usingthe.computer

install_deps() {
  apt update
  apt install curl git vim nginx -y
}

install_k8s() {
  snap install microk8s --classic --channel=1.26
  usermod -a -G microk8s ubuntu
  chown -f -R ubuntu ~/.kube
}

enable_nginx() {
  sudo systemctl enable --now nginx
}

install_zsh() {
  apt install zsh -y
  chsh -s /usr/bin/zsh ubuntu
  su ubuntu -c 'sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"'
}

install_postgres() {
  apt install postgresql postgresql-contrib -y
  systemctl enable postgresql.service --now
  sed -i '/^local\s\+all\s\+postgres/s/peer/trust/' /etc/postgresql/14/main/pg_hba.conf
  echo "host    all             all             0.0.0.0/0               md5" | tee -a /etc/postgresql/14/main/pg_hba.conf
  systemctl restart postgresql
}

update_zshrc() {
  echo "alias kc=\"microk8s kubectl\"" >> ~/.zshrc
  source ~/.zshrc
}

generate_certificate() {
  snap install --classic certbot
  ln -s /snap/bin/certbot /usr/bin/certbot
  sudo certbot --nginx -d $domains --non-interactive --agree-tos -m admin@usingthe.computer
}

generate_self_signed_certificate() {
  openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/nginx/ssl/example.key -out /etc/nginx/ssl/example.crt
}

install_deps
install_zsh
install_k8s
install_postgres
update_zshrc