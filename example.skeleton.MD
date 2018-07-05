# Ejemplo
Cada uno puede organizar los skeleton como crea mas conveniente, yo prefiero organizarlos por cliente/ubicación, puede que me equivoque, pero para mi es la forma mas clara para organizar los hosts:
```
---
- hosts: client01 
  roles:
     - minimal-system 
     - { role : zabbix-agent, zabbix_server_host: type_IP_Zabbix_server, os_client: Linux }
- hosts: type_IP_remote_macine
  roles:
     - { role : zabbix-proxy, zabbix_server_host: type_IP_Zabbix_server, database_type: pgsql, database_type_long: postgresql }

```
