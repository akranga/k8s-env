#!/bin/bash -xe

SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"


manifests_dir="/etc/kubernetes/manifests"

source "/etc/environment"

function render_template() {
  sed -e "s|$private_ipv4|$COREOS_PRIVATE_IPV4|" \ 
      -e "s|$public_ipv4|$COREOS_PUBLIC_IPV4|" \
      -e "s|$K8S_VER|$K8S_VER|" \
      -i $1
}

function deploy_manifest {
  yes | cp -rf "$DIR/$1" "$manifests_dir"
  render_template "$manifests_dir/$1"
}

mkdir -p "$manifests_dir"

deploy_manifest "kube-apiserver.yaml"