#!/bin/bash

user=$1
group=$1

/bin/echo "Copy config to user $user"
/bin/mkdir -p /home/$user/.kube
/bin/cat /root/.kube/config > /home/$user/.kube/config
/bin/chown -R $user:$group /home/$user/.kube
/bin/chmod 600 /home/$user/.kube/config