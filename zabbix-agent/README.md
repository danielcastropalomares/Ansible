# Ejemplo
Como utilizar en el skeleton este playbook:

Tenemos que declarar dos variables, una sera la IP del servidor de Zabbix y la segunda el tipo de sistema que es (Linux):

```
---
- hosts: client01 
  roles:
     - minimal-system 
     - { role : zabbix-agent, zabbix_server_host: IP, os_client: Linux }
```
