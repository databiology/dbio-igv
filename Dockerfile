FROM dbio/desktop:2.0.1

RUN apt-get update -q=2 && \
    apt-get upgrade -q=2 && \
    apt-get install -q=2 --no-install-recommends \
        telnet \
        parallel \
        openjdk-11-jre \
        vcftools \
        samtools \
        tabix \
        bzip2 && \
    apt-get clean && \
    apt-get purge && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN cd /opt/databiology/apps && \
    IGV_VERSION=2.8.4 && \
    wget -q https://data.broadinstitute.org/igv/projects/downloads/2.8/IGV_${IGV_VERSION}.zip && \
    unzip IGV_${IGV_VERSION}.zip && rm IGV_${IGV_VERSION}.zip && mv -f IGV_${IGV_VERSION} IGV

# Store the scripts in the container
COPY igv.sh /opt/databiology/apps/IGV/igv.sh
RUN chmod a+x /opt/databiology/apps/IGV/igv.sh
COPY loader.sh /opt/databiology/apps/IGV/loader.sh
RUN chmod a+x /opt/databiology/apps/IGV/loader.sh
COPY index_bam.sh /usr/local/bin/index_bam.sh
RUN chmod a+x /usr/local/bin/index_bam.sh
COPY index_vcf.sh /usr/local/bin/index_vcf.sh
RUN chmod a+x /usr/local/bin/index_vcf.sh
COPY VCFindex.sh /usr/local/bin/VCFindex.sh
RUN chmod a+x /usr/local/bin/VCFindex.sh

COPY main.sh /usr/local/bin
RUN chmod a+x /usr/local/bin/main.sh

EXPOSE 6080

