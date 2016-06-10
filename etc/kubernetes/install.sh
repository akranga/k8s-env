#!/bin/bash -xe

SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"

source "/etc/environment"

function render_template() {
  sed -e "s|$private_ipv4|$COREOS_PRIVATE_IPV4|" \ 
      -e "s|$public_ipv4|$COREOS_PUBLIC_IPV4|" \
      -e "s|${ADVERTISE_IP}|$COREOS_PUBLIC_IPV4|" \
      -e "s|${ETCD_ENDPOINTS}|http://$COREOS_PUBLIC_IPV4:2379|" \
      -e "s|${K8S_VER}|$K8S_VER|" \
      -i $1
}

function deploy_to_dir() {
  mkdir -p "$2" | true
  yes | cp -rf "$DIR/$1" "$2"
  render_template "$2/$1"
}

function deploy_manifest() {
  deploy_to_dir "$1" "/etc/kubernetes/manifests"
}

function deploy_service() {
  deploy_to_dir "$1" "/etc/systemd/system"
}

deploy_manifest "kube-apiserver.yaml"
deploy_manifest "kube-proxy.yaml"
deploy_manifest "kube-controller-manager.yaml"
deploy_manifest "kube-scheduler.yaml"
deploy_manifest "policy-agent.yaml"
deploy_service  "calico-node.service"
deploy_to_dir   "10-calico.conf" "/etc/kubernetes/cni/net.d"