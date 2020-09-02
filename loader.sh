#!/bin/bash

sleep 12

LOADER=/scratch/loader.sh
sh "$LOADER" | telnet 127.0.0.1 60151
