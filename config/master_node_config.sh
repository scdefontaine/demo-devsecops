

kubeadm init --pod-network-cidr=192.168.0.0/16
# export master node to environment variable

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# install node network - calico
kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml
