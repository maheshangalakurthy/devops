ARG PARENT_IMAGE=centos8:1.0
ARG NAME
FROM $PARENT_IMAGE
LABEL name="filebeat" \
        organization="devops" \
        unit="Docker for filebeat" \
        maintainer="mahesh" 

ARG USER=filebeat
ARG group=filebeat
ARG USER_UID=1000
ARG USER_GID=1000

RUN groupadd $group -g $USER_GID && \
    adduser $USER -u $USER_UID -g $USER_GID -c "filebeat User"
ENV NAME=$NAME
ARG FILEBEAT_SHA1=e2011711763e184d5530470243617064714c8207
RUN curl -LO https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-5.2.0-x86_64.rpm && \
    echo "${FILEBEAT_SHA1}  filebeat-5.2.0-x86_64.rpm" | sha1sum -c - && \
  yum localinstall -y filebeat-5.2.0-x86_64.rpm && \
  rm -f filebeat-5.2.0-x86_64.rpm && \
  yum clean all && \
  rm -f /var/log/yum.log

USER root
RUN chown -R filebeat:filebeat /usr/share/filebeat && \
  chmod -R 777 /usr/share/filebeat 

WORKDIR /usr/share/filebeat
VOLUME [ "/usr/share/filebeat" ]

USER filebeat
