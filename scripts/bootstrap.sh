#!/bin/bash

install_deps() {,test.usingthe.computer,test.usingthe.computer
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

start_services() {
  git clone https://github.com/jonh-a/infra.git

  for f in $(ls infra/services); do
    kc apply -f infra/services/$f
  done
}

install_deps
install_zsh
install_k8s
install_postgres
update_zshrc
start_services
enable_nginx