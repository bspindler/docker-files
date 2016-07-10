FROM java:8

# install wget, confluent, unzip
RUN apt-get update && \
    apt-get install -y wget unzip supervisor vim && \
    mkdir -p /opt/confluent && \
    cd /opt/confluent && \
    wget http://packages.confluent.io/archive/3.0/confluent-3.0.0-2.11.zip && \
    unzip confluent-3.0.0-2.11.zip && \
    cd confluent-3.0.0

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

EXPOSE 9092 2181 8081

CMD ["/usr/bin/supervisord"]