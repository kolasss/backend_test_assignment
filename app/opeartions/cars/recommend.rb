module Cars
  class Recommend
    def call(user_id:, query: nil, price_min: nil, price_max: nil)
      user = User.find(user_id)

      cars = query_cars(query, price_min, price_max)
      fill_labels(cars, user)
      fill_rank_scores(cars, user)
      sort(cars)
    end

    private

    def query_cars(query, price_min, price_max)
      cars = Car.all
      cars = cars.where('cars.price >= ?', price_min.to_i) if price_min
      cars = cars.where('cars.price <= ?', price_max.to_i) if price_max
      cars = cars.joins(:brand).merge(Brand.where('brands.name ILIKE ?', "%#{query}%")) if query.present?
      cars.includes(:brand).order(price: :asc)
    end

    def fill_labels(cars, user)
      preferred_brands = user.preferred_brands.to_a
      return if preferred_brands.blank? || user.preferred_price_range.blank?

      cars.each do |car|
        next unless preferred_brands.include?(car.brand)

        car.label = user.preferred_price_range.include?(car.price) ? 'perfect_match' : 'good_match'
      end
    end

    def fill_rank_scores(cars, user)
      scores_data = Score.new.call(user.id)
      return if scores_data.blank?

      cars.each do |car|
        car.rank_score = scores_data.find { |data| data[:car_id] == car.id }&.fetch(:rank_score)&.to_f
      end
    end

    def sort(cars)
      cars.to_a.sort_by { |car| [car.label_comparable, -car.rank_score_comparable, car.price] }
    end
  end
end
