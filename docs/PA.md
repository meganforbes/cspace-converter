# Public Art Example

```
NOTE When exporting data to Excel, each field is limited to 254 characters. In most cases this won’t be a problem, except for data in unlimited memo fields like Description and Notes. If you want to export data that is longer than 254 characters, please choose the Excel/HTML option. This export creates an HTML (.htm) file that is opened in Excel. To save this file as an Excel file (.xls), please use the Save As option in Excel.
```

For earlier versions of Past Perfect (< 5) you may need to manually clean up long fields (> 254 characters) to avoid export truncation.

Process:

```
# erase all staged records from the Mongo db
./bin/rake db:nuke

# stage cataloging records to Mongo db
./import_procedures.sh data/sample/100_artworks.csv cataloging PublicArt cataloging

# transfer/import cataloging records to CollectionSpace
./bin/rake remote:action:transfer[CollectionObject,all]

# transfer/import authority records to CollectionSpace
./bin/rake remote:action:transfer[Concept,all]
./bin/rake remote:action:transfer[Organization,all]
./bin/rake remote:action:transfer[Person,all]

```

To undo:

```
# delete imported cataloging records from CollectionSpace
./bin/rake remote:action:delete[CollectionObject,all]

# delete imported authority records from CollectionSpace
./bin/rake remote:action:delete[Concept,all]
./bin/rake remote:action:delete[Organization,all]
./bin/rake remote:action:delete[Person,all]

```

## Checks

Counting that all records in the converter were transferred to cspace is essential.

```
./bin/rake console

# get counts by type from converter
CollectionSpaceObject.where(category: 'Procedure', type: 'CollectionObject').count
CollectionSpaceObject.where(category: 'Authority', type: 'Concept').count
CollectionSpaceObject.where(category: 'Authority', type: 'Organization').count
CollectionSpaceObject.where(category: 'Authority', type: 'Person').count

# using csible get counts from cspace, the totals should match
rake cs:get:path[collectionobjects] | jq '.["abstract_common_list"]["totalItems"]'
rake cs:get:path["conceptauthorities/urn:cspace:name(material_ca)/items"] | jq '.["abstract_common_list"]["totalItems"]'
rake cs:get:path["orgauthorities/urn:cspace:name(organization)/items"] | jq '.["abstract_common_list"]["totalItems"]'
rake cs:get:path["personauthorities/urn:cspace:name(person)/items"] | jq '.["abstract_common_list"]["totalItems"]'
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
