FROM debian:buster-slim

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
	gnupg2 \
	wget \
	ca-certificates

RUN wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | apt-key add -
RUN echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | tee /etc/apt/sources.list.d/elastic-7.x.list
ENV LS_HOME=/usr/share/logstash
ENV LS_CONF=${LS_HOME}/config
RUN apt-get update && apt-get install -y --no-install-recommends \
	logstash

RUN apt-get purge -y gnupg2 wget ca-certificates && apt-get autoremove -y

RUN mkdir -p ${LS_CONF}
RUN mkdir -p ${LS_CONF}/conf.d
COPY ./jvm.options ${LS_CONF}/jvm.options
COPY ./log4j2.properties ${LS_CONF}/log4j2.properties
COPY ./pipelines.yml ${LS_CONF}/pipelines.yml
COPY ./logstash.yml ${LS_CONF}/logstash.yml
COPY ./beats.conf ${LS_CONF}/conf.d/beats.conf

COPY ./start.sh /usr/local/bin/start.sh
RUN chmod +x /usr/local/bin/start.sh

EXPOSE 9600 5044

RUN mkdir -p /etc/sysconfig
RUN touch /etc/sysconfig/logstash
RUN chown -R logstash:logstash ${LS_HOME}
RUN chown logstash:logstash /etc/sysconfig/logstash
USER logstash

CMD /usr/local/bin/start.sh
