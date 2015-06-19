class Disease < ActiveRecord::Base
  has_many :medicine_diseases
  has_many :medicines, through: :medicine_diseases
  
  rails_admin do
    configure :medicine_diseases do
      visible(false)
    end
  end
end
