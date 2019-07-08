FROM centos:7
LABEL Author="sajal.shres@gmail.com"

RUN yum install -y epel-release && \
    yum install -y http://repo.saltstack.com/yum/redhat/salt-repo-latest-2.el7.noarch.rpm && \
    yum update -y && \
    yum install -y virt-what salt-minion && \
    yum clean all && \
    rm -rf /var/cache/yum

RUN sed -i "s|#master: salt|master: salt-master|g" /etc/salt/minion

#ONBUILD RUN sed -i "s|#id:|id: $MINION_NAME|g" /etc/salt/minion

ENTRYPOINT ["salt-minion", "-l", "debug"]