### Kubernetes HA cluster setup with kubeadm on premise
### Reference: 
### https://kubernetes.io/docs/setup/independent/high-availability/
### https://kubernetes.io/docs/setup/independent/setup-ha-etcd-with-kubeadm/

Roles and playbook are created for ubuntu ONLY for the moment ( tested on ubuntu 18.04 - on premise setup)
Infrastructure:
1. External etcd cluster             - 3 nodes (hardcoded)
2. Master nodes for the k8s cluster  - 2 nodes (hardcoded)
3. HaProxy LB for the controll plane - 1 node
4. Worker nodes                      - as many as needed, will also run glusterfs cluster

Roles:
1. prereqs            -  Prerequsites for the cluster - docker pkgs, kubernetes etc.
2. local-certs-gen    -  Generating of certificates for etcd cluster
3. etcd-cluster       -  Bootstraping etcd cluster
4. ha-proxy           -  LB configuration for the k8s controll plane
5. master-bootstrap   -  Bootstraping of the first k8s master node (certificates generation)
6. add-masters        -  Add the remaining masters to the controll plane and CNI install (weave hardcoded for now)
7. add-workers        -  Add workers to the cluster 
8. glusterfs-storage  -  Create glusterfs cluster with all worker nodes (heketi will be deployed in the cluster)
9. post-install-tasks -  Install helm on the master along with prometheus,grafana, weave-scope and heketi deployment to manage persistent storage

Dependencies:
As the system is ubuntu ansible will be needed , as well as python-minimal package (python2.7)
All roles are running as user ansible for better security , so such user must be created on the deploy host and 
ssh key pair generated and distributed accross all machines.

Notes: 
* Upgrade your system and disable apparmor,(ufw will be replaced with firewalld)
* firewalld playbook is included to add rich rules for internal communication between nodes
* For more than 2 masters add additional backend server definition in haproxy template as well as such variable in hosts file
  example haproxy.cfg template:
  server kube-master2 {{ master3_ip }}:6443 fall 3 rise 2
  hosts
  [all:vars]
  ....
  master1_ip=...
  master2_ip=...
  master3_ip=<IP>
* Heketi deployment to manage glusterfs nodes will run on the master in kube-system namespace.
* For weave-scope UI either create ingress rule, expose the service as nodeport ,or use kubectl port-forward/proxy on port 4040
* Keepalived is installed along with haproxy for HA for virtual IP "lb_ip" is specified ,make sure that the actual IP of the haproxy node is different (there will be HA if another node with haproxy and keepalived is added manually, config files for both services can be modified in the templates directory for the role)
* --ignore-preflight-errors=all is added to roles mater-bootstrap, add-masters, add-workers  because of the latest docker version used
  if you want you can check the docker version installed in prereqs role
  
  
Variables that needs to be changed in hosts file:
[all:vars]
* etcd0=10.0.11.160                ### IP address of 1st etcd node
* etcd1=10.0.11.161                ### IP address of 2nd etcd node
* etcd2=10.0.11.162                ### IP address of 3rd etcd node
* etcd0_host=etcd1                 ### Hostname of 1st etcd node
* etcd1_host=etcd2                 ### Hostname of 2nd etcd node
* etcd2_host=etcd3                 ### Hostname of 3rd etcd node
* lb_name=10.0.11.155              ### Name for the LB  , IP address can be used too
* lb_ip=10.0.11.155                ### IP address of the LB
* pod_cidr=10.244.0.0/16           ### Cidr range for the pods - for the moment weave CNI is hardcoded
* master1_ip=10.0.11.150           ### IP address of the 1st master node
* master2_ip=10.0.11.151           ### IP address of the 2nd master node
* master_ip=10.0.11.150            ### IP address of any of the master nodes ( used for HA proxy and workers add roles )
* heketi_cluster_size=5            ### As many as your worker nodes


To be added later:
* elk stack with fluentbit for container and cluster log aggregation
* deployment mechanism for applications running in k8s
