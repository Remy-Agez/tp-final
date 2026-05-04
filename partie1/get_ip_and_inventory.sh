#!/bin/bash

IP=$(ssh -i ~/.vagrant_key -o StrictHostKeyChecking=no -p 22 vagrant@192.168.56.10 "ip a show eth1 | grep 'inet ' | awk '{print \$2}' | cut -d'/' -f1")

echo "IP récupérée : $IP"

cat > ~/tp-final/partie1/inventory.ini <<EOF
[k3s]
vm-k3s ansible_host=$IP ansible_port=22 ansible_user=vagrant ansible_ssh_private_key_file=~/.vagrant_key ansible_ssh_common_args='-o StrictHostKeyChecking=no'
EOF

echo "Inventaire généré !"
cat ~/tp-final/partie1/inventory.ini
