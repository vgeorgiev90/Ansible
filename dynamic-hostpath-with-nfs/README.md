## Dynamically provision nfs shared for kubernetes workers hostPath mounts
Workflow:
1. Create lvm physical volume, volume group and logical volume
2. Create file system on the new lv and mount it locally 
3. Export the filesystem with nfs to specific worker
4. Mount the exported share on the worker for hostPath based k8s pod volumes

Prereqs:
* Ansible installed, nfs-server node , Ubuntu OS, user ansible on the system and distributed key pair for it

Usage:
* run.sh gen-vars    ---    To generate some variables for ansible this creates file in hosts/ dir for multiple provisions
* run.sh vginit <File> present/absent  ---  Create the volume group base based on the vars file generated
* run.sh volume <File> present/absent  ---  Create the logical volume,make file system, export with nfs and mount it on specified worker 
  
Notes:
* For volume creation: 1) generate vars, 2) vginit <File> present, 3) volume <File> present
* For volume deletion: 1) volume <File> absent, 2) vginit <File> absent  

ToDO:
* Implement nfs security
* Test it on a large scale
* Think of volume redundancy and HA
