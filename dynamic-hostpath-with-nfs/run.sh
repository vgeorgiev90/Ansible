#!/bin/bash


usage () {
  clear
  echo "============================== Usage ================================================"
  echo "      This script is build on top of ansible, make sure you have it installed        "
  echo "     It sets: volume group, logical volume , nfs-export and mount by the worker      "
  echo ""
  echo "run.sh vginit example present/absent ---> Create/Remove volume group from vars file  "
  echo "run.sh volume example present/absent ---> Create/Remove logical volume from vars file"
  echo "run.sh gen-vars                      ---> Generate vars file for ansible to use,     "
  echo "                                          file name to be passed to vginit or volume "
  echo ""
  echo "====================================================================================="
}


if [ "${1}" == 'vginit' ];then
file="${2}"
state="${3}"
case ${state} in
'present')
	ansible-playbook -i hosts/${file} vg-init.yml --extra-vars "state=present"
	;;
'absent')
	ansible-playbook -i hosts/${file} vg-init.yml --extra-vars "state=absent"
	;;
*)
	usage
	;;
esac

elif [ "${1}" == 'volume' ];then
file="${2}"
state="${3}"
case ${state} in
'present')
	ansible-playbook -i hosts/${file} provision.yml --extra-vars "state=present"
	ansible-playbook -i hosts/${file} nfs-export.yml --extra-vars "state=present"
	ansible-playbook -i hosts/${file} workers-mount.yml --extra-vars "state=present"
	;;
'absent')
        ansible-playbook -i hosts/${file} workers-mount.yml --extra-vars "state=absent"
        ansible-playbook -i hosts/${file} nfs-export.yml --extra-vars "state=absent"
        ansible-playbook -i hosts/${file} provision.yml --extra-vars "state=absent"
        ;;
*)
	usage
	;;
esac

elif [ "${1}" == 'gen-vars' ];then
read -p 'Volume group name: ' vg_name
read -p 'Devices for volume group specify list ["/dev/vd1", ..]: ' devices
read -p 'Logical volume name: ' lv_name
read -p 'Logical volume size: ' lv_size
read -p 'File system type: ' fs_type
read -p 'Directory to mount: ' mount_name
read -p 'Worker host IP: ' worker_host
read -p 'Nfs server IP: ' nfs_server
read -p 'Directory on worker: ' work_dir
read -p 'Name for the hosts file: ' file

cat > hosts/${file} << EOF
[nfs-server]
${nfs_server}

[workers]
${worker_host}

[all:vars]
######vg init
vg_name=${vg_name}
devices=${devices}

######lvm provision
lv_name=${lv_name}
vg_name=${vg_name}
lv_size=${lv_size}
fs_type=${fs_type}
mount_name=${mount_name}

#nfs export
worker_host=${worker_host}
nfs_server=${nfs_server}
mount_name=${mount_name}

#worker mount
mount_name=${mount_name}
work_dir=${work_dir}
nfs_server=${nfs_server}
EOF
else
	usage

fi
