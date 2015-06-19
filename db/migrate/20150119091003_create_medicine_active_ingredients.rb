class CreateMedicineActiveIngredients < ActiveRecord::Migration
  def change
    create_table :medicine_active_ingredients do |t|
      t.references :medicine, index: true
      t.references :active_ingredient, index: true

      t.timestamps null: false
    end
    add_foreign_key :medicine_active_ingredients, :medicines
    add_foreign_key :medicine_active_ingredients, :active_ingredients
  end
end
