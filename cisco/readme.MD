
Es importante utilizar la ultima versión de Ansible, la que hay disponible en los repositorios de Ubuntu es muy antigua:

```
apt-add-repository ppa:ansible/ansible
apt-get install ansible
```
O en Debian:
```
/etc/apt/sources.list
deb http://ppa.launchpad.net/ansible/ansible/ubuntu trusty main
apt-get update && apt-get install ansible
```

Definimos los parametros de autenticación en el hosts, de momento con el password en texto plano, mas adelante lo encriptaremos:
```
	/etc/ansible/hosts
	[routers]
	ios ansible_host=10.10.10.2 ansible_connection=network_cli ansible_network_os=ios ansible_ssh_pass=test10
```
Modulos de IOS:
https://docs.ansible.com/ansible/latest/modules/list_of_network_modules.html#ios
# Cisco

De momento no funciona correctamente en todas las versiones de IOS la autenticación por keys publicas, asi que para los test utilizare el password en texto plano en el inventory, mas adelante lo encriptaremos:

Para introducir la key tal como pide Cisco, con un limite de caracteres por linea:
```
fold -b -w 72 .ssh/id_rsa.pub
```
Y añadimos la key:
```
ip ssh pubkey-chain
  username ansible
   key-hash ssh-rsa XXXXXXXXXXXXXXXXXXX
```
