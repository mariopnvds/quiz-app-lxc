user=$(whoami)
if [ $user != 'root' ]; then
  echo "El programa ha de ejecutarse como root"
  exit
fi

echo "Borrando contenedores..."
echo "Borrando contenedores nagios"
lxc delete nagios1 --force
echo "Borrando contenedores firewall"
lxc delete firewall1 --force
echo "Borrando contenedores loadbalancer"
lxc delete loadbalancer1 --force
echo "Borrando contenedores webserver"
lxc delete webserver1 --force
lxc delete webserver2 --force
lxc delete webserver3 --force
lxc delete webserver4 --force # este estara presente si hemos decidido crear el cuarto servidor desde un inicio
lxc delete webserver-cpy1 --force # este estara presente si hemos decidido crear el cuarto servidor en caliente
echo "Borrando contenedores storage"
lxc delete storage1 --force
lxc delete storage2 --force
lxc delete storage3 --force
echo "Borrando contenedores database"
lxc delete database1 --force
lxc delete database2 --force # esta estara presente si hemos pasado la plantilla con replicacion en base de datos

echo "Desconectando interfaces de red"
sudo ifconfig intra-lan0 down
sudo ifconfig intra-lan1 down
sudo ifconfig intra-lan2 down
sudo ifconfig intra-mgmt down

echo "Borrando bridges"
sudo brctl delbr intra-lan0
sudo brctl delbr intra-lan1
sudo brctl delbr intra-lan2
sudo brctl delbr intra-mgmt

echo "Borrando ficheros intermedios"
rm ../scripts/lxc-py-* 

echo "Desinstalacion completada"
