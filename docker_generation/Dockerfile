FROM ubuntu:latest
#FROM nvidia/cuda:11.0-base
#FROM nvidia/cuda:11.6.0-devel-ubuntu20.04

COPY installation /installation
#COPY libraries /libraries
#RUN ls -l /

RUN echo 'root:toor' | chpasswd

RUN /installation/packages.sh EDDL

RUN service ssh start

# COPY init.sh /usr/local/bin/
# RUN chmod u+x /usr/local/bin/init.sh
EXPOSE 2022
ENTRYPOINT ["/usr/local/bin/init.sh"]
#CMD ["/usr/sbin/sshd", "-D"]
