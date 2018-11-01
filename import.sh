#!/bin/bash

export CS_CONV_FILE=${1:-ppsobjectsdata.csv}
export CS_CONV_BATCH=${2:-ppsobjects1}
export CS_CONV_MODULE=${3:-PastPerfect}
export CS_CONV_PROFILE=${4:-ppsobjectsdata}

./bin/rake \
  db:import:data[data/${CS_CONV_FILE},$CS_CONV_BATCH,$CS_CONV_MODULE,$CS_CONV_PROFILE]
