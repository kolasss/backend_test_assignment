class AddIndexes < ActiveRecord::Migration[6.1]
  def change
    enable_extension "pg_trgm"
    add_index :brands, :name, using: :gin, opclass: :gin_trgm_ops
    add_index :cars, :price, order: { price: :asc }
  end
end
