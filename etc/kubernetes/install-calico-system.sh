#!/bin/bash -e
/usr/bin/curl -H "Content-Type: application/json" -XPOST -d @"/srv/kubernetes/manifests/calico-system.json" "http://127.0.0.1:8080/api/v1/namespaces"

/usr/bin/curl -H "Content-Type: application/json" -XPOST \
    -d @"/srv/kubernetes/manifests/network-policy.json" \
    "http://127.0.0.1:8080/apis/extensions/v1beta1/namespaces/default/thirdpartyresources"

#/usr/bin/cp /srv/kubernetes/manifests/calico-policy-agent.yaml /etc/kubernetes/manifests