require 'active_support/core_ext/date_time'

module CollectionSpace

  StructuredDate = Struct.new(
      :parsed_datetime,
      :date_string,
      :display_date,
      :earliest_day,
      :earliest_month,
      :earliest_year,
      :earliest_scalar,
      :latest_day,
      :latest_month,
      :latest_year,
      :latest_scalar
  )

  module DateParser
    ::CSDTP = CollectionSpace::DateParser

    def self.fields_for(date)
      {
        'scalarValuesComputed' => 'true',
        'dateDisplayDate' => date.display_date,
        'dateEarliestSingleYear' => date.earliest_year,
        'dateEarliestSingleMonth' => date.earliest_month,
        'dateEarliestSingleDay' => date.earliest_day,
        'dateEarliestScalarValue' => date.earliest_scalar,
        'dateEarliestSingleEra' => CSURN.get_vocab_urn('dateera', 'CE', true),
        'dateLatestYear' => date.latest_year,
        'dateLatestMonth' => date.latest_month,
        'dateLatestDay' => date.latest_day,
        'dateLatestScalarValue' => date.latest_scalar,
        'dateLatestEra' => CSURN.get_vocab_urn('dateera', 'CE', true),
      }
    end

    # start simple, build up
    def self.parse(date_string, end_date_string = nil)
      date_string = date_string.strip
      date_string = "#{date_string}-01-01" if date_string =~ /^\d{4}$/

      # TODO exceptions
      parsed_earliest_date = DateTime.parse(date_string)
      daysInYear           = parsed_earliest_date.year % 4 == 0 ? 365 : 364
      parsed_latest_date   = nil

      if end_date_string
        parsed_latest_date = DateTime.parse(end_date_string)
      else
        parsed_latest_date = DateTime.parse((parsed_earliest_date + daysInYear).to_s)
      end

      d = CollectionSpace::StructuredDate.new
      d.parsed_datetime = parsed_earliest_date
      d.date_string = date_string
      d.display_date = date_string

      d.earliest_day = parsed_earliest_date.day
      d.earliest_month = parsed_earliest_date.month
      d.earliest_year = parsed_earliest_date.year
      d.earliest_scalar = parsed_earliest_date.iso8601(3).sub('+00:00', "Z")

      d.latest_day = parsed_latest_date.day
      d.latest_month = parsed_latest_date.month
      d.latest_year = parsed_latest_date.year

      unless end_date_string
        # We want the latest scalar date to extend to midnight of the last day of the year
        parsed_latest_date = DateTime.parse((parsed_earliest_date + daysInYear + 1).to_s)
      end

      d.latest_scalar = parsed_latest_date.iso8601(3).sub('+00:00', "Z")
      # Return the date
      d
    end

  end
end
