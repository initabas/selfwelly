class MedicineActiveIngredient < ActiveRecord::Base
  belongs_to :medicine
  belongs_to :active_ingredient
end
