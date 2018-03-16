FROM app/dbio/desktop:1.0.9

MAINTAINER Felipe Leza <felipe.leza@databiology.com>

RUN apt-get update -q=2 && \
    apt-get install -q=2 --no-install-recommends \
    default-jre bzip2 && \
    apt-get clean && \
    apt-get purge && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN cd /opt/databiology/apps && \
    wget -q http://data.broadinstitute.org/igv/projects/downloads/2.4/IGV_2.4.4.zip && \
    unzip IGV_2.4.4.zip && rm IGV_2.4.4.zip && mv -f IGV_2.4.4 IGV

# Store the scripts in the container
COPY igv.sh /opt/databiology/apps/IGV/igv.sh
RUN chmod +x /opt/databiology/apps/IGV/igv.sh

COPY main.sh /usr/local/bin
RUN chmod +x /usr/local/bin/main.sh

# Set entrypoint script
ENTRYPOINT /usr/local/bin/main.sh

COPY docker-compose.yml /

LABEL "com.databiology.dbe.executable.type" "compose"
LABEL "com.databiology.dbe.executable.images" '["/app/dbio/igv:1.0.10"]'
LABEL "com.databiology.dbe.executable.service.expose" '{"service":"igv", "port":6080, "protocol":"http", "path":"", "proxy_type": "pathstrip"}'
