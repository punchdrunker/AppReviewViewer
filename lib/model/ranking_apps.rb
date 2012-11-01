class RankingApps < Sequel::Model
  plugin :schema
  plugin :validation_helpers
  unless table_exists?
    set_schema do
      primary_key :id
      int :store_type #0=> Apple, 1=>Google play
      string :app_id
      string :name
      string :url
      string :developer
      string :thumbnail
      string :genre
      timestamp :created_at
      index :app_id
      index :genre
      index :developer
    end
    create_table
  end

  def validate
    super
    validates_presence [:app_id, :name]
  end
end
