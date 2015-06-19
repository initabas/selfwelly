namespace :medicine do

  desc 'Generate search suggestions'
  task index: :environment do
    Medicine.seed
  end

end