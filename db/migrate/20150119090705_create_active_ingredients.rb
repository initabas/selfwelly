class CreateActiveIngredients < ActiveRecord::Migration
  def change
    create_table :active_ingredients do |t|
      t.string :name
      t.references :group, index: true

      t.timestamps null: false
    end
    add_foreign_key :active_ingredients, :groups
  end
end
