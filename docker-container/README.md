Example how to use this role:

```
  roles:
    - docker-container
  vars:
     docker_containers:
        - name: rancid-test01
          ports: 3443:443 
          image: ansible-container-rancid-web:99999999
          volumes:
             /tmp/test10:/var/lib/rancid/
          env:
             RANCID_GROUPS: "routers"
```
