class Form < ActiveRecord::Base
  has_many :medicine_forms
  has_many :medicines, through: :medicine_forms
  
  rails_admin do
    configure :medicine_forms do
      visible(false)
    end
  end
end
