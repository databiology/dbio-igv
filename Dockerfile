FROM app/dbio/desktop:1.0.0

MAINTAINER Felipe Leza <felipe.leza@databiology.com>

RUN apt-get update -q=2 && \
    apt-get install -q=2 --no-install-recommends \
    default-jre bzip2 && \
    apt-get clean && \
    apt-get purge && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN mkdir -p /opt/databiology/apps && cd /opt/databiology/apps && \
    wget http://data.broadinstitute.org/igv/projects/downloads/2.4/IGV_2.4.4.zip && \
    unzip IGV_2.4.4.zip && mv IGV_2.4.4 IGV && rm IGV_2.4.4.zip

COPY menu.xml /root/.config/openbox/

# Store the scripts in the container
COPY main.sh /usr/local/bin
RUN chmod +x /usr/local/bin/main.sh

# Set entrypoint script
ENTRYPOINT /usr/local/bin/main.sh

LABEL "com.databiology.dbe.executable.type" "compose"
LABEL "com.databiology.dbe.executable.images" '["/app/dbio/igv:0.0.1"]'
LABEL "com.databiology.dbe.executable.service.expose" '{"service":"igv", "port":6080, "protocol":"http", "path":"", "proxy_type": "pathstrip"}'
