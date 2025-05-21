require 'csv'

module CsvImportable
  extend ActiveSupport::Concern

  def validate_file!(file)
    raise 'Invalid file type' unless file.content_type == 'text/csv'
  end

  def parse_csv(file)
    CSV.parse(file.read, headers: true)
  rescue CSV::MalformedCSVError
    raise 'Malformed CSV file'
  end

  def validate_headers!(csv, expected_headers = nil)
    return if csv.headers == expected_headers

    raise 'Invalid CSV headers'
  end
end
