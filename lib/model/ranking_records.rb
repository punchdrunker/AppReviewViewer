class RankingRecords < Sequel::Model
  plugin :schema
  plugin :validation_helpers

  unless table_exists?
    set_schema do
      primary_key :id
      int :rank
      int :store_type #0=> Apple, 1=>Google play
      string :app_id
      string :rating
      string :keyword
      string :genre # genre of App Store
      timestamp :date
      timestamp :created_at
      index [:created_at, :app_id]
    end
    create_table
  end

  def validate
    super
    validates_presence [:rank, :app_id]
  end

  def self.dates
    self.db.fetch("SELECT DISTINCT date FROM ranking_records ORDER BY date")
  end
end
