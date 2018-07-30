How to use this role:

List of variables:

* htaccess_name: name of htaccess copied to  /etc/apache2/conf-available/
* htpasswd_path: path to copy htpasswd
* htaccess_user: user defined for htpasswd (default user: admin)
* htaccess_pw: password defined for htpasswd (default pw: htaccess)

Example:

```
- hosts: zabbix
  become: yes
  roles:
     - {role: htaccess_name: weathermap, htpasswd_path: /var/www/html/weathermap }
```
