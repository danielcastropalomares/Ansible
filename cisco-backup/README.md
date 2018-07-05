Ejemplo como configurar el hosts:
```
[routers]
HUB01 ansible_host=10.10.10.2 ansible_user=ansible ansible_ssh_pass=test10 ansible_network_os=ios
```
Ejemplo para skeleton:
```
---
- hosts: routers
  connection: network_cli
  become: yes
  become_method: yes
  roles:
     - cisco-backup
```

Los backups se guardan en 'roles/cisco-backup/backup/HUB01_config.2018-07-05@22\:06\:32' 
