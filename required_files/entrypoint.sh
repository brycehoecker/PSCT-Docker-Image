#!/bin/bash

source /opt/mambaforge/etc/profile.d/conda.sh
conda activate mymambaenv

if [ $# -gt 0 ]; then
    exec "$@"
else
    exec "/bin/bash"
fi


#
#source /opt/mambaforge/etc/profile.d/conda.sh
#conda activate mymambaenv
#
#exec "$@"
#
#bash
