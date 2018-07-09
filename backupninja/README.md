Variables a  utilizar:

Por defecto, los directorios a realizar backup son:
```
/etc /home /usr/local /root
```

En caso de añadir alguno mas, hay que indicar los directorio anterior + el nuevo añadir. Ejemplo:

```
---
- hosts: TEST01
    - { role : backupninja, directory_bck: /etc /home /usr/local /root /var/lib/rancid/ }

```

