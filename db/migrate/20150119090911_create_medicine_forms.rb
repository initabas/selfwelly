class CreateMedicineForms < ActiveRecord::Migration
  def change
    create_table :medicine_forms do |t|
      t.references :medicine, index: true
      t.references :form, index: true

      t.timestamps null: false
    end
    add_foreign_key :medicine_forms, :medicines
    add_foreign_key :medicine_forms, :forms
  end
end
