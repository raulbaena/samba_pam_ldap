#! /bin/bash
#@edt ASIX M06 2018-2019
#CREAR Y ENCENDER slapd con edt.org
#-----------------------------------
/opt/docker/install.sh && echo "Install OK"
/sbin/slapd -d0 && echo "slapd ok"
