#!/bin/sh
yes | yum install -y gcc libffi-devel krb5-devel openssl-devel
yes | yum install device-mapper-devel wget git python3 python3-devel
wget https://rpmfind.net/linux/fedora-secondary/releases/33/Everything/s390x/os/Packages/b/btrfs-progs-5.7-5.fc33.s390x.rpm
rpm -i btrfs-progs-5.7-5.fc33.s390x.rpm
wget https://rpmfind.net/linux/fedora-secondary/releases/33/Everything/s390x/os/Packages/l/libbtrfs-5.7-5.fc33.s390x.rpm
rpm -i libbtrfs-5.7-5.fc33.s390x.rpm
wget https://rpmfind.net/linux/fedora-secondary/releases/33/Everything/s390x/os/Packages/l/libbtrfsutil-5.7-5.fc33.s390x.rpm
rpm -i libbtrfsutil-5.7-5.fc33.s390x.rpm
wget https://rpmfind.net/linux/fedora-secondary/releases/33/Everything/s390x/os/Packages/b/btrfs-progs-devel-5.7-5.fc33.s390x.rpm
rpm -i btrfs-progs-devel-5.7-5.fc33.s390x.rpm
yes | dnf install https://download.docker.com/linux/rhel/7/s390x/stable/Packages/containerd.io-1.4.3-3.1.el7.s390x.rpm
yes | dnf config-manager --add-repo=https://download.docker.com/linux/rhel/docker-ce.repo
yes | dnf install -y docker-ce
systemctl start docker
cat >> /etc/docker/daemon.json << EOT
{ 
 "insecure-registries" : ["registry-proxy.engineering.redhat.com"] 
}
EOT
systemctl restart docker
yes | yum install golang
go get github.com/openshift/source-to-image/cmd/s2i
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin
cd ${GOPATH}/src/github.com/openshift/source-to-image
hack/build-go.sh
yes | cp _output/local/bin/linux/s390x/s2i $GOPATH/bin
cp $GOPATH/bin/s2i /usr/bin/
pip3 install -U pip
pip3 install virtualenv
virtualenv ~/cekit
source ~/cekit/bin/activate
pip3 install cekit odcs docker-py behave --use-feature=2020-resolver
STATIC_DEPS=true pip3 install lxml
# Creates a directory to store the test logs
if [ ! -d "~/test-results" ]
then
  mkdir ~/test-results
fi
