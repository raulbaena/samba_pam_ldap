# Practica SAMBA HOMES

## ARQUITECTURA

Disposem de un servidor ldap en el qual es connectará un servidor samba que sera capaç de exportar els directoris homes dels usuaris. Per poder fer les proves del funcionament dels servidors disposem d'un host configurat amb connexió PAM y LDAP. Tots aquests equips pertanyen a la meteixa xarxa una xarxa anomenada sambanet

smbhomes:host --> Client confitgurat amb PAM amb connexió LDAP, que monta els homes dels usuaris/as de ldap y locals

smbhomes:samba --> Servidor samba que amb connexió LDAP que comparteix els homes dels usuaris/as

smbhomes:ldapserver --> Servidor ldap amb usuaris/as

sambanet --> Xarxa on estan els equips anteriors

## Implementació 

En aquest disposem de tres maquines que he explicat anteriorment, les quals enxegarem i explicare la implementació que hem de fer per el seu funcionament. Per comneçar crearem la xarxa on estarán les maquines amb la següent comanda:
```
docker network create sambanet
```
Un cop creada aquesta xarxa posarem en martxa servidor LDAP en mode detach. 
```
docker run --rm --name ldap -h ldap --network sambanet -d smbhomes:ldapserver 
```

Comprovem que el nostre servidor estigui en martxa
```
[root@i12 samba:homes]# docker ps
CONTAINER ID        IMAGE                 COMMAND                  CREATED             STATUS              PORTS               NAMES
602dba162d4a        smbhomes:ldapserver   "/opt/docker/startup…"   5 seconds ago       Up 4 seconds        389/tcp             ldap
```
Ja tenim el nostre servidor LDAP en funcinament. Entxegarem el nostre servidor samba amb la següent comanda: 
```
docker run --rm --name samba -h samba --privileged --network sambanet -it smbhomes:samba
```
Ara comprovem si el nostre servidor samba tingui comunicació amb el servidor LDAP
```
getent passwd
```
Ja tenim comunicació entre els nostres servidors

Ara executarem el nostre client amb la següent comanda
```
docker run --rm --name host -h host --privileged --network sambanet -it smbhomes:host 
```
Un cop executada la maquina comprovem que tengui connexió amb el nostre servidor LDAP
```
getent passwd
```
Ja tenim tot configurat. Ara toca comprovar el funcionament de tota la nostra infraestructura

## Troubleshooting

En aquesta proba hem de ser capaç de connectar-nos amb l'usuari de LDAP pere y que ens monti automaticament el home de aquest usuari.
Un cop executat el docker client y que estiguem dintre ens conectem amb un usuari local
```
[root@host docker]# su - local01
```
Ja connectats amb l'usuaria local ens connectem com a Pere
```
[local01@host ~]$ su - pere
pam_mount password:
Creating directory '/tmp/home/pere'.
[pere@host ~]$ 
```
Ara comprovem que tot estigui ben montat
```
[pere@host ~]$ mount -t cifs
//samba/pere on /tmp/home/pere/pere type cifs (rw,relatime,vers=default,cache=strict,username=pere,domain=,uid=5001,forceuid,gid=5050,forcegid,addr=172.19.0.3,file_mode=0755,dir_mode=0755,soft,nounix,serverino,mapposix,rsize=1048576,wsize=1048576,echo_interval=60,actimeo=1)
```







