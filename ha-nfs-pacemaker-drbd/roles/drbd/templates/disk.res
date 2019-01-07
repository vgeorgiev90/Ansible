resource nfs {
  protocol C;
  device /dev/drbd0;
  disk /dev/drbd/replicated;
  meta-disk internal;
  on {{ node1 }} {
  address {{ ip1 }}:7788;
  }
  on {{ node2 }} {
  address {{ ip2 }}:7788;
  }
}
