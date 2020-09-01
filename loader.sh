#!/bin/bash

sleep 10

LOADER=/scratch/loader.sh
sh "$LOADER" | telnet 127.0.0.1 60151
