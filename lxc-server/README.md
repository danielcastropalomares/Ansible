This is the example of vars for role:

```
- hosts: testlab
  become: yes
  roles:
     - { role: lxc-server, lxc_addr: 10.0.3.1, lxc_netmask: 255.255.255.0, lxc_network: 10.0.3.0/24, lxc_dhcprange: '10.0.3.100,10.0.3.200' }
```
