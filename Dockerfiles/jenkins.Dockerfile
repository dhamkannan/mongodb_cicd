FROM jenkins/jenkins:latest
MAINTAINER Dhamodharakannan

# Set proxy settings
COPY src/environment /etc/environment
ENV http_proxy=http://proxysrv:8080
ENV https_proxy=https://proxysrv:8080
ENV no_proxy=".mylan.local,.domain1.com,host1,host2,.mongonetwork,control,gitlab,jenkins"

# Change to root user
USER root

#Install ansible package
RUN apt-get update -y && \
    apt-get install -y python-pip sshpass sudo apache2 net-tools createrepo vim && \
    echo "jenkins  ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/jenkins
RUN pip install ansible

COPY src/mongo/4.2.0 /var/www/html/repo/mongodb/4.2.0
COPY src/mongo/4.2.1 /var/www/html/repo/mongodb/4.2.1
COPY src/mongo/4.2.2 /var/www/html/repo/mongodb/4.2.2
RUN createrepo /var/www/html/repo/mongodb/4.2.0 && \
    createrepo /var/www/html/repo/mongodb/4.2.1 && \
    createrepo /var/www/html/repo/mongodb/4.2.2 && \
    service apache2 start

# Change back to jenkins user
USER jenkins

# Change proxy settings for jenkins
COPY src/environment /etc/environment
ENV http_proxy=proxysrv:8080
ENV https_proxy=proxysrv:8080
ENV no_proxy=".mylan.local,.domain1.com,host1,host2,.mongonetwork,control,gitlab,jenkins"


# Install jenkins plugins
COPY src/plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/ref/plugins.txt