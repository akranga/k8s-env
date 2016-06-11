#!/bin/bash -xe

SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"

source "/etc/environment"
source "/etc/flannel/options.env"

function render_template() {
  sed -e "s|\${K8S_VER}|$K8S_VER|" \
      -e "s|\${ETCD_ENDPOINTS}|http://$COREOS_PRIVATE_IPV4:2380|" \
      -e "s|\${ADVERTISE_IP}|$COREOS_PUBLIC_IPV4|" \
      -e "s|\$private_ipv4|$COREOS_PRIVATE_IPV4|" \
      -e "s|\$public_ipv4|$COREOS_PUBLIC_IPV4|" \
      -i $1
}

function wait_for_url() {
  echo wait for $1 be up and running
  until $(curl --output /dev/null --silent --head --fail $1); do
    printf '.'
    sleep 5
  done
}

function create_namespace() {
  curl -H "Content-Type: application/json" -XPOST -d'{"apiVersion":"v1","kind":"Namespace","metadata":{"name":"$1"}}' "http://127.0.0.1:8080/api/v1/namespaces"
}

function deploy_to_dir() {
  mkdir -p "$2" | true
  yes | cp -rf "$DIR/$1" "$2"
  render_template "$2/$1"
}

function deploy_manifest() {
  deploy_to_dir "$1" "/etc/kubernetes/manifests"
}

function deploy_script() {
  deploy_to_dir "$1" "/opt/bin"
  chmod 755 "/opt/bin/$1"
}

function deploy_service() {
  deploy_to_dir "$1" "/etc/systemd/system"
}

systemctl stop kubelet

#sleep 10

curl -X PUT -d "value={\"Network\":\"$POD_NETWORK\",\"Backend\":{\"Type\":\"vxlan\"}}" "http://$COREOS_PRIVATE_IPV4:2379/v2/keys/coreos.com/network/config"

deploy_manifest "kube-apiserver.yaml"
deploy_manifest "kube-proxy.yaml"
deploy_manifest "kube-controller-manager.yaml"
deploy_manifest "kube-scheduler.yaml"
deploy_manifest "policy-agent.yaml"
deploy_service  "calico-node.service"
deploy_to_dir   "10-calico.conf" "/etc/kubernetes/cni/net.d"

deploy_script   "install-kube-system.sh"

systemctl daemon-reload
systemctl start kubelet

wait_for_url "http://127.0.0.1:8080/version"

create_namespace "kube-system"
create_namespace "calico-system"
curl -H "Content-Type: application/json" -XPOST http://127.0.0.1:8080/apis/extensions/v1beta1/namespaces/default/thirdpartyresources --data-binary @- <<BODY
{
  "kind": "ThirdPartyResource",
  "apiVersion": "extensions/v1beta1",
  "metadata": {
    "name": "network-policy.net.alpha.kubernetes.io"
  },
  "description": "Specification for a network isolation policy",
  "versions": [
    {
      "name": "v1alpha1"
    }
  ]
}
BODY

# systemctl start calico-node