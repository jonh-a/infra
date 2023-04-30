#!/bin/bash

NAME=$1
TARGET_PORT=$2
PORT=$3

# get directory of script
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

if [[ $# -lt 3 ]]; then
  echo "Usage:"
  echo "new_service_file.sh NAME TARGET_PORT PORT"
  echo " - NAME: Service name (eg service-name)"
  echo " - TARGET_PORT: Port exposed by the container (eg 5000)"
  echo " - PORT: Port that will be exposed by Kubernetes (between 30001 and 32000)"
  exit 1
fi

check_for_overlapping_ports() {
  OVERLAP=$(cat "$DIR/../files/services.txt" | grep "$PORT,")
  if [[ $OVERLAP != "" ]]; then
    echo "port $(echo $OVERLAP | cut -d ',' -f 1) overlaps with $(echo $OVERLAP | cut -d ',' -f 2)..."
    echo "exiting"
    exit 1
  fi
}

generate_service_file() {
  # generate new service files to be consumed by kubernetes
  eval "cat <<EOF
$(<$DIR/../files/service.template.yml)
  " > "$DIR/../services/$NAME.yml"

  # generate nginx rules
  eval "cat <<EOF
$(<$DIR/../files/nginx_service.template.conf)
  " >> "$DIR/../files/www.usingthe.computer.conf"

  # add line to files/services.txt
  echo -e ${NEWLINEVAR}$PORT,$NAME | tee -a "$DIR/../files/services.txt"

  # add domain to files/domains.txt
  sed -i '' "1s/$/,$NAME.usingthe.computer/" "$DIR/../files/domains.txt"
}

check_for_overlapping_ports
generate_service_file
