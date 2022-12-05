module Cars
  class Score
    # NOTE: можно использовать разные стратегии для кэширования и обработки ошибок,
    # в данном случае самый простой вариант

    EXTERNAL_URL = 'https://bravado-images-production.s3.amazonaws.com/recomended_cars.json'.freeze

    def call(user_id)
      Rails.cache.fetch("user/#{user_id}/recomended_cars", expires_in: 1.day) do
        get_car_scores(user_id)
      end
    end

    private

    def get_car_scores(user_id)
      response = call_external_service(user_id)
      return [] unless response&.status&.success?

      JSON.parse(response.body, symbolize_names: true)
    rescue HTTP::Error => e
      Rails.logger.error(e)
      []
    end

    def call_external_service(user_id)
      # http = HTTP.use(logging: {logger: Rails.logger})

      # http.get(
      HTTP.get(EXTERNAL_URL, params: { user_id: user_id })
    end
  end
end
