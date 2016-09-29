FROM python:2.7
MAINTAINER Torsten Feld

# Installing Mongo Connector which will connect MongoDB and Elasticsearch
RUN pip install mongo-connector==2.4.0 elastic2-doc-manager==0.2.0

COPY startup.sh /tmp/

COPY mongo /usr/bin/
RUN chmod a+x /usr/bin/mongo

VOLUME /data

# Sample usage when no commands is given outside
CMD ["/bin/bash", "/tmp/startup.sh"]