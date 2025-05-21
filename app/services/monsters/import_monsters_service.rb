module Monsters
  class ImportMonstersService
    EXPECTED_HEADERS = %w[name attack defense hp speed imageUrl].freeze

    include CsvImportable

    attr_reader :file

    def initialize(file:)
      @file = file
    end

    def call
      import_monsters
    end

    private

    def import_monsters
      validate_file!(file)
      csv = parse_csv(file)
      validate_headers!(csv, EXPECTED_HEADERS)
      create_monsters(csv)
    end

    def create_monsters(csv)
      csv.each do |row|
        Monster.create!(
          name: row['name'],
          attack: row['attack'],
          defense: row['defense'],
          hp: row['hp'],
          speed: row['speed'],
          imageUrl: row['imageUrl']
        )
      end
    end
  end
end
