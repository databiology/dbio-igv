FROM app/dbio/desktop:1.4.1

RUN apt-get update -q=2 && \
    apt-get install -q=2 --no-install-recommends \
    openjdk-11-jre \
    bzip2 && \
    apt-get clean && \
    apt-get purge && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN cd /opt/databiology/apps && \
    wget -q https://data.broadinstitute.org/igv/projects/downloads/2.6/IGV_2.6.2.zip && \
    unzip IGV_2.6.2.zip && rm IGV_2.6.2.zip && mv -f IGV_2.6.2 IGV

# Install samtools via miniconda
ARG MINICONDA_VERSION=4.5.12

RUN mkdir -p /opt/databiology/apps

RUN cd /opt/databiology/apps \
    && wget -q https://repo.continuum.io/miniconda/Miniconda3-${MINICONDA_VERSION}-Linux-$(arch).sh \
    && bash Miniconda3-${MINICONDA_VERSION}-Linux-$(arch).sh -f -b -p /opt/databiology/apps/miniconda3/ \
    && rm -f Miniconda3-${MINICONDA_VERSION}-Linux-$(arch).sh

RUN /opt/databiology/apps/miniconda3/bin/conda create -q  -c biobuilds -n databiology-tools samtools -y \
    && ln -s /opt/databiology/apps/miniconda3/envs/databiology-tools/bin/* /usr/local/bin

# Store the scripts in the container
COPY igv.sh /opt/databiology/apps/IGV/igv.sh
RUN chmod +x /opt/databiology/apps/IGV/igv.sh
COPY no_output.sh /opt/databiology
RUN chmod +x /opt/databiology/no_output.sh

# terminate workunit if user click on logout button
RUN mkdir -p /home/dbe/.config/lxpanel/LXDE && \
echo '\n\
[Command]\n\
Logout=/opt/databiology/no_output.sh \n\
' > /home/dbe/.config/lxpanel/LXDE/config

COPY main.sh /usr/local/bin
RUN chmod +x /usr/local/bin/main.sh

EXPOSE 6080

RUN apt-get update -q=2 && \
    apt-get install -q=2 --no-install-recommends \
    vcftools \
    tabix && \
    apt-get clean && \
    apt-get purge && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*