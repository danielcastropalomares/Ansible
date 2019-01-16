Ejemplo de como configurar el skeleton:
```
---
- hosts: routers
  #network_os: ios 
  connection: network_cli
  become: yes
  become_method: yes
  roles:
     - { role:  cisco-minimal-router, ntp_server: 52.166.120.77, comunity_server: TesT10 } 
```
Variables:

* ntp_server: servidor NTP a configurar
* comunity_server: comunidad SNMP a configurar

Ejemplo de como configurar el host:
```
[routers]
HUB01 ansible_host=10.10.10.2 ansible_user=ansible ansible_ssh_pass=test10 ansible_network_os=ios

```

