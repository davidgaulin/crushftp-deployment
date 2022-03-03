FROM registry.access.redhat.com/ubi8/openjdk-11

COPY CrushFTP9.zip  /tmp/
ADD setup.sh /home/jboss/setup.sh
USER root
RUN microdnf update && microdnf install procps
RUN cp /etc/passwd /home/jboss/passwd
RUN cat /home/jboss/passwd
RUN chmod 777 /home/jboss /home/jboss/passwd
ENTRYPOINT [ "/bin/bash", "/home/jboss/setup.sh" ]

EXPOSE 21 443 2222 8080 8888 9022 9090
