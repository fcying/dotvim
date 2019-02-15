docker-machine start default

docker-machine ssh default "echo 'kill $(more /var/run/udhcpc.eth1.pid)' | sudo tee /var/lib/boot2docker/bootsync.sh"
docker-machine ssh default "echo 'ifconfig eth1 192.168.99.50 netmask 255.255.255.0 broadcast 192.168.99.255 up' | sudo tee -a /var/lib/boot2docker/bootsync.sh"

docker-machine restart
docker-machine regenerate-certs -f

docker-machine restart && docker-machine env