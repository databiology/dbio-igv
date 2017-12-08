#!/bin/bash

#This script is intended for launch on *nix machines

#Script must be in the same directory as igv.jar
#Add the flag -Ddevelopment = true to use features still in development
MEMORY="-Xmx$(free -m | grep 'Mem' | awk '{print $2}')m"
PREFIX=$(dirname "$(readlink "$0" || echo "$0")")
exec java "$MEMORY" \
-XX:+IgnoreUnrecognizedVMOptions \
    --illegal-access=permit --add-modules=java.xml.bind \
	-Dapple.laf.useScreenMenuBar=true \
	-Djava.net.preferIPv4Stack=true \
	-jar "$PREFIX"/igv.jar "$@"


