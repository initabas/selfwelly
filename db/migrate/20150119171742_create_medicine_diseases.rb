class CreateMedicineDiseases < ActiveRecord::Migration
  def change
    create_table :medicine_diseases do |t|
      t.references :medicine, index: true
      t.references :disease, index: true

      t.timestamps null: false
    end
    add_foreign_key :medicine_diseases, :medicines
    add_foreign_key :medicine_diseases, :diseases
  end
end
