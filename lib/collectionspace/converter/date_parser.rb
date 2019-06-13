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

    # start simple, build up
    def self.parse(date_string)
      date_string = date_string.strip
      date_string = "#{date_string}-01-01" if date_string =~ /^\d{4}$/
      # TODO exceptions
      parsed_earliest_date = DateTime.parse(date_string)
      daysInYear = parsed_earliest_date.year % 4 == 0 ? 365 : 364
      parsed_latest_date = DateTime.parse((parsed_earliest_date + daysInYear).to_s)

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

      # We want the latest scalar date to extend to midnight of the last day of the year
      parsed_latest_date = DateTime.parse((parsed_earliest_date + daysInYear + 1).to_s)
      d.latest_scalar = parsed_latest_date.iso8601(3).sub('+00:00', "Z")

      # Return the date
      d
    end

  end
end
