json.array!(@reviews) do |review|
  json.extract! review, :id, :text, :user_id_id, :reviewable_id, :reviewable_type
  json.url review_url(review, format: :json)
end
