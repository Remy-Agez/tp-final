# TP Final DevOps - Rémy Agez

## Prérequis
- VirtualBox
- Vagrant (Windows)
- Ansible
- Docker
- kubectl

## Partie 1 - Infrastructure

### Lancer les VMs
```powershell
cd partie1 && vagrant up
cd partie5 && vagrant up
```

### Récupérer l'IP et générer l'inventaire
```bash
bash partie1/get_ip_and_inventory.sh
```

### Installer k3s
```bash
ansible-playbook -i partie1/inventory.ini partie1/install_k3s.yml
```

## Partie 2 - Conteneurisation

Image Docker disponible sur : `aveeefr/devops_tp_final:latest`

### Builder et pousser l'image
```bash
docker build -t aveeefr/devops_tp_final:latest ./partie2
docker push aveeefr/devops_tp_final:latest
```

## Partie 3 - Déploiement Kubernetes

### Déployer l'API et la base de données
```bash
kubectl apply -f partie3/secret.yaml
kubectl apply -f partie3/mysql.yaml
kubectl apply -f partie3/api.yaml
```

L'API est accessible uniquement depuis l'intérieur du cluster (ClusterIP).
Les données MySQL sont persistantes via un PersistentVolumeClaim de 1Gi.
Le HPA assure entre 1 et 3 replicas selon la charge CPU/mémoire.

## Partie 4 - CI/CD

Pipeline GitHub Actions sur la branche `main` utilisant un runner self-hosted.

### Lancer le runner
```bash
cd ~/actions-runner && ./run.sh
```

La pipeline :
1. Build l'image Docker
2. La pousse sur Docker Hub
3. Configure l'infrastructure
4. Déploie sur Kubernetes

## Partie 5 - Monitoring

### Installer Prometheus, Node Exporter et Grafana
```bash
ansible-playbook -i partie5/inventory.ini partie5/install_monitoring.yml
ansible-playbook -i partie1/inventory.ini partie5/install_node_exporter_k3s.yml
```

### Accéder à Grafana
URL : http://192.168.56.11:3000
Login : admin / admin

Le dashboard Node Exporter Full (ID: 1860) est configuré pour afficher
les métriques des deux VMs (k3s sur 192.168.56.10 et monitoring sur 192.168.56.11).
