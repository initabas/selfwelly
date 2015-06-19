class SearchController < ApplicationController
  def index
    medicines = Medicine.srh(params[:q])
    active_ingredients = ActiveIngredient.srh(params[:q])
    search_params = {medicines: medicines.as_json}.merge({active_ingredients: active_ingredients.as_json})
    render json: search_params #.map(&:_source)
  end
end
