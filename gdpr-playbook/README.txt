### Created by AAAM EU L3 #####

This playbook distributes Splunk universal forwarder and OSSEC IDS software to all nodes in dha2

General overview

1 - Playbook 

name - splunk-forward-and-ossec.yml

This is the general playbook ( it does not contain any task.. ) , changes can be made only to:

remote_user - the user with which ansible is running on the remote host
hosts       - the actual hosts on which this playbook will run ( make sure that you have such group created in /etc/ansible/hosts )
server_ip   - this is the IP of the gdpr splunk server

2 -  plays directory
This is the directory containing the actual plays for the playbook
at the moment there are 2 plays created:

forwarder.yml - this file contains the tasks for splunk universal forwarder installation
ossec.yml     - this file contains the tasks for OSSEC-hids installation and configuration

3 - conf-files directory
It contains the template configuration files for splunk universal forwarder

inputs.conf   - contains the monitoring configuration for the forwarder ( what to monitor )
outputs.conf  - contains details about the remote splunk server to which the forwarder will report

4 -  splunk-forwarder directory
It contains the actual splunk forwarder package that will be copied and installed on the nodes
( the package is in rpm format so the instance must be redhat based )

Notes:
1 - User which will be used to run the playbook must have sudo privileges on the remote server
2 - At the moment the playbook will run with user: ansible
3 - If you change the index which will collect all events make sure that there is such created in the central splunk server
4 - For any clarifications write to: victor.georgiev@accenture.com

