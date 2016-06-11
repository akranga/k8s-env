#!/bin/bash -e
/usr/bin/curl -H "Content-Type: application/json" -XPOST -d @"/srv/kubernetes/manifests/kube-system.json" "http://127.0.0.1:8080/api/v1/namespaces"

#/usr/bin/curl  -H "Content-Type: application/json" -XPOST \
#    -d @"/srv/kubernetes/manifests/kube-dns-rc.json" \
#    "http://127.0.0.1:8080/api/v1/namespaces/kube-system/replicationcontrollers"

#/usr/bin/curl  -H "Content-Type: application/json" -XPOST \
#    -d @"/srv/kubernetes/manifests/heapster-dc.json" \
#    "http://127.0.0.1:8080/apis/extensions/v1beta1/namespaces/kube-system/deployments"

#for manifest in {kube-dns,heapster}-svc.json;do
#    /usr/bin/curl  -H "Content-Type: application/json" -XPOST \
#        -d @"/srv/kubernetes/manifests/$manifest" \
#        "http://127.0.0.1:8080/api/v1/namespaces/kube-system/services"
#done