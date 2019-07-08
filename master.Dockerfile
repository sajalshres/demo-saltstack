FROM centos:7
LABEL Author="sajal.shres@gmail.com"

RUN mkdir -p /docker-saltstack
RUN mkdir -p /srv/salt
RUN mkdir -p /srv/salt/ext
RUN mkdir -p /srv/salt/ext/pillar
RUN mkdir -p /srv/salt/pillars
RUN mkdir -p /srv/salt/states

WORKDIR /docker-saltstack

RUN yum install -y epel-release && \
    yum install -y http://repo.saltstack.com/yum/redhat/salt-repo-latest-2.el7.noarch.rpm && \
    yum update -y && \
    yum install -y virt-what salt-master && \
    yum clean all && \
    rm -rf /var/cache/yum


RUN mv -f /etc/salt/master /etc/salt/master.backup
ADD files/master  /etc/salt/
ADD files/minions.conf /srv/salt/ext/pillar/
ADD files/minion_config.py /srv/salt/ext/pillar/
ADD files/common.sls /srv/salt/pillars/
ADD files/top.sls /srv/salt/pillars/

#RUN sed -i "s|#auto_accept: False|auto_accept: True|g" /etc/salt/master

ENTRYPOINT ["salt-master", "-l", "debug"]