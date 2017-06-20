FROM danisla/gotty:latest

COPY bootstrap.sh /usr/local/bin/bootstrap.sh

COPY packages.txt /opt/cloudshell/packages.txt

RUN /usr/local/bin/bootstrap.sh

COPY init.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/init.sh

COPY cloudshell_profile /etc/profile.d/cloudshell

ENV UNAME cloudshell
ENV USERID 500
ENV GROUPID 100

ENTRYPOINT ["/usr/local/bin/init.sh"]

CMD ["/gotty","-p", "9000", "-w", "tmux", "new", "-A", "-s", "bash"]