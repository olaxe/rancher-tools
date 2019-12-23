#!/bin/sh
# Cleanup previous installation of Rancher 2, Kubernetes
# Run it using this: curl -s https://raw.githubusercontent.com/olaxe/tools/master/rancher2/scripts/cleanup.sh | source /dev/stdin
# Works well on Ubuntu 16.04 LTS and 18.04 LTS

docker rm -f $(docker ps -qa)
docker rmi -f $(docker images -q)
docker volume rm $(docker volume ls -q)
for mount in $(mount | grep tmpfs | grep '/var/lib/kubelet' | awk '{ print $3 }') /var/lib/kubelet /var/lib/rancher /opt/rancher; do umount $mount; done
cleanupdirs="/etc/ceph /etc/cni /etc/kubernetes /opt/cni /opt/rancher /opt/rke /run/secrets/kubernetes.io /run/calico /run/flannel /var/lib/calico /var/lib/etcd /var/lib/cni /var/lib/kubelet /var/lib/rancher /var/log/containers /var/log/pods /var/run/calico"
for dir in $cleanupdirs; do
  echo "Removing $dir"
  sudo rm -rf $dir
done
echo "Check if there is some docker containers remaining"
docker ps -a
echo "Check if the service docker is working well"
service docker status
echo "Docker information:"
docker info
