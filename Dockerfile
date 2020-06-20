FROM dbio/desktop:2.0.1

RUN apt-get update -q=2 && \
    apt-get upgrade -q=2 && \
    apt-get install -q=2 --no-install-recommends \
        openjdk-11-jre \
        vcftools \
        samtools \
        tabix \
        bzip2 && \
    apt-get clean && \
    apt-get purge && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN cd /opt/databiology/apps && \
    wget -q https://data.broadinstitute.org/igv/projects/downloads/2.6/IGV_2.6.2.zip && \
    unzip IGV_2.6.2.zip && rm IGV_2.6.2.zip && mv -f IGV_2.6.2 IGV

# Store the scripts in the container
COPY igv.sh /opt/databiology/apps/IGV/igv.sh
RUN chmod +x /opt/databiology/apps/IGV/igv.sh

COPY main.sh /usr/local/bin
RUN chmod +x /usr/local/bin/main.sh

EXPOSE 6080

