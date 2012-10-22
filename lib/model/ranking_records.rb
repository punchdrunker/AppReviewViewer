class RankingRecords < Sequel::Model
  plugin :schema
  plugin :validation_helpers
  unless table_exists?
    set_schema do
      primary_key :id
      int :rank
      string :app_id
      timestamp :created_at
      index [:created_at, :app_id]
    end
    create_table
  end

  def validate
    super
    validates_presence [:rank, :app_id]
  end
end
