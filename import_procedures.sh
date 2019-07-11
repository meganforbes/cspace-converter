#!/bin/bash

export FILE=${1:-ppsobjectsdata.csv}
export BATCH=${2:-ppsobjects1}
export PROFILE=${3:-ppsobjectsdata}

./bin/rake \
  import:procedures[${FILE},$BATCH,$PROFILE]
