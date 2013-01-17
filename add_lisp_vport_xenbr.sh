#lispconf -a cache -e 192.168.127.2/32 -r 10.32.164.178 -p 1 -w 100 -t 10

ovs-vsctl add-port xenbr0 lisp0 -- set Interface lisp0 type=lisp options:remote_ip=10.32.164.178

DOM=`xe vm-list name-label=Server params=dom-id | sed '/^dom-id ( RO)    : */!d; s///;q'`
VM_PORT=`ovs-ofctl dump-ports xenbr0 vif${DOM}.0 | sed '/^  port */!d; s///; /:.*/!d; s///;q'`
LISP_PORT=`ovs-ofctl dump-ports xenbr0 lisp0 | sed '/^  port */!d; s///; /:.*/!d; s///;q'`

ovs-ofctl add-flow xenbr0 priority=2,in_port=${VM_PORT},dl_type=0x0806,action=NORMAL
ovs-ofctl add-flow xenbr0 priority=1,in_port=${VM_PORT},dl_type=0x0800,vlan_tci=0,nw_src=192.168.127.0/24,action=output:${LISP_PORT}

ovs-ofctl show xenbr0
ovs-ofctl dump-flows xenbr0
