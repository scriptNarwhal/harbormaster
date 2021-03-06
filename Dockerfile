FROM centos:7
MAINTAINER Elson Rodriguez

RUN yum install -y syslinux dosfstools e2fsprogs parted epel-release createrepo file ed patch envsubst ruby gcc git rpm-build ruby-devel gettext
RUN yum install -y cobbler reprepro

RUN yum install -y perl-LockFile-Simple perl-IO-Compress perl-Compress-Raw-Zlib perl-Digest-MD5 perl-Digest-SHA perl-Net-INET6Glue perl-LWP-Protocol-https 

RUN gem install fpm -v 1.6.1

ADD . /source
RUN chmod +x /source/*.sh
RUN chmod +x /source/cobbler/bin/debmirror

RUN git clone https://github.com/elsonrodriguez/kubernetes-distro-packages.git /source/kubernetes-distro-packages
WORKDIR  /source/kubernetes-distro-packages
#RUN git reset --hard d4be861171e6073f9060da0c86d09aef47a595a3
#RUN git reset --hard 7ee27130aaa3808c2c4bf89e28e3ecd9be26977c
RUN git reset --hard 1783c3b0b35178a438ce5371e2872f9c0da96ab3

ENV ENABLE_PROXY false

ENV K8S_CLEAN_BUILD false
ENV K8S_VERSION 1.3.3
ENV K8S_CLUSTER_IP_RANGE 10.254.0.0/16
ENV K8S_SKYDNS_CLUSTERIP 10.254.0.10

#Pod IP ranges are automatically assigned per node, if a node has IP address 10.100.200.1, that node will have Pods on 10.200.1.0/24. However this variable has to be manually set to that range of all of your nodes for kube-proxy's sake.
ENV K8S_NODE_POD_CIDR 10.200.0.0/16

ENV TIMEZONE America/Los_Angeles
ENV NTP_SERVER pool.ntp.org

#The pattern to match for the root partition on the harbormaster server, see /dev/disk/by-path for examples
ENV ROOT_DISK_PATH_PATTERN ''
ENV ROOT_DISK_PATH_PATTERN_UBUNTU ''

# TODO: grab ip information as a cidr and infer the other variables.
ENV COBBLER_IP 172.16.101.100

ENV NETWORK_GATEWAY 172.16.101.2
ENV NETWORK_DOMAIN harbor0.group.company.com
ENV NETWORK_BOOTP_START 172.16.101.5
ENV NETWORK_BOOTP_END 172.16.101.254
ENV NETWORK_NETMASK 255.255.255.0
ENV NETWORK_SUBNET 172.16.101.0
ENV NETWORK_UPSTREAMDNS 8.8.8.8
ENV NETWORK_DNS_REVERSE 172.16.101

ENV NUM_MASTERS 1

ENV BUILD_DIRECTORY /build
ENV OUTPUT_DIRECTORY /output
ENV OUTPUT_IMAGE_NAME harbormaster.img

ENV CENTOS_ISO_URL http://mirrors.cmich.edu/centos/7/isos/x86_64
ENV CENTOS_ISO_NAME CentOS-7-x86_64-DVD-1511.iso

ENV UBUNTU_ISO_URL http://mirror.pnl.gov/releases/16.04
ENV UBUNTU_ISO_NAME ubuntu-16.04.1-server-amd64.iso

WORKDIR /source

ENTRYPOINT [ "/source/harbormaster-build.sh" ]
