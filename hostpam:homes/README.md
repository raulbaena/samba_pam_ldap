# PAM
## @edt Raul Baena Nocea ASIX M06-ASO Curs 2018-2019

# Execució de la maquina 

docker run --privileged --rm --name host --hostname host --network sambanet  -it raulbaena/hostpam:samba

## Configuracio del client

Hem de configurar l'arxiu pam_mount i afegir una line que permeti muntar sistemas de fitxers cifs.
```
<volume user="*" fstype="cifs" server="smb" path="%(USER)" mountpoint="~/%(USER)"
/>
```
## Exemple del funcionament

[root@host docker]# su - marta

Creating directory '/tmp/home/marta'.

reenter password for pam_mount:

id: cannot find name for group ID 600

[marta@host ~]$ mount -t cifs

//172.19.0.3/marta on /tmp/home/marta/marta type cifs (rw,relatime,vers=default,cache=strict,username=marta,domain=,uid=5003,forceuid,gid=600,forcegid,addr=172.19.0.3,file_mode=0755,dir_mode=0755,soft,nounix,serverino,mapposix,rsize=1048576,wsize=1048576,echo_interval=60,actimeo=1)


[root@host docker]# su - user10

Creating directory '/tmp/home/2asix/user10'.

reenter password for pam_mount:

id: cannot find name for group ID 611

[user10@host ~]$ mount -t cifs

//172.19.0.3/user10 on /tmp/home/2asix/user10/user10 type cifs (rw,relatime,vers=default,cache=strict,username=user10,domain=,uid=7010,forceuid,gid=611,forcegid,addr=172.19.0.3,file_mode=0755,dir_mode=0755,soft,nounix,serverino,mapposix,rsize=1048576,wsize=1048576,echo_interval=60,actimeo=1)

