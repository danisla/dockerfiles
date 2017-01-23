FROM centos:7

RUN \
  yum install -y rsync sudo && \
  yum clean all

COPY init.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/init.sh

ENV USERID 500
ENV GROUPID 100

ENTRYPOINT ["/usr/local/bin/init.sh"]
CMD ["rsync"]
