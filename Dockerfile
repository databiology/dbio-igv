FROM app/dbio/desktop:1.4.1

RUN apt-get update -q=2 && \
    apt-get install -q=2 --no-install-recommends \
    openjdk-8-jre \
    bzip2 && \
    apt-get clean && \
    apt-get purge && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN cd /opt/databiology/apps && \
    wget -q http://data.broadinstitute.org/igv/projects/downloads/2.4/IGV_2.4.4.zip && \
    unzip IGV_2.4.4.zip && rm IGV_2.4.4.zip && mv -f IGV_2.4.4 IGV

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
