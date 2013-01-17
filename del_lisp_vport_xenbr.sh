DOM=`xe vm-list name-label=Server params=dom-id | sed '/^dom-id ( RO)    : */!d; s///;q'`
VM_PORT=`ovs-ofctl dump-ports xenbr0 vif${DOM}.0 | sed '/^  port */!d; s///; /:.*/!d; s///;q'`

ovs-ofctl del-flows xenbr0 ip,in_port=${VM_PORT},vlan_tci=0x0000,nw_src=192.168.127.0/24
ovs-ofctl del-flows xenbr0 arp,in_port=${VM_PORT}

ovs-vsctl del-port xenbr0 lisp0

ovs-ofctl show xenbr0
ovs-ofctl dump-flows xenbr0
