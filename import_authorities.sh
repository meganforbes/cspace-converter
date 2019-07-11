#!/bin/bash

export FILE=${1}
export BATCH=${2}
export ID_COLUMN=${3}

# data/sample/SampleOrganization.csv,organization_batch,termdisplayname

./bin/rake \
  import:authorities[${FILE},$BATCH,$ID_COLUMN]
