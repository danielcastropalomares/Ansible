How to use this role

This role install the next packages:
* rancid
* cvsweb
* apache2


And include:
* link icons cvsweb
* enable module cgi of apache2
* install and configure CVSWEB
* enable cron.d for rancid

The parameters
```
rancid_groups: switchs routers madrid bcn
```

Example use:

```
---
- hosts: zabbix
  become: yes
  roles:
     - { role: rancid, rancid_groups: switchs routers }
     - { role: htaccess, htaccess_name: rancid, htpasswd_path: /var/lib/rancid/CVS }
```
