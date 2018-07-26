How to use this role

This roles is designated for install weathermap and connect to Zabbix via php-weathermap-zabbix-plugin:

https://github.com/amousset/php-weathermap-zabbix-plugin/archive/

The parameters:
```
zabx_username: Admin
zabx_pw: zabbix
zabx_url: http://{{ ansible_host }}/zabbix
zabx_api_url: http://{{ ansible_host }}/zabbix/api_jsonrpc.php 
```
Example:

```

- hosts: zabbix
  become: yes
  roles:
     - { role: weathermap, zabx_username: weathermap, zabx_pw: zabbix }
```

This playbook include:
* Download and install weathermap version 0.98
* Enable editor web on editor.php 
* Copy custom icons
* Download and install php-weathermap-zabbix-plugin
* Install php-curl, apache2 and php

After installation, it's important create a new user on Zabbix with permisions read only. Is not recomandable use the user Admin for security.

