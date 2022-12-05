class CarsController < ApplicationController
  def recommend
    cars = Cars::Recommend.new.call(**recommend_params.to_h.symbolize_keys)
    @pagy, @cars = pagy_array(cars)
  end

  private

  def recommend_params
    params.permit(:user_id, :query, :price_min, :price_max)
  end
end
