FROM ubuntu:latest

COPY installation /installation

RUN echo 'root:toor' | chpasswd

RUN /installation/packages.sh

RUN service ssh start

COPY isar-riscv /isar-riscv

EXPOSE 2022
ENTRYPOINT ["/usr/local/bin/init.sh"]
