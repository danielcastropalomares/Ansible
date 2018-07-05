# ansible
## Instalación

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

Este repositorio esta destinado a subir los playbooks obtenidos de https://galaxy.ansible.com/ y modificados por mi añadiendo algunas configuraciones adicionales.


Comandos utiles:

Ejecutar playbook solo para grupos definidos en el hosts:

```
ansible-playbook minimal_system.yml -l [group]
```

Ejecutar playbook solo para un host en concreto y la primera vez, importante de habilitar el root a nivel del SSH 

```
ansible-playbook --limit [IP] --ask-pass minimal_system.yml
```
Ejecutar comando en todos los equipos:

```
ansible all -a "/bin/echo hello"
```

# Editor para vim

Descargamos el plug vim para poder instalar el plugin: 

```
curl -fLo ~/.vim/autoload/plug.vim --create-dirs     https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
```

En nuestro fichero .vimrc añadimos las siguientes lineas:

```
.vim/vimrc 
	" Specify a directory for plugins
	call plug#begin('~/.vim/plugged')

	Plug 'pearofducks/ansible-vim'
	" Initialize plugin system
	call plug#end()
	set tabstop=4
	set expandtab
	set shiftwidth=3
	set background=dark
```


Ahora abrimos vim, y tecleamos:

```
:PlugInstall
```
