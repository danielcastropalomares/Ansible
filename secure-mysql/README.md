Ejemplo de como  utilizar el plyabook en el skeleton:
```
---
- hosts: zabbix
  become: yes
  roles:
     - { role: secure-mysql, mysql_root_password: lkjlkdjf8676 }
```
Fuente: https://github.com/PCextreme/ansible-role-mariadb/blob/master/tasks/mysql_secure_installation.yml
