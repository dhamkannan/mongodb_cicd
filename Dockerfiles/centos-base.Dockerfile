FROM centos:7
MAINTAINER Dhamodharakannan

ENV container docker
ENV http_proxy=http://proxysrv:8080
ENV https_proxy=https://proxysrv:8080
ENV no_proxy=".mylan.local,.domain1.com,host1,host2,.mongonetwork,control,gitlab,jenkins"

COPY src/environment /etc/environment

RUN yum -y update && \
    yum clean all && \
    yum install -y ncurses sudo net-tools initscripts openssh-server openssh-clients wget git epel-release
RUN yum -y install python-pip systemd; yum clean all; \
    (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == systemd-tmpfiles-setup.service ] || rm -f $i; done); \
    rm -f /lib/systemd/system/multi-user.target.wants/*;\
    rm -f /etc/systemd/system/*.wants/*;\
    rm -f /lib/systemd/system/local-fs.target.wants/*; \
    rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
    rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
    rm -f /lib/systemd/system/basic.target.wants/*;\
    rm -f /lib/systemd/system/anaconda.target.wants/*;
RUN useradd -ms /bin/bash dbadmin && \
    echo "linuxpass" | passwd --stdin dbadmin && \
    echo "dbadmin  ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/dbadmin

VOLUME [ "/sys/fs/cgroup" ]

CMD ["/usr/sbin/init"]