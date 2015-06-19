class CreateModals < ActiveRecord::Migration
  def change
    create_table :modals do |t|

      t.timestamps null: false
    end
  end
end
