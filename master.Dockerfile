FROM redhat/ubi8:latest
LABEL Author="sajal.shres@gmail.com"

# Set working directory and create necessary directories
WORKDIR /docker-saltstack
RUN mkdir -p /srv/salt

# Update CA certificates
COPY ./certs/* /etc/pki/ca-trust/source/anchors/
RUN update-ca-trust extract

# # CentOS End-of-life Workaround
# RUN sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-* && \
#     sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-*

# Install ca-certificates, adjust yum repos, and install packages
RUN yum -y update && \
    yum -y install ca-certificates && \
    update-ca-trust force-enable && \
    curl -fsSL https://repo.saltproject.io/salt/py3/redhat/8/x86_64/latest.repo | tee /etc/yum.repos.d/salt.repo && \
    yum install -y virt-what salt-master && \
    yum clean all && \
    rm -rf /var/cache/yum

# Configure Salt Master
RUN mv -f /etc/salt/master /etc/salt/master.backup
COPY files/master /etc/salt/
COPY ./salt /srv/salt

ENTRYPOINT ["salt-master", "-l", "debug"]
