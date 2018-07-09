Variables a  utilizar:

Por defecto, los directorios a realizar backup son:
```
/etc /home /usr/local /root
```

En caso de a√adir alguno mas, hay que indicar los directorio anterior + el nuevo a√dir. Ejemplo:

```
---
- hosts: ieaisa-oficina 
    - { role : backupninja, directory_bck: /etc /home /usr/local /root /var/lib/rancid/ }

```

