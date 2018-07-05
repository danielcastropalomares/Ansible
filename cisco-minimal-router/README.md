Ejemplo de como configurar el skeleton:
```
---
- hosts: routers
  #network_os: ios 
  connection: network_cli
  become: yes
  become_method: yes
  roles:
     - { role:  cisco-minimal-router, ntp_server: 52.166.120.77, comunity_server: TesT10, NET_MGMT1: 1.1.1.1 0.0.0.0,  NET_MGMT2: 2.2.2.2 0.0.0.0,NET_MGMT3: 10.10.10.0 0.0.0.255 } 
```
Variables:

* ntp_server: servidor NTP a configurar
* comunity_server: comunidad SNMP a configurar
* NET_MGMT1: IPs desde donde se aceptaran las conexiones SSH y SNMP, es importante especificar siempre la wildard.
* NET_MGMT2: IPs desde donde se aceptaran las conexiones SSH y SNMP, es importante especificar siempre la wildard.
* NET_MGMT3: IPs desde donde se aceptaran las conexiones SSH y SNMP, es importante especificar siempre la wildard.

Es mandatory rellenar los 3 campos de MGMT, aunque solo se administre desde una IP. Repetirla en NET_MGMT2 y NET_MGMT3 
Ejemplo de como configurar el host:
```
[routers]
HUB01 ansible_host=10.10.10.2 ansible_user=ansible ansible_ssh_pass=test10 ansible_network_os=ios

```

