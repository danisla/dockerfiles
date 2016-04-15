FROM centos:5

ENV PATH=${PATH}:/usr/local/rvm/bin LANG=en_US.utf8
ENV RUBY_VERSION=1.8.7
ENV RUBYGEMS_VERSION=1.6.2

RUN \
    yum update && yum install -y sudo curl which && \
    sed -i --posix -e '/Defaults.*env_reset\|requiretty/ s/^#*/#/' /etc/sudoers && \
    echo 'Defaults    secure_path = /sbin:/bin:/usr/sbin:/usr/bin:/usr/local/rvm/bin' >> /etc/sudoers && \
    curl -L https://get.rvm.io | sudo bash -s stable && \
    rvm install ${RUBY_VERSION} --default && \
    rvm rubygems ${RUBYGEMS_VERSION} --force && \
    rvm cleanup all && \
    yum remove -y patch libyaml-devel glibc-headers autoconf gcc-c++ glibc-devel patch readline-devel zlib-devel libffi-devel openssl-devel make bzip2 automake libtool bison sqlite-devel && \
    yum clean all
