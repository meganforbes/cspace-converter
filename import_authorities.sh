#!/bin/bash

export FILE=${1}
export BATCH=${2}
export MODULE=${3}
export ID_COLUMN=${4}

# data/sample/SampleOrganization.csv,organization_batch,PublicArt,termdisplayname

./bin/rake \
  import:authorities[${FILE},$BATCH,$MODULE,$ID_COLUMN]
