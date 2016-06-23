cspace-converter
===

Migrate data to CollectionSpace from CSV.

Getting Started
---

Ruby (2.x) & Rails are required. The database backend is MongoDB (3.2) and by default should be running on `localhost:27017`.

```
bundle install
```

Setup
---

Create the data directory and add the data files.

```
db/data/
├── cataloging.csv # custom CSV data file
└── ppsobjectsdata.csv # Past Perfect objects data file
```

**Run MongoDB**

```
# for local development / conversions
docker run --net=host --name mongo -d mongo:3.2
```

You should be able to access MongDB on `http://localhost:27017`.

**Initial data import**

The general command is:

```
. ./set_env.sh [CSPACE_CONVERTER_DOMAIN] # optional
./import.sh [CS_CONV_BATCH] [CS_CONV_TYPE] [CS_CONV_PROFILE]
```

- `CSPACE_CONVERTER_DOMAIN`: domain to use in tenant data
- `CS_CONV_BATCH`: batch name
- `CS_CONV_TYPE`: converter type (module)
- `CS_CONV_PROFILE`: profile from type

```
# import to converter
./import.sh pbm_acq1 PBM pbm_acquisition
./import.sh pbm_cat1 PBM pbm_cataloging
./import.sh pbm_con1 PBM pbm_conservation
./import.sh pbm_val1 PBM pbm_valuationcontrol

# transfer data (requires cspace)
rake remote:action:transfer[Acquisition,pbm_acq1]
rake remote:action:transfer[CollectionObject,pbm_cat1]
rake remote:action:transfer[Conservation,pbm_con1]
rake remote:action:transfer[ValuationControl,pbm_val1]

# delete transfers (requires cspace)
rake remote:action:delete[Acquisition,pbm_acq1]
rake remote:action:delete[CollectionObject,pbm_cat1]
rake remote:action:delete[Conservation,pbm_con1]
rake remote:action:delete[ValuationControl,pbm_val1]

./import.sh ppsaccession1 PastPerfect ppsaccessiondata
./import.sh ppsobjects1 PastPerfect ppsobjectsdata
```

For these commands to actually work you will need the data files in `db/data`.

**Using the console**

```
rails c
p = DataObject.first
puts p.to_procedure_xml("CollectionObject")
```

**Running the development server**

```
rails s
```

To fire jobs created using the ui:

```
rake jobs:work
```

License
---

The project is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

---