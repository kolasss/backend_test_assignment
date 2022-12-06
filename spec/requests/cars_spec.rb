require 'rails_helper'

RSpec.describe '/cars', type: :request do
  describe 'GET /recommend' do
    subject do
      VCR.use_cassette 'recomended_cars' do
        get(cars_recommend_path(**params))
      end
    end

    context 'with valid parameters' do
      let(:params) { { user_id: user.id } }
      let(:user) { create(:user) }

      before do
        create(:car)
        create(:car)
      end

      it 'returns ok' do
        subject
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to match(a_string_including('application/json'))
      end

      it 'renders a JSON response' do
        subject
        json = JSON.parse(response.body)
        expect(json.size).to eq(2)
      end
    end

    context 'with invalid parameters' do
      let(:params) { { asf: 1 } }

      it 'raises error' do
        expect { subject }.to raise_error(ArgumentError)
      end
    end
  end
end
