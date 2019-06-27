# Converters

Converters are a "profile" for mapping data in one or more CSV
documents to CollectionSpace XML payloads.

## How to create a converter

Converters are defined in `lib/collectionspace/converter/`.
This directory containers a `_default/record.rb` file that is the
foundation for converter profiles to build upon. If a procedure
or authority is not represented in `record.rb` it cannot be mapped,
and most likely should be added (pull requests welcome!).

Subfolders in this directory are converter implementations. Each
converter requires a `_config.rb` file to define its behavior.

If you're creating a converter for `mymuseum` you could create
`lib/collectionspace/converter/mymuseum/_config.rb`.

## Converter configuration

Begin by copying the `_default/default.rb` but replace "Default"
with "MyMuseum" (following ruby naming conventions).

```
module CollectionSpace
  module Converter
    module MyMuseum

      def self.registered_procedures
        []
      end

      def self.registered_profiles
        {}
      end

    end
  end
end
```

The converter configuration must implement the two class methods:

### Registered Procedures

This is simply a list of Procedures that this converter can generate
XML records for. It's a handbrake against inadevertently generating
invalid record types.

### Registered Profiles

This is where the bulk of configuration happens. A converter can
implement one or more profiles. You can name these arbitrarily
according to what makes sense for your data. If all of your data
was in a single spreadsheet if may look like:

```ruby
def self.registered_profiles
  {
    "mymuseum" => {}, # ...
  }
end
```

This would indicate a single converter "profile" being used to handle
a **single** CSV document. Note: one profile per CSV file, but one
profile can handle multiple record types per CSV.

If we have multiple CSV files to work with we'll need multiple
"profiles".

```ruby
def self.registered_profiles
  {
    "cataloging" => {}, # ...
    "media" => {}, # ...
  }
end
```

In this case there are distinct CSV files for different procedures
so we need a profile to manage data file.

Each "profile" needs to define what it does with the CSV data. It can
do this for:

#### Procedures

Each Procedure to be generated using this profile needs an entry
defining:

- identifier_field: field used to look this record type up in CollectionSpace
- identifier: the field in the source data used for identifier_field
- title: the field in the source data used for the local title

Note: the CSV processor downcases all characters and replaces spaces
with "_". So a field like "ID Number" should be referred to
as "id_number" within the application.

Example:

```ruby
"Procedures" => {
  "Acquisition" => {
    "identifier_field" => "acquisitionReferenceNumber",
    "identifier" => "accession_number",
    "title" => "accession_number",
  },
  "ValuationControl" => {
    "identifier_field" => "valuationcontrolRefNumber",
    "identifier" => "valuation_number",
    "title" => "valuation_number",
  },
},
```

#### Authorities

If a data field is an authority type specify the authority type and
field name:

```ruby
"Authorities" => {
  "Person" => ["recby", "recfrom"],
},
```

#### Relationships

Relationships can be created between procedures (these are
bi-directional). You specify the procedure pair and which fields
in the source data should be used to identify the records that should
be related.

```ruby
"Relationships" => [
  {
    "procedure1_type"  => "Acquisition",
    "data1_field" => "accession_number",
    "procedure2_type"  => "ValuationControl",
    "data2_field" => "valuation_number",
  },
],
```

## Running a converter

```bash
./import_procedures.sh data/sample/mymuseum_data.csv mymuseum1 MyMuseum mymuseum
```

The arguments correspond to:

- csv name
- batch name (arbitrary)
- converter type
- converter profile

---
