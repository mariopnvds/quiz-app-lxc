#!/bin/bash

# root user check

user=$(whoami)
if [ $user != 'root' ]; then
  echo "El programa ha de ejecutarse como root"
  exit
fi

# dependencies check

echo "[******].Se hace un control de dependencias"

ntools=$(dpkg-query -W -f='${Status}' net-tools 2>/dev/null | grep -c "ok installed")
if [ $ntools = 0 ]; then
  echo "[******]..Se instalan las net-tools para poder manejar las interfaces de red"
  sudo apt install -y net-tools
fi;
echo "[******]..net-tools ya instalado"

bctl=$(dpkg-query -W -f='${Status}' bridge-utils 2>/dev/null | grep -c "ok installed")
if [ $bctl = 0 ]; then
  echo "[******]..Se instala bridge-utils para poder levantar bridges virtuales"
  sudo apt install -y bridge-utils
fi
echo "[******]..bridge-utils ya instalado"

# python pakcages check

echo "[******].Se hace un control de paquetes python"

if python -c 'import pkgutil; exit(not pkgutil.find_loader("pybrctl"))'; then
    echo '[******]..Paquete de python pybrctl ya instalado'
else
    echo '[******]..Se instala el paquete de python: pybrctl'
    pip install pybrctl
fi

if python -c 'import pkgutil; exit(not pkgutil.find_loader("yaml"))'; then
    echo '[******]..Paquete de python yaml ya instalado'
else
    echo '[******]..Se instala el paquete de python: yaml'
    pip install pyyaml
fi

# primero se crea el contenedor de monitoreo para poder habilitar monitorizacion en resto
python ./lxc-setup.py ../templates/management/nagios-cfg.json
# se crea el firewall, que hará NAt y filtro de paquetes
python ./lxc-setup.py ../templates/firewall/firewall-cfg.json
# se crea el balanceador, que distribuira la carga entre 4 webservers, comprobando si estan activos
python ./lxc-setup.py ../templates/loadbalancer/loadbalancer-cfg.json
# se crea el conjunto de bases de datos con replica maestra/esclavo
python ./lxc-setup.py ../templates/database/database-upgrade-cfg.json
# se crea el cluster de almacenamiento NAS replicado mediante glusterfs
python ./lxc-setup.py ../templates/storage/storage-cfg.json
# por ultimo, creamos los contenedores con las aplicaciones web
python ./lxc-setup.py ../templates/webapp/webserver-cfg.json
