# SAMBA

## Aitor Galilea@edt ASIX M06 2018-2019
Las imágenes se encuentran en el Dockerhub de [Aitor Galilea](https://hub.docker.com/u/ClRDAN/), los archivos para generar dichas imágenes están en [este](https://github.com/ClRDAN/sambahomes) repositorio de github.

### Descripción general:
Práctica de integración de las tecnologías PAM, LDAP y SAMBA. En esta parte creamos un servidor SAMBA capaz de conectar a un servidor LDAP y exportar directorios HOME de usuarios locales y LDAP. Para ello necesitamos un servidor LDAP (el mismo usado en prácticas anteriores), un servidor SAMBA y un cliente con LDAP y PAM configurados

### Pasos seguidos:
   La configuración del servidor está automatizada mediante el Dockerfile y los scripts startup.sh e install.sh. Estos son los pasos que llevan a cabo.
* Generamos una imagen en la que instalamos los paquetes samba samba-client cifs-utils vim less openldap-clients nss-pam-ldapd passwd authconfig.
* Creamos la configuración de SAMBA (/etc/samba/smb.conf)
* Configuramos la conexión al servidor LDAP (authconfig)
* Arrancamos los servicios SAMBA y LDAP (nslcd, nscd, smbd y nmbd)
* Creamos los usuarios SAMBA, los directorios que se van a compartir y les asignamos los permisos adecuados.

   En el cliente:
* Instalamos los paquetes samba-client (para poder acceder a los shares de SAMBA), pam_mount y cifs-utils (para poder montar los HOMES desde SAMBA) y openldap-clients nss-pam-ldapd authconfig para configurar la conexión a LDAP.  
* Modificamos el archivo de configuración /etc/nsswitch.conf para que el sistema resuelva los nombres con LDAP además de /etc/passwd y /etc/groups.
* creamos usuarios locales
* Creamos un archivo /etc/pam.d/system-auth.edt con la configuración de módulos PAM que permita el login a usuarios LDAP y les monte sus HOMES al iniciar sesión, y hacemos que el symlink /etc/pam.d/system-auth apunte a nuestra configuración.
* Modificamos el archivo /etc/security/pam_mount.conf.xml para que al usar el módulo pam_mount en system-auth se automonte el HOME del usuario desde el servidor SAMBA.
* Configuramos la conexión a LDAP mediante la herramienta authconfig.
* Arrancamos los daemon nscd y nslcd, necesarios para la comunicación con LDAP.

### Imágenes:
* **agalilea/sambahome** Servidor SAMBA *shares* que comparte los homes de usuarios LDAP y locales. Archivos para generar la imagen en 
* **agalilea/sambaclient** Máquina cliente
* **agalilea/ldap** Servidor LDAP

#### Ejecución

```
docker run --rm --network sambanet --name ldap --hostname ldap -d agalilea/ldap
docker run --rm --network sambanet --name samba --hostname samba -it agalilea/sambahome
docker run --rm --network sambanet --privileged --name client  -hostname client -it agalilea/sambaclient 
```
