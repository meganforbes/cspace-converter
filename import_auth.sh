#!/bin/bash

export CS_CONV_FILE=${1}
export CS_CONV_BATCH=${2}
export CS_CONV_MODULE=${3}
export CS_CONV_ID_COLUMN=${4}
export CS_CONV_AUTH_TYPE=${5}
export CS_CONV_AUTH_INSTANCE=${6}

# data/SampleOrganization.csv,organization_batch,PublicArt,termdisplayname,Organization,organization

./bin/rake \
  db:import:authorities[data/${CS_CONV_FILE},$CS_CONV_BATCH,$CS_CONV_MODULE,$CS_CONV_ID_COLUMN,$CS_CONV_AUTH_TYPE,$CS_CONV_AUTH_INSTANCE]
