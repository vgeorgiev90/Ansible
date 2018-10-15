### Kubernetes HA cluster setup on premise
### Reference: 
### https://kubernetes.io/docs/setup/independent/high-availability/
### https://kubernetes.io/docs/setup/independent/setup-ha-etcd-with-kubeadm/

Roles and playbook are created for ubuntu ONLY for the moment ( tested on ubuntu 18.04 - on premise setup)
Infrastructure:
1. External etcd cluster             - 3 nodes (hardcoded)
2. Master nodes for the k8s cluster  - 2 nodes (hardcoded)
3. HaProxy LB for the controll plane - 1 node
4. Worker nodes                      - as many as needed

Roles:
1. prereqs            -  Prerequsites for the cluster - docker pkgs, kubernetes etc.
2. local-certs-gen    -  Generating of certificates for etcd cluster
3. etcd-cluster       -  Bootstraping etcd cluster
4. ha-proxy           -  LB configuration for the k8s controll plane
5. master-bootstrap   -  Bootstraping of the first k8s master node (certificates generation)
6. add-masters        -  Add the remaining masters to the controll plane and CNI install (weave hardcoded for now)
7. add-workers        -  Add workers to the cluster 

Dependencies:
As the system is ubuntu ansible will be needed , as well as python-minimal package (python2.7)
All roles are running as user ansible for better security , so such user must be created on the deploy host and 
ssh key pair generated and distributed accross all machines.
Note: Upgrade your system and disable apparmor,ufw services before start (apt-get upgrade -y;systemctl disable apparmor;systemctl stop apparmor;ufw disable)

To be added later:
* glusterfs backed storage class for dynamic persistent volumes provisioning
* helm package manager for k8s along with tiller deployment for easy installations
* prometheus, grafana for cluster monitoring
* elk stack with fluentbit for container and cluster log aggregation
* deployment mechanism for applications running in k8s
