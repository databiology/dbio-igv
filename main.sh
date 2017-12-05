#!/bin/bash
# Entrypoint for igv application
# Felipe Leza <felipe.leza@databiology.com>
# Databiology @ 2017

set -euo pipefail

: ${DBE_SYSTEM_USERID:?"ERROR: No User id given"}
: ${DBE_SYSTEM_GROUPID:?"ERROR: No User Groupid given"}
: ${DBE_WORKUNIT_USERNAME:?"ERROR: No Username given"}
: ${DBE_WORKUNIT_USER_SHADOW:?"ERROR: No User Shadow given"}

if [ ${DBE_SYSTEM_USERID} -ne 0 ]; then
    groupadd -g ${DBE_SYSTEM_GROUPID} ${DBE_WORKUNIT_USERNAME}
    useradd -u ${DBE_SYSTEM_USERID} -g ${DBE_SYSTEM_GROUPID} -s /bin/bash -p "${DBE_WORKUNIT_USER_SHADOW}" -d /scratch/ ${DBE_WORKUNIT_USERNAME}
else
    useradd -s /bin/bash -p "${DBE_WORKUNIT_USER_SHADOW}" -d /scratch/ ${DBE_WORKUNIT_USERNAME}
fi

chown -R ${DBE_WORKUNIT_USERNAME} /scratch

# launch novnc server
Xvfb :1 -screen 0 1600x900x16 &
sleep 5
# running open-box, this command set wallpaper, add icon
# and turn off screensaver. Launch commands in autostart file
gosu ${DBE_WORKUNIT_USERNAME} openbox-session &
# running x11vnc and launch novnc server
x11vnc -display :1 -nopw -listen localhost -xkb -ncache 10 -ncache_cr -forever -q &
cd /opt/databiology/apps/noVNC && ln -s vnc_lite.html index.html \
&& gosu ${DBE_WORKUNIT_USERNAME} ./utils/launch.sh --vnc localhost:5900 &


# runnning IGV
SCRATCH=/scratch
IGVDIR=/opt/databiology/apps/IGV

# read parameters from parameters.json
DIEVER=$(cat < $SCRATCH/ingestion.json | jq -r '.version')
if [ "$DIEVER" != "0.1" ]; then
    echo "WARNING: Version of ingestion engine equals not 0.1"
fi

# launch app with gosu command
gosu ${DBE_WORKUNIT_USERNAME} $IGVDIR/igv.sh &

child=$!
wait "$child"

echo "IGV stopped"
echo "-----"