class MedicineDisease < ActiveRecord::Base
  belongs_to :medicine
  belongs_to :disease
end
