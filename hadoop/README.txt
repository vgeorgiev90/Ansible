Modify the user and host groups in both playbooks


Location for hadoop config files template (hadoop_templates)
modify core-site.xml to change the hostname of the hadoop master server
<value>hdfs://hadoop-master:9000</value>

hdfs-site.xml - modify the path for hadoop file system

 <name>dfs.namenode.name.dir</name>
 <name>dfs.datanode.data.dir</name>

Modify dfs repliucation with the total number of you work nodes 
<name>dfs.replication</name>

Modify yarn-site.xml to set the correct set name
<name>yarn.resourcemanager.hostname</name>


After bot hadoop server and nodes are setup

- Format the hdfs file system
hdfs namenode -format

- Manage hdfs

start-dfs.sh
stop-dfs.sh
hdfs dfsadmin -report

- Manage Yarn
start-yarn.sh
stop-yarn.sh

yarn nodes -list

- Check the java processes
jps

If everything is correct you should see something smilliar in master node
1480 SecondaryNameNode
2168 Jps
1257 NameNode
1756 ResourceManager

and on the worker nodes
20928 Jps
20810 NodeManager
20684 DataNode


