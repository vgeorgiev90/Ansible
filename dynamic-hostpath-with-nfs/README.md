## Dynamically provision nfs shared for kubernetes workers hostPath mounts
Prereqs:
* Ansible to be installed , Ubuntu OS, user ansible on the system and distributed key pair for it

Usage:
* run.sh gen-vars    ---    To generate some variables for ansible 
this creates file in hosts/ dir for multiple provisions
* run.sh vginit <File> present  ---  Create the volume group base based on the vars file generated
present/absent for create or delete
* run.sh volume <File> present  ---  Create the logical volume,make file system, export with nfs and mount it on specified worker node , present/absent for create or delete

