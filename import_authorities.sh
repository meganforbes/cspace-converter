#!/bin/bash

export FILE=${1}
export BATCH=${2}
export MODULE=${3}
export ID_COLUMN=${4}
export AUTH_TYPE=${5}
export AUTH_INSTANCE=${6}

# data/SampleOrganization.csv,organization_batch,PublicArt,termdisplayname,Organization,organization

./bin/rake \
  db:import:authorities[${FILE},$BATCH,$MODULE,$ID_COLUMN,$AUTH_TYPE,$AUTH_INSTANCE]
