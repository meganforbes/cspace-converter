# PastPerfect

```
NOTE When exporting data to Excel, each field is limited to 254 characters. In most cases this won’t be a problem, except for data in unlimited memo fields like Description and Notes. If you want to export data that is longer than 254 characters, please choose the Excel/HTML option. This export creates an HTML (.htm) file that is opened in Excel. To save this file as an Excel file (.xls), please use the Save As option in Excel.
```

For earlier versions of Past Perfect (< 5) you may need to manually clean up long fields (> 254 characters) to avoid export truncation.

Process:

```
./bin/rake db:nuke

./import_procedures.sh data/sample/PPSdata_accession.csv pp_accession1 PastPerfect accessions
./import_procedures.sh data/sample/PPSdata_archives.csv pp_archives1 PastPerfect archives
./import_procedures.sh data/sample/PPSdata_library.csv pp_library1 PastPerfect library
./import_procedures.sh data/sample/PPSdata_objects.csv pp_objects1 PastPerfect objects
./import_procedures.sh data/sample/PPSdata_photos.csv pp_photos1 PastPerfect photos

# procedures
./bin/rake remote:transfer[Acquisition,all]
./bin/rake remote:transfer[CollectionObject,all]
./bin/rake remote:transfer[Media,all]
./bin/rake remote:transfer[Movement,all]
./bin/rake remote:transfer[ValuationControl,all]

# authorities
./bin/rake remote:transfer[Concept,all]
./bin/rake remote:transfer[Location,all]
./bin/rake remote:transfer[Organization,all]
./bin/rake remote:transfer[Person,all]
./bin/rake remote:transfer[Place,all]

# after other transfers
./bin/rake relationships:generate[pp_accession1]
./bin/rake relationships:generate[pp_archives1]
./bin/rake relationships:generate[pp_library1]
./bin/rake relationships:generate[pp_objects1]
./bin/rake relationships:generate[pp_photos1]

./bin/rake remote:transfer[Relationship,all]
```

To undo:

```
./bin/rake remote:delete[Acquisition,all]
./bin/rake remote:delete[CollectionObject,all]
./bin/rake remote:delete[Media,all]
./bin/rake remote:delete[Movement,all]
./bin/rake remote:delete[ValuationControl,all]

./bin/rake remote:delete[Concept,all]
./bin/rake remote:delete[Location,all]
./bin/rake remote:delete[Organization,all]
./bin/rake remote:delete[Person,all]
./bin/rake remote:delete[Place,all]

./bin/rake remote:delete[Relationship,all]
```

## Checks

Counting that all records in the converter were transferred to cspace is essential.

```
./bin/rake console

# get counts by type from converter
CollectionSpaceObject.where(category: 'Procedure', type: 'CollectionObject').count
CollectionSpaceObject.where(category: 'Procedure', type: 'Media').count
CollectionSpaceObject.where(category: 'Procedure', type: 'Acquisition').count
CollectionSpaceObject.where(category: 'Procedure', type: 'ValuationControl').count
CollectionSpaceObject.where(category: 'Procedure', type: 'Movement').count
CollectionSpaceObject.where(category: 'Authority', type: 'Concept').count
CollectionSpaceObject.where(category: 'Authority', type: 'Location').count
CollectionSpaceObject.where(category: 'Authority', type: 'Organization').count
CollectionSpaceObject.where(category: 'Authority', type: 'Person').count
CollectionSpaceObject.where(category: 'Relationship', type: 'Relationship').count

# using csible get counts from cspace, the totals should match
rake cs:get:path[collectionobjects] | jq '.["abstract_common_list"]["totalItems"]'
rake cs:get:path[media] | jq '.["abstract_common_list"]["totalItems"]'
rake cs:get:path[acquisitions] | jq '.["abstract_common_list"]["totalItems"]'
rake cs:get:path[valuationcontrols] | jq '.["abstract_common_list"]["totalItems"]'
rake cs:get:path[movements] | jq '.["abstract_common_list"]["totalItems"]'
rake cs:get:path["conceptauthorities/urn:cspace:name(category)/items"] | jq '.["abstract_common_list"]["totalItems"]'
rake cs:get:path["conceptauthorities/urn:cspace:name(objectname)/items"] | jq '.["abstract_common_list"]["totalItems"]'
rake cs:get:path["conceptauthorities/urn:cspace:name(subcategory)/items"] | jq '.["abstract_common_list"]["totalItems"]'
rake cs:get:path["locauthorities/urn:cspace:name(location)/items"] | jq '.["abstract_common_list"]["totalItems"]'
rake cs:get:path["orgauthorities/urn:cspace:name(organization)/items"] | jq '.["abstract_common_list"]["totalItems"]'
rake cs:get:path["personauthorities/urn:cspace:name(person)/items"] | jq '.["abstract_common_list"]["totalItems"]'
rake cs:get:path[relations] | jq '.["relations_common_list"]["totalItems"]'
```

TODO: add rake task to get counts and compare.

## Debug

Finding records that did not transfer:

```
./bin/rake console
CollectionSpaceObject.where(csid: nil).count
# => 0 # =)
```

---
