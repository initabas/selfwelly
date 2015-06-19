json.array!(@medicines) do |medicine|
  json.extract! medicine, :id, :name, :description
  json.url medicine_url(medicine, format: :json)
end
