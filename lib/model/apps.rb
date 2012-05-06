class Apps < Sequel::Model
  plugin :schema
  plugin :validation_helpers
  unless table_exists?
    set_schema do
      primary_key :id
      string :name
      string :app_id
      timestamp :created_at
      index [:name, :app_id]
    end
    create_table
  end

  def validate
    super
    validates_presence [:name, :app_id]
    validates_unique :app_id
  end
end
