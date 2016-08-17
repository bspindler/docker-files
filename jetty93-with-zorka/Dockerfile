FROM jetty:9.3

# grab our editor of choice
RUN apt-get update -y && \
	apt-get install -y vim

# get zorka and install 
RUN mkdir /apps && \
	cd /apps && \
	curl -s https://repos.uat.netuitive.com/java-agent/netuitive-zorka-1.0.16.zip --output zorka.zip && \
	unzip zorka.zip && \
	mv netuitive-zorka-1.0.16 zorka && \
	cd zorka/

ENV JAVA_OPTIONS="-javaagent:/apps/zorka/netuitive.jar=/apps/zorka"

ENTRYPOINT ["/docker-entrypoint.sh"]
