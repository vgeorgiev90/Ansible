#!/bin/bash


help() {
   clear
   echo "If the playbooks will run for first time , generate variables vile with ./run-playbooks new-vars"
   echo ""
   echo "new-vars    --->  Generate vairables file for the playbooks"
   echo "kdc-server  --->  Install kdc server"
   echo "firewall    --->  Add necessary firewall rules"
   echo "nfs         --->  Install krb5 nfs shares"
   echo "client      --->  Install krb5 clients"
   echo "iscsi-target--->  Install ISCSI target"
   echo "run-all     --->  Run all playbooks"
   echo ""
}


case "${1}" in
'new-vars')
## Gather variables for the playbooks
echo "realm_caps variable: "
read REALM_CAPS
echo "realm variable:"
read REALM
echo "kdc_server variable:"
read KDC_SERVER
echo "kdb_password variable:"
read -s KDC_PASSWORD
echo "admin_pass variable:"
read -s ADMIN_PASS
echo "user_principle variable:"
read USER
echo "nfs_server variable:"
read NFS
echo "servers_network variable:"
read NETWORK
echo "block_device variable:"
read BLOCK
echo "iqn_name variable:"
read IQN
echo "iscsi_user variable:"
read USER
echo "iscsi_pass variable:"
read PASS 


## Write variables to the vars file
echo "---" > vars/variables.yml
echo "realm_caps: ${REALM_CAPS}" >> vars/variables.yml
echo "realm: ${REALM}" >> vars/variables.yml
echo "kdc_server: ${KDC_SERVER}" >> vars/variables.yml
echo "kdb_password: ${KDC_PASSWORD}" >> vars/variables.yml
echo "admin_pass: ${ADMIN_PASS}" >> vars/variables.yml
echo "user_principle: ${USER}" >> vars/variables.yml
echo "nfs_server: ${NFS}" >> vars/variables.yml
echo "servers_network: ${NETWORK}" >> vars/variables.yml
echo "block_device: ${BLOCK}" >> vars/variables.yml
echo "iqn_name: ${IQN}" >> vars/variables.yml
echo "iscsi_user: ${USER}" >> vars/variables.yml
echo "iscsi_pass: ${PASS}" >> vars/variables.yml
;;
'kdc-server')
   ansible-playbook krb5-server.yml
   ;;
'firewall')
   ansible-playbook firewalld.yml
   ;;
'nfs')
   ansible-playbook krb5-nfs-workstation.yml
   ;;
'iscsi-target')
   ansible-playbook iscsi-target.yml
   ;;
'client')
   ansible-playbook krb5-client.yml
   ;;
'run-all')
   ansible-playbook krb5-server.yml
   ansible-playbook firewalld.yml
   ansible-playbook krb5-nfs-workstation.yml
   ansible-playbook krb5-client.yml
   ;;
'help') help;;
*) help;;
esac

