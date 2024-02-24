FROM redhat/ubi8:latest
LABEL Author="sajal.shres@gmail.com"

# Update CA certificates
COPY ./certs/* /etc/pki/ca-trust/source/anchors/
RUN update-ca-trust extract

# Install ca-certificates, adjust yum repos, and install packages
RUN yum -y update && \
    yum -y install ca-certificates && \
    update-ca-trust force-enable && \
    curl -fsSL https://repo.saltproject.io/salt/py3/redhat/8/x86_64/latest.repo | tee /etc/yum.repos.d/salt.repo && \
    yum install -y virt-what salt-minion && \
    yum clean all && \
    rm -rf /var/cache/yum

RUN sed -i "s|#master: salt|master: salt-master|g" /etc/salt/minion

ENTRYPOINT ["salt-minion", "-l", "debug"]
