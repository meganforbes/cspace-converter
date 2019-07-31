# cspace-converter

[![Build Status](https://travis-ci.com/lyrasis/cspace-converter.svg?branch=master)](https://travis-ci.com/lyrasis/cspace-converter) [![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](http://opensource.org/licenses/MIT)

Migrate data into CollectionSpace from CSV files.

## Getting Started

The converter tool is a [Ruby on Rails](https://rubyonrails.org/) application.
See `.ruby-version` for the recommended version of Ruby. The database backend is
[MongoDB](https://www.mongodb.com/) (v3.2).

Install Ruby and bundler then run:

```bash
bundle install
```

## Configuration

There is a default `.env` file that provides example configuration. Override it
by creating a `.env.local` file with custom settings.

```bash
# DEVELOPMENT .env
export CSPACE_CONVERTER_AUTH_CACHE_INITIALIZE=false
export CSPACE_CONVERTER_DB_HOST=127.0.0.1
export CSPACE_CONVERTER_BASE_URI=http://localhost:1980/cspace-services
export CSPACE_CONVERTER_DOMAIN=core.collectionspace.org
export CSPACE_CONVERTER_LOG_LEVEL=debug
export CSPACE_CONVERTER_MODULE=Core
export CSPACE_CONVERTER_USERNAME=admin@core.collectionspace.org
export CSPACE_CONVERTER_PASSWORD=Administrator
```

## Setup CSV Data to be Imported

Before the *cspace-converter* tool can import CSV data into CollectionSpace, it first
"stages" the data from the CSV files into a MongoDB database.

Create a data directory and add the CSV files. For example:

```txt
data/sample/
├── cataloging.csv # custom CSV data file
└── ppsobjectsdata.csv # Past Perfect objects data file
```

**Start the MongoDB Server**

If installed locally, you can start the MongoDB server with this command:

```bash
mongod

# If you don't want to install and run Mongo DB directly, you can
# use a Docker image to run MongoDB -see https://hub.docker.com/r/_/mongo/
docker run --name mongo -d -p 27017:27017 mongo:3.2
```

You should be able to access MongDB on `http://localhost:27017`.  To test the
connection: https://docs.mongodb.com/v3.0/tutorial/getting-started-with-the-mongo-shell/

**Setup the cache (optional)**

To match csv fields to existing CollectionSpace authority and vocabulary terms:

```bash
# clear things out if starting over
bundle exec rake db:nuke
bundle exec rake cache:clear

# populate the database with terms
bundle exec rake cache:download_authorities
bundle exec rake cache:download_vocabularies

# prime the cache
bundle exec rake cache:setup
```

Alternatively set `CSPACE_CONVERTER_AUTH_CACHE_INITIALIZE=true` in `.env.local`.

**Stage the data to MongoDB**

The general format for the command is:

```bash
./import_procedures.sh [FILE] [BATCH] [PROFILE]
```

- `FILE`: path to the import file
- `BATCH`: import batch label (for future reference)
- `PROFILE`: profile key from config (`config.yml` registered_profiles)

For example:

```bash
# procedure / object
./import_procedures.sh data/sample/SampleCatalogingData.csv cataloging cataloging
# NOTE: for media csv blob_uri field will attempt to create the image
./import_procedures.sh data/sample/SampleMediaUrl.csv media1 media
```

For authorities:

```
# authority
./import_authorities.sh [FILE] [BATCH] [ID_COLUMN]
./import_authorities.sh data/sample/SamplePerson.csv person1 termdisplayname
```

Note: authoritiy csv files must contain both `authority_type` and `authority_subtype` fields.

## Import Staged Data from MongoDB to CollectionSpace

If you don't want to install and run CollectionSpace directly, you can
use a Docker image to run CollectionSpace

For local testing only: [docker-collectionspace](https://github.com/lyrasis/docker-collectionspace).

**Starting/Running the cspace-converter tool UI server**

```bash
./bin/rails s
```
Once started, visit http://localhost:3000 with a web browser.

Next, to execute "transfer" jobs you'll eventually create using the UI server, run this command:

```bash
./bin/rake jobs:work
```

**Using the console**

```ruby
# ./bin/rails c
p = DataObject.first
puts p.inspect
```

**Clearing out data**

```bash
bundle exec rake db:nuke
```

Or use 'Nuke' in the ui. Warning: this deletes all data including failed jobs.

## (Optional) Test environment

```bash
docker-compose build
docker-compose up

# to run commands
docker exec -it converter ./bin/rails c
docker exec -it converter \
  ./import_procedures.sh data/sample/SampleCatalogingData.csv cataloging cataloging
docker exec -it converter ./bin/rake db:nuke
```

To test with the prebuilt Docker images:

```
docker-compose -f docker-compose-test.yml up
```

## Deploying Converter to Amazon Elastic Beanstalk

The converter can be easily deployed to [Amazon Elastic Beanstalk](https://aws.amazon.com/documentation/elastic-beanstalk/)
(account required).

```bash
cp Dockerrun.aws-example.json Dockerrun.aws.json
```

Replace the `INSERT_YOUR_VALUE_HERE` values as needed. Note: for a production
environment the `username` and `password` should be for a temporary account used
only to perform the migration tasks. Delete this user from CollectionSpace when
the migration has been completed.

Follow the AWS documentation for deployment details:

- [Getting started](https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/GettingStarted.html)

Summary:

- Create a new application and give it a name
- Choose Web application
- Choose Multi-container docker, single instance
- Upload your custom Dockerrun-aws.json (under application version)
- Choose a domain name (can be customized further later)
- Skip RDS and VPC (the mongo db is isolated to a docker local network)
- Select `t2.small` for instance type (everything else optional)
- Launch

## License

The project is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

---
