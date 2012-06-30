class Reviews < Sequel::Model
  plugin :schema
  unless table_exists?
    set_schema do
      primary_key :id
      string :hash
      string :user
      string :date
      string :title
      string :body
      string :version
      string :device
      string :app_id
      string :nodes
      int :star
      timestamp :created_at
      index [:hash, :app_id, :version]
    end
    create_table
  end

  def self.versions(app_id)
    self.db.fetch("SELECT DISTINCT version FROM reviews WHERE app_id = ? ORDER BY version", app_id)
  end
end
