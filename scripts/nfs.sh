dir=/nfs
ip=192.168.0.0/24

sudo mkdir -fp $dir
sudo chown nobody:nogroup $dir
sudo echo "$dir $ip(rw,sync,no_subtree_check)" >> /etc/exports
sudo service nfs-kernel-server restart
