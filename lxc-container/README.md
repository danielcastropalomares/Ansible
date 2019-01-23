This is the example of vars for role

```
- hosts: testlab
  become: yes
  roles:
     - lxc-container
  vars:
     lxc_containers:
        - { hostname: container01, ip: 10.0.3.10 }
```

The LXCSERVER is the jumperhost, example hosts file: 
```
[testlab]
lxcserver01 ansible_host=x.x.x.x
[testlab-lxc]
container01 ansible_host=y.y.y.y

[testlab-lxc:vars]
ansible_ssh_common_args='-o ProxyCommand="ssh -W %h:%p -q root@x.x.x.x"'
```
